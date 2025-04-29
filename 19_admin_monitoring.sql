-- File: 19_admin_monitoring.sql
-- Deskripsi: Contoh query SQL untuk monitoring dasar aktivitas database.
-- Catatan: Query ini biasanya dijalankan oleh administrator atau user monitoring.
--          Beberapa view membutuhkan hak akses tertentu.

-- =============================================
-- Melihat Koneksi Aktif (pg_stat_activity)
-- =============================================

-- Melihat semua koneksi (termasuk idle dan proses background)
SELECT
    pid,                   -- Process ID backend
    datname,               -- Nama database yang terhubung
    usename,               -- Nama user yang terhubung
    application_name,      -- Nama aplikasi (jika diset oleh klien)
    client_addr,           -- Alamat IP klien (NULL jika koneksi lokal via socket)
    client_port,           -- Port klien
    backend_start,         -- Waktu backend dimulai
    query_start,           -- Waktu query saat ini dimulai
    state_change,          -- Waktu state terakhir berubah
    wait_event_type,       -- Tipe event yang sedang ditunggu (CPU, IO, Lock, etc.)
    wait_event,            -- Nama event spesifik yang ditunggu
    state,                 -- Status koneksi (active, idle, idle in transaction, etc.)
    backend_xid,           -- Top-level transaction ID (jika ada)
    backend_xmin,          -- Horizon xmin backend
    query,                 -- Teks query yang sedang berjalan (atau terakhir berjalan)
    backend_type           -- Tipe backend (client backend, autovacuum worker, etc.)
FROM pg_stat_activity;

-- Melihat hanya koneksi yang aktif (sedang menjalankan query)
SELECT pid, datname, usename, application_name, client_addr, state, wait_event_type, wait_event, query
FROM pg_stat_activity
WHERE state = 'active';

-- Melihat koneksi yang idle dalam transaksi (berpotensi menahan lock)
SELECT pid, datname, usename, application_name, client_addr, state, now() - state_change AS idle_duration, query
FROM pg_stat_activity
WHERE state = 'idle in transaction'
ORDER BY idle_duration DESC;

-- Melihat query yang berjalan lama (misal, lebih dari 30 detik)
SELECT
    pid,
    now() - query_start AS duration,
    usename,
    datname,
    state,
    query
FROM pg_stat_activity
WHERE state = 'active' AND (now() - query_start) > interval '30 seconds'
ORDER BY duration DESC;

-- =============================================
-- Membatalkan / Menghentikan Backend
-- =============================================
-- Gunakan PID dari query pg_stat_activity di atas. Jalankan sebagai superuser. Hati-hati!

-- Mencoba membatalkan query yang sedang berjalan (graceful)
-- SELECT pg_cancel_backend(<PID_TARGET>);

-- Menghentikan paksa koneksi backend (terminate)
-- SELECT pg_terminate_backend(<PID_TARGET>);

-- =============================================
-- Statistik Tabel dan Indeks
-- =============================================

-- Statistik penggunaan tabel (scan, tuple read/insert/update/delete, vacuum, analyze)
SELECT
    schemaname,
    relname AS table_name,
    seq_scan,          -- Jumlah sequential scan
    seq_tup_read,      -- Jumlah baris dibaca via sequential scan
    idx_scan,          -- Jumlah index scan
    idx_tup_fetch,     -- Jumlah baris dibaca via index scan
    n_tup_ins,         -- Jumlah baris di-insert
    n_tup_upd,         -- Jumlah baris di-update
    n_tup_del,         -- Jumlah baris di-delete
    n_live_tup,        -- Perkiraan jumlah baris hidup (live)
    n_dead_tup,        -- Perkiraan jumlah baris mati (dead)
    last_vacuum,       -- Waktu vacuum terakhir
    last_autovacuum,   -- Waktu autovacuum terakhir
    last_analyze,      -- Waktu analyze terakhir
    last_autoanalyze   -- Waktu autoanalyze terakhir
FROM pg_stat_user_tables
ORDER BY schemaname, relname;

-- Statistik penggunaan indeks
SELECT
    schemaname,
    relname AS table_name,
    indexrelname AS index_name,
    idx_scan,          -- Jumlah scan pada indeks ini
    idx_tup_read,      -- Jumlah entri indeks dikembalikan oleh scan
    idx_tup_fetch      -- Jumlah baris tabel di-fetch menggunakan indeks ini
FROM pg_stat_user_indexes
ORDER BY schemaname, relname, indexrelname;

-- Mencari indeks yang mungkin tidak terpakai (idx_scan = 0 atau sangat kecil)
SELECT
    indexrelid::regclass as index_name,
    relid::regclass as table_name,
    pg_size_pretty(pg_relation_size(indexrelid)) as index_size,
    idx_scan
FROM pg_stat_user_indexes
JOIN pg_index USING (indexrelid)
WHERE indisunique IS FALSE -- Abaikan indeks UNIQUE/PK karena mungkin dipakai untuk constraint
ORDER BY idx_scan ASC, pg_relation_size(indexrelid) DESC;


-- =============================================
-- Ukuran Database dan Objek
-- =============================================

-- Ukuran database saat ini
SELECT pg_size_pretty(pg_database_size(current_database())) AS current_db_size;

-- Ukuran semua database di server
SELECT
    datname,
    pg_size_pretty(pg_database_size(datname)) AS size
FROM pg_database
ORDER BY pg_database_size(datname) DESC;

-- Ukuran semua tabel di skema tertentu (misal 'public' dan 'penjualan'), termasuk indeks & TOAST
SELECT
    table_schema,
    table_name,
    pg_size_pretty(pg_total_relation_size('"' || table_schema || '"."' || table_name || '"')) AS total_size
FROM information_schema.tables
WHERE table_schema IN ('public', 'penjualan') -- Sesuaikan nama skema
ORDER BY pg_total_relation_size('"' || table_schema || '"."' || table_name || '"') DESC;

-- Detail ukuran tabel (tabel utama, indeks, TOAST)
SELECT
    relname AS table_name,
    pg_size_pretty(pg_table_size(oid)) AS table_size, -- Ukuran data tabel saja
    pg_size_pretty(pg_indexes_size(oid)) AS index_size, -- Ukuran semua indeks
    pg_size_pretty(pg_total_relation_size(oid)) AS total_size, -- Ukuran total
    CASE WHEN reltoastrelid = 0 THEN '0 bytes' ELSE pg_size_pretty(pg_total_relation_size(reltoastrelid)) END AS toast_size -- Ukuran TOAST data (jika ada)
FROM pg_class
WHERE relkind = 'r' -- Hanya tabel biasa (relation)
  AND relnamespace IN (SELECT oid FROM pg_namespace WHERE nspname IN ('public', 'penjualan')) -- Sesuaikan skema
ORDER BY pg_total_relation_size(oid) DESC;


-- =============================================
-- Informasi Lock (Jika ada dugaan blocking)
-- =============================================
SELECT
    locktype,              -- Tipe lock (relation, transactionid, tuple, etc.)
    database::regclass,    -- Database OID
    relation::regclass,    -- Relation OID (jika lock pada tabel/indeks)
    page,                  -- Nomor halaman (jika lock halaman)
    tuple,                 -- Nomor tuple (jika lock baris)
    virtualtransaction,    -- Virtual transaction ID
    pid,                   -- Proses ID yang menahan lock
    mode,                  -- Mode lock (AccessShareLock, RowExclusiveLock, ExclusiveLock, etc.)
    granted                -- Apakah lock sudah diberikan (t = true, f = false/menunggu)
FROM pg_locks
WHERE not granted; -- Tampilkan hanya lock yang sedang menunggu (menunjukkan adanya blocking)

-- Query lebih detail untuk melihat siapa memblokir siapa
SELECT
    blocked_locks.pid     AS blocked_pid,
    blocked_activity.usename  AS blocked_user,
    blocked_activity.query    AS blocked_query,
    blocking_locks.pid     AS blocking_pid,
    blocking_activity.usename AS blocking_user,
    blocking_activity.query   AS blocking_query,
    blocked_locks.mode    AS blocked_mode,
    blocking_locks.mode   AS blocking_mode
FROM pg_catalog.pg_locks         blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity  ON blocked_locks.pid = blocked_activity.pid
JOIN pg_catalog.pg_locks         blocking_locks ON blocking_locks.locktype = blocked_locks.locktype
    AND blocking_locks.DATABASE IS NOT DISTINCT FROM blocked_locks.DATABASE
    AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
    AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
    AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
    AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
    AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
    AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
    AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
    AND blocking_locks.pid != blocked_locks.pid
JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_locks.pid = blocking_activity.pid
WHERE NOT blocked_locks.granted;


-- Akhir File 19

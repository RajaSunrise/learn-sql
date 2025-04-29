-- File: 18_advanced_fdw.sql
-- Deskripsi: Contoh penggunaan Foreign Data Wrapper (FDW), khususnya file_fdw.
-- Catatan: file_fdw biasanya sudah include dalam paket postgresql-contrib.
--          Membutuhkan hak akses superuser atau user yang diizinkan.
--          File CSV harus dapat diakses oleh user OS yang menjalankan proses PostgreSQL server.

-- =============================================
-- Menggunakan file_fdw (Akses file CSV sebagai tabel)
-- =============================================

-- 1. Aktifkan ekstensi file_fdw (jika belum)
CREATE EXTENSION IF NOT EXISTS file_fdw;

-- 2. Buat SERVER asing yang merepresentasikan akses ke file sistem
--    Nama server bisa apa saja.
DROP SERVER IF EXISTS server_file_csv CASCADE; -- CASCADE untuk menghapus foreign table yang bergantung
CREATE SERVER server_file_csv FOREIGN DATA WRAPPER file_fdw;

-- 3. (Opsional) Buat USER MAPPING jika ingin user non-superuser mengakses
--    Secara default, hanya superuser yang bisa pakai server FDW ini.
--    Jika user 'user_aplikasi' ingin akses:
--    GRANT USAGE ON FOREIGN SERVER server_file_csv TO user_aplikasi;
--    (Tidak perlu opsi username/password untuk file_fdw)

-- 4. Buat file CSV contoh di server.
--    Misal, buat file bernama '/tmp/data_eksternal_produk.csv' (pastikan path valid dan readable oleh user postgres)
--    dengan isi:
/*
kode_produk,nama_item,harga_beli
P001,Widget Alpha,9500.75
P002,Gadget Beta,15200.50
P003,Gizmo Gamma,7800.00
*/
-- Anda perlu membuat file ini secara manual di server database.

-- 5. Buat FOREIGN TABLE yang mendefinisikan struktur file CSV
DROP FOREIGN TABLE IF EXISTS produk_eksternal_csv;
CREATE FOREIGN TABLE produk_eksternal_csv (
    kode_produk VARCHAR(10),
    nama_item TEXT,
    harga_beli NUMERIC(10, 2)
)
SERVER server_file_csv -- Tentukan server FDW yang digunakan
OPTIONS (
    filename '/tmp/data_eksternal_produk.csv', -- Path absolut ke file CSV di server
    format 'csv',                       -- Format file (bisa 'text' atau 'binary')
    header 'true'                       -- Apakah baris pertama adalah header?
    -- delimiter ',',                    -- Karakter pemisah (default koma)
    -- null ''                           -- String yang dianggap NULL (default string kosong)
);

-- 6. Query FOREIGN TABLE seperti tabel biasa
SELECT * FROM produk_eksternal_csv;

SELECT nama_item, harga_beli
FROM produk_eksternal_csv
WHERE harga_beli > 10000;

-- Data dibaca langsung dari file CSV setiap kali query dijalankan.
-- Foreign table ini bersifat read-only secara default untuk file_fdw.

-- Contoh FDW lain (misal postgres_fdw untuk konek ke DB Postgres lain)
/*
-- 1. Install postgres_fdw extension (jika belum)
-- CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- 2. Buat Server Asing menunjuk ke DB Postgres lain
-- CREATE SERVER server_db_lain
--     FOREIGN DATA WRAPPER postgres_fdw
--     OPTIONS (host 'hostname_db_lain', port '5432', dbname 'nama_db_lain');

-- 3. Buat User Mapping (menyimpan kredensial user LOKAL ke user REMOTE)
-- CREATE USER MAPPING FOR user_lokal -- User di DB saat ini
--     SERVER server_db_lain
--     OPTIONS (user 'user_remote', password 'password_remote'); -- Kredensial di DB lain

-- 4. Buat Foreign Table (mendefinisikan struktur tabel remote)
-- CREATE FOREIGN TABLE tabel_remote_produk (
--     id INT,
--     nama VARCHAR(255),
--     harga NUMERIC(10, 2)
-- )
-- SERVER server_db_lain
-- OPTIONS (schema_name 'public', table_name 'produk'); -- Nama skema & tabel di DB remote

-- 5. Query tabel asing
-- SELECT * FROM tabel_remote_produk WHERE harga < 500;
-- INSERT INTO tabel_remote_produk (id, nama, harga) VALUES (100, 'Produk Baru Remote', 450); -- Bisa writable
*/

-- Akhir File 18

-- File: 20_admin_vacuum.sql
-- Deskripsi: Contoh perintah VACUUM dan ANALYZE.
-- Catatan: Perintah ini biasanya dijalankan oleh administrator atau proses autovacuum.
--          Menjalankannya secara manual mungkin diperlukan setelah operasi besar atau untuk troubleshooting.

-- =============================================
-- VACUUM
-- =============================================
-- Membersihkan 'dead tuples' (baris mati) dan memperbarui visibility map.
-- TIDAK mengembalikan ruang ke OS (kecuali VACUUM FULL).
-- Dapat berjalan bersamaan dengan operasi baca/tulis (kecuali VACUUM FULL).

-- Menjalankan VACUUM pada tabel tertentu
VACUUM produk;

-- Menjalankan VACUUM dengan output detail (verbose)
VACUUM VERBOSE penjualan.pesanan;

-- Menjalankan VACUUM pada semua tabel di database saat ini (biasanya tidak perlu jika autovacuum aktif)
-- VACUUM;
-- VACUUM VERBOSE;

-- =============================================
-- ANALYZE
-- =============================================
-- Mengumpulkan statistik tentang distribusi data dalam tabel dan indeks.
-- Sangat penting untuk query planner memilih rencana eksekusi yang efisien.
-- Dapat berjalan bersamaan dengan operasi baca/tulis.

-- Menjalankan ANALYZE pada tabel tertentu
ANALYZE produk;

-- Menjalankan ANALYZE dengan output detail (verbose)
ANALYZE VERBOSE penjualan.pelanggan;

-- Menjalankan ANALYZE pada semua tabel di database saat ini (biasanya tidak perlu jika autovacuum aktif)
-- ANALYZE;
-- ANALYZE VERBOSE;

-- =============================================
-- VACUUM ANALYZE
-- =============================================
-- Menjalankan VACUUM dan ANALYZE secara berurutan untuk tabel.
-- Ini adalah operasi maintenance manual yang paling umum jika diperlukan.

VACUUM ANALYZE produk;
VACUUM ANALYZE VERBOSE penjualan.pesanan;

-- =============================================
-- VACUUM FULL (Gunakan dengan SANGAT HATI-HATI!)
-- =============================================
-- Menulis ulang seluruh tabel ke file baru di disk, menghilangkan bloat sepenuhnya
-- dan mengembalikan ruang kosong ke sistem operasi.
-- Membutuhkan lock EKSKLUSIF pada tabel (memblokir SEMUA operasi baca/tulis).
-- Bisa sangat lambat dan intensif I/O pada tabel besar.
-- Biasanya TIDAK diperlukan jika autovacuum dikonfigurasi dengan baik.
-- Jalankan hanya jika Anda mengidentifikasi bloat yang signifikan dan downtime dapat ditoleransi.

-- Contoh (JANGAN JALANKAN kecuali benar-benar perlu dan paham risikonya):
-- VACUUM FULL produk;
-- VACUUM FULL VERBOSE penjualan.pesanan;

-- =============================================
-- Melihat Pengaturan Autovacuum (Contoh)
-- =============================================
-- Melihat pengaturan global autovacuum
SHOW autovacuum;
SHOW autovacuum_max_workers;
SHOW autovacuum_naptime;
SHOW autovacuum_vacuum_threshold;
SHOW autovacuum_analyze_threshold;
SHOW autovacuum_vacuum_scale_factor;
SHOW autovacuum_analyze_scale_factor;
-- Pengaturan per-tabel bisa dilihat atau diubah via ALTER TABLE ... SET (...)

-- Akhir File 20

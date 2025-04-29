-- File: 11_advanced_views.sql
-- Deskripsi: Contoh pembuatan dan penggunaan Views.
-- Catatan: Asumsi tabel dan data dari file sebelumnya ada.

-- =============================================
-- CREATE VIEW
-- =============================================

-- Membuat view sederhana: Produk aktif (stok > 0) dengan harga di atas 500rb
DROP VIEW IF EXISTS view_produk_aktif_mahal;
CREATE VIEW view_produk_aktif_mahal AS
SELECT id, nama, harga, kategori, stok
FROM produk
WHERE stok > 0 AND harga > 500000;

-- Membuat view yang menggabungkan data pesanan dan pelanggan
DROP VIEW IF EXISTS penjualan.view_detail_pesanan;
CREATE VIEW penjualan.view_detail_pesanan AS
SELECT
    p.id_pesanan,
    p.tanggal_pesanan,
    p.status,
    p.total_harga,
    pl.id_pelanggan,
    pl.nama AS nama_pelanggan,
    pl.email AS email_pelanggan
FROM penjualan.pesanan AS p
LEFT JOIN penjualan.pelanggan AS pl ON p.id_pelanggan = pl.id_pelanggan;

-- =============================================
-- Menggunakan VIEW
-- =============================================

-- Menggunakan view seperti tabel biasa
SELECT * FROM view_produk_aktif_mahal WHERE kategori = 'Elektronik';

SELECT nama_pelanggan, email_pelanggan, COUNT(id_pesanan) AS jumlah_pesanan
FROM penjualan.view_detail_pesanan
GROUP BY nama_pelanggan, email_pelanggan
ORDER BY jumlah_pesanan DESC;

SELECT * FROM penjualan.view_detail_pesanan WHERE status = 'pending';

-- =============================================
-- Updatable Views (Contoh Sederhana)
-- =============================================
-- View sederhana (tanpa join, agregasi, distinct, window func, dll) bisa jadi updatable.
-- UPDATE view_produk_aktif_mahal SET stok = 5 WHERE id = <id_produk>; -- Coba dengan ID produk yang ada

-- =============================================
-- Materialized Views (Contoh)
-- =============================================
-- Menyimpan hasil query secara fisik, perlu di-refresh manual.
DROP MATERIALIZED VIEW IF EXISTS mv_summary_kategori;
CREATE MATERIALIZED VIEW mv_summary_kategori AS
SELECT
    kategori,
    COUNT(*) as jumlah_produk,
    AVG(harga) as rata_rata_harga,
    SUM(stok) as total_stok
FROM produk
WHERE kategori IS NOT NULL
GROUP BY kategori;

-- Mengakses materialized view
SELECT * FROM mv_summary_kategori ORDER BY jumlah_produk DESC;

-- Me-refresh data materialized view (setelah data di tabel produk berubah)
REFRESH MATERIALIZED VIEW mv_summary_kategori;

-- Melihat data setelah refresh
SELECT * FROM mv_summary_kategori ORDER BY jumlah_produk DESC;

-- =============================================
-- DROP VIEW
-- =============================================
DROP VIEW IF EXISTS view_produk_aktif_mahal;
DROP VIEW IF EXISTS penjualan.view_detail_pesanan;
DROP MATERIALIZED VIEW IF EXISTS mv_summary_kategori;

-- Akhir File 11

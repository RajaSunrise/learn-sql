-- File: 07_aggregates_grouping.sql
-- Deskripsi: Contoh penggunaan Fungsi Agregat, GROUP BY, dan HAVING.
-- Catatan: Asumsi tabel dan data dari file sebelumnya ada.

-- =============================================
-- Fungsi Agregat Dasar
-- =============================================

-- Jumlah total produk
SELECT COUNT(*) AS total_produk FROM produk;

-- Jumlah kategori produk yang unik (tidak termasuk NULL)
SELECT COUNT(DISTINCT kategori) AS jumlah_kategori_unik FROM produk WHERE kategori IS NOT NULL;

-- Total nilai stok semua produk
SELECT SUM(stok) AS total_stok FROM produk;

-- Harga rata-rata produk
SELECT AVG(harga) AS harga_rata_rata FROM produk;

-- Harga produk termurah dan termahal
SELECT MIN(harga) AS harga_termurah, MAX(harga) AS harga_termahal FROM produk;

-- =============================================
-- GROUP BY Clause
-- =============================================

-- Jumlah produk per kategori (abaikan kategori NULL)
SELECT kategori, COUNT(*) AS jumlah_produk
FROM produk
WHERE kategori IS NOT NULL
GROUP BY kategori
ORDER BY jumlah_produk DESC;

-- Rata-rata harga dan total stok per kategori
SELECT
    kategori,
    AVG(harga) AS rata_rata_harga,
    SUM(stok) AS total_stok
FROM produk
WHERE kategori IS NOT NULL -- Filter sebelum agregasi
GROUP BY kategori;

-- Jumlah pesanan per pelanggan
SELECT
    p.id_pelanggan,
    pl.nama,
    COUNT(p.id_pesanan) AS jumlah_pesanan
FROM penjualan.pesanan p
JOIN penjualan.pelanggan pl ON p.id_pelanggan = pl.id_pelanggan
GROUP BY p.id_pelanggan, pl.nama -- Group by semua kolom non-agregat
ORDER BY jumlah_pesanan DESC;

-- =============================================
-- HAVING Clause
-- =============================================
-- Memfilter hasil SETELAH agregasi GROUP BY.

-- Menampilkan kategori yang memiliki lebih dari 0 produk (contoh sederhana)
-- (Ganti angka 0 dengan angka yang lebih relevan untuk data Anda, misal 1 atau 5)
SELECT kategori, COUNT(*) AS jumlah_produk
FROM produk
WHERE kategori IS NOT NULL
GROUP BY kategori
HAVING COUNT(*) > 0;

-- Menampilkan kategori dengan harga rata-rata di atas 1 juta
SELECT kategori, AVG(harga) AS rata_rata_harga
FROM produk
WHERE kategori IS NOT NULL
GROUP BY kategori
HAVING AVG(harga) > 1000000;

-- Menampilkan pelanggan yang telah melakukan lebih dari 0 pesanan
SELECT
    pl.nama,
    COUNT(p.id_pesanan) AS jumlah_pesanan
FROM penjualan.pelanggan pl
JOIN penjualan.pesanan p ON pl.id_pelanggan = p.id_pelanggan
GROUP BY pl.id_pelanggan, pl.nama -- Group by PK pelanggan sudah cukup jika nama unik per ID
HAVING COUNT(p.id_pesanan) > 0;

-- Akhir File 07

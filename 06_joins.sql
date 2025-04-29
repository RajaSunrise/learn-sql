-- File: 06_joins.sql
-- Deskripsi: Contoh penggunaan JOIN untuk menggabungkan data dari beberapa tabel.
-- Catatan: Asumsi tabel dan data dari file sebelumnya ada.

-- =============================================
-- INNER JOIN
-- =============================================
-- Mengambil pesanan yang memiliki data pelanggan yang cocok.
SELECT
    p.id_pesanan,
    p.tanggal_pesanan,
    pl.nama AS nama_pelanggan,
    pl.email
FROM penjualan.pesanan AS p
INNER JOIN penjualan.pelanggan AS pl ON p.id_pelanggan = pl.id_pelanggan;

-- =============================================
-- LEFT JOIN (LEFT OUTER JOIN)
-- =============================================
-- Mengambil semua pelanggan, beserta pesanan mereka jika ada.
-- Pelanggan yang belum pernah memesan akan muncul dengan kolom pesanan bernilai NULL.
SELECT
    pl.nama,
    pl.email,
    p.id_pesanan,
    p.tanggal_pesanan,
    p.status
FROM penjualan.pelanggan AS pl -- Tabel kiri
LEFT JOIN penjualan.pesanan AS p ON pl.id_pelanggan = p.id_pelanggan;

-- =============================================
-- RIGHT JOIN (RIGHT OUTER JOIN)
-- =============================================
-- Mengambil semua pesanan, beserta data pelanggan jika ada.
-- Jika id_pelanggan di pesanan tidak valid atau NULL (jika FK memperbolehkan),
-- kolom pelanggan akan NULL. (Kurang intuitif dibanding LEFT JOIN biasanya).
SELECT
    p.id_pesanan,
    p.tanggal_pesanan,
    pl.nama AS nama_pelanggan,
    pl.email
FROM penjualan.pelanggan AS pl -- Tabel kiri
RIGHT JOIN penjualan.pesanan AS p ON pl.id_pelanggan = p.id_pelanggan; -- Tabel kanan

-- =============================================
-- FULL OUTER JOIN
-- =============================================
-- Mengambil semua pelanggan dan semua pesanan.
-- Menampilkan baris jika ada kecocokan di salah satu sisi.
-- Akan ada baris untuk pelanggan tanpa pesanan (kolom pesanan NULL).
-- Akan ada baris untuk pesanan tanpa pelanggan (kolom pelanggan NULL - jika FK memungkinkan NULL atau tidak valid).
SELECT
    pl.nama,
    pl.email,
    p.id_pesanan,
    p.tanggal_pesanan,
    p.status
FROM penjualan.pelanggan AS pl
FULL OUTER JOIN penjualan.pesanan AS p ON pl.id_pelanggan = p.id_pelanggan;

-- Akhir File 06

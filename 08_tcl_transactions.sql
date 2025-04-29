-- File: 08_tcl_transactions.sql
-- Deskripsi: Contoh penggunaan Transaction Control Language (BEGIN, COMMIT, ROLLBACK).
-- Catatan: Jalankan blok ini secara keseluruhan di psql atau klien lain yang mendukung transaksi.

-- =============================================
-- Transaksi Sukses (COMMIT)
-- =============================================
BEGIN; -- Memulai transaksi

-- Contoh: Transfer stok antar produk (misal dari produk A ke produk B)
-- Pastikan ID produk ini ada dan sesuai dengan data Anda
-- UPDATE produk SET stok = stok - 1 WHERE id = <id_produk_A> AND stok > 0;
-- UPDATE produk SET stok = stok + 1 WHERE id = <id_produk_B>;

-- Contoh sederhana: Mengurangi stok produk 1 dan mencatat penjualan (simulasi)
UPDATE produk SET stok = stok - 1 WHERE id = 1 AND stok > 0;
-- Anggap ada tabel log penjualan
-- INSERT INTO log_penjualan (id_produk, jumlah, waktu) VALUES (1, 1, NOW());

-- Jika semua operasi di atas berhasil tanpa error:
COMMIT; -- Menyimpan semua perubahan secara permanen

-- Cek hasilnya (opsional)
-- SELECT id, nama, stok FROM produk WHERE id = 1;

-- =============================================
-- Transaksi Gagal (ROLLBACK)
-- =============================================
BEGIN; -- Memulai transaksi baru

-- Simpan stok awal produk dengan id = 1 (jika ada)
-- SELECT stok FROM produk WHERE id = 1; -- Catat nilai ini

-- Operasi 1: Kurangi stok produk
UPDATE produk SET stok = stok - 5 WHERE id = 1 AND stok >= 5;

-- Operasi 2: Misalkan terjadi error di sini atau kondisi tidak terpenuhi
-- Misalnya, kita ingin membatalkan jika stok menjadi negatif (meskipun cek di atas sudah mencegah)
-- Atau ada operasi lain yang gagal.

-- Jika terjadi kesalahan atau pembatalan disengaja:
ROLLBACK; -- Membatalkan semua perubahan sejak BEGIN

-- Cek hasilnya: Stok produk dengan id = 1 seharusnya kembali ke nilai sebelum BEGIN kedua.
-- SELECT id, nama, stok FROM produk WHERE id = 1;

-- Akhir File 08

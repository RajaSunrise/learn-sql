-- File: 05_dml_update_delete.sql
-- Deskripsi: Contoh DML UPDATE dan DELETE.
-- Catatan: Asumsi data dari file 03 sudah dimasukkan. Hati-hati saat menjalankan DELETE/UPDATE.

-- =============================================
-- UPDATE
-- =============================================
-- PENTING: Selalu gunakan WHERE clause pada UPDATE kecuali Anda benar-benar
--          ingin mengubah SEMUA baris di tabel.

-- Menaikkan harga semua produk 'Elektronik' sebesar 5%
UPDATE produk
SET harga = harga * 1.05
WHERE kategori = 'Elektronik';

-- Mengubah nama dan stok produk dengan ID tertentu (misal ID 1)
-- Cek dulu apakah produk dengan ID 1 ada
-- SELECT * FROM produk WHERE id = 1;
UPDATE produk
SET
    nama = 'Laptop ABC Generasi Baru',
    stok = stok - 1
WHERE id = 1 AND stok > 0; -- Pastikan ID ada dan stok cukup

-- Mengubah kategori produk yang deskripsinya NULL menjadi 'Lain-lain'
UPDATE produk
SET kategori = 'Lain-lain'
WHERE deskripsi IS NULL AND kategori IS NULL; -- Tambahkan kondisi agar tidak menimpa kategori yg sudah ada

-- Lihat hasil update (opsional)
-- SELECT * FROM produk WHERE id = 1;
-- SELECT * FROM produk WHERE kategori = 'Elektronik';
-- SELECT * FROM produk WHERE kategori = 'Lain-lain';

-- =============================================
-- DELETE FROM
-- =============================================
-- SANGAT BERBAHAYA! Selalu gunakan WHERE clause pada DELETE kecuali Anda
--                  ingin menghapus SEMUA data di tabel.

-- Menghapus produk dengan ID tertentu (misal ID yang merujuk ke 'Mouse XYZ' jika ada)
-- Cari ID dulu jika perlu: SELECT id FROM produk WHERE nama = 'Mouse XYZ';
-- DELETE FROM produk WHERE id = <id_mouse_xyz>; -- Ganti <id_mouse_xyz> dengan ID sebenarnya

-- Contoh: Menghapus produk 'Keyboard Mekanik' berdasarkan nama
DELETE FROM produk WHERE nama = 'Keyboard Mekanik';

-- Menghapus semua produk yang stoknya 0 (jika ada)
DELETE FROM produk WHERE stok = 0;

-- Contoh melihat data setelah delete (opsional)
-- SELECT * FROM produk;

-- PERINGATAN: Perintah berikut akan menghapus SEMUA data dari tabel produk.
-- JANGAN JALANKAN kecuali Anda yakin.
-- DELETE FROM produk;

-- PERINGATAN: Perintah TRUNCATE lebih cepat tapi tidak bisa di-rollback dalam transaksi standar
-- dan tidak menjalankan trigger ON DELETE.
-- JANGAN JALANKAN kecuali Anda yakin.
-- TRUNCATE TABLE produk;

-- Akhir File 05

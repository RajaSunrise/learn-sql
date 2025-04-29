-- File: 03_dml_insert.sql
-- Deskripsi: Contoh DML untuk INSERT data ke dalam tabel.
-- Catatan: Asumsi tabel dari file 01 & 02 sudah dibuat.

-- =============================================
-- INSERT INTO
-- =============================================

-- Menyiapkan data pelanggan terlebih dahulu
-- Gunakan ON CONFLICT DO NOTHING agar bisa dijalankan ulang tanpa error jika email sudah ada.
INSERT INTO penjualan.pelanggan (id_pelanggan, nama, email) VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Budi Santoso', 'budi.s@example.com'),
    ('f81d4fae-7dec-11d0-a765-00a0c91e6bf6', 'Ani Lestari', 'ani.l@example.com')
ON CONFLICT (email) DO NOTHING; -- Abaikan jika email sudah ada

-- Menyisipkan satu baris produk, menentukan kolom yang relevan
-- Gunakan ON CONFLICT DO NOTHING agar bisa dijalankan ulang tanpa error jika nama produk sudah ada (karena ada UNIQUE constraint).
INSERT INTO produk (nama, harga, stok, kategori) VALUES
    ('Laptop ABC', 15000000.50, 10, 'Elektronik')
ON CONFLICT (nama) DO NOTHING;

-- Menyisipkan satu baris, beberapa kolom akan menggunakan nilai DEFAULT atau NULL
INSERT INTO produk (nama, harga) VALUES
    ('Mouse XYZ', 250000.00) -- stok akan jadi 0 (DEFAULT), tanggal_dibuat (DEFAULT), kategori NULL
ON CONFLICT (nama) DO NOTHING;

-- Menyisipkan beberapa baris produk sekaligus
INSERT INTO produk (nama, harga, stok, kategori) VALUES
    ('Keyboard Mekanik', 750000, 25, 'Aksesoris Komputer'),
    ('Monitor 24 inch', 2200000, 15, 'Elektronik')
ON CONFLICT (nama) DO NOTHING;

-- Menyisipkan data pesanan (membutuhkan id_pelanggan yang valid)
INSERT INTO penjualan.pesanan (id_pelanggan, total_harga, status) VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 15750000.50, 'pending'), -- Pesanan Budi
    ('f81d4fae-7dec-11d0-a765-00a0c91e6bf6', 2200000.00, 'shipped'); -- Pesanan Ani

-- Contoh Menyisipkan hasil dari query SELECT
-- Buat tabel target dulu (misalnya produk diskon)
DROP TABLE IF EXISTS produk_diskon;
CREATE TABLE produk_diskon (
    nama_produk VARCHAR(255),
    harga_lama NUMERIC(12, 2)
);

-- Masukkan produk dengan harga < 1000000
INSERT INTO produk_diskon (nama_produk, harga_lama)
SELECT nama, harga
FROM produk
WHERE harga < 1000000;

-- Lihat hasilnya (opsional)
-- SELECT * FROM produk_diskon;

-- Akhir File 03

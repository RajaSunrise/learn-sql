-- File: 16_advanced_ctes.sql
-- Deskripsi: Contoh penggunaan Common Table Expressions (CTE).
-- Catatan: Asumsi tabel dan data dari file sebelumnya ada.

-- =============================================
-- CTE Non-Rekursif Sederhana
-- =============================================

-- Menemukan pelanggan yang memesan produk termahal
WITH ProdukTermahal AS (
    -- CTE 1: Cari ID produk termahal
    SELECT id
    FROM produk
    ORDER BY harga DESC
    LIMIT 1
),
PesananProdukTermahal AS (
    -- CTE 2: Cari pesanan yang mengandung produk termahal
    -- Asumsi tabel detail_pesanan sudah ada dan terisi
    SELECT DISTINCT p.id_pelanggan
    FROM penjualan.pesanan p
    JOIN penjualan.detail_pesanan dp ON p.id_pesanan = dp.id_pesanan
    JOIN ProdukTermahal pt ON dp.id_produk = pt.id -- Join dengan CTE pertama
)
-- Query Utama: Gabungkan dengan tabel pelanggan
SELECT pl.nama, pl.email
FROM penjualan.pelanggan pl
JOIN PesananProdukTermahal ppt ON pl.id_pelanggan = ppt.id_pelanggan; -- Join dengan CTE kedua


-- Contoh lain: Menampilkan produk dengan harga di atas rata-rata
WITH RataRataHarga AS (
    SELECT AVG(harga) as avg_harga FROM produk
)
SELECT p.nama, p.harga
FROM produk p, RataRataHarga r -- Cross join (hanya 1 baris di RataRataHarga)
WHERE p.harga > r.avg_harga
ORDER BY p.harga DESC;

-- =============================================
-- CTE Rekursif (Contoh Hierarki Kategori)
-- =============================================
-- Pertama, siapkan tabel kategori dengan relasi parent-child
DROP TABLE IF EXISTS kategori CASCADE;
CREATE TABLE kategori (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    id_induk INTEGER REFERENCES kategori(id) ON DELETE SET NULL -- Kolom untuk relasi hierarki
);

-- Isi data contoh hierarki
INSERT INTO kategori (nama, id_induk) VALUES
('Elektronik', NULL),       -- Level 0 (ID 1)
    ('Komputer', 1),        -- Level 1 (ID 2)
        ('Laptop', 2),      -- Level 2 (ID 3)
        ('Desktop', 2),     -- Level 2 (ID 4)
    ('Aksesoris', 1),       -- Level 1 (ID 5)
        ('Keyboard', 5),    -- Level 2 (ID 6)
        ('Mouse', 5),       -- Level 2 (ID 7)
('Fashion', NULL),          -- Level 0 (ID 8)
    ('Pakaian Pria', 8),    -- Level 1 (ID 9)
    ('Pakaian Wanita', 8); -- Level 1 (ID 10)

-- Query menggunakan CTE Rekursif untuk menampilkan hierarki
WITH RECURSIVE HierarkiKategori AS (
    -- Bagian Anchor (Basis Rekursi): Pilih kategori level teratas (tidak punya induk)
    SELECT
        id,
        nama,
        id_induk,
        0 AS level, -- Level kedalaman hierarki
        ARRAY[nama] AS path_nama -- Menyimpan path sebagai array nama
    FROM kategori
    WHERE id_induk IS NULL

    UNION ALL -- Gabungkan hasil basis dengan hasil rekursif

    -- Bagian Rekursif: Cari anak dari kategori yang sudah ditemukan di langkah sebelumnya
    SELECT
        k.id,
        k.nama,
        k.id_induk,
        hk.level + 1, -- Tingkatkan level
        hk.path_nama || k.nama -- Tambahkan nama ke path
    FROM kategori k
    JOIN HierarkiKategori hk ON k.id_induk = hk.id -- Join dengan hasil CTE itu sendiri
)
-- Query Utama: Tampilkan hasil dari CTE Rekursif
SELECT
    id,
    nama,
    id_induk,
    level,
    path_nama,
    array_to_string(path_nama, ' > ') AS breadcrumb -- Tampilkan path sebagai string
FROM HierarkiKategori
ORDER BY path_nama; -- Urutkan berdasarkan path untuk visualisasi hierarki

-- Akhir File 16

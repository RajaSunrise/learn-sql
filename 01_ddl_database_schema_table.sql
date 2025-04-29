-- File: 01_ddl_database_schema_table.sql
-- Deskripsi: Contoh DDL untuk membuat Database, Schema, Tabel, Alter, dan Drop.

-- =============================================
-- CREATE DATABASE
-- =============================================
-- Catatan: Perintah CREATE DATABASE biasanya dijalankan dari psql saat terhubung
-- ke database lain (seperti 'postgres') atau dari command line, bukan
-- sebagai bagian dari skrip yang dijalankan pada database target.
-- Contoh ini disertakan untuk kelengkapan. Anda mungkin perlu menjalankannya secara terpisah.

-- CREATE DATABASE toko_online;

-- Contoh dengan opsi tambahan:
/*
CREATE DATABASE toko_online_dev
    WITH
    OWNER = user_dev -- Pastikan role 'user_dev' sudah ada
    ENCODING = 'UTF8'
    LC_COLLATE = 'id_ID.UTF-8' -- Sesuaikan dengan locale sistem Anda jika perlu
    LC_CTYPE = 'id_ID.UTF-8'
    CONNECTION LIMIT = 100;
*/

-- =============================================
-- CREATE SCHEMA
-- =============================================
-- Anda harus terhubung ke database target (misal 'toko_online') untuk menjalankan ini.
CREATE SCHEMA IF NOT EXISTS penjualan;
CREATE SCHEMA IF NOT EXISTS inventaris;

-- =============================================
-- CREATE TABLE
-- =============================================
-- Membuat tabel 'produk' di skema default 'public'
DROP TABLE IF EXISTS produk CASCADE; -- Hapus jika sudah ada (hati-hati!)
CREATE TABLE produk (
    id SERIAL PRIMARY KEY, -- Kolom ID unik, auto-increment, sebagai primary key
    nama VARCHAR(255) NOT NULL, -- Nama produk, maks 255 char, tidak boleh kosong
    deskripsi TEXT,             -- Deskripsi panjang, boleh kosong
    harga NUMERIC(10, 2) NOT NULL CHECK (harga >= 0), -- Harga, presisi 10 digit total, 2 di belakang koma, tidak boleh kosong, harus >= 0
    stok INTEGER DEFAULT 0,     -- Jumlah stok, default 0 jika tidak diisi
    tanggal_dibuat TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP -- Waktu baris dibuat
);

-- Membuat tabel 'pelanggan' di skema 'penjualan'
DROP TABLE IF EXISTS penjualan.pelanggan CASCADE;
CREATE TABLE penjualan.pelanggan (
    id_pelanggan UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- Menggunakan UUID sebagai PK (membutuhkan ekstensi pgcrypto atau uuid-ossp jika < PG13, atau bawaan di PG13+)
    nama_lengkap VARCHAR(150) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL, -- Email harus unik dan tidak boleh kosong
    tanggal_daftar DATE DEFAULT CURRENT_DATE
);

-- Membuat tabel 'pesanan' dengan Foreign Key
DROP TABLE IF EXISTS penjualan.pesanan CASCADE;
CREATE TABLE penjualan.pesanan (
    id_pesanan BIGSERIAL PRIMARY KEY,
    id_pelanggan UUID, -- Diperbarui di file constraints untuk NOT NULL dan FK
    tanggal_pesanan TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    total_harga NUMERIC(12, 2),
    status VARCHAR(50) DEFAULT 'pending'
    -- Constraint Foreign Key akan ditambahkan di file 02_ddl_constraints.sql
);

-- =============================================
-- ALTER TABLE
-- =============================================

-- Menambah kolom baru
ALTER TABLE produk ADD COLUMN IF NOT EXISTS kategori VARCHAR(100);

-- Menghapus kolom (Hati-hati!)
-- ALTER TABLE produk DROP COLUMN IF EXISTS deskripsi;

-- Mengubah tipe data kolom (Hati-hati, pastikan kompatibel!)
ALTER TABLE produk ALTER COLUMN harga TYPE NUMERIC(12, 2);

-- Menambah constraint NOT NULL (jika kolom sudah ada)
-- Catatan: Jika ada data NULL, ini akan gagal. Pastikan data valid dulu.
-- UPDATE produk SET kategori = 'Default' WHERE kategori IS NULL; -- Contoh penanganan data NULL
ALTER TABLE produk ALTER COLUMN kategori SET NOT NULL;

-- Menghapus constraint NOT NULL
ALTER TABLE produk ALTER COLUMN kategori DROP NOT NULL;

-- Menambah constraint UNIQUE (akan dibahas lebih detail di file constraints)
ALTER TABLE produk ADD CONSTRAINT produk_nama_unik UNIQUE (nama);

-- Menambah constraint CHECK (akan dibahas lebih detail di file constraints)
-- Hapus constraint check lama jika ada
ALTER TABLE produk DROP CONSTRAINT IF EXISTS harga_positif;
ALTER TABLE produk ADD CONSTRAINT harga_positif CHECK (harga > 0);

-- Mengganti nama kolom
ALTER TABLE penjualan.pelanggan RENAME COLUMN nama_lengkap TO nama;

-- Mengganti nama tabel
ALTER TABLE produk RENAME TO barang;
-- Mengembalikan nama tabel untuk konsistensi contoh berikutnya
ALTER TABLE barang RENAME TO produk;

-- =============================================
-- DROP TABLE
-- =============================================

-- Menghapus tabel jika ada
DROP TABLE IF EXISTS produk_lama;

-- Menghapus tabel beserta objek yang bergantung padanya (misal: views, foreign keys ke tabel ini)
-- Contoh (jalankan jika benar-benar ingin menghapus pelanggan dan pesanan):
-- DROP TABLE IF EXISTS penjualan.pelanggan CASCADE; -- Ini akan menghapus pesanan juga jika ada FK ON DELETE CASCADE

-- Akhir File 01

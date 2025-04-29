-- File: 10_advanced_indexes.sql
-- Deskripsi: Contoh pembuatan berbagai jenis Indeks.
-- Catatan: Asumsi tabel dari file sebelumnya ada. Pembuatan indeks bisa memakan waktu pada tabel besar.

-- =============================================
-- Indeks B-tree (Default)
-- =============================================

-- Membuat indeks B-tree pada kolom email di tabel pelanggan (sudah ada UNIQUE constraint, biasanya otomatis membuat indeks)
-- Tapi jika belum ada atau ingin nama spesifik:
DROP INDEX IF EXISTS penjualan.idx_pelanggan_email;
CREATE INDEX idx_pelanggan_email ON penjualan.pelanggan (email);

-- Membuat indeks pada kolom harga produk
DROP INDEX IF EXISTS idx_produk_harga;
CREATE INDEX idx_produk_harga ON produk (harga);

-- Membuat indeks pada beberapa kolom (composite index)
-- Efektif untuk query WHERE id_pelanggan = .. AND tanggal_pesanan = ..
-- atau WHERE id_pelanggan = ..
DROP INDEX IF EXISTS penjualan.idx_pesanan_pelanggan_tanggal;
CREATE INDEX idx_pesanan_pelanggan_tanggal ON penjualan.pesanan (id_pelanggan, tanggal_pesanan);

-- =============================================
-- Indeks Unik
-- =============================================
-- Constraint UNIQUE biasanya otomatis membuat indeks unik.
-- Contoh eksplisit (jika constraint belum dibuat):
DROP INDEX IF EXISTS idx_produk_nama_unik_expl;
CREATE UNIQUE INDEX idx_produk_nama_unik_expl ON produk (nama);
-- Ini akan gagal jika constraint unique 'produk_nama_unik' sudah ada.

-- =============================================
-- Indeks Fungsional (Functional Index)
-- =============================================
-- Berguna untuk query yang memfilter/mengurutkan berdasarkan hasil fungsi.
-- Contoh: Pencarian nama pelanggan case-insensitive.
DROP INDEX IF EXISTS penjualan.idx_pelanggan_nama_lower;
CREATE INDEX idx_pelanggan_nama_lower ON penjualan.pelanggan (LOWER(nama));
-- Query yang bisa memanfaatkan indeks ini:
-- SELECT * FROM penjualan.pelanggan WHERE LOWER(nama) = 'budi santoso';

-- =============================================
-- Indeks GIN (Generalized Inverted Index)
-- =============================================
-- Biasanya digunakan untuk tipe data array, JSONB, full-text search.
-- Contoh: Mengindeks kolom JSONB (akan ditambahkan di file JSONB)
-- ALTER TABLE produk ADD COLUMN IF NOT EXISTS atribut JSONB;
-- UPDATE produk SET atribut = '{"warna": "merah", "tags": ["baru", "promo"]}' WHERE id = 1;
-- DROP INDEX IF EXISTS idx_produk_atribut_gin;
-- CREATE INDEX idx_produk_atribut_gin ON produk USING GIN (atribut);
-- Query: SELECT * FROM produk WHERE atribut @> '{"tags": ["baru"]}';

-- Contoh untuk Full Text Search (membutuhkan kolom tsvector)
-- ALTER TABLE produk ADD COLUMN IF NOT EXISTS fts_vector tsvector;
-- UPDATE produk SET fts_vector = to_tsvector('indonesian', coalesce(nama, '') || ' ' || coalesce(deskripsi, ''));
-- DROP INDEX IF EXISTS idx_produk_fts;
-- CREATE INDEX idx_produk_fts ON produk USING GIN (fts_vector);
-- Query: SELECT nama FROM produk WHERE fts_vector @@ to_tsquery('indonesian', 'laptop & bagus');

-- =============================================
-- Melihat Indeks pada Tabel
-- =============================================
-- Gunakan perintah psql berikut:
-- \d produk
-- \d penjualan.pelanggan
-- \d penjualan.pesanan

-- =============================================
-- Analisis Penggunaan Indeks (Menggunakan EXPLAIN)
-- =============================================
-- Jalankan di psql untuk melihat rencana eksekusi query:
-- EXPLAIN ANALYZE SELECT * FROM produk WHERE harga > 1000000;
-- EXPLAIN ANALYZE SELECT * FROM penjualan.pelanggan WHERE LOWER(nama) = 'budi santoso';
-- Perhatikan apakah "Index Scan", "Bitmap Heap Scan", atau "Seq Scan" digunakan.

-- Akhir File 10

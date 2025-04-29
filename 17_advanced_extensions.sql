-- File: 17_advanced_extensions.sql
-- Deskripsi: Contoh penggunaan Ekstensi PostgreSQL.
-- Catatan: Ekstensi mungkin perlu diinstal di level OS terlebih dahulu.
--          Jalankan perintah ini sebagai superuser atau user dengan privilege CREATE EXTENSION.

-- =============================================
-- Melihat Ekstensi yang Tersedia
-- =============================================
-- Menampilkan daftar ekstensi yang paketnya sudah terinstal di server
-- dan siap diaktifkan di database ini.
SELECT name, default_version, installed_version, comment
FROM pg_available_extensions
ORDER BY name;

-- =============================================
-- Mengaktifkan Ekstensi
-- =============================================

-- Mengaktifkan ekstensi 'uuid-ossp' (jika belum aktif)
-- Berguna untuk generate UUID versi lama (v1, v3, v5). PG13+ punya gen_random_uuid() bawaan.
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Mengaktifkan ekstensi 'pgcrypto' (jika belum aktif)
-- Menyediakan fungsi hashing (MD5, SHA) dan enkripsi (PGP).
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Mengaktifkan ekstensi 'pg_trgm' (jika belum aktif)
-- Untuk perbandingan similaritas teks berdasarkan trigram.
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Mengaktifkan ekstensi 'hstore' (jika belum aktif)
-- Tipe data key-value store sederhana.
CREATE EXTENSION IF NOT EXISTS hstore;

-- (Contoh untuk PostGIS - butuh instalasi OS yang lebih kompleks)
-- CREATE EXTENSION IF NOT EXISTS postgis;

-- =============================================
-- Menggunakan Fungsi dari Ekstensi
-- =============================================

-- Contoh fungsi dari 'uuid-ossp'
SELECT uuid_generate_v1() AS uuid_v1, uuid_generate_v4() AS uuid_v4;
-- Fungsi bawaan PG13+ (tidak butuh ekstensi)
SELECT gen_random_uuid() AS random_uuid;

-- Contoh fungsi dari 'pgcrypto'
-- Hashing password (gunakan crypt() dengan algoritma yang kuat seperti bcrypt 'bf')
SELECT crypt('password_saya', gen_salt('bf', 8)) AS hashed_password;
-- Verifikasi password: SELECT (crypt('password_dicoba', hashed_password) = hashed_password);
-- Enkripsi/Dekripsi PGP (simetris)
-- SELECT pgp_sym_encrypt('data rahasia', 'kunci enkripsi') AS encrypted_data;
-- SELECT pgp_sym_decrypt(encrypted_data, 'kunci enkripsi') AS decrypted_data;

-- Contoh fungsi/operator dari 'pg_trgm'
-- Mengukur similaritas antara dua string (0-1)
SELECT similarity('postgresql', 'postgres');
SELECT similarity('panduan postgresql', 'belajar postgres');
-- Mencari string yang mirip (menggunakan operator %) - butuh indeks GIN/GiST trgm untuk performa
-- ALTER TABLE produk ADD CONSTRAINT produk_nama_trgm_idx GIN(nama gin_trgm_ops);
-- SELECT nama FROM produk WHERE nama % 'Laptop ABC'; -- Cari yang mirip

-- Contoh penggunaan 'hstore'
-- ALTER TABLE produk ADD COLUMN IF NOT EXISTS extra_info hstore;
-- UPDATE produk SET extra_info = '"garansi"=>"1 tahun", "warna"=>"hitam", "buatan"=>"China"'::hstore WHERE id = 1;
-- SELECT nama, extra_info -> 'garansi' AS garansi FROM produk WHERE extra_info ? 'garansi';
-- SELECT nama, extra_info FROM produk WHERE extra_info @> '"warna"=>"hitam"'::hstore;

-- =============================================
-- Menonaktifkan (Drop) Ekstensi
-- =============================================
-- Hati-hati: Ini akan menghapus semua objek yang dibuat oleh ekstensi (fungsi, tipe data, operator).
-- Pastikan tidak ada objek database lain yang bergantung padanya.

-- DROP EXTENSION IF EXISTS "uuid-ossp";
-- DROP EXTENSION IF EXISTS pgcrypto;
-- DROP EXTENSION IF EXISTS pg_trgm;
-- DROP EXTENSION IF EXISTS hstore;
-- DROP EXTENSION IF EXISTS postgis;

-- Akhir File 17

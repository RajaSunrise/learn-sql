-- File: 14_advanced_jsonb.sql
-- Deskripsi: Contoh penggunaan tipe data JSON dan JSONB.
-- Catatan: Asumsi tabel produk ada. JSONB umumnya lebih disarankan.

-- =============================================
-- Menambah Kolom JSONB
-- =============================================
ALTER TABLE produk ADD COLUMN IF NOT EXISTS spesifikasi JSONB;
ALTER TABLE produk ADD COLUMN IF NOT EXISTS atribut JSONB; -- Kolom lain untuk contoh GIN Index

-- =============================================
-- Menyisipkan/Memperbarui Data JSONB
-- =============================================
UPDATE produk
SET spesifikasi = '{
    "warna": "hitam",
    "ram_gb": 16,
    "storage": {"tipe": "SSD", "kapasitas_gb": 512},
    "fitur": ["backlit keyboard", "fingerprint reader", "webcam"],
    "berat_kg": 1.8,
    "tersedia": true,
    "supplier": null
}'
WHERE nama ILIKE '%Laptop ABC%'; -- Sesuaikan dengan nama laptop Anda

UPDATE produk
SET spesifikasi = '{
    "resolusi": "1920x1080",
    "refresh_rate_hz": 75,
    "port": ["HDMI", "VGA", "DisplayPort"],
    "warna": "silver"
}'
WHERE nama ILIKE '%Monitor%'; -- Sesuaikan dengan nama monitor Anda

UPDATE produk
SET atribut = '{"warna": "merah", "tags": ["baru", "promo", "gaming"]}'
WHERE nama ILIKE '%Keyboard%'; -- Sesuaikan nama keyboard

-- =============================================
-- Mengambil Nilai dari JSONB
-- =============================================

-- Operator -> (mengembalikan JSON/JSONB) dan ->> (mengembalikan TEXT)
SELECT
    nama,
    spesifikasi -> 'ram_gb' AS ram_json, -- Hasilnya JSONB: 16
    spesifikasi ->> 'warna' AS warna_text, -- Hasilnya TEXT: 'hitam'
    spesifikasi -> 'storage' ->> 'tipe' AS tipe_storage_text, -- Hasilnya TEXT: 'SSD'
    spesifikasi -> 'storage' -> 'kapasitas_gb' AS kapasitas_storage_json -- Hasilnya JSONB: 512
FROM produk
WHERE spesifikasi IS NOT NULL AND nama ILIKE '%Laptop ABC%';

-- Operator #> (path, hasil JSON/JSONB) dan #>> (path, hasil TEXT)
SELECT
    nama,
    spesifikasi #> '{storage, kapasitas_gb}' AS kapasitas_json_path, -- Hasil JSONB: 512
    spesifikasi #>> '{storage, kapasitas_gb}' AS kapasitas_text_path, -- Hasil TEXT: '512'
    spesifikasi -> 'fitur' ->> 0 AS fitur_pertama_text, -- Akses elemen array (indeks 0), hasil TEXT
    spesifikasi #>> '{fitur, 1}' AS fitur_kedua_text -- Akses elemen array via path, hasil TEXT
FROM produk
WHERE spesifikasi IS NOT NULL AND nama ILIKE '%Laptop ABC%';

-- =============================================
-- Query Menggunakan Kondisi pada JSONB
-- =============================================

-- Mencari produk dengan RAM 16GB (casting ke tipe numerik untuk perbandingan)
SELECT nama, spesifikasi ->> 'ram_gb' AS ram
FROM produk
WHERE (spesifikasi -> 'ram_gb')::int = 16;

-- Mencari produk dengan storage tipe SSD (menggunakan ->> dan perbandingan teks)
SELECT nama, spesifikasi -> 'storage' ->> 'tipe' AS tipe_storage
FROM produk
WHERE spesifikasi -> 'storage' ->> 'tipe' = 'SSD';

-- Operator Containment (@>) - Sangat efisien dengan Indeks GIN
-- Mencari produk yang spesifikasinya MENGANDUNG JSON tertentu
-- Buat indeks GIN dulu (jika belum ada dari file index):
DROP INDEX IF EXISTS idx_produk_spec_gin;
CREATE INDEX idx_produk_spec_gin ON produk USING GIN (spesifikasi);

-- Cari produk dengan storage SSD
SELECT nama, spesifikasi
FROM produk
WHERE spesifikasi @> '{"storage": {"tipe": "SSD"}}';

-- Cari produk dengan fitur "fingerprint reader" (dalam array)
SELECT nama, spesifikasi
FROM produk
WHERE spesifikasi @> '{"fitur": ["fingerprint reader"]}';
-- Perhatikan: Harus dalam bentuk array jika value di JSONB adalah array

-- Cari produk yang tersedia (boolean)
SELECT nama, spesifikasi
FROM produk
WHERE spesifikasi @> '{"tersedia": true}';

-- Operator Existence (?) - Cek apakah top-level key ada
SELECT nama, spesifikasi
FROM produk
WHERE spesifikasi ? 'berat_kg';

-- Operator Existence Any (?|) - Cek apakah salah satu key (dari array) ada
SELECT nama, spesifikasi
FROM produk
WHERE spesifikasi ?| array['resolusi', 'ram_gb'];

-- Operator Existence All (?&) - Cek apakah semua key (dari array) ada
SELECT nama, spesifikasi
FROM produk
WHERE spesifikasi ?& array['warna', 'storage'];

-- =============================================
-- Memodifikasi JSONB (UPDATE)
-- =============================================

-- Menambahkan atau mengganti field
UPDATE produk
SET spesifikasi = spesifikasi || '{"ports_usb": 3}'::jsonb
WHERE nama ILIKE '%Laptop ABC%';

-- Mengganti nilai field yang nested
UPDATE produk
SET spesifikasi = jsonb_set(spesifikasi, '{storage, kapasitas_gb}', '1024'::jsonb)
WHERE nama ILIKE '%Laptop ABC%';

-- Menghapus field
UPDATE produk
SET spesifikasi = spesifikasi - 'berat_kg'
WHERE nama ILIKE '%Laptop ABC%';

-- Menghapus elemen dari array (misal 'webcam')
UPDATE produk
SET spesifikasi = jsonb_set(spesifikasi, '{fitur}', (spesifikasi->'fitur') - 'webcam')
WHERE nama ILIKE '%Laptop ABC%';

-- Cek hasil modifikasi
-- SELECT nama, spesifikasi FROM produk WHERE nama ILIKE '%Laptop ABC%';

-- Akhir File 14

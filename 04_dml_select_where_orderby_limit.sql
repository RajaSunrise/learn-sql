-- File: 04_dml_select_where_orderby_limit.sql
-- Deskripsi: Contoh DML SELECT dengan klausa WHERE, ORDER BY, LIMIT/OFFSET.
-- Catatan: Asumsi data dari file 03 sudah dimasukkan.

-- =============================================
-- SELECT
-- =============================================

-- Mengambil semua kolom (*) dari semua baris tabel produk
SELECT * FROM produk;

-- Mengambil kolom tertentu
SELECT nama, harga, stok FROM produk;

-- Mengambil data dengan alias kolom dan perhitungan
SELECT
    nama AS nama_produk,
    harga AS harga_jual,
    (harga * 0.11) AS ppn_11_persen -- Contoh PPN 11%
FROM produk;

-- =============================================
-- WHERE Clause
-- =============================================

-- Mengambil produk dengan harga di bawah 1 juta
SELECT nama, harga FROM produk WHERE harga < 1000000;

-- Mengambil produk dalam kategori 'Elektronik' (Case-sensitive)
SELECT * FROM produk WHERE kategori = 'Elektronik';

-- Menggunakan ILIKE untuk pencarian case-insensitive
SELECT * FROM produk WHERE nama ILIKE '%laptop%'; -- Mencari nama yang mengandung 'laptop'

-- Menggunakan operator AND, OR, NOT
SELECT * FROM produk WHERE kategori = 'Elektronik' AND harga > 10000000;
SELECT * FROM produk WHERE stok = 0 OR kategori = 'Aksesoris Komputer';
SELECT * FROM produk WHERE NOT kategori = 'Elektronik'; -- atau <> atau !=
SELECT * FROM produk WHERE kategori <> 'Elektronik';

-- Menggunakan IN untuk mencocokkan dengan beberapa nilai
SELECT * FROM produk WHERE kategori IN ('Elektronik', 'Aksesoris Komputer');

-- Menggunakan BETWEEN untuk rentang nilai (inklusif)
SELECT * FROM produk WHERE harga BETWEEN 500000 AND 1000000;

-- Memeriksa nilai NULL
SELECT * FROM produk WHERE deskripsi IS NULL;
SELECT * FROM produk WHERE kategori IS NOT NULL;

-- =============================================
-- ORDER BY Clause
-- =============================================

-- Mengurutkan produk berdasarkan harga, termurah ke termahal (ASC default)
SELECT nama, harga FROM produk ORDER BY harga ASC;
-- atau
SELECT nama, harga FROM produk ORDER BY harga;

-- Mengurutkan produk berdasarkan harga, termahal ke termurah (DESC)
SELECT nama, harga FROM produk ORDER BY harga DESC;

-- Mengurutkan berdasarkan beberapa kolom (pertama berdasarkan kategori ASC, lalu harga DESC)
SELECT nama, kategori, harga FROM produk ORDER BY kategori ASC, harga DESC;

-- =============================================
-- LIMIT / OFFSET
-- =============================================

-- Mengambil 2 produk termahal
SELECT nama, harga FROM produk ORDER BY harga DESC LIMIT 2;

-- Mengambil 2 produk, dimulai dari produk ke-3 (OFFSET 2) berdasarkan ID
SELECT * FROM produk ORDER BY id LIMIT 2 OFFSET 2;
-- Berguna untuk pagination (misal: halaman 2, 2 item per halaman)

-- Akhir File 04

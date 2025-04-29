-- File: 15_advanced_window_functions.sql
-- Deskripsi: Contoh penggunaan Fungsi Window.
-- Catatan: Asumsi tabel dan data dari file sebelumnya ada.

-- =============================================
-- ROW_NUMBER, RANK, DENSE_RANK
-- =============================================

-- Memberi nomor urut pada semua produk berdasarkan harga (termurah ke termahal)
SELECT
    nama,
    harga,
    kategori,
    ROW_NUMBER() OVER (ORDER BY harga ASC) AS nomor_urut_keseluruhan
FROM produk;

-- Memberi ranking produk berdasarkan harga DESC dalam setiap kategori
SELECT
    nama,
    kategori,
    harga,
    ROW_NUMBER() OVER (PARTITION BY kategori ORDER BY harga DESC) AS rn_per_kategori, -- Nomor urut unik dalam partisi
    RANK()       OVER (PARTITION BY kategori ORDER BY harga DESC) AS rank_harga_per_kategori, -- Bisa ada lompatan rank jika ada nilai sama
    DENSE_RANK() OVER (PARTITION BY kategori ORDER BY harga DESC) AS dense_rank_harga -- Tidak ada lompatan rank
FROM produk
WHERE kategori IS NOT NULL
ORDER BY kategori, harga DESC;

-- =============================================
-- Fungsi Agregat sebagai Window Function
-- =============================================

-- Menghitung total harga kumulatif pesanan per hari (running total)
SELECT
    id_pesanan,
    tanggal_pesanan::date AS tanggal,
    total_harga,
    SUM(total_harga) OVER (ORDER BY tanggal_pesanan::date, id_pesanan) AS total_kumulatif_harian
FROM penjualan.pesanan
WHERE total_harga IS NOT NULL
ORDER BY tanggal, id_pesanan;

-- Menampilkan harga produk bersama dengan harga rata-rata di kategorinya
SELECT
    nama,
    kategori,
    harga,
    AVG(harga) OVER (PARTITION BY kategori) AS avg_harga_di_kategori
FROM produk
WHERE kategori IS NOT NULL;

-- Menampilkan harga produk dan perbedaannya dengan harga rata-rata kategori
SELECT
    nama,
    kategori,
    harga,
    harga - AVG(harga) OVER (PARTITION BY kategori) AS diff_from_avg_kategori
FROM produk
WHERE kategori IS NOT NULL;

-- Menampilkan total stok per kategori di setiap baris produk
SELECT
    nama,
    kategori,
    stok,
    SUM(stok) OVER (PARTITION BY kategori) AS total_stok_di_kategori
FROM produk
WHERE kategori IS NOT NULL;

-- =============================================
-- LAG dan LEAD
-- =============================================
-- Membandingkan nilai baris saat ini dengan baris sebelumnya/berikutnya dalam partisi.

-- Membandingkan harga pesanan saat ini dengan harga pesanan sebelumnya (berdasarkan tanggal)
SELECT
    id_pesanan,
    tanggal_pesanan,
    total_harga,
    LAG(total_harga, 1, 0.0) OVER (ORDER BY tanggal_pesanan, id_pesanan) AS harga_pesanan_sebelumnya,
    -- LAG(kolom, offset, default_value_jika_tidak_ada)
    LEAD(total_harga, 1, 0.0) OVER (ORDER BY tanggal_pesanan, id_pesanan) AS harga_pesanan_berikutnya
    -- LEAD(kolom, offset, default_value_jika_tidak_ada)
FROM penjualan.pesanan
WHERE total_harga IS NOT NULL
ORDER BY tanggal_pesanan, id_pesanan;

-- Membandingkan harga produk saat ini dengan produk termahal sebelumnya dalam kategori yang sama
SELECT
    nama,
    kategori,
    harga,
    LAG(nama) OVER (PARTITION BY kategori ORDER BY harga DESC) AS nama_produk_lebih_mahal_sebelumnya,
    LAG(harga) OVER (PARTITION BY kategori ORDER BY harga DESC) AS harga_produk_lebih_mahal_sebelumnya
FROM produk
WHERE kategori IS NOT NULL
ORDER BY kategori, harga DESC;

-- =============================================
-- NTILE
-- =============================================
-- Membagi partisi menjadi N kelompok (bucket) berdasarkan urutan.

-- Membagi produk menjadi 4 kelompok (kuartil) berdasarkan harga
SELECT
    nama,
    harga,
    NTILE(4) OVER (ORDER BY harga ASC) AS kuartil_harga
FROM produk;

-- Membagi produk dalam setiap kategori menjadi 2 kelompok (atas/bawah) berdasarkan stok
SELECT
    nama,
    kategori,
    stok,
    NTILE(2) OVER (PARTITION BY kategori ORDER BY stok DESC) AS kelompok_stok_per_kategori -- 1 = stok atas, 2 = stok bawah
FROM produk
WHERE kategori IS NOT NULL
ORDER BY kategori, stok DESC;

-- Akhir File 15

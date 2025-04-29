-- File: 02_ddl_constraints.sql
-- Deskripsi: Contoh DDL untuk mendefinisikan dan menambah Constraints.
-- Catatan: Asumsi tabel dari file 01 sudah dibuat.

-- =============================================
-- CONSTRAINTS
-- =============================================
-- Tabel produk sudah memiliki PRIMARY KEY (id), NOT NULL (nama, harga), CHECK (harga >= 0), UNIQUE (nama) dari file 01.
-- Tabel pelanggan sudah memiliki PRIMARY KEY (id_pelanggan), NOT NULL (nama, email), UNIQUE (email).

-- Menambahkan Foreign Key Constraint ke tabel 'pesanan'
-- Pastikan kolom id_pelanggan di pesanan adalah NOT NULL terlebih dahulu
ALTER TABLE penjualan.pesanan ALTER COLUMN id_pelanggan SET NOT NULL;

-- Hapus constraint FK lama jika ada (untuk idempotensi skrip)
ALTER TABLE penjualan.pesanan DROP CONSTRAINT IF EXISTS fk_pelanggan;

-- Tambahkan constraint Foreign Key
ALTER TABLE penjualan.pesanan
    ADD CONSTRAINT fk_pelanggan
    FOREIGN KEY (id_pelanggan) -- Kolom di tabel pesanan
    REFERENCES penjualan.pelanggan (id_pelanggan) -- Mereferensi tabel pelanggan kolom id_pelanggan
    ON DELETE SET NULL -- Jika pelanggan dihapus, set id_pelanggan di pesanan ini jadi NULL
    -- Opsi lain:
    -- ON DELETE CASCADE -- Jika pelanggan dihapus, hapus juga pesanannya. Hati-hati!
    -- ON DELETE RESTRICT -- Larang hapus pelanggan jika masih punya pesanan (default jika tidak dispesifikasi).
    -- ON DELETE NO ACTION -- Sama seperti RESTRICT, tapi dicek di akhir statement/transaksi.
    -- ON UPDATE CASCADE -- Jika id_pelanggan di tabel pelanggan berubah, ubah juga di pesanan (jarang terjadi pada PK).
;

-- Contoh Menambahkan Constraint CHECK pada tabel 'pesanan'
ALTER TABLE penjualan.pesanan DROP CONSTRAINT IF EXISTS status_valid;
ALTER TABLE penjualan.pesanan
    ADD CONSTRAINT status_valid
    CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled'));

-- Contoh Constraint pada Beberapa Kolom (misal UNIQUE constraint)
-- DROP TABLE IF EXISTS contoh_multi_unique;
-- CREATE TABLE contoh_multi_unique (
--     col_a INT,
--     col_b INT,
--     CONSTRAINT unique_a_b UNIQUE (col_a, col_b) -- Kombinasi col_a dan col_b harus unik
-- );

-- Akhir File 02

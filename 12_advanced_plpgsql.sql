-- File: 12_advanced_plpgsql.sql
-- Deskripsi: Contoh pembuatan Stored Functions dan Procedures menggunakan PL/pgSQL.
-- Catatan: Asumsi tabel dan data dari file sebelumnya ada.

-- Buat tabel detail pesanan untuk contoh fungsi/prosedur
DROP TABLE IF EXISTS penjualan.detail_pesanan;
CREATE TABLE penjualan.detail_pesanan (
    id_detail BIGSERIAL PRIMARY KEY,
    id_pesanan BIGINT NOT NULL REFERENCES penjualan.pesanan(id_pesanan) ON DELETE CASCADE,
    id_produk INT NOT NULL REFERENCES produk(id) ON DELETE RESTRICT, -- Produk tidak bisa dihapus jika ada di detail pesanan
    jumlah INT NOT NULL CHECK (jumlah > 0),
    harga_saat_beli NUMERIC(12, 2) NOT NULL
);

-- Isi data contoh (sesuaikan ID pesanan dan produk)
-- Misal pesanan 1 (Budi) beli produk 1 (Laptop)
-- INSERT INTO penjualan.detail_pesanan (id_pesanan, id_produk, jumlah, harga_saat_beli)
-- VALUES ( (SELECT id_pesanan FROM penjualan.pesanan WHERE status='pending' LIMIT 1), 1, 1, 15000000.50);
-- Misal pesanan 2 (Ani) beli produk 4 (Monitor)
-- INSERT INTO penjualan.detail_pesanan (id_pesanan, id_produk, jumlah, harga_saat_beli)
-- VALUES ( (SELECT id_pesanan FROM penjualan.pesanan WHERE status='shipped' LIMIT 1), 4, 1, 2200000.00);


-- =============================================
-- Stored Function (PL/pgSQL)
-- =============================================

-- Fungsi: Menghitung total harga item dalam satu pesanan
CREATE OR REPLACE FUNCTION penjualan.hitung_total_harga_item_pesanan(p_id_pesanan BIGINT)
RETURNS NUMERIC AS $$ -- Tipe data kembalian
DECLARE -- Deklarasi variabel lokal
    v_total NUMERIC := 0;
BEGIN
    -- Logika: Jumlahkan (harga saat beli * jumlah) dari detail pesanan
    SELECT SUM(dp.harga_saat_beli * dp.jumlah)
    INTO v_total -- Simpan hasil ke variabel v_total
    FROM penjualan.detail_pesanan dp
    WHERE dp.id_pesanan = p_id_pesanan;

    -- Kembalikan total, atau 0 jika pesanan tidak ada item atau NULL
    RETURN COALESCE(v_total, 0);
END;
$$ LANGUAGE plpgsql; -- Bahasa yang digunakan

-- Memanggil fungsi dalam SELECT
-- Cari ID pesanan yang ada dulu
-- SELECT id_pesanan FROM penjualan.pesanan LIMIT 1;
-- Ganti <id_pesanan_valid> dengan ID yang ada
-- SELECT id_pesanan, tanggal_pesanan, penjualan.hitung_total_harga_item_pesanan(<id_pesanan_valid>) AS total_item
-- FROM penjualan.pesanan
-- WHERE id_pesanan = <id_pesanan_valid>;

-- Contoh penggunaan untuk mengupdate total_harga di tabel pesanan
-- UPDATE penjualan.pesanan
-- SET total_harga = penjualan.hitung_total_harga_item_pesanan(id_pesanan)
-- WHERE id_pesanan = <id_pesanan_valid>;


-- =============================================
-- Stored Procedure (PL/pgSQL - Sejak PG11)
-- =============================================
-- Prosedur: Memproses pesanan (mengubah status & mengurangi stok)
CREATE OR REPLACE PROCEDURE penjualan.proses_pesanan(p_id_pesanan BIGINT)
AS $$
DECLARE
    r_item RECORD; -- Variabel untuk menampung baris dari loop (item pesanan)
    v_stok_cukup BOOLEAN := TRUE;
    v_id_produk_stok_kurang INT;
BEGIN
    -- Validasi Awal: Cek apakah pesanan ada dan statusnya 'pending'
    IF NOT EXISTS (SELECT 1 FROM penjualan.pesanan WHERE id_pesanan = p_id_pesanan AND status = 'pending') THEN
        RAISE EXCEPTION 'Pesanan ID % tidak ditemukan atau statusnya bukan pending.', p_id_pesanan;
    END IF;

    -- 1. Cek ketersediaan stok untuk SEMUA item dalam pesanan SEBELUM mengurangi
    FOR r_item IN SELECT dp.id_produk, dp.jumlah, pr.stok
                  FROM penjualan.detail_pesanan dp
                  JOIN produk pr ON dp.id_produk = pr.id
                  WHERE dp.id_pesanan = p_id_pesanan
    LOOP
        IF r_item.stok < r_item.jumlah THEN
            v_stok_cukup := FALSE;
            v_id_produk_stok_kurang := r_item.id_produk;
            EXIT; -- Keluar dari loop jika satu item stoknya kurang
        END IF;
    END LOOP;

    -- 2. Jika stok tidak cukup, batalkan proses dan berikan pesan error
    IF NOT v_stok_cukup THEN
        RAISE EXCEPTION 'Stok tidak cukup untuk produk ID % dalam pesanan ID %.', v_id_produk_stok_kurang, p_id_pesanan;
    END IF;

    -- 3. Jika stok cukup, Lanjutkan proses (dalam satu transaksi implisit prosedur)
    --    Update status pesanan
    UPDATE penjualan.pesanan SET status = 'processing' WHERE id_pesanan = p_id_pesanan;

    -- 4. Kurangi stok untuk setiap item dalam pesanan
    FOR r_item IN SELECT id_produk, jumlah FROM penjualan.detail_pesanan WHERE id_pesanan = p_id_pesanan
    LOOP
        UPDATE produk SET stok = stok - r_item.jumlah
        WHERE id = r_item.id_produk;
    END LOOP;

    -- Prosedur tidak mengembalikan nilai secara langsung.
    -- COMMIT/ROLLBACK bisa dilakukan di sini, TAPI biasanya lebih baik
    -- membiarkan pemanggil prosedur mengontrol transaksi.
    -- Jika prosedur dipanggil dalam transaksi yang sudah ada, COMMIT/ROLLBACK di sini akan error (kecuali PG11+ dengan fitur tertentu).
    -- Jika dipanggil di luar transaksi, prosedur akan berjalan dalam transaksinya sendiri.

    RAISE NOTICE 'Pesanan ID % berhasil diproses.', p_id_pesanan;

END;
$$ LANGUAGE plpgsql;

-- Memanggil prosedur
-- Pastikan ada pesanan dengan status 'pending' dan stok produknya cukup.
-- Cari ID pesanan pending: SELECT id_pesanan FROM penjualan.pesanan WHERE status = 'pending';
-- CALL penjualan.proses_pesanan(<id_pesanan_pending_valid>);

-- Cek hasilnya (status pesanan dan stok produk)
-- SELECT status FROM penjualan.pesanan WHERE id_pesanan = <id_pesanan_pending_valid>;
-- SELECT id, nama, stok FROM produk WHERE id IN (SELECT id_produk FROM penjualan.detail_pesanan WHERE id_pesanan = <id_pesanan_pending_valid>);

-- Akhir File 12

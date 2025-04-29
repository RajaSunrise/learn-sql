-- File: 13_advanced_triggers.sql
-- Deskripsi: Contoh pembuatan Trigger dan Trigger Functions.
-- Catatan: Asumsi tabel dan data dari file sebelumnya ada.

-- Buat tabel log untuk contoh trigger
DROP TABLE IF EXISTS log_harga_produk;
CREATE TABLE log_harga_produk (
    id_log SERIAL PRIMARY KEY,
    id_produk INT,
    harga_lama NUMERIC(12, 2),
    harga_baru NUMERIC(12, 2),
    waktu_perubahan TIMESTAMPTZ DEFAULT NOW(),
    user_pengubah NAME DEFAULT current_user -- Menyimpan user DB yang melakukan perubahan
);

-- =============================================
-- Trigger Function 1: Log Perubahan Harga
-- =============================================
CREATE OR REPLACE FUNCTION log_perubahan_harga()
RETURNS TRIGGER AS $$
BEGIN
    -- Hanya jalankan jika operasi adalah UPDATE dan kolom 'harga' benar-benar berubah.
    -- Gunakan IS DISTINCT FROM untuk menangani NULL dengan benar.
    IF TG_OP = 'UPDATE' AND NEW.harga IS DISTINCT FROM OLD.harga THEN
        INSERT INTO log_harga_produk (id_produk, harga_lama, harga_baru)
        VALUES (OLD.id, OLD.harga, NEW.harga); -- OLD merujuk ke data sebelum update, NEW ke data sesudah
    END IF;

    -- Untuk trigger AFTER, nilai kembalian diabaikan (bisa RETURN NULL).
    -- Untuk trigger BEFORE, RETURN NEW melanjutkan operasi, RETURN NULL membatalkan.
    RETURN NEW; -- Mengembalikan baris baru agar UPDATE tetap berjalan
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- Trigger Definition 1: Kaitkan fungsi ke tabel produk
-- =============================================
-- Hapus trigger lama jika ada
DROP TRIGGER IF EXISTS trg_log_harga_produk ON produk;

-- Buat trigger baru
CREATE TRIGGER trg_log_harga_produk
AFTER UPDATE ON produk -- Jalankan SETELAH operasi UPDATE selesai di tabel produk
FOR EACH ROW -- Jalankan fungsi untuk setiap baris yang terpengaruh oleh UPDATE
WHEN (OLD.harga IS DISTINCT FROM NEW.harga) -- Kondisi tambahan (opsional, bisa juga di dalam fungsi)
EXECUTE FUNCTION log_perubahan_harga();

-- =============================================
-- Contoh Pengujian Trigger 1
-- =============================================
-- Cek harga produk (misal ID 1) sebelum update
-- SELECT id, nama, harga FROM produk WHERE id = 1;
-- Cek isi tabel log (seharusnya kosong)
-- SELECT * FROM log_harga_produk;

-- Lakukan UPDATE harga pada produk ID 1
-- UPDATE produk SET harga = harga + 100000 WHERE id = 1;

-- Cek harga produk lagi (seharusnya sudah berubah)
-- SELECT id, nama, harga FROM produk WHERE id = 1;
-- Cek isi tabel log (seharusnya ada 1 baris baru)
-- SELECT * FROM log_harga_produk;

-- Lakukan UPDATE tapi harga sama (seharusnya tidak menambah log)
-- UPDATE produk SET stok = stok - 1 WHERE id = 1;
-- SELECT * FROM log_harga_produk; -- Jumlah log tidak bertambah

-- =============================================
-- Trigger Function 2: Mencegah Penghapusan Kategori Tertentu
-- =============================================
CREATE OR REPLACE FUNCTION cegah_hapus_kategori_penting()
RETURNS TRIGGER AS $$
BEGIN
    -- Cek jika operasi adalah DELETE dan kategori produk lama adalah 'Elektronik'
    IF TG_OP = 'DELETE' AND OLD.kategori = 'Elektronik' THEN
        -- Batalkan operasi DELETE dengan memunculkan exception
        RAISE EXCEPTION 'Tidak dapat menghapus produk dalam kategori penting: %', OLD.kategori
              USING HINT = 'Ubah kategori produk terlebih dahulu jika ingin menghapus.';
    END IF;

    -- Untuk trigger BEFORE DELETE, kembalikan OLD agar operasi dilanjutkan (jika tidak dibatalkan)
    -- atau NULL untuk membatalkan secara diam-diam.
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- Trigger Definition 2: Kaitkan fungsi ke tabel produk
-- =============================================
DROP TRIGGER IF EXISTS trg_cegah_hapus_kategori_penting ON produk;

CREATE TRIGGER trg_cegah_hapus_kategori_penting
BEFORE DELETE ON produk -- Jalankan SEBELUM operasi DELETE
FOR EACH ROW -- Untuk setiap baris yang akan dihapus
EXECUTE FUNCTION cegah_hapus_kategori_penting();

-- =============================================
-- Contoh Pengujian Trigger 2
-- =============================================
-- Coba hapus produk dari kategori lain (misal 'Aksesoris Komputer' atau 'Lain-lain')
-- Cari ID produknya dulu: SELECT id, nama, kategori FROM produk WHERE kategori <> 'Elektronik' LIMIT 1;
-- DELETE FROM produk WHERE id = <id_produk_non_elektronik>; -- Seharusnya berhasil

-- Coba hapus produk dari kategori 'Elektronik'
-- Cari ID produknya dulu: SELECT id, nama, kategori FROM produk WHERE kategori = 'Elektronik' LIMIT 1;
-- DELETE FROM produk WHERE id = <id_produk_elektronik>; -- Seharusnya GAGAL dan menampilkan pesan EXCEPTION

-- Akhir File 13

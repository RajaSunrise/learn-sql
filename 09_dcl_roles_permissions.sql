-- File: 09_dcl_roles_permissions.sql
-- Deskripsi: Contoh Data Control Language (DCL) untuk manajemen Role dan Hak Akses.
-- Catatan: Perintah ini biasanya dijalankan oleh superuser atau user dengan privilege yang cukup.

-- =============================================
-- Manajemen Roles (Pengguna dan Grup)
-- =============================================

-- Membuat role/user baru yang bisa login
DROP ROLE IF EXISTS user_aplikasi;
CREATE ROLE user_aplikasi LOGIN PASSWORD 'password_rahasia'; -- Ganti password!

-- Membuat role grup (tidak bisa login)
DROP ROLE IF EXISTS staf_penjualan;
CREATE ROLE staf_penjualan;

-- Memberikan role 'staf_penjualan' kepada 'user_aplikasi'
-- user_aplikasi akan mewarisi hak akses dari 'staf_penjualan'
GRANT staf_penjualan TO user_aplikasi;

-- =============================================
-- GRANT (Memberikan Hak Akses)
-- =============================================

-- Memberikan hak akses USAGE pada skema 'penjualan' kepada grup staf_penjualan
-- Tanpa ini, anggota grup tidak bisa 'melihat' atau mengakses objek di dalam skema
GRANT USAGE ON SCHEMA penjualan TO staf_penjualan;

-- Memberikan hak akses SELECT pada tabel produk ke user_aplikasi secara langsung
GRANT SELECT ON TABLE produk TO user_aplikasi;

-- Memberikan hak akses SELECT, INSERT, UPDATE pada SEMUA tabel di skema penjualan ke grup staf_penjualan
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA penjualan TO staf_penjualan;
-- Catatan: Ini hanya berlaku untuk tabel yang SUDAH ADA saat perintah dijalankan.

-- Untuk tabel yang AKAN DIBUAT di masa depan, gunakan DEFAULT PRIVILEGES.
-- Misal, user 'admin' (atau user lain yang membuat tabel) harus memberikan default privs:
-- Ganti 'admin' dengan role yang relevan yang akan membuat tabel baru
-- ALTER DEFAULT PRIVILEGES FOR ROLE admin IN SCHEMA penjualan
--    GRANT SELECT, INSERT, UPDATE ON TABLES TO staf_penjualan;

-- Memberikan hak eksekusi pada fungsi (jika ada fungsi yang relevan)
-- GRANT EXECUTE ON FUNCTION penjualan.hitung_total_pesanan(BIGINT) TO staf_penjualan;

-- =============================================
-- REVOKE (Mencabut Hak Akses)
-- =============================================

-- Mencabut hak akses UPDATE dari user_aplikasi pada tabel produk
REVOKE UPDATE ON TABLE produk FROM user_aplikasi;

-- Mencabut hak akses INSERT dari grup staf_penjualan pada semua tabel di skema penjualan
REVOKE INSERT ON ALL TABLES IN SCHEMA penjualan FROM staf_penjualan;

-- Mencabut keanggotaan grup
-- REVOKE staf_penjualan FROM user_aplikasi;

-- =============================================
-- Mengubah Role
-- =============================================

-- Mengubah password role
ALTER ROLE user_aplikasi PASSWORD 'password_baru_lebih_aman'; -- Ganti password!

-- Menambahkan atribut SUPERUSER (Hati-hati!)
-- ALTER ROLE user_aplikasi SUPERUSER;
-- Menghapus atribut SUPERUSER
-- ALTER ROLE user_aplikasi NOSUPERUSER;

-- Menetapkan batas koneksi
ALTER ROLE user_aplikasi CONNECTION LIMIT 50;

-- Menetapkan validitas password
ALTER ROLE user_aplikasi VALID UNTIL '2025-01-01';

-- =============================================
-- Menghapus Role
-- =============================================
-- Tidak bisa menghapus role jika masih memiliki objek atau menjadi anggota grup lain.
-- Hapus objek/cabut keanggotaan dulu atau gunakan DROP OWNED dan REASSIGN OWNED.

-- Contoh: Menghapus user dan grup yang dibuat di atas
-- REVOKE staf_penjualan FROM user_aplikasi; -- Cabut keanggotaan dulu
-- DROP ROLE IF EXISTS user_aplikasi;
-- DROP ROLE IF EXISTS staf_penjualan;

-- Akhir File 09

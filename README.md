# Panduan Komprehensif Belajar PostgreSQL

![PostgreSQL Logo](https://wiki.postgresql.org/images/a/a4/PostgreSQL_logo.3colors.svg)

Selamat datang di repositori panduan belajar PostgreSQL! Dokumen ini bertujuan untuk menjadi sumber daya yang lengkap dan terstruktur bagi siapa saja yang ingin mempelajari PostgreSQL, mulai dari konsep dasar hingga fitur-fitur tingkat lanjut dan praktik administrasi dasar.

**Target Audiens:** Pemula hingga Menengah yang ingin memahami dan menggunakan PostgreSQL secara efektif.

## Deskripsi

PostgreSQL, seringkali disebut "Postgres", adalah sistem manajemen basis data relasional objek (ORDBMS) sumber terbuka (open-source) yang sangat kuat, stabil, dan dapat diperluas. Dikenal karena kepatuhannya terhadap standar SQL, keandalannya, set fitur yang kaya, dan komunitas yang aktif, PostgreSQL menjadi pilihan populer untuk berbagai jenis aplikasi, mulai dari proyek kecil hingga sistem skala besar yang kritikal.

Panduan ini akan membawa Anda melalui perjalanan belajar PostgreSQL, mencakup:

*   **Konsep Dasar:** Memahami apa itu database relasional dan mengapa PostgreSQL unggul.
*   **Instalasi:** Menyiapkan PostgreSQL di lingkungan pengembangan Anda.
*   **SQL Fundamental:** Menguasai bahasa SQL untuk berinteraksi dengan database (membuat tabel, memasukkan data, mengambil data, memodifikasi data).
*   **Fitur Lanjutan:** Menjelajahi kemampuan unik PostgreSQL seperti tipe data JSONB, fungsi window, indeks tingkat lanjut, dan lainnya.
*   **Administrasi Dasar:** Mempelajari tugas-tugas penting seperti backup, restore, dan manajemen pengguna.
*   **Tools & Ekosistem:** Mengenal alat bantu populer yang memudahkan pengembangan dan administrasi.

## Mengapa Belajar PostgreSQL?

Ada banyak alasan kuat mengapa PostgreSQL layak dipelajari dan digunakan:

1.  **Sumber Terbuka (Open Source):** Sepenuhnya gratis digunakan, dimodifikasi, dan didistribusikan di bawah lisensi liberal PostgreSQL. Tidak ada biaya lisensi yang mahal atau vendor lock-in.
2.  **Kepatuhan Standar SQL:** PostgreSQL sangat patuh terhadap standar SQL (saat ini SQL:2016). Ini memastikan portabilitas query dan memudahkan transisi bagi mereka yang sudah familiar dengan SQL.
3.  **Ekstensibilitas Tinggi:** Memungkinkan Anda mendefinisikan tipe data, fungsi, operator, fungsi agregat, metode indeks, dan bahasa prosedural sendiri. Ekstensi seperti PostGIS (untuk data geospasial) menunjukkan kekuatan ini.
4.  **Keandalan dan Stabilitas:** Memiliki reputasi yang sangat baik dalam hal stabilitas dan integritas data. Dengan fitur seperti Multi-Version Concurrency Control (MVCC), Write-Ahead Logging (WAL), dan Point-in-Time Recovery (PITR), PostgreSQL dirancang untuk menangani beban kerja kritis.
5.  **Set Fitur yang Kaya:** Mendukung berbagai fitur canggih yang seringkali hanya ditemukan di database komersial mahal, termasuk:
    *   Tipe data kompleks (Array, JSON/JSONB, HSTORE, Geometris)
    *   Full-Text Search
    *   Foreign Data Wrappers (untuk terhubung ke database atau sumber data lain)
    *   Fungsi Window
    *   Common Table Expressions (CTE) Rekursif
    *   Kendala (Constraints) yang fleksibel
6.  **Konkurensi yang Kuat:** Menggunakan sistem Multi-Version Concurrency Control (MVCC) untuk menangani banyak koneksi pengguna secara bersamaan dengan efisien. Pembaca tidak memblok penulis, dan penulis tidak memblok pembaca.
7.  **Komunitas Aktif dan Mendukung:** Didukung oleh komunitas global yang berdedikasi yang terus mengembangkan, memperbaiki bug, dan menyediakan dukungan melalui milis, forum, dan platform lainnya.
8.  **Skalabilitas:** Mampu menangani volume data yang besar dan beban kerja yang tinggi. Mendukung replikasi bawaan (streaming replication) untuk high availability dan read scaling.

## Prasyarat

*   **Pemahaman Dasar Komputer:** Familiar dengan penggunaan terminal atau command prompt di sistem operasi Anda (Windows, macOS, atau Linux).
*   **Konsep Dasar Database (Membantu, tapi tidak wajib):** Memiliki sedikit gambaran tentang apa itu database dan tabel akan membantu, tetapi panduan ini akan mencoba menjelaskan dari dasar.
*   **Keinginan untuk Belajar:** Motivasi untuk memahami cara kerja database relasional dan bahasa SQL.

## Daftar Isi

1.  [Instalasi PostgreSQL](#1-instalasi-postgresql)
    *   [Windows](#instalasi-di-windows)
    *   [macOS](#instalasi-di-macos)
    *   [Linux (Debian/Ubuntu)](#instalasi-di-linux-debianubuntu)
    *   [Docker](#instalasi-menggunakan-docker)
    *   [Verifikasi Instalasi](#verifikasi-instalasi)
2.  [Dasar-dasar SQL dengan PostgreSQL](#2-dasar-dasar-sql-dengan-postgresql)
    *   [Menghubungkan ke Database (`psql`)](#menghubungkan-ke-database-psql)
    *   [Konsep Dasar: Database, Skema, Tabel, Kolom, Baris](#konsep-dasar-database-skema-tabel-kolom-baris)
    *   [Tipe Data Umum](#tipe-data-umum)
    *   [DDL (Data Definition Language)](#ddl-data-definition-language)
        *   [`CREATE DATABASE`](#create-database)
        *   [`CREATE SCHEMA`](#create-schema)
        *   [`CREATE TABLE`](#create-table)
        *   [`ALTER TABLE`](#alter-table)
        *   [`DROP TABLE`](#drop-table)
        *   [Kendala (Constraints)](#kendala-constraints)
    *   [DML (Data Manipulation Language)](#dml-data-manipulation-language)
        *   [`INSERT INTO`](#insert-into)
        *   [`SELECT`](#select)
        *   [`WHERE`](#where-clause)
        *   [`ORDER BY`](#order-by-clause)
        *   [`LIMIT` / `OFFSET`](#limit--offset)
        *   [`UPDATE`](#update)
        *   [`DELETE FROM`](#delete-from)
    *   [Mengambil Data dari Beberapa Tabel (JOINs)](#mengambil-data-dari-beberapa-tabel-joins)
        *   [`INNER JOIN`](#inner-join)
        *   [`LEFT JOIN` (atau `LEFT OUTER JOIN`)](#left-join-atau-left-outer-join)
        *   [`RIGHT JOIN` (atau `RIGHT OUTER JOIN`)](#right-join-atau-right-outer-join)
        *   [`FULL OUTER JOIN`](#full-outer-join)
    *   [Fungsi Agregat](#fungsi-agregat)
        *   [`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`](#count-sum-avg-min-max)
        *   [`GROUP BY`](#group-by-clause)
        *   [`HAVING`](#having-clause)
    *   [TCL (Transaction Control Language)](#tcl-transaction-control-language)
        *   [Konsep ACID](#konsep-acid)
        *   [`BEGIN`, `COMMIT`, `ROLLBACK`](#begin-commit-rollback)
    *   [DCL (Data Control Language) - Pengantar](#dcl-data-control-language---pengantar)
        *   [`GRANT`, `REVOKE`](#grant-revoke)
3.  [Fitur Tingkat Lanjut PostgreSQL](#3-fitur-tingkat-lanjut-postgresql)
    *   [Indeks (Indexes)](#indeks-indexes)
    *   [Views](#views)
    *   [Stored Procedures dan Functions (PL/pgSQL)](#stored-procedures-dan-functions-plpgsql)
    *   [Triggers](#triggers)
    *   [Tipe Data JSON dan JSONB](#tipe-data-json-dan-jsonb)
    *   [Fungsi Window (Window Functions)](#fungsi-window-window-functions)
    *   [Common Table Expressions (CTEs)](#common-table-expressions-ctes)
    *   [Ekstensi (Extensions)](#ekstensi-extensions)
    *   [Foreign Data Wrappers (FDW)](#foreign-data-wrappers-fdw)
4.  [Administrasi Dasar PostgreSQL](#4-administrasi-dasar-postgresql)
    *   [Backup dan Restore](#backup-dan-restore)
        *   [`pg_dump`](#pg_dump)
        *   [`pg_restore` / `psql`](#pg_restore--psql)
    *   [Manajemen Pengguna dan Hak Akses (Roles)](#manajemen-pengguna-dan-hak-akses-roles)
    *   [Monitoring Dasar](#monitoring-dasar)
    *   [Vacuuming dan Analisis](#vacuuming-dan-analisis)
5.  [Tools dan Ekosistem PostgreSQL](#5-tools-dan-ekosistem-postgresql)
    *   [Klien CLI: `psql`](#klien-cli-psql)
    *   [Klien GUI](#klien-gui)
    *   [Object-Relational Mappers (ORMs)](#object-relational-mappers-orms)
    *   [Alat Migrasi Skema](#alat-migrasi-skema)
6.  [Sumber Belajar Lanjutan](#6-sumber-belajar-lanjutan)
7.  [Kontribusi](#7-kontribusi)
8.  [Lisensi](#8-lisensi)

---

## 1. Instalasi PostgreSQL

Langkah pertama adalah menginstal server PostgreSQL dan alat kliennya di sistem Anda.

### Instalasi di Windows

Cara termudah adalah menggunakan installer dari EnterpriseDB (EDB), yang menyertakan server PostgreSQL, alat baris perintah `psql`, dan GUI pgAdmin.

1.  Kunjungi halaman [download PostgreSQL EDB](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads).
2.  Pilih versi PostgreSQL terbaru dan sistem operasi Windows Anda.
3.  Unduh installer dan jalankan.
4.  Ikuti wizard instalasi:
    *   Pilih direktori instalasi.
    *   Pilih komponen yang akan diinstal (minimal Server, Command Line Tools, pgAdmin).
    *   Pilih direktori data (tempat data database disimpan).
    *   **Tetapkan kata sandi** untuk pengguna superuser `postgres`. **Ingat kata sandi ini!**
    *   Pilih port (default 5432).
    *   Pilih locale (biasanya default sudah baik).
5.  Selesaikan instalasi.
6.  Pastikan direktori `bin` PostgreSQL (misalnya, `C:\Program Files\PostgreSQL\<versi>\bin`) ditambahkan ke variabel lingkungan `PATH` sistem Anda agar Anda bisa menjalankan `psql` dari mana saja.

### Instalasi di macOS

Ada beberapa cara:

1.  **Postgres.app (Direkomendasikan untuk pemula):** Aplikasi mandiri yang mudah digunakan.
    *   Unduh dari [Postgres.app](https://postgresapp.com/).
    *   Seret ke folder Aplikasi Anda.
    *   Jalankan aplikasi untuk memulai server. Konfigurasikan `PATH` Anda seperti instruksi di situs web mereka untuk menggunakan `psql` dari terminal.
2.  **Homebrew:** Manajer paket populer untuk macOS.
    ```bash
    brew update
    brew install postgresql
    # Untuk memulai server saat login:
    brew services start postgresql
    # Atau untuk memulai secara manual:
    pg_ctl -D /usr/local/var/postgres start
    # Inisialisasi cluster database jika belum ada (biasanya dilakukan otomatis oleh brew)
    # initdb /usr/local/var/postgres
    ```
    Secara default, tidak ada kata sandi untuk pengguna `postgres` atau pengguna macOS Anda saat menggunakan Homebrew. Anda mungkin perlu membuat pengguna/database awal: `createdb`

### Instalasi di Linux (Debian/Ubuntu)

Gunakan manajer paket bawaan.

```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
```

*   Instalasi ini secara otomatis membuat pengguna sistem `postgres` dan pengguna database superuser `postgres`.
*   Server biasanya dimulai secara otomatis. Anda bisa memeriksanya dengan: `sudo systemctl status postgresql`
*   Untuk terhubung sebagai superuser `postgres`, gunakan: `sudo -u postgres psql`

### Instalasi Menggunakan Docker

Jika Anda familiar dengan Docker, ini adalah cara yang bagus untuk menjalankan PostgreSQL dalam lingkungan terisolasi.

```bash
# Mengunduh image PostgreSQL terbaru
docker pull postgres

# Menjalankan container PostgreSQL
docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 -d postgres
# --name some-postgres: Nama container (bisa diganti)
# -e POSTGRES_PASSWORD=mysecretpassword: Menetapkan kata sandi untuk user 'postgres'
# -p 5432:5432: Memetakan port 5432 host ke port 5432 container
# -d: Menjalankan container di background (detached mode)
# postgres: Nama image yang digunakan

# Untuk menyimpan data secara persisten, gunakan volume:
docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 -v pgdata:/var/lib/postgresql/data -d postgres
# -v pgdata:/var/lib/postgresql/data: Membuat volume bernama 'pgdata' dan me-mountnya ke direktori data PostgreSQL di dalam container
```

### Verifikasi Instalasi

Buka terminal atau command prompt Anda dan coba hubungkan menggunakan `psql`:

```bash
# Format umum: psql -h <host> -p <port> -U <user> -d <database>
# Contoh koneksi ke server lokal, sebagai user 'postgres', ke database default 'postgres'
psql -U postgres -h localhost

# Jika Anda menginstal di Linux via apt:
sudo -u postgres psql

# Jika Anda menggunakan Docker (dengan container bernama 'some-postgres'):
docker exec -it some-postgres psql -U postgres
```

Anda akan diminta memasukkan kata sandi yang Anda tetapkan saat instalasi (kecuali untuk beberapa metode instalasi Linux/Homebrew). Jika berhasil, Anda akan melihat prompt `psql` seperti `postgres=#`. Ketik `\q` lalu Enter untuk keluar.

---

## 2. Dasar-dasar SQL dengan PostgreSQL

SQL (Structured Query Language) adalah bahasa standar untuk berinteraksi dengan database relasional. PostgreSQL mendukung sebagian besar fitur standar SQL dan menambahkan beberapa ekstensi sendiri.

### Menghubungkan ke Database (`psql`)

`psql` adalah klien baris perintah interaktif untuk PostgreSQL. Ini sangat kuat dan berguna untuk menjalankan query, skrip, dan tugas administrasi.

```bash
# Menghubungkan ke database tertentu
psql -U nama_user -d nama_database -h nama_host

# Contoh: Menghubungkan sebagai user 'admin' ke database 'toko_online' di localhost
psql -U admin -d toko_online -h localhost
```

Beberapa perintah `psql` yang berguna (meta-commands, dimulai dengan `\`):

*   `\l`: Menampilkan daftar semua database.
*   `\c nama_database`: Menghubungkan ke database lain.
*   `\dt`: Menampilkan daftar tabel di database saat ini (dalam skema default `public`).
*   `\d nama_tabel`: Menampilkan struktur (kolom, tipe data, indeks) dari tabel tertentu.
*   `\dn`: Menampilkan daftar skema.
*   `\df`: Menampilkan daftar fungsi.
*   `\dv`: Menampilkan daftar view.
*   `\du`: Menampilkan daftar pengguna (roles).
*   `\?`: Menampilkan bantuan untuk perintah `psql`.
*   `\q`: Keluar dari `psql`.
*   `\timing`: Menampilkan waktu eksekusi untuk setiap query.
*   `\i nama_file.sql`: Menjalankan perintah SQL dari file.

### Konsep Dasar: Database, Skema, Tabel, Kolom, Baris

*   **Database Server:** Proses perangkat lunak yang mengelola data. Satu server PostgreSQL dapat mengelola banyak database.
*   **Database:** Kumpulan objek terkait data, seperti tabel, view, fungsi, dll. Bertindak sebagai wadah terisolasi. Anda terhubung ke *satu* database spesifik pada satu waktu.
*   **Skema (Schema):** Namespace di dalam database. Memungkinkan pengelompokan objek (seperti tabel) secara logis. Secara default, objek dibuat dalam skema `public`. Anda bisa membuat skema lain (misalnya, `penjualan`, `hrd`) untuk organisasi yang lebih baik. Nama objek harus unik *dalam satu skema*. Anda bisa mereferensikan objek di skema lain menggunakan `nama_skema.nama_objek`.
*   **Tabel (Table):** Struktur utama untuk menyimpan data. Terdiri dari kolom dan baris. Mirip dengan spreadsheet.
*   **Kolom (Column / Field / Attribute):** Mendefinisikan jenis data yang dapat disimpan dalam tabel (misalnya, nama, usia, tanggal lahir). Setiap kolom memiliki nama dan tipe data.
*   **Baris (Row / Record / Tuple):** Satu entri data dalam tabel. Berisi nilai untuk setiap kolom dalam tabel tersebut.

### Tipe Data Umum

PostgreSQL mendukung berbagai macam tipe data. Beberapa yang paling umum digunakan:

*   **Numerik:**
    *   `INTEGER` atau `INT`: Bilangan bulat (positif/negatif).
    *   `SMALLINT`: Bilangan bulat dengan jangkauan lebih kecil (hemat ruang).
    *   `BIGINT`: Bilangan bulat dengan jangkauan sangat besar.
    *   `NUMERIC(precision, scale)` atau `DECIMAL(precision, scale)`: Angka desimal presisi tetap. `precision` adalah total digit, `scale` adalah jumlah digit di belakang koma. Sangat baik untuk data keuangan.
    *   `REAL` atau `FLOAT4`: Angka floating-point presisi tunggal (kurang akurat).
    *   `DOUBLE PRECISION` atau `FLOAT8`: Angka floating-point presisi ganda (lebih akurat).
    *   `SERIAL`, `BIGSERIAL`: Sama seperti `INTEGER` atau `BIGINT`, tetapi secara otomatis menghasilkan nilai unik yang bertambah saat baris baru dimasukkan (biasa digunakan untuk Primary Key).
*   **Teks/String:**
    *   `VARCHAR(n)`: String teks dengan panjang variabel, maksimal `n` karakter.
    *   `CHAR(n)`: String teks dengan panjang tetap `n` karakter (jarang digunakan).
    *   `TEXT`: String teks dengan panjang variabel tanpa batas eksplisit (paling fleksibel).
*   **Tanggal/Waktu:**
    *   `DATE`: Hanya tanggal (tahun, bulan, hari).
    *   `TIME`: Hanya waktu (jam, menit, detik).
    *   `TIMESTAMP`: Tanggal dan waktu.
    *   `TIMESTAMPTZ` atau `TIMESTAMP WITH TIME ZONE`: Tanggal dan waktu, disimpan dalam UTC dan dikonversi ke/dari zona waktu sesi saat ditampilkan/dimasukkan. **Sangat direkomendasikan untuk sebagian besar aplikasi.**
    *   `INTERVAL`: Rentang waktu (misalnya, '2 hari', '5 jam').
*   **Logika:**
    *   `BOOLEAN`: Nilai `TRUE`, `FALSE`, atau `NULL`.
*   **Lainnya:**
    *   `UUID`: Pengenal unik universal.
    *   `JSON`, `JSONB`: Menyimpan data JSON (JSONB adalah format biner yang lebih efisien dan mendukung pengindeksan).
    *   `ARRAY`: Memungkinkan kolom menyimpan array dari tipe data lain (misalnya, `INTEGER[]`, `TEXT[]`).

### DDL (Data Definition Language)

Perintah SQL untuk mendefinisikan atau memodifikasi struktur database.

#### `CREATE DATABASE`

Membuat database baru. Anda biasanya menjalankan ini dari `psql` saat terhubung ke database lain (seperti `postgres`) atau dari shell sistem.

```sql
CREATE DATABASE toko_online;

-- Dengan opsi tambahan (jarang diperlukan di awal)
CREATE DATABASE toko_online_dev
    WITH
    OWNER = user_dev
    ENCODING = 'UTF8'
    LC_COLLATE = 'id_ID.UTF-8' -- Penentuan urutan sortir
    LC_CTYPE = 'id_ID.UTF-8'   -- Penentuan klasifikasi karakter
    CONNECTION LIMIT = 100;
```

#### `CREATE SCHEMA`

Membuat skema baru di dalam database saat ini.

```sql
CREATE SCHEMA penjualan;
CREATE SCHEMA inventaris;
```

#### `CREATE TABLE`

Membuat tabel baru di dalam skema saat ini (atau skema yang ditentukan).

```sql
-- Membuat tabel 'produk' di skema default 'public'
CREATE TABLE produk (
    id SERIAL PRIMARY KEY, -- Kolom ID unik, auto-increment, sebagai primary key
    nama VARCHAR(255) NOT NULL, -- Nama produk, maks 255 char, tidak boleh kosong
    deskripsi TEXT,             -- Deskripsi panjang, boleh kosong
    harga NUMERIC(10, 2) NOT NULL CHECK (harga >= 0), -- Harga, presisi 10 digit total, 2 di belakang koma, tidak boleh kosong, harus >= 0
    stok INTEGER DEFAULT 0,     -- Jumlah stok, default 0 jika tidak diisi
    tanggal_dibuat TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP -- Waktu baris dibuat
);

-- Membuat tabel 'pelanggan' di skema 'penjualan'
CREATE TABLE penjualan.pelanggan (
    id_pelanggan UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- Menggunakan UUID sebagai PK
    nama_lengkap VARCHAR(150) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL, -- Email harus unik dan tidak boleh kosong
    tanggal_daftar DATE DEFAULT CURRENT_DATE
);

-- Membuat tabel 'pesanan' dengan Foreign Key
CREATE TABLE penjualan.pesanan (
    id_pesanan BIGSERIAL PRIMARY KEY,
    id_pelanggan UUID NOT NULL,
    tanggal_pesanan TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    total_harga NUMERIC(12, 2),
    status VARCHAR(50) DEFAULT 'pending',

    -- Mendefinisikan Foreign Key constraint
    CONSTRAINT fk_pelanggan
        FOREIGN KEY (id_pelanggan) -- Kolom di tabel ini
        REFERENCES penjualan.pelanggan (id_pelanggan) -- Mereferensi tabel 'pelanggan' kolom 'id_pelanggan'
        ON DELETE SET NULL -- Jika pelanggan dihapus, set id_pelanggan di pesanan ini jadi NULL
        -- Opsi lain: ON DELETE CASCADE (hapus pesanan), ON DELETE RESTRICT (larang hapus pelanggan jika punya pesanan)
);
```

#### `ALTER TABLE`

Memodifikasi struktur tabel yang sudah ada.

```sql
-- Menambah kolom baru
ALTER TABLE produk ADD COLUMN kategori VARCHAR(100);

-- Menghapus kolom
ALTER TABLE produk DROP COLUMN deskripsi;

-- Mengubah tipe data kolom (harus kompatibel atau data bisa hilang!)
ALTER TABLE produk ALTER COLUMN harga TYPE NUMERIC(12, 2);

-- Menambah constraint NOT NULL
ALTER TABLE produk ALTER COLUMN kategori SET NOT NULL;

-- Menghapus constraint NOT NULL
ALTER TABLE produk ALTER COLUMN kategori DROP NOT NULL;

-- Menambah constraint UNIQUE
ALTER TABLE produk ADD CONSTRAINT produk_nama_unik UNIQUE (nama);

-- Menambah constraint CHECK
ALTER TABLE produk ADD CONSTRAINT harga_positif CHECK (harga > 0);

-- Mengganti nama kolom
ALTER TABLE penjualan.pelanggan RENAME COLUMN nama_lengkap TO nama;

-- Mengganti nama tabel
ALTER TABLE produk RENAME TO barang;
```

#### `DROP TABLE`

Menghapus tabel beserta semua datanya. **Hati-hati, operasi ini tidak bisa dibatalkan!**

```sql
DROP TABLE produk;

-- Menghapus tabel hanya jika ada
DROP TABLE IF EXISTS produk_lama;

-- Menghapus tabel beserta objek yang bergantung padanya (misal: views, foreign keys ke tabel ini)
DROP TABLE penjualan.pelanggan CASCADE;
```

#### Kendala (Constraints)

Aturan yang diterapkan pada data dalam tabel untuk memastikan integritas dan validitas data.

*   `PRIMARY KEY`: Satu atau lebih kolom yang secara unik mengidentifikasi setiap baris dalam tabel. Tidak boleh `NULL`. Setiap tabel sebaiknya memiliki satu Primary Key.
*   `FOREIGN KEY`: Satu atau lebih kolom yang nilainya harus cocok dengan nilai Primary Key di tabel lain. Menegakkan hubungan antar tabel (integritas referensial).
*   `UNIQUE`: Memastikan bahwa semua nilai dalam satu atau lebih kolom adalah unik (berbeda satu sama lain) di seluruh tabel. Boleh `NULL` (biasanya hanya satu `NULL` yang diizinkan).
*   `NOT NULL`: Memastikan bahwa kolom tidak boleh berisi nilai `NULL`.
*   `CHECK`: Memastikan bahwa nilai dalam kolom memenuhi kondisi boolean tertentu (misalnya, `harga > 0`, `status IN ('pending', 'shipped', 'delivered')`).

Constraints bisa didefinisikan saat `CREATE TABLE` (inline atau di akhir) atau ditambahkan nanti menggunakan `ALTER TABLE ... ADD CONSTRAINT`.

### DML (Data Manipulation Language)

Perintah SQL untuk memanipulasi data: menambah, membaca, mengubah, menghapus.

#### `INSERT INTO`

Menambahkan baris baru ke dalam tabel.

```sql
-- Menyisipkan satu baris, menentukan semua kolom
INSERT INTO produk (nama, harga, stok, kategori)
VALUES ('Laptop ABC', 15000000.50, 10, 'Elektronik');

-- Menyisipkan satu baris, beberapa kolom akan menggunakan nilai DEFAULT atau NULL
INSERT INTO produk (nama, harga)
VALUES ('Mouse XYZ', 250000.00); -- stok akan jadi 0, tanggal_dibuat akan jadi waktu saat ini, kategori NULL

-- Menyisipkan beberapa baris sekaligus
INSERT INTO produk (nama, harga, stok, kategori) VALUES
    ('Keyboard Mekanik', 750000, 25, 'Aksesoris Komputer'),
    ('Monitor 24 inch', 2200000, 15, 'Elektronik');

-- Menyisipkan hasil dari query SELECT (contoh: menyalin produk murah ke tabel lain)
INSERT INTO produk_diskon (nama_produk, harga_lama)
SELECT nama, harga FROM produk WHERE harga < 1000000;
```

#### `SELECT`

Mengambil data dari satu atau lebih tabel. Ini adalah perintah yang paling sering digunakan.

```sql
-- Mengambil semua kolom (*) dari semua baris tabel produk
SELECT * FROM produk;

-- Mengambil kolom tertentu
SELECT nama, harga, stok FROM produk;

-- Mengambil data dengan alias kolom
SELECT
    nama AS nama_produk,
    harga AS harga_jual,
    (harga * 0.1) AS ppn -- Menghitung nilai baru
FROM produk;
```

#### `WHERE` Clause

Memfilter baris berdasarkan kondisi tertentu.

```sql
-- Mengambil produk dengan harga di bawah 1 juta
SELECT nama, harga FROM produk WHERE harga < 1000000;

-- Mengambil produk dalam kategori 'Elektronik'
SELECT * FROM produk WHERE kategori = 'Elektronik'; -- Case-sensitive

-- Menggunakan ILIKE untuk pencarian case-insensitive
SELECT * FROM produk WHERE nama ILIKE '%laptop%'; -- Mencari nama yang mengandung 'laptop'

-- Menggunakan operator AND, OR, NOT
SELECT * FROM produk WHERE kategori = 'Elektronik' AND harga > 10000000;
SELECT * FROM produk WHERE stok = 0 OR kategori = 'Aksesoris Komputer';
SELECT * FROM produk WHERE NOT kategori = 'Elektronik'; -- atau <> atau !=

-- Menggunakan IN untuk mencocokkan dengan beberapa nilai
SELECT * FROM produk WHERE kategori IN ('Elektronik', 'Gadget');

-- Menggunakan BETWEEN untuk rentang nilai
SELECT * FROM produk WHERE harga BETWEEN 500000 AND 1000000; -- Termasuk batas atas dan bawah

-- Memeriksa nilai NULL
SELECT * FROM produk WHERE deskripsi IS NULL;
SELECT * FROM produk WHERE kategori IS NOT NULL;
```

#### `ORDER BY` Clause

Mengurutkan hasil query.

```sql
-- Mengurutkan produk berdasarkan harga, dari termurah ke termahal (ASC default)
SELECT nama, harga FROM produk ORDER BY harga ASC;
-- atau cukup: SELECT nama, harga FROM produk ORDER BY harga;

-- Mengurutkan produk berdasarkan harga, dari termahal ke termurah (DESC)
SELECT nama, harga FROM produk ORDER BY harga DESC;

-- Mengurutkan berdasarkan beberapa kolom (pertama berdasarkan kategori, lalu harga)
SELECT nama, kategori, harga FROM produk ORDER BY kategori ASC, harga DESC;
```

#### `LIMIT` / `OFFSET`

Membatasi jumlah baris yang dikembalikan dan/atau melewati sejumlah baris awal. Berguna untuk pagination.

```sql
-- Mengambil 5 produk termahal
SELECT nama, harga FROM produk ORDER BY harga DESC LIMIT 5;

-- Mengambil 10 produk, dimulai dari produk ke-21 (untuk halaman ke-3 jika per halaman 10)
SELECT * FROM produk ORDER BY id LIMIT 10 OFFSET 20;
```

#### `UPDATE`

Memodifikasi data pada baris yang sudah ada. **Selalu gunakan `WHERE` clause kecuali Anda ingin mengubah *semua* baris!**

```sql
-- Menaikkan harga semua produk 'Elektronik' sebesar 10%
UPDATE produk
SET harga = harga * 1.1
WHERE kategori = 'Elektronik';

-- Mengubah nama dan stok produk dengan ID tertentu
UPDATE produk
SET
    nama = 'Laptop ABC Generasi Baru',
    stok = stok - 1
WHERE id = 1; -- Pastikan ID ini sesuai

-- Mengubah kategori produk yang deskripsinya NULL
UPDATE produk
SET kategori = 'Lain-lain'
WHERE deskripsi IS NULL;
```

#### `DELETE FROM`

Menghapus baris dari tabel. **Sangat berbahaya! Selalu gunakan `WHERE` clause kecuali Anda ingin menghapus *semua* data di tabel!**

```sql
-- Menghapus produk dengan ID 5
DELETE FROM produk WHERE id = 5;

-- Menghapus semua produk yang stoknya 0
DELETE FROM produk WHERE stok = 0;

-- Menghapus SEMUA data dari tabel produk (struktur tabel tetap ada)
-- DELETE FROM produk; -- Berbahaya!

-- Cara lebih cepat untuk menghapus semua data (tidak menjalankan trigger, tidak bisa di-rollback jika tidak dalam transaksi)
-- TRUNCATE TABLE produk; -- Sangat Berbahaya!
```

### Mengambil Data dari Beberapa Tabel (JOINs)

JOIN digunakan untuk menggabungkan baris dari dua atau lebih tabel berdasarkan kolom terkait.

Misal kita punya tabel `penjualan.pelanggan` dan `penjualan.pesanan`.

#### `INNER JOIN`

Mengembalikan hanya baris yang memiliki kecocokan di *kedua* tabel.

```sql
SELECT
    p.id_pesanan,
    p.tanggal_pesanan,
    pl.nama AS nama_pelanggan,
    pl.email
FROM penjualan.pesanan AS p
INNER JOIN penjualan.pelanggan AS pl ON p.id_pelanggan = pl.id_pelanggan;
-- Mengambil pesanan yang memiliki data pelanggan yang cocok
```

#### `LEFT JOIN` (atau `LEFT OUTER JOIN`)

Mengembalikan *semua* baris dari tabel kiri (tabel pertama yang disebut, `pesanan`) dan baris yang cocok dari tabel kanan (`pelanggan`). Jika tidak ada kecocokan di tabel kanan, kolom dari tabel kanan akan berisi `NULL`.

```sql
SELECT
    pl.nama,
    pl.email,
    p.id_pesanan,
    p.tanggal_pesanan
FROM penjualan.pelanggan AS pl -- Tabel kiri
LEFT JOIN penjualan.pesanan AS p ON pl.id_pelanggan = p.id_pelanggan;
-- Mengambil semua pelanggan, beserta pesanan mereka jika ada.
-- Jika pelanggan belum pernah memesan, id_pesanan dan tanggal_pesanan akan NULL.
```

#### `RIGHT JOIN` (atau `RIGHT OUTER JOIN`)

Kebalikan dari `LEFT JOIN`. Mengembalikan *semua* baris dari tabel kanan (`pesanan`) dan baris yang cocok dari tabel kiri (`pelanggan`). Jika tidak ada kecocokan di tabel kiri, kolom dari tabel kiri akan `NULL`. (Jarang digunakan, biasanya lebih intuitif menulis ulang sebagai `LEFT JOIN`).

```sql
SELECT
    p.id_pesanan,
    p.tanggal_pesanan,
    pl.nama AS nama_pelanggan
FROM penjualan.pelanggan AS pl -- Tabel kiri
RIGHT JOIN penjualan.pesanan AS p ON pl.id_pelanggan = p.id_pelanggan; -- Tabel kanan
-- Mengambil semua pesanan, beserta data pelanggan jika ada.
-- Jika id_pelanggan di pesanan tidak valid (atau NULL), nama_pelanggan akan NULL.
```

#### `FULL OUTER JOIN`

Mengembalikan semua baris ketika ada kecocokan di salah satu tabel (kiri atau kanan). Jika tidak ada kecocokan untuk baris di tabel kiri, kolom tabel kanan `NULL`. Jika tidak ada kecocokan untuk baris di tabel kanan, kolom tabel kiri `NULL`.

```sql
SELECT
    pl.nama,
    p.id_pesanan
FROM penjualan.pelanggan AS pl
FULL OUTER JOIN penjualan.pesanan AS p ON pl.id_pelanggan = p.id_pelanggan;
-- Menampilkan semua pelanggan dan semua pesanan.
-- Akan ada baris untuk pelanggan tanpa pesanan (id_pesanan NULL).
-- Akan ada baris untuk pesanan tanpa pelanggan (nama NULL - jika FK memungkinkan NULL atau tidak valid).
```

### Fungsi Agregat

Fungsi yang melakukan perhitungan pada sekelompok baris dan mengembalikan satu nilai ringkasan.

#### `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`

*   `COUNT(*)`: Menghitung jumlah total baris.
*   `COUNT(nama_kolom)`: Menghitung jumlah baris di mana `nama_kolom` tidak `NULL`.
*   `COUNT(DISTINCT nama_kolom)`: Menghitung jumlah nilai unik dalam `nama_kolom`.
*   `SUM(nama_kolom)`: Menjumlahkan semua nilai dalam `nama_kolom` (harus numerik).
*   `AVG(nama_kolom)`: Menghitung rata-rata nilai dalam `nama_kolom` (harus numerik).
*   `MIN(nama_kolom)`: Menemukan nilai minimum dalam `nama_kolom`.
*   `MAX(nama_kolom)`: Menemukan nilai maksimum dalam `nama_kolom`.

```sql
-- Jumlah total produk
SELECT COUNT(*) AS total_produk FROM produk;

-- Jumlah kategori produk yang unik
SELECT COUNT(DISTINCT kategori) AS jumlah_kategori FROM produk;

-- Total nilai stok semua produk
SELECT SUM(stok) AS total_stok FROM produk;

-- Harga rata-rata produk
SELECT AVG(harga) AS harga_rata_rata FROM produk;

-- Harga produk termurah dan termahal
SELECT MIN(harga) AS harga_termurah, MAX(harga) AS harga_termahal FROM produk;
```

#### `GROUP BY` Clause

Mengelompokkan baris yang memiliki nilai yang sama dalam satu atau lebih kolom, sehingga fungsi agregat dapat diterapkan pada setiap kelompok. Kolom yang ada di `SELECT` harus merupakan kolom `GROUP BY` atau fungsi agregat.

```sql
-- Jumlah produk per kategori
SELECT kategori, COUNT(*) AS jumlah_produk
FROM produk
GROUP BY kategori
ORDER BY jumlah_produk DESC;

-- Rata-rata harga dan total stok per kategori
SELECT
    kategori,
    AVG(harga) AS rata_rata_harga,
    SUM(stok) AS total_stok
FROM produk
WHERE kategori IS NOT NULL -- Filter sebelum agregasi
GROUP BY kategori;

-- Jumlah pesanan per pelanggan
SELECT
    p.id_pelanggan,
    pl.nama,
    COUNT(p.id_pesanan) AS jumlah_pesanan
FROM penjualan.pesanan p
JOIN penjualan.pelanggan pl ON p.id_pelanggan = pl.id_pelanggan
GROUP BY p.id_pelanggan, pl.nama -- Group by semua kolom non-agregat
ORDER BY jumlah_pesanan DESC;
```

#### `HAVING` Clause

Memfilter hasil *setelah* agregasi `GROUP BY` dilakukan. `WHERE` memfilter baris *sebelum* agregasi, `HAVING` memfilter grup *setelah* agregasi.

```sql
-- Menampilkan kategori yang memiliki lebih dari 5 produk
SELECT kategori, COUNT(*) AS jumlah_produk
FROM produk
GROUP BY kategori
HAVING COUNT(*) > 5;

-- Menampilkan kategori dengan harga rata-rata di atas 1 juta
SELECT kategori, AVG(harga) AS rata_rata_harga
FROM produk
WHERE kategori IS NOT NULL
GROUP BY kategori
HAVING AVG(harga) > 1000000;
```

### TCL (Transaction Control Language)

Perintah untuk mengelola transaksi database. Transaksi adalah satu unit kerja yang terdiri dari satu atau lebih operasi SQL.

#### Konsep ACID

PostgreSQL menjamin properti ACID untuk transaksi:

*   **Atomicity:** Semua operasi dalam transaksi berhasil, atau tidak ada yang berhasil (rollback). Transaksi bersifat "semua atau tidak sama sekali".
*   **Consistency:** Transaksi membawa database dari satu state konsisten ke state konsisten lainnya. Semua constraint dan aturan integritas data tetap terjaga.
*   **Isolation:** Transaksi yang berjalan bersamaan tidak saling mengganggu. Setiap transaksi seolah-olah berjalan sendiri. PostgreSQL mencapai ini melalui MVCC.
*   **Durability:** Setelah transaksi di-`COMMIT`, perubahannya bersifat permanen dan akan bertahan bahkan jika terjadi kegagalan sistem (misalnya, crash, mati listrik). Dicapai melalui Write-Ahead Logging (WAL).

#### `BEGIN`, `COMMIT`, `ROLLBACK`

Secara default, setiap pernyataan SQL di `psql` (dan banyak alat lain) berjalan dalam transaksinya sendiri (autocommit). Untuk mengelompokkan beberapa pernyataan:

```sql
BEGIN; -- Atau START TRANSACTION;

-- Pernyataan 1: Kurangi stok produk
UPDATE produk SET stok = stok - 1 WHERE id = 1 AND stok > 0;

-- Pernyataan 2: Tambah item ke tabel keranjang belanja (misalnya)
INSERT INTO keranjang (id_produk, jumlah) VALUES (1, 1);

-- Pernyataan 3: Cek kondisi lain (jika perlu)
-- SELECT ...

-- Jika semua berhasil:
COMMIT; -- Menyimpan semua perubahan secara permanen

-- Jika terjadi kesalahan atau kondisi tidak terpenuhi:
-- ROLLBACK; -- Membatalkan semua perubahan sejak BEGIN
```

Jika koneksi terputus sebelum `COMMIT` atau `ROLLBACK`, transaksi akan otomatis di-rollback.

### DCL (Data Control Language) - Pengantar

Perintah untuk mengelola hak akses pengguna ke database.

#### `GRANT`, `REVOKE`

*   `GRANT`: Memberikan hak akses (misalnya, `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `CREATE`, `USAGE`) pada objek database (tabel, skema, database, fungsi) kepada pengguna atau peran (role).
*   `REVOKE`: Mencabut hak akses yang sebelumnya diberikan.

Manajemen pengguna dan hak akses di PostgreSQL menggunakan konsep `ROLE`. Role bisa berupa pengguna login atau grup.

```sql
-- Membuat role/user baru dengan kemampuan login dan password
CREATE ROLE user_aplikasi LOGIN PASSWORD 'password_rahasia';

-- Memberikan hak akses SELECT pada tabel produk ke user_aplikasi
GRANT SELECT ON TABLE produk TO user_aplikasi;

-- Memberikan semua hak akses (INSERT, SELECT, UPDATE, DELETE) pada tabel pesanan
GRANT ALL PRIVILEGES ON TABLE penjualan.pesanan TO user_aplikasi;

-- Memberikan hak akses penggunaan (USAGE) pada skema 'penjualan'
GRANT USAGE ON SCHEMA penjualan TO user_aplikasi;
-- Tanpa ini, user_aplikasi tidak bisa 'melihat' objek di dalam skema penjualan

-- Mencabut hak akses DELETE dari user_aplikasi pada tabel pesanan
REVOKE DELETE ON TABLE penjualan.pesanan FROM user_aplikasi;
```

Manajemen hak akses bisa menjadi kompleks, terutama dengan pewarisan role. Ini akan dibahas lebih lanjut di bagian administrasi.

---

## 3. Fitur Tingkat Lanjut PostgreSQL

PostgreSQL menawarkan banyak fitur canggih yang melampaui SQL dasar.

### Indeks (Indexes)

Indeks adalah struktur data khusus yang memungkinkan database menemukan baris dalam tabel dengan lebih cepat tanpa harus memindai seluruh tabel (full table scan). Sangat penting untuk performa query pada tabel besar.

*   **Kapan menggunakan indeks?** Kolom yang sering digunakan dalam klausa `WHERE`, `JOIN ON`, atau `ORDER BY`.
*   **Kapan *tidak* menggunakan indeks?**
    *   Tabel yang sangat kecil.
    *   Kolom dengan kardinalitas sangat rendah (sedikit nilai unik, misal kolom boolean atau gender).
    *   Tabel yang lebih sering di-`INSERT`/`UPDATE`/`DELETE` daripada di-`SELECT` (karena indeks juga perlu diperbarui).
*   **Tipe Indeks Umum:**
    *   **B-tree (Default):** Paling umum, cocok untuk perbandingan `=`, `>`, `<`, `>=`, `<=`, `BETWEEN`, `IN`, `IS NULL`, `IS NOT NULL`, dan pencocokan awalan (`LIKE 'abc%'`).
    *   **Hash:** Hanya berguna untuk perbandingan `=` (lebih cepat dari B-tree untuk kesetaraan, tapi kurang fleksibel dan tidak crash-safe sebelum PG10).
    *   **GIN (Generalized Inverted Index):** Optimal untuk mengindeks tipe data komposit seperti Array, JSONB, HSTORE, dan data Full-Text Search. Cepat untuk query yang mencari elemen *dalam* nilai komposit.
    *   **GiST (Generalized Search Tree):** Kerangka kerja untuk membangun berbagai skema pengindeksan, termasuk data geometris (PostGIS), Full-Text Search, dll. Lebih fleksibel daripada GIN tapi bisa lebih lambat untuk kasus spesifik GIN.
    *   **BRIN (Block Range Index):** Efektif untuk tabel sangat besar yang datanya secara fisik terurut (atau berkorelasi) dengan nilai kolom yang diindeks (misalnya, timestamp pada tabel log). Membutuhkan ruang sangat sedikit.

```sql
-- Membuat indeks B-tree (default) pada kolom email di tabel pelanggan
CREATE INDEX idx_pelanggan_email ON penjualan.pelanggan (email);

-- Membuat indeks pada beberapa kolom (composite index)
-- Urutan kolom penting! Efektif untuk query yang memfilter berdasarkan id_pelanggan,
-- atau berdasarkan id_pelanggan DAN tanggal_pesanan
CREATE INDEX idx_pesanan_pelanggan_tanggal ON penjualan.pesanan (id_pelanggan, tanggal_pesanan);

-- Membuat indeks unik (sekaligus menerapkan constraint unique)
CREATE UNIQUE INDEX idx_produk_nama_unik ON produk (nama);

-- Membuat indeks menggunakan fungsi (functional index)
-- Berguna jika sering memfilter berdasarkan hasil fungsi, misal pencarian case-insensitive
CREATE INDEX idx_pelanggan_nama_lower ON penjualan.pelanggan (LOWER(nama));

-- Membuat indeks GIN pada kolom JSONB (misalnya, kolom 'atribut')
CREATE INDEX idx_produk_atribut_gin ON produk USING GIN (atribut);

-- Melihat indeks pada tabel
\d nama_tabel
```

Perintah `EXPLAIN ANALYZE <query>` sangat berguna untuk melihat apakah query Anda menggunakan indeks atau tidak.

### Views

View adalah query `SELECT` yang disimpan dan diberi nama, yang bisa Anda gunakan seperti tabel virtual.

*   **Kegunaan:**
    *   Menyederhanakan query yang kompleks.
    *   Menyembunyikan kompleksitas skema dari pengguna akhir.
    *   Memberikan lapisan keamanan (hanya menampilkan kolom/baris tertentu).
    *   Memastikan konsistensi dalam cara data ditampilkan.

```sql
-- Membuat view sederhana yang menampilkan produk aktif dengan harga di atas 500rb
CREATE VIEW view_produk_aktif_mahal AS
SELECT id, nama, harga, kategori
FROM produk
WHERE stok > 0 AND harga > 500000;

-- Menggunakan view seperti tabel
SELECT * FROM view_produk_aktif_mahal WHERE kategori = 'Elektronik';

-- Membuat view yang menggabungkan data pesanan dan pelanggan
CREATE VIEW penjualan.view_detail_pesanan AS
SELECT
    p.id_pesanan,
    p.tanggal_pesanan,
    p.status,
    pl.nama AS nama_pelanggan,
    pl.email AS email_pelanggan
FROM penjualan.pesanan AS p
LEFT JOIN penjualan.pelanggan AS pl ON p.id_pelanggan = pl.id_pelanggan;

-- Menggunakan view gabungan
SELECT * FROM penjualan.view_detail_pesanan WHERE status = 'pending';

-- Menghapus view
DROP VIEW view_produk_aktif_mahal;
```

View standar biasanya read-only. PostgreSQL mendukung *updatable views* untuk view sederhana dan `INSTEAD OF` triggers untuk view kompleks agar bisa di-`INSERT`/`UPDATE`/`DELETE`. Ada juga `MATERIALIZED VIEW` yang menyimpan hasil query secara fisik dan perlu di-refresh manual (berguna untuk query mahal yang datanya jarang berubah).

### Stored Procedures dan Functions (PL/pgSQL)

Memungkinkan Anda menulis blok kode (logika pemrograman) yang disimpan dan dieksekusi di server database.

*   **Functions:** Mengembalikan nilai (termasuk tabel). Bisa dipanggil dalam query `SELECT`.
*   **Procedures (Sejak PG11):** Tidak mengembalikan nilai secara langsung. Bisa mengontrol transaksi (`COMMIT`/`ROLLBACK`) di dalamnya. Dipanggil menggunakan `CALL`.
*   **Bahasa:** Bahasa default dan paling umum adalah PL/pgSQL (mirip Oracle PL/SQL). Bahasa lain seperti PL/Python, PL/Perl, PL/Tcl, PL/SQL (JavaScript) juga tersedia.
*   **Kegunaan:**
    *   Enkapsulasi logika bisnis di database.
    *   Mengurangi lalu lintas jaringan (kirim satu panggilan, bukan banyak query).
    *   Reusabilitas kode.
    *   Keamanan (memberikan hak `EXECUTE` pada fungsi/prosedur, bukan pada tabel dasar).

```sql
-- Contoh Fungsi PL/pgSQL sederhana: Menghitung total harga pesanan
CREATE OR REPLACE FUNCTION penjualan.hitung_total_pesanan(p_id_pesanan BIGINT)
RETURNS NUMERIC AS $$ -- Menentukan tipe data kembalian
DECLARE -- Bagian deklarasi variabel lokal
    v_total NUMERIC := 0;
BEGIN
    -- Logika fungsi: menjumlahkan harga*jumlah dari tabel detail_pesanan (misalnya)
    SELECT SUM(dp.harga_saat_beli * dp.jumlah)
    INTO v_total -- Menyimpan hasil query ke variabel
    FROM penjualan.detail_pesanan dp
    WHERE dp.id_pesanan = p_id_pesanan;

    RETURN COALESCE(v_total, 0); -- Mengembalikan total (atau 0 jika tidak ada item/pesanan)
END;
$$ LANGUAGE plpgsql; -- Menentukan bahasa yang digunakan

-- Memanggil fungsi dalam SELECT
SELECT id_pesanan, tanggal_pesanan, penjualan.hitung_total_pesanan(id_pesanan) AS total
FROM penjualan.pesanan
WHERE id_pesanan = 101;

-- Contoh Prosedur PL/pgSQL: Memproses pesanan (mengubah status dan mengurangi stok)
CREATE OR REPLACE PROCEDURE penjualan.proses_pesanan(p_id_pesanan BIGINT)
AS $$
DECLARE
    r_item RECORD; -- Variabel untuk menampung baris dari loop
BEGIN
    -- 1. Update status pesanan
    UPDATE penjualan.pesanan SET status = 'processing' WHERE id_pesanan = p_id_pesanan;

    -- 2. Kurangi stok untuk setiap item dalam pesanan
    FOR r_item IN SELECT id_produk, jumlah FROM penjualan.detail_pesanan WHERE id_pesanan = p_id_pesanan
    LOOP
        UPDATE produk SET stok = stok - r_item.jumlah
        WHERE id = r_item.id_produk;
        -- Tambahkan pengecekan stok jika perlu
    END LOOP;

    -- Tidak perlu RETURN
    -- Bisa COMMIT/ROLLBACK di sini jika diperlukan (tapi hati-hati)
END;
$$ LANGUAGE plpgsql;

-- Memanggil prosedur
CALL penjualan.proses_pesanan(102);
```

### Triggers

Fungsi khusus yang secara otomatis dieksekusi oleh server ketika event tertentu terjadi pada tabel (misalnya, `INSERT`, `UPDATE`, `DELETE`).

*   **Kapan dieksekusi:** `BEFORE` atau `AFTER` event.
*   **Granularitas:** `FOR EACH ROW` (dieksekusi sekali untuk setiap baris yang terpengaruh) atau `FOR EACH STATEMENT` (dieksekusi sekali per pernyataan SQL).
*   **Kegunaan:**
    *   Menjalankan logika bisnis kompleks yang tidak bisa ditangani oleh constraints.
    *   Audit trail (mencatat perubahan data ke tabel log).
    *   Menjaga integritas data denormalisasi.
    *   Mencegah operasi tertentu.

Trigger terdiri dari dua bagian:

1.  **Trigger Function:** Fungsi PL/pgSQL (atau bahasa lain) yang tidak menerima argumen dan mengembalikan tipe `TRIGGER`. Di dalam fungsi ini, variabel khusus seperti `TG_OP` (operasi: INSERT, UPDATE, DELETE), `NEW` (record baris baru untuk INSERT/UPDATE), `OLD` (record baris lama untuk UPDATE/DELETE) tersedia.
2.  **Trigger Definition:** Mengaitkan trigger function ke tabel, event, dan waktu eksekusi.

```sql
-- 1. Buat Trigger Function untuk mencatat histori perubahan harga produk
CREATE OR REPLACE FUNCTION log_perubahan_harga()
RETURNS TRIGGER AS $$
BEGIN
    -- Hanya jalankan jika harga benar-benar berubah
    IF TG_OP = 'UPDATE' AND NEW.harga <> OLD.harga THEN
        INSERT INTO log_harga_produk (id_produk, harga_lama, harga_baru, waktu_perubahan)
        VALUES (OLD.id, OLD.harga, NEW.harga, NOW());
    END IF;

    -- Untuk trigger BEFORE UPDATE, ini mengembalikan baris yang akan disimpan
    -- Untuk trigger AFTER, nilai kembalian diabaikan (bisa return NULL)
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Buat Trigger Definition untuk menjalankan fungsi di atas
CREATE TRIGGER trg_log_harga_produk
AFTER UPDATE ON produk -- Jalankan SETELAH update di tabel produk
FOR EACH ROW -- Untuk setiap baris yang di-update
WHEN (OLD.harga IS DISTINCT FROM NEW.harga) -- Kondisi tambahan (opsional, bisa juga di dalam fungsi)
EXECUTE FUNCTION log_perubahan_harga();

-- Contoh lain: Mencegah penghapusan kategori 'Elektronik'
CREATE OR REPLACE FUNCTION cegah_hapus_elektronik()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' AND OLD.kategori = 'Elektronik' THEN
        RAISE EXCEPTION 'Tidak dapat menghapus produk dalam kategori Elektronik!';
    END IF;
    RETURN OLD; -- Untuk BEFORE DELETE, kembalikan baris yang akan dihapus
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_cegah_hapus_elektronik
BEFORE DELETE ON produk
FOR EACH ROW
EXECUTE FUNCTION cegah_hapus_elektronik();
```

Penggunaan trigger harus hati-hati karena bisa memperlambat operasi DML dan membuat alur logika sulit dilacak.

### Tipe Data JSON dan JSONB

PostgreSQL memiliki dukungan kelas satu untuk menyimpan dan meng-query data JSON.

*   `JSON`: Menyimpan teks JSON persis seperti yang dimasukkan. Memvalidasi JSON. Setiap query harus mem-parsing ulang teks JSON.
*   `JSONB` (Binary JSON): Menyimpan JSON dalam format biner terurai. Lebih efisien untuk penyimpanan (sedikit lebih besar tapi menghilangkan spasi kosong dan duplikasi key) dan *jauh lebih cepat* untuk di-query karena tidak perlu parsing ulang. Mendukung pengindeksan (GIN). **Umumnya `JSONB` lebih disukai daripada `JSON`.**

**Operator Query JSON/JSONB:**

*   `->`: Mengambil field objek JSON berdasarkan key (hasilnya JSON/JSONB).
*   `->>`: Mengambil field objek JSON berdasarkan key (hasilnya `TEXT`).
*   `#>`: Mengambil elemen JSON berdasarkan path (array of keys/indices) (hasilnya JSON/JSONB).
*   `#>>`: Mengambil elemen JSON berdasarkan path (hasilnya `TEXT`).
*   `@>`: Apakah JSON kiri mengandung JSON kanan? (Berguna dengan indeks GIN).
*   `<@`: Apakah JSON kiri terkandung dalam JSON kanan?
*   `?`: Apakah key (string) ada sebagai top-level key di objek JSON?
*   `?|`: Apakah salah satu dari keys (array string) ada?
*   `?&`: Apakah semua keys (array string) ada?

```sql
-- Menambah kolom JSONB ke tabel produk
ALTER TABLE produk ADD COLUMN spesifikasi JSONB;

-- Menyisipkan data JSONB
UPDATE produk SET spesifikasi = '{
    "warna": "hitam",
    "ram_gb": 16,
    "storage": {"tipe": "SSD", "kapasitas_gb": 512},
    "fitur": ["backlit keyboard", "fingerprint reader"]
}' WHERE id = 1;

-- Mengambil nilai JSONB
SELECT
    nama,
    spesifikasi -> 'ram_gb' AS ram, -- Hasilnya JSONB: 16
    spesifikasi ->> 'warna' AS warna, -- Hasilnya TEXT: 'hitam'
    spesifikasi -> 'storage' ->> 'tipe' AS tipe_storage, -- Hasilnya TEXT: 'SSD'
    spesifikasi #>> '{storage, kapasitas_gb}' AS kapasitas_storage, -- Hasilnya TEXT: '512'
    spesifikasi -> 'fitur' ->> 0 AS fitur_pertama -- Hasilnya TEXT: 'backlit keyboard'
FROM produk WHERE id = 1;

-- Mencari produk dengan RAM 16GB
SELECT nama FROM produk WHERE spesifikasi ->> 'ram_gb' = '16'; -- Lambat tanpa indeks
-- atau (lebih baik untuk perbandingan numerik):
SELECT nama FROM produk WHERE (spesifikasi -> 'ram_gb')::int = 16;

-- Mencari produk dengan storage tipe SSD menggunakan containment operator (cepat dengan indeks GIN)
-- Buat indeks dulu: CREATE INDEX idx_produk_spec_gin ON produk USING GIN (spesifikasi);
SELECT nama FROM produk WHERE spesifikasi @> '{"storage": {"tipe": "SSD"}}';

-- Mencari produk yang memiliki fitur 'fingerprint reader'
SELECT nama FROM produk WHERE spesifikasi -> 'fitur' ? 'fingerprint reader'; -- Lambat
-- atau (cepat dengan indeks GIN)
SELECT nama FROM produk WHERE spesifikasi @> '{"fitur": ["fingerprint reader"]}';
```

### Fungsi Window (Window Functions)

Melakukan perhitungan pada sekelompok baris (disebut *window frame*) yang terkait dengan baris saat ini, tanpa mengkolaps baris-baris tersebut seperti `GROUP BY`.

*   **Sintaks:** `fungsi_window(...) OVER (PARTITION BY ... ORDER BY ... frame_clause)`
    *   `fungsi_window`: Fungsi agregat (`SUM`, `AVG`, `COUNT`, dll.) atau fungsi window khusus (`ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`, `LEAD`, dll.).
    *   `PARTITION BY kolom1, kolom2`: Membagi baris menjadi partisi-partisi. Perhitungan dilakukan secara independen untuk setiap partisi (mirip `GROUP BY`, tapi tidak mengkolaps baris). Jika dihilangkan, seluruh hasil query dianggap satu partisi.
    *   `ORDER BY kolom3`: Menentukan urutan baris *dalam* setiap partisi. Penting untuk fungsi seperti `RANK`, `LAG`, `LEAD`.
    *   `frame_clause`: (Opsional) Mendefinisikan window frame (subset baris dalam partisi relatif terhadap baris saat ini). Contoh: `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`.

**Contoh Penggunaan:**

*   Memberi nomor urut pada baris.
*   Menghitung ranking.
*   Menghitung running total (total kumulatif).
*   Membandingkan nilai baris saat ini dengan baris sebelumnya/berikutnya.

```sql
-- Memberi nomor urut pada semua produk berdasarkan harga (termurah ke termahal)
SELECT
    nama,
    harga,
    ROW_NUMBER() OVER (ORDER BY harga ASC) AS nomor_urut
FROM produk;

-- Memberi ranking produk berdasarkan harga dalam setiap kategori
SELECT
    nama,
    kategori,
    harga,
    RANK() OVER (PARTITION BY kategori ORDER BY harga DESC) AS ranking_harga_per_kategori,
    DENSE_RANK() OVER (PARTITION BY kategori ORDER BY harga DESC) AS dense_rank_harga -- Rank tanpa lompatan nomor
FROM produk
WHERE kategori IS NOT NULL;
-- RANK: 1, 2, 2, 4 (jika ada 2 produk di rank 2)
-- DENSE_RANK: 1, 2, 2, 3

-- Menghitung total harga kumulatif pesanan per hari
SELECT
    DATE(tanggal_pesanan) AS tanggal,
    id_pesanan,
    total_harga,
    SUM(total_harga) OVER (ORDER BY DATE(tanggal_pesanan), id_pesanan) AS total_kumulatif
FROM penjualan.pesanan;

-- Menampilkan harga produk bersama dengan harga produk termahal di kategorinya
SELECT
    nama,
    kategori,
    harga,
    MAX(harga) OVER (PARTITION BY kategori) AS harga_termahal_di_kategori
FROM produk
WHERE kategori IS NOT NULL;

-- Membandingkan harga pesanan saat ini dengan harga pesanan sebelumnya (berdasarkan tanggal)
SELECT
    id_pesanan,
    tanggal_pesanan,
    total_harga,
    LAG(total_harga, 1, 0) OVER (ORDER BY tanggal_pesanan) AS harga_pesanan_sebelumnya
    -- LAG(kolom, offset, default_value)
FROM penjualan.pesanan;
```

### Common Table Expressions (CTEs)

Memungkinkan Anda mendefinisikan hasil query sementara yang bisa direferensikan dalam query utama (`SELECT`, `INSERT`, `UPDATE`, `DELETE`). Membuat query kompleks lebih mudah dibaca dan diorganisir.

*   **Sintaks:** `WITH nama_cte AS ( ... query SELECT ... ) SELECT ... FROM nama_cte ...;`
*   Bisa mendefinisikan beberapa CTE, dipisahkan koma.
*   Bisa rekursif (menggunakan `WITH RECURSIVE`) untuk query hierarki atau graph traversal.

```sql
-- Contoh non-rekursif: Menemukan pelanggan yang memesan produk termahal

-- Tanpa CTE (lebih sulit dibaca)
SELECT pl.nama, pl.email
FROM penjualan.pelanggan pl
JOIN penjualan.pesanan p ON pl.id_pelanggan = p.id_pelanggan
JOIN penjualan.detail_pesanan dp ON p.id_pesanan = dp.id_pesanan
WHERE dp.id_produk = (SELECT id FROM produk ORDER BY harga DESC LIMIT 1);

-- Dengan CTE (lebih jelas)
WITH ProdukTermahal AS (
    SELECT id
    FROM produk
    ORDER BY harga DESC
    LIMIT 1
),
PesananProdukTermahal AS (
    SELECT DISTINCT p.id_pelanggan
    FROM penjualan.pesanan p
    JOIN penjualan.detail_pesanan dp ON p.id_pesanan = dp.id_pesanan
    JOIN ProdukTermahal pt ON dp.id_produk = pt.id
)
SELECT pl.nama, pl.email
FROM penjualan.pelanggan pl
JOIN PesananProdukTermahal ppt ON pl.id_pelanggan = ppt.id_pelanggan;


-- Contoh Rekursif: Menampilkan hierarki kategori (misal tabel kategori punya kolom id_induk)
WITH RECURSIVE HierarkiKategori AS (
    -- Basis rekursi: Kategori level teratas (tidak punya induk)
    SELECT id, nama, 0 AS level
    FROM kategori
    WHERE id_induk IS NULL

    UNION ALL

    -- Langkah rekursif: Cari anak dari kategori yang sudah ditemukan
    SELECT k.id, k.nama, hk.level + 1
    FROM kategori k
    JOIN HierarkiKategori hk ON k.id_induk = hk.id
)
SELECT id, nama, level
FROM HierarkiKategori
ORDER BY level, nama;
```

### Ekstensi (Extensions)

Modul perangkat lunak tambahan yang bisa dimuat ke PostgreSQL untuk menambah fungsionalitas.

*   **Cara menggunakan:**
    1.  Instal paket ekstensi di level sistem operasi (jika perlu, biasanya via `apt`, `yum`, atau dari source).
    2.  Aktifkan ekstensi di *database spesifik* menggunakan `CREATE EXTENSION nama_ekstensi;`.
    3.  Gunakan fungsi, tipe data, atau operator baru yang disediakan ekstensi.
*   **Contoh Ekstensi Populer:**
    *   `PostGIS`: Dukungan lengkap untuk data geografis dan spasial (tipe geometri/geografi, fungsi spasial, indeks spasial GiST). Sangat kuat.
    *   `uuid-ossp`: Menyediakan fungsi untuk menghasilkan UUID (misalnya, `uuid_generate_v4()`). (Meskipun `gen_random_uuid()` bawaan seringkali cukup).
    *   `hstore`: Tipe data key-value store sederhana.
    *   `pg_trgm`: Fungsi dan operator untuk menentukan similaritas teks berdasarkan pencocokan trigram (berguna untuk 'fuzzy search').
    *   `pgcrypto`: Fungsi kriptografi (hashing, enkripsi).
    *   `plpython3u`, `plv8`, dll.: Untuk menulis fungsi/prosedur dalam bahasa lain.

```sql
-- Melihat ekstensi yang tersedia (yang paketnya sudah terinstal)
SELECT name, default_version, installed_version FROM pg_available_extensions;

-- Mengaktifkan ekstensi di database saat ini
CREATE EXTENSION IF NOT EXISTS "uuid-ossp"; -- IF NOT EXISTS mencegah error jika sudah aktif

-- Sekarang bisa pakai fungsinya
SELECT uuid_generate_v4();

-- Mengaktifkan PostGIS (setelah paketnya diinstal di OS)
CREATE EXTENSION postgis;

-- Menghapus (menonaktifkan) ekstensi dari database
DROP EXTENSION postgis;
```

### Foreign Data Wrappers (FDW)

Memungkinkan PostgreSQL mengakses data yang tersimpan di luar server PostgreSQL itu sendiri, seolah-olah data tersebut adalah tabel lokal di PostgreSQL.

*   **Sumber Data:** Database PostgreSQL lain, MySQL, Oracle, SQL Server, MongoDB, Redis, file CSV, LDAP, Twitter, dll.
*   **Cara Kerja:**
    1.  Instal ekstensi FDW yang sesuai (misalnya, `postgres_fdw`, `mysql_fdw`, `file_fdw`).
    2.  `CREATE EXTENSION nama_fdw;`
    3.  `CREATE SERVER server_asing FOREIGN DATA WRAPPER nama_fdw OPTIONS (...);` (mendefinisikan koneksi ke sumber eksternal).
    4.  `CREATE USER MAPPING FOR user_lokal SERVER server_asing OPTIONS (...);` (menyimpan kredensial untuk koneksi).
    5.  `CREATE FOREIGN TABLE tabel_lokal (...) SERVER server_asing OPTIONS (...);` (mendefinisikan struktur tabel asing).
    6.  Query `tabel_lokal` seperti tabel biasa. PostgreSQL akan menerjemahkan query dan mengambil data dari sumber eksternal.

```sql
-- Contoh sederhana menggunakan file_fdw (biasanya sudah include di contrib)

-- Aktifkan ekstensi
CREATE EXTENSION file_fdw;

-- Buat server yang merepresentasikan direktori file di server PostgreSQL
CREATE SERVER server_file_csv FOREIGN DATA WRAPPER file_fdw;

-- Buat tabel asing yang mereferensikan file CSV
-- Misal ada file /tmp/data_produk.csv dengan header: id,nama,harga
CREATE FOREIGN TABLE produk_csv (
    id INT,
    nama TEXT,
    harga NUMERIC
) SERVER server_file_csv
OPTIONS ( filename '/tmp/data_produk.csv', format 'csv', header 'true' );

-- Query tabel asing
SELECT * FROM produk_csv WHERE harga > 1000;

-- Data akan dibaca dari file CSV saat query dijalankan.
```

FDW adalah fitur yang sangat powerful untuk integrasi data. `postgres_fdw` sangat berguna untuk query antar database PostgreSQL atau membuat sistem terdistribusi sederhana.

---

## 4. Administrasi Dasar PostgreSQL

Meskipun PostgreSQL dikenal minim perawatan, ada beberapa tugas administrasi dasar yang penting untuk diketahui.

### Backup dan Restore

**Sangat Penting!** Lakukan backup secara teratur untuk melindungi data Anda dari kehilangan akibat kegagalan hardware, error manusia, atau masalah lainnya.

#### `pg_dump`

Utilitas baris perintah untuk membuat backup *logis* dari *satu* database. Menghasilkan file teks SQL (`INSERT` statements, `CREATE TABLE`, dll.) atau format arsip kustom.

*   **Kelebihan:** Fleksibel (bisa restore ke versi PG berbeda, OS berbeda, selektif restore tabel/skema), ukuran file relatif kecil (terutama format terkompresi).
*   **Kekurangan:** Bisa lambat untuk database sangat besar, tidak mencakup data global (roles, tablespaces).

```bash
# Backup database 'toko_online' ke file SQL teks biasa
pg_dump -U postgres -h localhost toko_online > toko_online_backup.sql

# Backup dengan format kustom (-Fc), terkompresi (-Z level), lebih disarankan
# Meminta password secara interaktif (-W)
pg_dump -U postgres -h localhost -W -Fc -Z 5 -f toko_online_backup.dump toko_online

# Backup hanya skema 'penjualan'
pg_dump -U postgres -h localhost -Fc -Z 5 -n penjualan -f penjualan_schema.dump toko_online

# Backup hanya tabel 'produk'
pg_dump -U postgres -h localhost -Fc -Z 5 -t produk -f produk_table.dump toko_online

# Backup hanya definisi skema (tanpa data)
pg_dump -U postgres -h localhost -s -f toko_online_schema_only.sql toko_online

# Backup data saja (tanpa skema)
pg_dump -U postgres -h localhost -a -f toko_online_data_only.sql toko_online
```

#### `pg_restore` / `psql`

*   Untuk restore dari file SQL teks biasa (`.sql`), gunakan `psql`.
*   Untuk restore dari format arsip (`.dump`, dibuat dengan `-Fc`, `-Ft`, atau `-Fd`), gunakan `pg_restore`.

```bash
# Restore dari file SQL teks biasa ke database BARU (harus sudah dibuat)
# Pastikan database tujuan kosong atau sesuai keinginan.
psql -U postgres -h localhost -d toko_online_restored < toko_online_backup.sql

# Restore dari file format kustom ke database BARU
# Opsi -d menentukan database tujuan
# Opsi -C akan mencoba membuat database dulu (jika di-dump dengan info DB)
pg_restore -U postgres -h localhost -d toko_online_restored toko_online_backup.dump

# Restore dengan beberapa job paralel (-j) untuk mempercepat (jika CPU & disk memungkinkan)
pg_restore -U postgres -h localhost -j 4 -d toko_online_restored toko_online_backup.dump

# Melihat daftar isi file arsip
pg_restore -l toko_online_backup.dump

# Restore hanya tabel atau skema tertentu dari file arsip (gunakan daftar dari -l)
pg_restore -U postgres -h localhost -d toko_online_restored -t produk -t penjualan.pelanggan toko_online_backup.dump
```

**Penting:**
*   Uji proses restore Anda secara berkala! Backup tidak berguna jika tidak bisa direstore.
*   Simpan file backup di lokasi yang aman dan terpisah dari server database.
*   Untuk backup *fisik* (level filesystem, lebih cepat untuk database sangat besar, diperlukan untuk Point-in-Time Recovery), pelajari tentang `pg_basebackup` dan konsep Write-Ahead Logging (WAL) archiving.

### Manajemen Pengguna dan Hak Akses (Roles)

PostgreSQL menggunakan konsep `ROLE` untuk mengelola hak akses. Role bisa menjadi pengguna (jika punya atribut `LOGIN`), grup, atau keduanya.

```sql
-- Membuat role user baru yang bisa login
CREATE ROLE budi WITH LOGIN PASSWORD 'passwordbudi' VALID UNTIL '2024-12-31';

-- Membuat role grup (tidak bisa login)
CREATE ROLE staf_penjualan;

-- Memberikan role 'staf_penjualan' kepada 'budi'
-- Budi akan mewarisi hak akses dari 'staf_penjualan'
GRANT staf_penjualan TO budi;

-- Memberikan hak akses ke role grup
GRANT USAGE ON SCHEMA penjualan TO staf_penjualan;
GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA penjualan TO staf_penjualan;
-- Perlu dijalankan ulang jika ada tabel baru, atau gunakan ALTER DEFAULT PRIVILEGES

-- Mengatur default privileges agar role staf_penjualan otomatis dapat hak akses
-- pada tabel baru yang dibuat oleh user 'admin' di skema 'penjualan'
ALTER DEFAULT PRIVILEGES FOR ROLE admin IN SCHEMA penjualan
   GRANT SELECT, INSERT ON TABLES TO staf_penjualan;

-- Melihat daftar role
\du

-- Mengubah password role
ALTER ROLE budi PASSWORD 'passwordbarubudi';

-- Menghapus role (tidak bisa jika role masih punya objek atau jadi anggota grup lain)
DROP ROLE budi;
DROP ROLE staf_penjualan;
```

Gunakan prinsip *least privilege*: berikan hak akses seminimal mungkin yang dibutuhkan oleh pengguna atau aplikasi.

### Monitoring Dasar

Memantau kondisi server database penting untuk mendeteksi masalah performa atau potensi isu lainnya.

*   **Log Server:** Lokasi log ditentukan dalam file konfigurasi `postgresql.conf` (parameter `log_directory`, `log_filename`). Periksa log secara rutin untuk pesan error, warning, query lambat (jika `log_min_duration_statement` diaktifkan).
*   **Statistik Aktivitas:** PostgreSQL mengumpulkan banyak statistik runtime. View sistem `pg_stat_activity` sangat berguna.

    ```sql
    -- Melihat semua koneksi aktif dan query yang sedang berjalan
    SELECT pid, datname, usename, application_name, client_addr, state, wait_event_type, wait_event, query
    FROM pg_stat_activity
    WHERE state IS NOT NULL; -- Filter koneksi idle jika terlalu banyak

    -- Melihat query yang berjalan lama
    SELECT pid, now() - query_start AS duration, query
    FROM pg_stat_activity
    WHERE state = 'active' AND (now() - query_start) > interval '1 minute'
    ORDER BY duration DESC;

    -- Membatalkan query yang berjalan (gunakan dengan hati-hati!)
    SELECT pg_cancel_backend(pid); -- Mencoba membatalkan secara halus

    -- Menghentikan paksa koneksi backend (lebih keras)
    SELECT pg_terminate_backend(pid);
    ```

*   **Statistik Tabel & Indeks:** View seperti `pg_stat_user_tables`, `pg_stat_user_indexes` menunjukkan seberapa sering tabel/indeks diakses (scan sequential, scan indeks), jumlah baris `INSERT`/`UPDATE`/`DELETE`, kapan terakhir di-vacuum/analyze. Berguna untuk identifikasi tabel panas atau indeks tak terpakai.
*   **Ukuran Database & Tabel:**
    ```sql
    -- Ukuran database saat ini
    SELECT pg_size_pretty(pg_database_size(current_database()));

    -- Ukuran semua tabel di skema public (termasuk indeks dan TOAST data)
    SELECT
        table_schema || '.' || table_name AS table_full_name,
        pg_size_pretty(pg_total_relation_size('"' || table_schema || '"."' || table_name || '"')) AS total_size
    FROM information_schema.tables
    WHERE table_schema = 'public'
    ORDER BY pg_total_relation_size('"' || table_schema || '"."' || table_name || '"') DESC;
    ```
*   **Tools Eksternal:** Banyak alat monitoring pihak ketiga (Nagios, Zabbix, Datadog, Prometheus dengan `postgres_exporter`, pgAdmin) yang menyediakan dashboard dan alerting lebih canggih.

### Vacuuming dan Analisis

Karena arsitektur MVCC, versi baris lama (yang sudah di-`UPDATE` atau `DELETE`) tidak langsung dihapus dari disk. Mereka ditandai sebagai tidak terlihat oleh transaksi baru. Proses `VACUUM` diperlukan untuk:

1.  **Membersihkan Ruang:** Menghapus baris "mati" (dead tuples) dan memungkinkan ruang disk digunakan kembali oleh tabel yang sama (atau oleh OS jika `VACUUM FULL`).
2.  **Mencegah Transaction ID Wraparound:** Meng-update "visibility map" dan "freeze" transaction ID pada baris lama agar database tidak kehabisan TXID (masalah serius yang bisa menyebabkan shutdown).
3.  **Memperbarui Statistik:** `VACUUM ANALYZE` (atau `ANALYZE` saja) mengumpulkan statistik tentang distribusi data dalam tabel dan indeks. Statistik ini *sangat penting* bagi query planner untuk memilih rencana eksekusi query yang efisien.

*   **Autovacuum:** PostgreSQL memiliki proses background `autovacuum` yang secara otomatis menjalankan `VACUUM` dan `ANALYZE` pada tabel yang mengalami banyak perubahan (`INSERT`, `UPDATE`, `DELETE`). **Secara default, ini aktif dan sangat direkomendasikan untuk dibiarkan aktif.**
*   **Kapan Manual `VACUUM`/`ANALYZE`?**
    *   Setelah bulk load data yang sangat besar.
    *   Sebelum/sesudah operasi maintenance besar.
    *   Jika Anda merasa autovacuum kurang agresif (perlu tuning parameter autovacuum di `postgresql.conf`).
    *   Untuk membersihkan tabel secara spesifik.

```sql
-- Menjalankan VACUUM dan ANALYZE pada tabel tertentu
VACUUM ANALYZE produk;

-- Menjalankan ANALYZE saja (hanya update statistik)
ANALYZE penjualan.pesanan;

-- Menjalankan VACUUM saja (hanya reclaim space & update visibility map)
VACUUM verbose produk; -- verbose memberikan output detail

-- VACUUM FULL: Menulis ulang seluruh tabel ke file baru, mengunci tabel secara eksklusif,
-- mengembalikan ruang ke OS. Gunakan dengan SANGAT HATI-HATI dan jarang, hanya jika
-- ada bloat (ruang terbuang) yang signifikan dan downtime bisa ditoleransi.
-- VACUUM FULL produk; -- Butuh waktu lama & lock berat!
```

Pastikan autovacuum berjalan dan dikonfigurasi dengan baik untuk beban kerja Anda. Statistik yang akurat adalah kunci performa query yang baik.

---

## 5. Tools dan Ekosistem PostgreSQL

Banyak alat bantu yang bisa memudahkan pekerjaan Anda dengan PostgreSQL.

### Klien CLI: `psql`

Seperti yang sudah dibahas, `psql` adalah alat bawaan yang sangat kuat dan efisien untuk administrasi dan eksekusi query interaktif maupun skrip. Pelajari meta-commands (`\d`, `\l`, `\timing`, dll.) untuk memaksimalkannya.

### Klien GUI

Alat berbasis Graphical User Interface untuk mengelola database, menjalankan query, melihat data, dll.

*   **pgAdmin:** GUI open-source paling populer dan "resmi", kaya fitur, berjalan di web browser atau sebagai aplikasi desktop. Bagus untuk administrasi dan pengembangan. ([https://www.pgadmin.org/](https://www.pgadmin.org/))
*   **DBeaver:** Klien database universal open-source (mendukung banyak jenis database, termasuk PostgreSQL), berbasis Java/Eclipse. Sangat fleksibel dan punya banyak fitur. ([https://dbeaver.io/](https://dbeaver.io/))
*   **DataGrip:** Klien database komersial dari JetBrains (pembuat IntelliJ IDEA, PyCharm). Sangat cerdas dengan fitur auto-complete, refactoring, dan debugging SQL/PLpgSQL yang canggih. Berbayar, tapi ada lisensi gratis untuk pelajar/proyek open-source. ([https://www.jetbrains.com/datagrip/](https://www.jetbrains.com/datagrip/))
*   **Postico (macOS):** Klien native macOS yang bersih dan mudah digunakan. Fokus pada kesederhanaan dan kecepatan. Komersial. ([https://eggerapps.at/postico/](https://eggerapps.at/postico/))
*   **SQL Workbench/J:** Klien SQL universal gratis berbasis Java. Fokus pada eksekusi skrip SQL. ([https://www.sql-workbench.eu/](https://www.sql-workbench.eu/))

Pilih yang sesuai dengan preferensi dan kebutuhan Anda.

### Object-Relational Mappers (ORMs)

Library dalam bahasa pemrograman aplikasi Anda yang memetakan objek aplikasi ke tabel database, memungkinkan Anda berinteraksi dengan database menggunakan kode berorientasi objek daripada menulis SQL mentah.

*   **Python:** SQLAlchemy, Django ORM, Peewee
*   **Node.js/JavaScript/TypeScript:** Sequelize, TypeORM, Prisma, Knex.js (Query Builder)
*   **Java:** Hibernate (JPA), JOOQ (lebih dekat ke SQL), MyBatis
*   **Ruby:** ActiveRecord (Rails)
*   **PHP:** Doctrine, Eloquent (Laravel)
*   **Go:** GORM, sqlx
*   **.NET:** Entity Framework Core

ORMs bisa mempercepat pengembangan, tapi penting untuk memahami SQL dasar dan bagaimana ORM menerjemahkan operasi objek menjadi SQL untuk debugging dan optimasi performa.

### Alat Migrasi Skema

Alat untuk mengelola perubahan skema database secara terstruktur dan version-controlled. Sangat penting dalam pengembangan tim dan deployment aplikasi.

*   **Flyway:** Populer, berbasis file migrasi SQL atau Java. Mendukung banyak database. ([https://flywaydb.org/](https://flywaydb.org/))
*   **Liquibase:** Berbasis XML, JSON, YAML, atau SQL. Sangat fleksibel, mendukung banyak database. ([https://www.liquibase.org/](https://www.liquibase.org/))
*   **Alembic:** Khusus untuk Python dan SQLAlchemy.
*   **Django Migrations:** Bawaan framework Django.
*   **ActiveRecord Migrations:** Bawaan framework Ruby on Rails.

Alat migrasi memungkinkan Anda menerapkan perubahan skema (membuat tabel, menambah kolom, dll.) secara otomatis dan berulang di berbagai lingkungan (pengembangan, staging, produksi) dan memudahkan rollback jika terjadi masalah.

---

## 6. Sumber Belajar Lanjutan

*   **Dokumentasi Resmi PostgreSQL:** Sumber paling akurat dan lengkap. Sangat bagus dan terstruktur. Mulai dari Tutorial dan bagian SQL Language & Server Administration. ([https://www.postgresql.org/docs/current/](https://www.postgresql.org/docs/current/))
*   **PostgreSQL Tutorial:** Situs web dengan tutorial langkah demi langkah yang jelas. ([https://www.postgresqltutorial.com/](https://www.postgresqltutorial.com/))
*   **Planet PostgreSQL:** Agregator blog dan berita dari komunitas PostgreSQL. ([https://planet.postgresql.org/](https://planet.postgresql.org/))
*   **PG Casts:** Screencasts tentang berbagai topik PostgreSQL. ([https://www.pgcasts.com/](https://www.pgcasts.com/)) (Mungkin sudah tidak aktif, tapi arsipnya berguna)
*   **Buku:**
    *   "PostgreSQL: Up and Running" oleh Regina Obe & Leo Hsu (Bagus untuk memulai)
    *   "The Art of PostgreSQL" oleh Dimitri Fontaine (Fokus pada penulisan SQL yang efisien)
    *   "Mastering PostgreSQL in Application Development" oleh Dimitri Fontaine
*   **Komunitas:**
    *   Milis PostgreSQL (pgsql-general, pgsql-novice): Tempat bertanya dan berdiskusi.
    *   Stack Overflow (tag `postgresql`): Banyak tanya jawab.
    *   Server Discord / Slack komunitas PostgreSQL.

---

## 7. Kontribusi

Jika Anda menemukan kesalahan, kekurangan, atau memiliki saran untuk perbaikan pada panduan ini, jangan ragu untuk:

1.  **Membuat Issue:** Laporkan masalah atau usulkan ide baru melalui tab "Issues" di repositori ini.
2.  **Membuat Pull Request:**
    *   Fork repositori ini.
    *   Buat branch baru untuk perubahan Anda (`git checkout -b fitur/nama-fitur-anda` atau `fix/deskripsi-perbaikan`).
    *   Lakukan perubahan pada file `README.md`.
    *   Commit perubahan Anda (`git commit -am 'Menambahkan penjelasan tentang XYZ'`).
    *   Push ke branch Anda (`git push origin fitur/nama-fitur-anda`).
    *   Buka Pull Request dari fork Anda ke branch `main` repositori ini.

Kontribusi Anda sangat dihargai!

---

## 8. Lisensi

Konten panduan ini dilisensikan di bawah [Lisensi MIT](LICENSE.md). Anda bebas menggunakan, menyalin, memodifikasi, menggabungkan, mempublikasikan, mendistribusikan, mensublisensikan, dan/atau menjual salinan panduan ini.

---

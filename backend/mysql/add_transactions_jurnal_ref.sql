-- Menambah kolom `jurnal_ref` di tabel `transactions` -- dipakai oleh
-- fitur baru "Isi dari Riwayat Jurnal Umum" di form Kas/Bank Keluar:
-- saat sebuah pembayaran dipilih dari voucher Hutang Dagang tertentu,
-- ref voucher itu (mis. 'JU26100136') disimpan di sini supaya sistem
-- tahu voucher mana yang sudah (sebagian/seluruhnya) dibayar, dan bisa
-- menyembunyikannya dari daftar begitu lunas.
--
-- PENTING: jalankan file ini SEBELUM upload backend/frontend baru --
-- kalau kolomnya belum ada saat kode baru sudah jalan, menyimpan Kas
-- Keluar/Bank Keluar akan gagal (error SQL "Unknown column").
--
-- Tidak pakai FOREIGN KEY ke jurnal_umum karena satu ref voucher di
-- sana punya banyak baris (satu per akun) -- sama seperti kolom
-- `project`/`relasi` lain di tabel ini, ini referensi string biasa,
-- bukan relasi ber-FK.
ALTER TABLE `transactions`
  ADD COLUMN `jurnal_ref` VARCHAR(40) NULL DEFAULT NULL AFTER `relasi`;

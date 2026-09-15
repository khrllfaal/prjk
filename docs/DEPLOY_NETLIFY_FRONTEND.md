# Tahap dekat — Frontend di Netlify, Backend PHP+MySQL tetap terpisah

Untuk online-kan aplikasi cepat tanpa pindah database dulu: `frontend/`
(HTML/JS statis, tanpa build step) di-hosting di Netlify, sementara
`backend/api/` (PHP) + MySQL tetap di hosting yang sudah ada sekarang
(mis. Hostinger). Karena frontend dan backend jadi **dua domain
berbeda**, ada 2 hal wajib disetel di backend supaya login/sesi tetap
jalan lintas domain — lihat langkah 2.

Kalau rencana jangka panjangnya semuanya (frontend+backend+database)
pindah ke satu hosting yang sama (Hostinger), pakai
[DEPLOY_HOSTINGER.md](DEPLOY_HOSTINGER.md) — tahap ini murni langkah
antara, dan sepenuhnya reversibel (tinggal upload ulang `frontend/` ke
domain backend dan balikkan config di langkah 2 kalau nanti mau gabung
lagi jadi satu domain).

## 1. Pastikan backend PHP+MySQL sudah online

Kalau backend belum online sama sekali, ikuti **langkah 1, 3, 5, 6, 7, 8**
di [DEPLOY_HOSTINGER.md](DEPLOY_HOSTINGER.md) dulu (skip langkah 2 dan 4
di sana — itu khusus kalau frontend juga ikut di domain yang sama).
Kalau backend sudah online (mis. sudah ada `https://acc.prakasa-group.com`
atau serupa berjalan), lanjut ke langkah 2.

Catat URL API-nya, contoh: `https://acc.prakasa-group.com/api`.

## 2. Setel backend untuk domain silang (cross-domain)

Edit `config.php` di server backend (bukan `config.sample.php` — itu
cuma template):

```php
return [
    'db_host' => 'localhost',
    'db_name' => '...',
    'db_user' => '...',
    'db_pass' => '...',
    // Ganti dengan URL Netlify Anda yang sebenarnya (langkah 4 di bawah
    // akan memberi tahu URL persisnya — https://nama-app.netlify.app,
    // atau domain custom kalau sudah disetel). Harus PERSIS, termasuk
    // https:// dan tanpa trailing slash.
    'cors_origins' => ['https://nama-app-anda.netlify.app'],
    // WAJIB 'None' untuk domain silang — cookie login tidak akan pernah
    // terkirim balik ke server kalau ini dibiarkan 'Lax' (default),
    // dan gejalanya login kelihatan berhasil sekali lalu langsung
    // "ke-logout" di setiap request berikutnya.
    'cookie_samesite' => 'None',
    'backup_dir' => '...',
    'backup_retention_days' => 14,
];
```

`cookie_samesite => 'None'` hanya berfungsi kalau backend diakses lewat
HTTPS (browser menolak cookie `SameSite=None` di koneksi HTTP biasa) —
pastikan HTTPS sudah aktif di backend (langkah 5 di DEPLOY_HOSTINGER.md).

**Setelah upload `config.php` yang baru, upload juga `backend/api/helpers.php`
dan `backend/api/config.sample.php`** dari repo versi terbaru — keduanya
baru saja diperbarui untuk mendukung opsi `cookie_samesite` di atas; tanpa
file `helpers.php` yang baru, opsi ini di `config.php` tidak akan
terbaca (backend lama selalu memaksa `Lax`, login lintas domain tidak
akan pernah berhasil).

## 3. Setel frontend (`backend-config.js`)

Sebelum upload ke Netlify, edit `frontend/backend-config.js`:

```js
window.API_BASE_URL = 'https://acc.prakasa-group.com/api';
```

Isi persis dengan URL API dari langkah 1 (URL penuh, bukan path relatif
`/api` — path relatif hanya berlaku kalau frontend & API satu domain).

## 4. Deploy ke Netlify

**Cara tercepat (drag & drop, tanpa akun GitHub terhubung):**

1. Buka [app.netlify.com/drop](https://app.netlify.com/drop).
2. Seret folder `frontend/` (yang isinya `index.html`, `auth.js`,
   `data-sync.js`, `backend-config.js` yang sudah diedit di langkah 3,
   `vendor/`, `_headers`, dst.) ke halaman itu.
3. Netlify langsung memberi URL acak, misal
   `https://random-name-123.netlify.app` — catat URL ini.

**Cara yang lebih rapi untuk update berkala (terhubung ke GitHub):**

1. Di Netlify: **Add new site → Import an existing project → Deploy with
   GitHub**, pilih repo `khrllfaal/prjk`.
2. Build settings:
   - **Base directory**: `frontend`
   - **Build command**: *(kosongkan — tidak ada build step)*
   - **Publish directory**: `frontend`
3. Deploy. Setiap kali ada commit baru ke branch yang dipilih, Netlify
   otomatis re-deploy.

Kalau pakai cara GitHub, URL Netlify-nya bisa dilihat di dashboard site
tersebut (Site settings → Domain management) — **atau** langsung set
domain custom Anda sendiri di menu yang sama kalau punya (mis.
`app.prakasa-group.com`), Netlify otomatis menerbitkan HTTPS gratis untuk
domain custom itu.

## 5. Cocokkan `cors_origins` dengan URL Netlify yang sebenarnya

Balik lagi ke `config.php` di backend (langkah 2) — pastikan
`cors_origins` isinya PERSIS sama dengan URL Netlify final dari langkah
4 (termasuk kalau nanti ganti ke domain custom, update lagi baris ini).
Boleh isi lebih dari satu origin sekaligus kalau perlu, misal URL
preview Netlify + domain custom:

```php
'cors_origins' => [
    'https://nama-app-anda.netlify.app',
    'https://app.prakasa-group.com',
],
```

## 6. Verifikasi

1. Buka URL Netlify Anda — harus muncul layar login (bukan mode
   offline/demo — kalau yang muncul data contoh/placeholder, cek lagi
   `API_BASE_URL` di langkah 3, kemungkinan salah ketik atau belum
   ter-upload).
2. Login. Kalau layar langsung balik ke halaman login setelah submit
   (bukan error jelas), itu tanda `cookie_samesite`/`cors_origins` di
   langkah 2 belum benar — buka DevTools browser → tab Network → klik
   request login → cek response header `Set-Cookie` ada
   `SameSite=None; Secure`, dan tab Console tidak ada error CORS.
3. Tambah 1 data uji di salah satu menu, refresh halaman, pastikan data
   tetap ada.
4. Buka dari perangkat/browser lain, pastikan bisa login terpisah tanpa
   saling logout (multi-device tetap jalan meski frontend sekarang di
   domain berbeda).

## Checklist keamanan tambahan (di atas checklist DEPLOY_HOSTINGER.md)

- [ ] `cors_origins` HANYA berisi domain Netlify/custom Anda sendiri —
      jangan pernah `'*'` atau daftar domain yang tidak Anda kontrol,
      karena dikombinasikan dengan `Allow-Credentials: true` itu
      mengizinkan situs lain membaca data akun yang sedang login.
- [ ] `cookie_samesite` cuma `'None'` kalau memang frontend & backend
      beda domain — balikkan ke `'Lax'` (atau hapus barisnya) begitu
      nanti pindah ke satu domain (tahap panjang, Hostinger penuh).

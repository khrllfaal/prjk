/* ===========================================================
   data.js — lapisan penyimpanan data (localStorage, mode demo)
   -----------------------------------------------------------
   Semua entitas dirujuk lewat ID, BUKAN nama teks. Ini sengaja:
   versi Excel sebelumnya memakai SUMIFS berbasis nama bahan lintas
   sheet, jadi begitu ada typo/rename sheet -> muncul #REF! di
   seluruh rekap. Dengan ID sebagai kunci, ganti nama bahan tidak
   pernah merusak angka yang sudah dihitung.

   Struktur ini didesain agar gampang dipetakan 1:1 ke tabel SQL
   saat backend digarap (lihat README.md di folder ini).
   =========================================================== */

const DB_KEY = 'mattrack_v1';

const uid = (p) => p + '_' + Math.random().toString(36).slice(2, 9) + Date.now().toString(36).slice(-4);
const todayISODate = () => new Date().toISOString().slice(0, 10);

function seedData() {
  const now = new Date();
  const d = (offsetDays) => {
    const x = new Date(now);
    x.setDate(x.getDate() - offsetDays);
    return x.toISOString().slice(0, 10);
  };

  const projA = 'proj_demo_cibalong';
  const projB = 'proj_demo_baru';

  // Katalog Bahan (global, lintas proyek). Nama bahan di tiap RAB proyek
  // sering beda-beda penulisannya walau barangnya sama -> dihubungkan ke
  // sini lewat catalogId supaya bisa direkap total lintas proyek, TANPA
  // memaksa nama di RAB masing-masing proyek diseragamkan (nama di RAB
  // harus tetap sesuai dokumen kontrak aslinya).
  const catalog = [
    { id: 'cat_semen', nama: 'Semen PC 50kg', satuan: 'zak (50kg)', kategori: 'Beton' },
    { id: 'cat_pasir_beton', nama: 'Pasir Beton', satuan: 'm3', kategori: 'Beton' },
    { id: 'cat_split', nama: 'Split / Kerikil', satuan: 'm3', kategori: 'Beton' },
    { id: 'cat_agregat_a', nama: 'Agregat Kelas A', satuan: 'm3', kategori: 'Perkerasan' },
    { id: 'cat_agregat_s', nama: 'Agregat Kelas S', satuan: 'm3', kategori: 'Perkerasan' },
    { id: 'cat_sirtu', nama: 'Sirtu', satuan: 'rit', kategori: 'Timbunan' },
    { id: 'cat_pasir_pasang', nama: 'Pasir Pasang', satuan: 'm3', kategori: 'Pasangan' },
  ];

  const projects = [
    {
      id: projA,
      nama: 'Contoh: Peningkatan Jalan Cibalong (Demo)',
      lokasi: 'Kec. Cibalong, Kab. Garut',
      nilaiKontrak: 9172992036,
      tanggalMulai: d(40),
      status: 'active',
      pic: 'Aksan (Admin Lapangan)',
    },
    {
      id: projB,
      nama: 'Contoh: Rehab Saluran Irigasi Blok B (Demo)',
      lokasi: 'Kec. Bungbulang, Kab. Garut',
      nilaiKontrak: 1850000000,
      tanggalMulai: d(6),
      status: 'active',
      pic: 'Tim Lapangan B',
    },
  ];

  // Materials per project. rabKebutuhan = null artinya data RAB volume
  // bahan belum tersedia -> UI harus tetap jalan & jujur menampilkan
  // "Belum ada RAB", bukan error / NaN.
  const materials = [
    { id: 'mat_a1', projectId: projA, nama: 'Semen PC', satuan: 'zak (50kg)', kategori: 'Beton', rabKebutuhan: 18301.98, catalogId: 'cat_semen' },
    { id: 'mat_a2', projectId: projA, nama: 'Pasir Beton (Cor)', satuan: 'm3', kategori: 'Beton', rabKebutuhan: 1600.43, catalogId: 'cat_pasir_beton' },
    { id: 'mat_a3', projectId: projA, nama: 'Split / Kerikil', satuan: 'm3', kategori: 'Beton', rabKebutuhan: 2462.09, catalogId: 'cat_split' },
    { id: 'mat_a4', projectId: projA, nama: 'Agregat Kelas A', satuan: 'm3', kategori: 'Perkerasan', rabKebutuhan: 2314.84, catalogId: 'cat_agregat_a' },
    { id: 'mat_a5', projectId: projA, nama: 'Agregat Kelas S', satuan: 'm3', kategori: 'Perkerasan', rabKebutuhan: 615, catalogId: 'cat_agregat_s' },
    { id: 'mat_a6', projectId: projA, nama: 'Sirtu', satuan: 'rit', kategori: 'Timbunan', rabKebutuhan: null, catalogId: 'cat_sirtu' },
    // Sengaja beda nama & satuan dari mat_a1 (RAB proyek B menulisnya beda),
    // tapi barangnya sama -> dihubungkan ke catalogId yang sama supaya tetap
    // bisa direkap total lintas proyek lewat halaman Katalog Bahan.
    { id: 'mat_b1', projectId: projB, nama: 'Semen Portland (Padang) 50kg', satuan: 'zak', kategori: 'Beton', rabKebutuhan: null, catalogId: 'cat_semen' },
    { id: 'mat_b2', projectId: projB, nama: 'Pasir Pasang', satuan: 'm3', kategori: 'Pasangan', rabKebutuhan: null, catalogId: 'cat_pasir_pasang' },
  ];

  const tx = [];
  const pushTx = (materialId, tipe, tanggal, volume, extra) => {
    tx.push(Object.assign({
      id: uid('tx'),
      materialId,
      tipe,
      tanggal,
      volume,
      noSuratJalan: '',
      keterangan: '',
      diinputOleh: 'Demo Admin Lapangan',
      dibuatPada: new Date().toISOString(),
    }, extra || {}));
  };

  // Semen PC (mat_a1) - masuk bertahap, sedikit terpakai
  [[38, 4560, 'SJ-0731'], [30, 3600, 'SJ-0808'], [22, 4200, 'SJ-0816'], [12, 3120, 'SJ-0826'], [4, 2760, 'SJ-0901']]
    .forEach(([o, v, sj]) => pushTx('mat_a1', 'masuk', d(o), v, { noSuratJalan: sj }));
  [[27, 5200], [17, 6100], [7, 4800]].forEach(([o, v]) => pushTx('mat_a1', 'keluar', d(o), v, { itemPekerjaan: 'Skh-1.5.24.(2) Perkerasan Beton' }));

  // Pasir Cor (mat_a2)
  [[36, 380, 'SJ-0729'], [24, 420, 'SJ-0810'], [10, 300, 'SJ-0824']].forEach(([o, v, sj]) => pushTx('mat_a2', 'masuk', d(o), v, { noSuratJalan: sj }));
  [[26, 410], [9, 260]].forEach(([o, v]) => pushTx('mat_a2', 'keluar', d(o), v, { itemPekerjaan: 'Skh-1.5.24.(2) Perkerasan Beton' }));

  // Split (mat_a3)
  [[34, 700, 'SJ-0730'], [20, 900, 'SJ-0813'], [8, 700, 'SJ-0825']].forEach(([o, v, sj]) => pushTx('mat_a3', 'masuk', d(o), v, { noSuratJalan: sj }));
  [[25, 640]].forEach(([o, v]) => pushTx('mat_a3', 'keluar', d(o), v, { itemPekerjaan: 'Skh-1.5.24.(2) Perkerasan Beton' }));

  // Agregat Kelas A (mat_a4) - dibuat mepet supaya status PERLU ORDER
  [[15, 2200, 'SJ-0820']].forEach(([o, v, sj]) => pushTx('mat_a4', 'masuk', d(o), v, { noSuratJalan: sj }));
  [[9, 2050]].forEach(([o, v]) => pushTx('mat_a4', 'keluar', d(o), v, { itemPekerjaan: '5.1.(1) Lapis Pondasi Agregat A' }));

  // Agregat Kelas S (mat_a5) - dibuat OVER dari RAB
  [[18, 700, 'SJ-0818']].forEach(([o, v, sj]) => pushTx('mat_a5', 'masuk', d(o), v, { noSuratJalan: sj }));
  [[10, 690]].forEach(([o, v]) => pushTx('mat_a5', 'keluar', d(o), v, { itemPekerjaan: '5.1.(3) Lapis Pondasi Agregat S' }));

  // Sirtu (mat_a6) - belum ada RAB, tapi ada transaksi
  [[5, 96, 'SJ-0828']].forEach(([o, v, sj]) => pushTx('mat_a6', 'masuk', d(o), v, { noSuratJalan: sj }));

  // Project B - belum ada barang masuk sama sekali utk salah satu bahan
  [[3, 480, 'SJ-B01']].forEach(([o, v, sj]) => pushTx('mat_b1', 'masuk', d(o), v, { noSuratJalan: sj }));

  return { projects, materials, transactions: tx, catalog };
}

const Store = {
  _cache: null,

  load() {
    if (this._cache) return this._cache;
    try {
      const raw = localStorage.getItem(DB_KEY);
      if (raw) {
        this._cache = JSON.parse(raw);
        if (!this._cache.catalog) this._cache.catalog = []; // data lama sebelum fitur katalog ada
      } else {
        this._cache = seedData();
        this.save();
      }
    } catch (e) {
      console.error('Gagal load data, reset ke seed demo.', e);
      this._cache = seedData();
    }
    return this._cache;
  },

  save() {
    localStorage.setItem(DB_KEY, JSON.stringify(this._cache));
  },

  resetDemo() {
    this._cache = seedData();
    this.save();
  },

  // ---- Projects ----
  projects() { return this.load().projects; },
  project(id) { return this.load().projects.find(p => p.id === id); },
  addProject(p) {
    const rec = Object.assign({ id: uid('proj'), status: 'active' }, p);
    this.load().projects.push(rec);
    this.save();
    return rec;
  },
  updateProject(id, patch) {
    const p = this.project(id);
    if (p) { Object.assign(p, patch); this.save(); }
    return p;
  },

  // ---- Materials ----
  materials(projectId) {
    const all = this.load().materials;
    return projectId ? all.filter(m => m.projectId === projectId) : all;
  },
  material(id) { return this.load().materials.find(m => m.id === id); },
  addMaterial(m) {
    const rec = Object.assign({ id: uid('mat') }, m);
    this.load().materials.push(rec);
    this.save();
    return rec;
  },
  updateMaterial(id, patch) {
    const m = this.material(id);
    if (m) { Object.assign(m, patch); this.save(); }
    return m;
  },
  deleteMaterial(id) {
    const db = this.load();
    db.materials = db.materials.filter(m => m.id !== id);
    db.transactions = db.transactions.filter(t => t.materialId !== id);
    this.save();
  },

  // Tindak lanjut ringan untuk status "Perlu Order"/"Habis": bukan form
  // pengajuan formal, cuma penanda "sudah diproses" biar Admin Pusat/Owner
  // tidak bolak-balik menindaklanjuti bahan yang sama.
  markOrdered(materialId, oleh) {
    return this.updateMaterial(materialId, { dipesanPada: todayISODate(), dipesanOleh: oleh || '' });
  },
  unmarkOrdered(materialId) {
    return this.updateMaterial(materialId, { dipesanPada: null, dipesanOleh: '' });
  },

  // ---- Katalog Bahan (global, penghubung nama-bahan-berbeda antar proyek) ----
  catalog() { return this.load().catalog; },
  catalogItem(id) { return this.load().catalog.find(c => c.id === id); },
  addCatalog(c) {
    const rec = Object.assign({ id: uid('cat') }, c);
    this.load().catalog.push(rec);
    this.save();
    return rec;
  },
  updateCatalog(id, patch) {
    const c = this.catalogItem(id);
    if (c) { Object.assign(c, patch); this.save(); }
    return c;
  },
  deleteCatalog(id) {
    const db = this.load();
    db.catalog = db.catalog.filter(c => c.id !== id);
    db.materials.forEach(m => { if (m.catalogId === id) m.catalogId = null; });
    this.save();
  },

  // ---- Transactions ----
  transactions(materialId) {
    const all = this.load().transactions;
    return materialId ? all.filter(t => t.materialId === materialId) : all;
  },
  transactionsByProject(projectId) {
    const matIds = new Set(this.materials(projectId).map(m => m.id));
    return this.load().transactions.filter(t => matIds.has(t.materialId));
  },
  addTransaction(t) {
    const rec = Object.assign({ id: uid('tx'), dibuatPada: new Date().toISOString() }, t);
    this.load().transactions.push(rec);
    // Barang benar-benar masuk -> penanda "sudah dipesan" otomatis lepas,
    // tidak perlu dibatalkan manual.
    if (rec.tipe === 'masuk') {
      const m = this.material(rec.materialId);
      if (m && m.dipesanPada) { m.dipesanPada = null; m.dipesanOleh = ''; }
    }
    this.save();
    return rec;
  },
  updateTransaction(id, patch) {
    const t = this.load().transactions.find(x => x.id === id);
    if (t) { Object.assign(t, patch); this.save(); }
    return t;
  },
  deleteTransaction(id) {
    const db = this.load();
    db.transactions = db.transactions.filter(t => t.id !== id);
    this.save();
  },
};

// ---- Session (role/user demo, terpisah dari data agar bisa multi-device via login berbeda) ----
const Session = {
  KEY: 'mattrack_session_v1',
  get() {
    try { return JSON.parse(localStorage.getItem(this.KEY)); } catch (e) { return null; }
  },
  set(sess) { localStorage.setItem(this.KEY, JSON.stringify(sess)); },
  clear() { localStorage.removeItem(this.KEY); },
};

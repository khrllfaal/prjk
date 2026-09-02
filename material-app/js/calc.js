/* ===========================================================
   calc.js — mesin kalkulasi rekap stok & status
   -----------------------------------------------------------
   Semua angka rekap dihitung ulang dari transaksi mentah tiap
   render (bukan disimpan sebagai field). Ini sengaja meniru
   "recompute on read" ala spreadsheet SUMIFS, tapi dalam JS biasa
   yang gampang ditelusuri saat debug — tidak ada rantai formula
   antar-sheet yang bisa putus.
   =========================================================== */

const Calc = {
  // Rekap 1 bahan: total masuk, keluar, sisa, status stok & status RAB
  materialSummary(material, transactions) {
    const tx = transactions.filter(t => t.materialId === material.id);
    const totalMasuk = tx.filter(t => t.tipe === 'masuk').reduce((s, t) => s + Number(t.volume || 0), 0);
    const totalKeluar = tx.filter(t => t.tipe === 'keluar').reduce((s, t) => s + Number(t.volume || 0), 0);
    const sisaStok = totalMasuk - totalKeluar;

    let statusStok;
    if (totalMasuk === 0) statusStok = 'belum-ada-data';
    else if (sisaStok <= 0) statusStok = 'habis';
    else if (sisaStok <= totalMasuk * 0.1) statusStok = 'perlu-order';
    else statusStok = 'aman';

    const rab = material.rabKebutuhan;
    let statusRab = null, deviasiRab = null, pctRab = null;
    if (rab !== null && rab !== undefined && rab > 0) {
      deviasiRab = (totalKeluar - rab) / rab;
      pctRab = totalKeluar / rab;
      if (deviasiRab > 0.10) statusRab = 'over';
      else if (deviasiRab > 0.05) statusRab = 'perlu-perhatian';
      else statusRab = 'aman';
    } else {
      statusRab = 'belum-ada-rab';
    }

    return {
      material,
      totalMasuk, totalKeluar, sisaStok,
      statusStok, statusRab, deviasiRab, pctRab,
      txCount: tx.length,
      lastTxDate: tx.length ? tx.map(t => t.tanggal).sort().slice(-1)[0] : null,
    };
  },

  projectSummaries(projectId) {
    const materials = Store.materials(projectId);
    const tx = Store.transactionsByProject(projectId);
    return materials.map(m => this.materialSummary(m, tx));
  },

  projectHealth(projectId) {
    const rows = this.projectSummaries(projectId);
    const alerts = rows.filter(r => ['habis', 'perlu-order'].includes(r.statusStok) || ['over', 'perlu-perhatian'].includes(r.statusRab));
    const withRab = rows.filter(r => r.statusRab !== 'belum-ada-rab');
    const avgPct = withRab.length ? withRab.reduce((s, r) => s + Math.min(r.pctRab, 1.4), 0) / withRab.length : null;
    return {
      totalBahan: rows.length,
      totalAlert: alerts.length,
      avgPct,
      rows,
      alerts,
      belumAdaRab: rows.filter(r => r.statusRab === 'belum-ada-rab').length,
    };
  },

  allProjectsHealth() {
    return Store.projects().map(p => ({ project: p, health: this.projectHealth(p.id) }));
  },

  // Rekap 1 entri Katalog Bahan lintas SEMUA proyek yang bahannya
  // dihubungkan ke entri itu. Hanya bahan dengan satuan SAMA PERSIS dengan
  // satuan baku katalog yang dijumlahkan (m3 tidak boleh ketimpa rit) --
  // yang satuannya beda ditandai terpisah supaya tidak salah hitung diam-diam.
  catalogSummary() {
    const allTx = Store.transactions();
    return Store.catalog().map(cat => {
      const linked = Store.materials().filter(m => m.catalogId === cat.id);
      const sameUnit = linked.filter(m => m.satuan.trim().toLowerCase() === cat.satuan.trim().toLowerCase());
      const mismatched = linked.filter(m => m.satuan.trim().toLowerCase() !== cat.satuan.trim().toLowerCase());
      let totalMasuk = 0, totalKeluar = 0, totalRab = 0, hasRab = false;
      sameUnit.forEach(m => {
        const tx = allTx.filter(t => t.materialId === m.id);
        totalMasuk += tx.filter(t => t.tipe === 'masuk').reduce((s, t) => s + Number(t.volume || 0), 0);
        totalKeluar += tx.filter(t => t.tipe === 'keluar').reduce((s, t) => s + Number(t.volume || 0), 0);
        if (m.rabKebutuhan != null) { totalRab += Number(m.rabKebutuhan); hasRab = true; }
      });
      const projectsInvolved = [...new Set(linked.map(m => m.projectId))].map(pid => Store.project(pid)).filter(Boolean);
      return { catalog: cat, linked, sameUnit, mismatched, totalMasuk, totalKeluar, totalRab: hasRab ? totalRab : null, projectsInvolved };
    });
  },

  unlinkedMaterialCount() {
    return Store.materials().filter(m => !m.catalogId).length;
  },

  // Rekap mingguan (ISO week) untuk 1 proyek
  weeklyRecap(projectId, weekStartDate) {
    const materials = Store.materials(projectId);
    const tx = Store.transactionsByProject(projectId);
    const start = new Date(weekStartDate);
    const end = new Date(start);
    end.setDate(end.getDate() + 7);

    return materials.map(m => {
      const inWeek = tx.filter(t => t.materialId === m.id && t.tanggal >= toISO(start) && t.tanggal < toISO(end));
      const masuk = inWeek.filter(t => t.tipe === 'masuk').reduce((s, t) => s + Number(t.volume || 0), 0);
      const keluar = inWeek.filter(t => t.tipe === 'keluar').reduce((s, t) => s + Number(t.volume || 0), 0);
      const summary = this.materialSummary(m, tx.filter(t => t.tanggal < toISO(end)));
      return { material: m, masukMinggu: masuk, keluarMinggu: keluar, sisaSdMinggu: summary.sisaStok };
    });
  },

  weekOptions(projectId) {
    const tx = Store.transactionsByProject(projectId);
    if (!tx.length) return [toISO(mondayOf(new Date()))];
    const dates = tx.map(t => new Date(t.tanggal)).sort((a, b) => a - b);
    const first = mondayOf(dates[0]);
    const last = mondayOf(new Date());
    const weeks = [];
    let cur = new Date(first);
    while (cur <= last) {
      weeks.push(toISO(cur));
      cur.setDate(cur.getDate() + 7);
    }
    return weeks.reverse();
  },
};

function mondayOf(dateLike) {
  const dt = new Date(dateLike);
  const day = dt.getDay();
  const diff = (day === 0 ? -6 : 1) - day;
  dt.setDate(dt.getDate() + diff);
  dt.setHours(0, 0, 0, 0);
  return dt;
}
function toISO(dt) { return new Date(dt).toISOString().slice(0, 10); }

const STATUS_LABEL = {
  'aman': 'Aman',
  'perlu-order': 'Perlu Order',
  'habis': 'Habis',
  'belum-ada-data': 'Belum Ada Data',
  'perlu-perhatian': 'Perlu Perhatian',
  'over': 'Over RAB',
  'belum-ada-rab': 'Belum Ada RAB',
};

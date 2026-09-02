/* ===========================================================
   views.js — kumpulan tampilan halaman
   =========================================================== */

const Perm = {
  isOwner: () => App.session && App.session.role === 'owner',
  canManageProjects: () => Perm.isOwner(),
  canManageRab: () => Perm.isOwner(),
  canDelete: () => Perm.isOwner(),
};

const Views = {};

/* ================= DASHBOARD ================= */
Views.dashboard = function (root) {
  App.setTopbar('Dashboard', App.session.role === 'owner' ? 'Ringkasan seluruh proyek' : 'Ringkasan proyek Anda');
  const all = Calc.allProjectsHealth();
  const totalProyek = all.length;
  const proyekAlert = all.filter(x => x.health.totalAlert > 0).length;
  const withAvg = all.filter(x => x.health.avgPct !== null);
  const avgAll = withAvg.length ? withAvg.reduce((s, x) => s + x.health.avgPct, 0) / withAvg.length : null;
  const belumAdaRabTotal = all.reduce((s, x) => s + x.health.belumAdaRab, 0);

  const alertRows = [];
  all.forEach(({ project, health }) => {
    health.alerts.forEach(r => alertRows.push({ project, r }));
  });
  alertRows.sort((a, b) => {
    const rank = { habis: 0, over: 0, 'perlu-order': 1, 'perlu-perhatian': 1 };
    return (rank[a.r.statusStok] ?? rank[a.r.statusRab] ?? 2) - (rank[b.r.statusStok] ?? rank[b.r.statusRab] ?? 2);
  });

  root.innerHTML = `
    <div class="view">
      <div class="page-head">
        <div>
          <h2>Halo, ${esc(App.session.name.split(' ')[0])} &#128075;</h2>
          <p>Berikut kondisi bahan proyek per ${fmtDate(todayISO())}.</p>
        </div>
        <div class="actions">
          <button class="btn btn-outline" id="gotoProjects">${ic('folder')} Lihat Proyek</button>
          <button class="btn btn-primary" id="gotoInput">${ic('plus')} Input Transaksi</button>
        </div>
      </div>

      <div class="kpi-grid">
        <div class="kpi-card">
          <div class="icon">${ic('folder')}</div>
          <div class="val">${totalProyek}</div>
          <div class="lbl">Proyek Aktif</div>
        </div>
        <div class="kpi-card ${proyekAlert ? 'red' : 'green'}">
          <div class="icon">${ic('alert')}</div>
          <div class="val">${proyekAlert}</div>
          <div class="lbl">Proyek Perlu Perhatian</div>
        </div>
        <div class="kpi-card amber">
          <div class="icon">${ic('trending')}</div>
          <div class="val">${avgAll === null ? '-' : (avgAll * 100).toFixed(0) + '%'}</div>
          <div class="lbl">Rata-rata Pemakaian vs RAB</div>
        </div>
        <div class="kpi-card">
          <div class="icon">${ic('info')}</div>
          <div class="val">${belumAdaRabTotal}</div>
          <div class="lbl">Bahan Tanpa Data RAB</div>
        </div>
      </div>

      <div class="grid-2">
        <div class="card">
          <div class="card-head">
            <div><h3>Ringkasan per Proyek</h3><div class="sub">Klik baris untuk lihat detail</div></div>
          </div>
          <div class="card-body pad-0">
            <div class="table-wrap">
              <table class="data-table">
                <thead><tr><th>Proyek</th><th>Bahan</th><th>Pemakaian vs RAB</th><th>Status</th></tr></thead>
                <tbody id="dashProjRows"></tbody>
              </table>
            </div>
          </div>
        </div>

        <div class="card">
          <div class="card-head">
            <div><h3>Perlu Perhatian</h3><div class="sub">${alertRows.length} bahan butuh tindak lanjut</div></div>
          </div>
          <div class="card-body pad-0">
            ${alertRows.length ? `<div class="table-wrap"><table class="data-table"><thead><tr><th>Bahan</th><th>Proyek</th><th>Status</th><th>Tindak Lanjut</th></tr></thead><tbody>
              ${alertRows.slice(0, 8).map(({ project, r }) => `
                <tr>
                  <td class="clickable-row" data-hash="#/proyek/${project.id}/ringkasan">${esc(r.material.nama)}</td>
                  <td class="clickable-row" data-hash="#/proyek/${project.id}/ringkasan">${esc(project.nama)}</td>
                  <td>${statusBadge(r.statusStok === 'aman' ? r.statusRab : r.statusStok)}</td>
                  <td style="min-width:150px">${followUpCell(r.material, r.statusStok)}</td>
                </tr>`).join('')}
            </tbody></table></div>` : `
              <div class="empty-state">${ic('check')}<h4>Semua aman</h4><p>Tidak ada bahan yang perlu perhatian khusus saat ini.</p></div>`}
          </div>
        </div>
      </div>
    </div>`;

  const tbody = document.getElementById('dashProjRows');
  tbody.innerHTML = all.map(({ project, health }) => {
    const overall = overallStatus(health);
    return `
    <tr class="clickable-row" data-hash="#/proyek/${project.id}/ringkasan">
      <td><strong>${esc(project.nama)}</strong><div style="font-size:11.5px;color:var(--gray-500)">${esc(project.lokasi)}</div></td>
      <td class="num">${health.totalBahan}</td>
      <td style="min-width:140px">${health.avgPct === null ? '<span style="color:var(--gray-500);font-size:12px">Belum ada RAB</span>' : progressBar(health.avgPct, progressClassFor(null, health.avgPct > 1 ? 'over' : health.avgPct > 0.9 ? 'perlu-perhatian' : 'aman')) + `<div style="font-size:11px;color:var(--gray-500);margin-top:4px">${(health.avgPct * 100).toFixed(0)}%</div>`}</td>
      <td>${statusBadge(overall)}</td>
    </tr>`;
  }).join('') || `<tr><td colspan="4"><div class="empty-state">${ic('folder')}<h4>Belum ada proyek</h4></div></td></tr>`;

  bindRowNav(root);
  bindFollowUpActions(root);
  document.getElementById('gotoProjects').onclick = () => App.navigate('#/proyek');
  document.getElementById('gotoInput').onclick = () => App.navigate('#/input');
};

function overallStatus(health) {
  if (health.avgPct === null && health.totalAlert === 0) return 'belum-ada-rab';
  const has = (s) => health.alerts.some(r => r.statusStok === s || r.statusRab === s);
  if (has('habis')) return 'habis';
  if (has('over')) return 'over';
  if (has('perlu-order')) return 'perlu-order';
  if (has('perlu-perhatian')) return 'perlu-perhatian';
  return 'aman';
}

function bindRowNav(root) {
  root.querySelectorAll('[data-hash]').forEach(el => {
    el.style.cursor = 'pointer';
    el.addEventListener('click', () => App.navigate(el.dataset.hash));
  });
}

/* ================= PROJECTS LIST ================= */
Views.projects = function (root) {
  App.setTopbar('Daftar Proyek', `${Store.projects().length} proyek`);
  const projects = Store.projects();

  root.innerHTML = `
    <div class="view">
      <div class="page-head">
        <div><h2>Daftar Proyek</h2><p>Kelola proyek dan pantau status bahan tiap proyek.</p></div>
        <div class="actions">
          ${Perm.canManageProjects() ? `<button class="btn btn-primary" id="newProjBtn">${ic('plus')} Proyek Baru</button>` : ''}
        </div>
      </div>
      <div class="proj-grid" id="projGrid"></div>
    </div>`;

  const grid = document.getElementById('projGrid');
  if (!projects.length) {
    grid.innerHTML = `<div class="empty-state" style="grid-column:1/-1">${ic('folder')}<h4>Belum ada proyek</h4><p>Buat proyek pertama untuk mulai mencatat bahan.</p></div>`;
  } else {
    grid.innerHTML = projects.map(p => {
      const health = Calc.projectHealth(p.id);
      const overall = overallStatus(health);
      return `
      <div class="proj-card" data-hash="#/proyek/${p.id}/ringkasan">
        <div class="top-row">
          <div><h4>${esc(p.nama)}</h4><div class="loc">${ic('mapPin')} ${esc(p.lokasi)}</div></div>
          <span class="badge ${p.status === 'active' ? 'active' : 'selesai'}">${p.status === 'active' ? 'Aktif' : 'Selesai'}</span>
        </div>
        <div class="stat-row"><span>Nilai Kontrak</span><strong style="color:var(--navy-900)">${fmtCurrency(p.nilaiKontrak)}</strong></div>
        <div class="stat-row"><span>Jumlah Bahan</span><span>${health.totalBahan}</span></div>
        ${health.avgPct !== null ? progressBar(health.avgPct, progressClassFor(null, health.avgPct > 1 ? 'over' : 'aman')) : ''}
        <div class="top-row" style="align-items:center">
          ${statusBadge(overall)}
          ${health.totalAlert ? `<span class="alert-chip">${ic('alert')} ${health.totalAlert} perlu perhatian</span>` : `<span style="font-size:11px;color:var(--gray-500)">${ic('calendar')} Mulai ${fmtDate(p.tanggalMulai)}</span>`}
        </div>
      </div>`;
    }).join('');
  }
  bindRowNav(grid);

  if (Perm.canManageProjects()) {
    document.getElementById('newProjBtn').onclick = () => Views.openProjectModal();
  }
};

Views.openProjectModal = function (project) {
  const isEdit = !!project;
  Modal.open(isEdit ? 'Edit Proyek' : 'Proyek Baru', `
    <div class="form-grid">
      <div class="field full"><label>Nama Proyek</label><input id="fNama" value="${esc(project?.nama || '')}" placeholder="Contoh: Peningkatan Jalan Cibalong" /></div>
      <div class="field"><label>Lokasi</label><input id="fLokasi" value="${esc(project?.lokasi || '')}" placeholder="Kecamatan, Kabupaten" /></div>
      <div class="field"><label>Nilai Kontrak (Rp)</label><input id="fNilai" type="number" value="${project?.nilaiKontrak ?? ''}" placeholder="0" /></div>
      <div class="field"><label>Tanggal Mulai</label><input id="fTgl" type="date" value="${project?.tanggalMulai || todayISO()}" /></div>
      <div class="field"><label>PIC Lapangan</label><input id="fPic" value="${esc(project?.pic || '')}" placeholder="Nama admin lapangan" /></div>
      ${!isEdit && Store.projects().length ? `<div class="field full">
        <label>Salin daftar bahan RAB dari proyek lain (opsional)</label>
        <select id="fTemplate"><option value="">Tidak, mulai kosong</option>${Store.projects().map(p => `<option value="${p.id}">${esc(p.nama)}</option>`).join('')}</select>
        <div class="hint">Bahan &amp; satuan langsung tersalin, tinggal cek ulang angka RAB-nya (bisa dikoreksi lewat tab RAB &amp; Bahan).</div>
      </div>` : ''}
    </div>
    <div class="note-callout">${ic('info')} Belum punya data RAB volume bahan? Tidak masalah &mdash; proyek tetap bisa dibuat dan bahan bisa ditambahkan tanpa RAB, lalu dilengkapi belakangan. Untuk input banyak bahan sekaligus, gunakan "Import Massal" di tab RAB &amp; Bahan setelah proyek dibuat.</div>
  `, `<button class="btn btn-ghost" id="mCancel">Batal</button><button class="btn btn-primary" id="mSave">${isEdit ? 'Simpan' : 'Buat Proyek'}</button>`);

  document.getElementById('mCancel').onclick = Modal.close;
  document.getElementById('mSave').onclick = () => {
    const nama = document.getElementById('fNama').value.trim();
    if (!nama) { Toast.show('Nama proyek wajib diisi', 'error'); return; }
    const payload = {
      nama,
      lokasi: document.getElementById('fLokasi').value.trim(),
      nilaiKontrak: Number(document.getElementById('fNilai').value) || 0,
      tanggalMulai: document.getElementById('fTgl').value || todayISO(),
      pic: document.getElementById('fPic').value.trim(),
    };
    if (isEdit) { Store.updateProject(project.id, payload); Toast.show('Proyek diperbarui', 'success'); }
    else {
      const rec = Store.addProject(payload);
      const templateId = document.getElementById('fTemplate')?.value;
      if (templateId) {
        Store.materials(templateId).forEach(m => Store.addMaterial({ projectId: rec.id, nama: m.nama, kategori: m.kategori, satuan: m.satuan, rabKebutuhan: m.rabKebutuhan }));
        Toast.show('Proyek dibuat, bahan RAB disalin', 'success');
      } else {
        Toast.show('Proyek dibuat', 'success');
      }
      App.navigate('#/proyek/' + rec.id + '/ringkasan');
    }
    Modal.close();
    App.renderView();
  };
};

/* ================= PROJECT DETAIL ================= */
Views.projectDetail = function (root, id, tab) {
  const project = Store.project(id);
  if (!project) { root.innerHTML = `<div class="view"><div class="empty-state">${ic('alert')}<h4>Proyek tidak ditemukan</h4></div></div>`; return; }
  App.setTopbar(project.nama, project.lokasi);

  const tabs = [
    { key: 'ringkasan', label: 'Ringkasan' },
    { key: 'transaksi', label: 'Transaksi' },
    { key: 'rab', label: 'RAB & Bahan' },
    { key: 'mingguan', label: 'Laporan Mingguan' },
  ];
  const health = Calc.projectHealth(id);

  root.innerHTML = `
    <div class="view">
      <div class="page-head">
        <div>
          <h2>${esc(project.nama)}</h2>
          <p>${ic('mapPin')} ${esc(project.lokasi)} &middot; Mulai ${fmtDate(project.tanggalMulai)} &middot; PIC: ${esc(project.pic || '-')}</p>
        </div>
        <div class="actions">
          ${Perm.canManageProjects() ? `<button class="btn btn-outline" id="editProjBtn">${ic('edit')} Edit Proyek</button>` : ''}
          <button class="btn btn-primary" id="inputHereBtn">${ic('plus')} Input Transaksi</button>
        </div>
      </div>

      <div class="kpi-grid">
        <div class="kpi-card"><div class="icon">${ic('layers')}</div><div class="val">${health.totalBahan}</div><div class="lbl">Jenis Bahan</div></div>
        <div class="kpi-card ${health.totalAlert ? 'red' : 'green'}"><div class="icon">${ic('alert')}</div><div class="val">${health.totalAlert}</div><div class="lbl">Perlu Perhatian</div></div>
        <div class="kpi-card amber"><div class="icon">${ic('trending')}</div><div class="val">${health.avgPct === null ? '-' : (health.avgPct * 100).toFixed(0) + '%'}</div><div class="lbl">Rata-rata Pemakaian vs RAB</div></div>
        <div class="kpi-card"><div class="icon">${ic('package')}</div><div class="val">${fmtCurrency(project.nilaiKontrak)}</div><div class="lbl">Nilai Kontrak</div></div>
      </div>

      <div class="tabs" id="detailTabs">
        ${tabs.map(t => `<button class="tab-btn ${t.key === tab ? 'active' : ''}" data-tab="${t.key}">${t.label}</button>`).join('')}
      </div>
      <div id="tabBody"></div>
    </div>`;

  document.getElementById('detailTabs').querySelectorAll('.tab-btn').forEach(b => {
    b.addEventListener('click', () => App.navigate(`#/proyek/${id}/${b.dataset.tab}`));
  });
  document.getElementById('inputHereBtn').onclick = () => Views.openTransactionModal(id);
  if (Perm.canManageProjects()) document.getElementById('editProjBtn').onclick = () => Views.openProjectModal(project);

  const body = document.getElementById('tabBody');
  if (tab === 'transaksi') Views.tabTransaksi(body, project);
  else if (tab === 'rab') Views.tabRab(body, project);
  else if (tab === 'mingguan') Views.tabMingguan(body, project);
  else Views.tabRingkasan(body, project);
};

// Sel "Tindak Lanjut": penanda ringan (bukan form pengajuan) untuk bahan
// yang berstatus Perlu Order/Habis, supaya Admin Pusat/Owner tahu mana yang
// sudah ditindaklanjuti tanpa harus tanya-tanya ulang. Hanya owner yang bisa
// menandai; admin lapangan cukup melihat.
function followUpCell(material, statusStok) {
  const needsFollowUp = statusStok === 'habis' || statusStok === 'perlu-order';
  if (!needsFollowUp) return '<span style="color:var(--gray-300);font-size:12px">-</span>';
  if (material.dipesanPada) {
    return `<div style="display:flex;align-items:center;gap:6px;flex-wrap:wrap">
      <span class="badge aman">${ic('check')} Sudah dipesan &middot; ${fmtDate(material.dipesanPada)}</span>
      ${Perm.isOwner() ? `<button class="btn btn-ghost btn-sm" data-unmark="${material.id}" title="Batalkan tanda">${ic('x')}</button>` : ''}
    </div>`;
  }
  return Perm.isOwner()
    ? `<button class="btn btn-outline btn-sm" data-mark="${material.id}">${ic('check')} Tandai Sudah Dipesan</button>`
    : `<span class="badge habis" style="font-weight:600">${ic('alert')} Belum ditindaklanjuti</span>`;
}

function bindFollowUpActions(root) {
  root.querySelectorAll('[data-mark]').forEach(b => b.addEventListener('click', () => {
    Store.markOrdered(b.dataset.mark, App.session.name);
    Toast.show('Ditandai sudah dipesan', 'success');
    App.renderView();
  }));
  root.querySelectorAll('[data-unmark]').forEach(b => b.addEventListener('click', () => {
    Store.unmarkOrdered(b.dataset.unmark);
    Toast.show('Tanda dibatalkan', 'success');
    App.renderView();
  }));
}

Views.tabRingkasan = function (body, project) {
  const rows = Calc.projectSummaries(project.id);
  body.innerHTML = `
    <div class="card">
      <div class="card-head"><div><h3>Rekap Stok Bahan</h3><div class="sub">Dihitung otomatis dari seluruh transaksi masuk/keluar</div></div></div>
      <div class="card-body pad-0">
        <div class="table-wrap">
          <table class="data-table">
            <thead><tr>
              <th>Bahan</th><th>Satuan</th><th>RAB Kebutuhan</th><th>Total Masuk</th><th>Total Keluar</th><th>Sisa Stok</th><th>% Pemakaian</th><th>Status Stok</th><th>Status RAB</th><th>Tindak Lanjut</th>
            </tr></thead>
            <tbody>
              ${rows.length ? rows.map(r => `
                <tr>
                  <td><strong>${esc(r.material.nama)}</strong></td>
                  <td>${esc(r.material.satuan)}</td>
                  <td class="num">${r.material.rabKebutuhan == null ? '<span style="color:var(--gray-500)">-</span>' : fmtNum(r.material.rabKebutuhan)}</td>
                  <td class="num">${fmtNum(r.totalMasuk)}</td>
                  <td class="num">${fmtNum(r.totalKeluar)}</td>
                  <td class="num"><strong>${fmtNum(r.sisaStok)}</strong></td>
                  <td style="min-width:120px">${r.pctRab === null ? '<span style="font-size:11.5px;color:var(--gray-500)">Belum ada RAB</span>' : progressBar(r.pctRab, progressClassFor(r.statusStok, r.statusRab)) + `<div style="font-size:11px;color:var(--gray-500);margin-top:4px">${(r.pctRab * 100).toFixed(0)}%</div>`}</td>
                  <td>${statusBadge(r.statusStok)}</td>
                  <td>${statusBadge(r.statusRab)}</td>
                  <td style="min-width:150px">${followUpCell(r.material, r.statusStok)}</td>
                </tr>`).join('') : `<tr><td colspan="10"><div class="empty-state">${ic('package')}<h4>Belum ada bahan</h4><p>Tambahkan bahan lewat tab RAB &amp; Bahan.</p></div></td></tr>`}
            </tbody>
          </table>
        </div>
      </div>
    </div>`;
  bindFollowUpActions(body);
};

Views.tabTransaksi = function (body, project) {
  const materials = Store.materials(project.id);
  const allTx = Store.transactionsByProject(project.id).slice().sort((a, b) => b.tanggal.localeCompare(a.tanggal) || b.dibuatPada.localeCompare(a.dibuatPada));

  body.innerHTML = `
    <div class="card">
      <div class="card-head">
        <div><h3>Riwayat Transaksi</h3><div class="sub">${allTx.length} transaksi tercatat</div></div>
      </div>
      <div class="card-body pad-0">
        <div class="filter-bar" style="padding:16px 18px 0">
          <select id="fMat"><option value="">Semua Bahan</option>${materials.map(m => `<option value="${m.id}">${esc(m.nama)}</option>`).join('')}</select>
          <select id="fTipe"><option value="">Semua Tipe</option><option value="masuk">Masuk</option><option value="keluar">Keluar</option></select>
          <input class="fb-grow" id="fSearch" placeholder="Cari no. surat jalan / keterangan..." />
        </div>
        <div class="table-wrap" style="margin-top:10px">
          <table class="data-table">
            <thead><tr><th>Tanggal</th><th>Bahan</th><th>Tipe</th><th>Volume</th><th>No. Surat/Ref</th><th>Keterangan</th><th>Diinput</th><th></th></tr></thead>
            <tbody id="txRows"></tbody>
          </table>
        </div>
      </div>
    </div>`;

  const renderRows = () => {
    const fm = document.getElementById('fMat').value;
    const ft = document.getElementById('fTipe').value;
    const fs = document.getElementById('fSearch').value.trim().toLowerCase();
    const filtered = allTx.filter(t =>
      (!fm || t.materialId === fm) &&
      (!ft || t.tipe === ft) &&
      (!fs || (t.noSuratJalan || '').toLowerCase().includes(fs) || (t.keterangan || '').toLowerCase().includes(fs))
    );
    const tbody = document.getElementById('txRows');
    tbody.innerHTML = filtered.length ? filtered.map(t => {
      const m = Store.material(t.materialId);
      return `<tr>
        <td>${fmtDate(t.tanggal)}</td>
        <td>${esc(m ? m.nama : '-')}</td>
        <td>${statusBadge(t.tipe)}</td>
        <td class="num">${fmtNum(t.volume)} ${esc(m ? m.satuan : '')}</td>
        <td>${esc(t.noSuratJalan || '-')}</td>
        <td>${esc(t.keterangan || t.itemPekerjaan || '-')}</td>
        <td style="font-size:11.5px;color:var(--gray-500)">${esc(t.diinputOleh || '-')}</td>
        <td style="white-space:nowrap">
          <button class="btn btn-ghost btn-sm" data-edit="${t.id}">${ic('edit')}</button>
          ${Perm.canDelete() ? `<button class="btn btn-ghost btn-sm" data-del="${t.id}">${ic('trash')}</button>` : ''}
        </td>
      </tr>`;
    }).join('') : `<tr><td colspan="8"><div class="empty-state">${ic('search')}<h4>Tidak ada transaksi</h4><p>Coba ubah filter, atau tambah transaksi baru.</p></div></td></tr>`;

    tbody.querySelectorAll('[data-edit]').forEach(b => b.onclick = () => Views.openTransactionModal(project.id, allTx.find(t => t.id === b.dataset.edit)));
    tbody.querySelectorAll('[data-del]').forEach(b => b.onclick = () => {
      if (confirm('Hapus transaksi ini? Tindakan tidak bisa dibatalkan.')) {
        Store.deleteTransaction(b.dataset.del);
        Toast.show('Transaksi dihapus', 'success');
        App.renderView();
      }
    });
  };
  ['fMat', 'fTipe', 'fSearch'].forEach(id => document.getElementById(id).addEventListener('input', renderRows));
  renderRows();
};

Views.tabRab = function (body, project) {
  const materials = Store.materials(project.id);
  const canEdit = Perm.canManageRab();
  body.innerHTML = `
    <div class="card">
      <div class="card-head">
        <div><h3>RAB &amp; Master Bahan</h3><div class="sub">Kebutuhan bahan acuan RAB per proyek ini</div></div>
        ${canEdit ? `<div class="actions">
          <button class="btn btn-outline btn-sm" id="dupRabBtn">${ic('copy')} Salin dari Proyek Lain</button>
          <button class="btn btn-outline btn-sm" id="importRabBtn">${ic('upload')} Import Massal</button>
          <button class="btn btn-primary btn-sm" id="addMatBtn">${ic('plus')} Tambah Bahan</button>
        </div>` : ''}
      </div>
      <div class="card-body pad-0">
        ${!canEdit ? `<div style="padding:14px 18px 0"><div class="note-callout">${ic('info')} Hanya Admin Pusat/Owner yang bisa mengubah data RAB. Hubungi owner bila kebutuhan RAB perlu diperbarui.</div></div>` : ''}
        <div class="table-wrap">
          <table class="data-table">
            <thead><tr><th>Bahan</th><th>Kategori</th><th>Satuan</th><th>RAB Kebutuhan</th><th>Kelompok Bahan (Katalog)</th>${canEdit ? '<th></th>' : ''}</tr></thead>
            <tbody>
              ${materials.length ? materials.map(m => {
                const cat = m.catalogId ? Store.catalogItem(m.catalogId) : null;
                return `
                <tr>
                  <td><strong>${esc(m.nama)}</strong></td>
                  <td>${esc(m.kategori || '-')}</td>
                  <td>${esc(m.satuan)}</td>
                  <td class="num">${m.rabKebutuhan == null ? `<span class="badge belum-ada-rab">Belum ada RAB</span>` : fmtNum(m.rabKebutuhan)}</td>
                  <td>${cat ? `<span style="font-size:12px;color:var(--gray-500)">${ic('copy')} ${esc(cat.nama)}</span>` : `<span style="font-size:11.5px;color:var(--gray-300)">belum dihubungkan</span>`}</td>
                  ${canEdit ? `<td style="white-space:nowrap"><button class="btn btn-ghost btn-sm" data-edit="${m.id}">${ic('edit')}</button><button class="btn btn-ghost btn-sm" data-del="${m.id}">${ic('trash')}</button></td>` : ''}
                </tr>`;
              }).join('') : `<tr><td colspan="6"><div class="empty-state">${ic('layers')}<h4>Belum ada bahan</h4></div></td></tr>`}
            </tbody>
          </table>
        </div>
      </div>
    </div>`;

  if (canEdit) {
    document.getElementById('addMatBtn').onclick = () => Views.openMaterialModal(project.id);
    document.getElementById('importRabBtn').onclick = () => Views.openImportRabModal(project.id);
    document.getElementById('dupRabBtn').onclick = () => Views.openDuplicateRabModal(project.id);
    body.querySelectorAll('[data-edit]').forEach(b => b.onclick = () => Views.openMaterialModal(project.id, Store.material(b.dataset.edit)));
    body.querySelectorAll('[data-del]').forEach(b => b.onclick = () => {
      if (confirm('Hapus bahan ini beserta seluruh riwayat transaksinya?')) {
        Store.deleteMaterial(b.dataset.del);
        Toast.show('Bahan dihapus', 'success');
        App.renderView();
      }
    });
  }
};

/* ---- Import RAB massal (paste dari Excel / upload CSV) ---- */
function parseBulkMaterialText(text) {
  return text.split(/\r?\n/)
    .filter(l => l.trim() !== '')
    .map(line => {
      const delim = line.includes('\t') ? '\t' : (line.includes(';') ? ';' : ',');
      const parts = line.split(delim).map(p => p.trim().replace(/^"|"$/g, ''));
      return { nama: parts[0] || '', kategori: parts[1] || '', satuan: parts[2] || '', rabRaw: parts[3] !== undefined ? parts[3] : '' };
    });
}

const smallInputStyle = 'width:100%;border:1px solid var(--gray-200);border-radius:6px;padding:5px 7px;font-size:12.5px';

Views.openImportRabModal = function (projectId) {
  let rows = [];
  Modal.open('Import RAB Massal', `
    <div class="note-callout">${ic('info')} Salin beberapa baris langsung dari Excel (kolom: Nama Bahan, Kategori, Satuan, RAB Kebutuhan) lalu tempel di bawah. RAB Kebutuhan boleh dikosongkan bila belum tersedia. Bisa juga unggah file .csv.</div>
    <div class="field full" style="margin-top:14px">
      <label>Tempel data di sini (dipisah Tab/koma, satu baris per bahan)</label>
      <textarea id="bulkText" rows="6" placeholder="Semen PC&#9;Beton&#9;zak (50kg)&#9;18301.98
Pasir Beton&#9;Beton&#9;m3&#9;1600.43"></textarea>
    </div>
    <div style="display:flex;align-items:center;gap:14px;flex-wrap:wrap;margin-bottom:6px">
      <label style="display:flex;align-items:center;gap:6px;font-size:12.5px;color:var(--gray-700)"><input type="checkbox" id="bulkHeader" checked /> Baris pertama header</label>
      <select id="bulkMode" style="padding:7px 9px;border:1.5px solid var(--gray-200);border-radius:8px;font-size:12.5px">
        <option value="gabung">Update bila nama sama, tambah bila baru</option>
        <option value="tambah">Selalu tambah sebagai bahan baru</option>
      </select>
      <input type="file" id="bulkFile" accept=".csv,.txt" class="hidden" />
      <button type="button" class="btn btn-ghost btn-sm" id="bulkFileBtn">${ic('folder')} Unggah CSV</button>
      <button type="button" class="btn btn-ghost btn-sm" id="bulkTemplateBtn">${ic('download')} Contoh Format</button>
      <button type="button" class="btn btn-outline btn-sm" id="bulkParseBtn">Pratinjau</button>
    </div>
    <div id="bulkPreviewWrap"></div>
  `, `<button class="btn btn-ghost" id="mCancel">Batal</button><button class="btn btn-primary" id="mImport" disabled>Import 0 Bahan</button>`);

  document.getElementById('mCancel').onclick = Modal.close;
  document.getElementById('bulkFileBtn').onclick = () => document.getElementById('bulkFile').click();
  document.getElementById('bulkFile').addEventListener('change', (e) => {
    const f = e.target.files[0];
    if (!f) return;
    const reader = new FileReader();
    reader.onload = () => { document.getElementById('bulkText').value = String(reader.result || ''); };
    reader.readAsText(f);
  });
  document.getElementById('bulkTemplateBtn').onclick = () => {
    const sample = 'Nama Bahan,Kategori,Satuan,RAB Kebutuhan\nSemen PC,Beton,zak (50kg),18301.98\nPasir Beton,Beton,m3,1600.43\nSplit/Kerikil,Beton,m3,\n';
    const blob = new Blob([sample], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url; a.download = 'template_rab_bahan.csv';
    document.body.appendChild(a); a.click(); a.remove();
    setTimeout(() => URL.revokeObjectURL(url), 1000);
  };

  const updateImportBtn = () => {
    const validCount = rows.filter(r => r.nama.trim() && r.satuan.trim()).length;
    const btn = document.getElementById('mImport');
    btn.disabled = validCount === 0;
    btn.textContent = `Import ${validCount} Bahan`;
  };

  const renderPreview = () => {
    const wrap = document.getElementById('bulkPreviewWrap');
    if (!rows.length) { wrap.innerHTML = ''; updateImportBtn(); return; }
    const existingNames = new Set(Store.materials(projectId).map(m => m.nama.trim().toLowerCase()));
    wrap.innerHTML = `<div class="table-wrap" style="max-height:280px;overflow-y:auto;border:1px solid var(--gray-100);border-radius:10px">
      <table class="data-table">
        <thead><tr><th>Nama Bahan</th><th>Kategori</th><th>Satuan</th><th>RAB Kebutuhan</th><th>Ket.</th><th></th></tr></thead>
        <tbody>${rows.map((r, i) => {
          const valid = r.nama.trim() && r.satuan.trim();
          const isUpdate = existingNames.has(r.nama.trim().toLowerCase());
          return `<tr>
            <td><input data-i="${i}" data-f="nama" value="${esc(r.nama)}" style="${smallInputStyle}" /></td>
            <td><input data-i="${i}" data-f="kategori" value="${esc(r.kategori)}" style="${smallInputStyle}" /></td>
            <td><input data-i="${i}" data-f="satuan" value="${esc(r.satuan)}" style="${smallInputStyle};width:90px" /></td>
            <td><input data-i="${i}" data-f="rabRaw" value="${esc(r.rabRaw)}" style="${smallInputStyle};width:100px" /></td>
            <td>${!valid ? '<span class="badge habis">Belum lengkap</span>' : isUpdate ? '<span class="badge perlu-order">Update</span>' : '<span class="badge aman">Baru</span>'}</td>
            <td><button type="button" class="btn btn-ghost btn-sm" data-del="${i}">${ic('x')}</button></td>
          </tr>`;
        }).join('')}</tbody>
      </table></div>
      <div class="hint" style="margin-top:8px">${rows.filter(r => r.nama.trim() && r.satuan.trim()).length} dari ${rows.length} baris siap diimport.</div>`;

    wrap.querySelectorAll('input[data-i]').forEach(inp => inp.addEventListener('input', () => {
      rows[Number(inp.dataset.i)][inp.dataset.f] = inp.value;
      updateImportBtn();
      wrap.querySelectorAll(`[data-del="${inp.dataset.i}"]`);
    }));
    wrap.querySelectorAll('[data-del]').forEach(b => b.addEventListener('click', () => { rows.splice(Number(b.dataset.del), 1); renderPreview(); }));
    updateImportBtn();
  };

  document.getElementById('bulkParseBtn').onclick = () => {
    const text = document.getElementById('bulkText').value;
    let parsed = parseBulkMaterialText(text);
    if (document.getElementById('bulkHeader').checked && parsed.length) parsed = parsed.slice(1);
    if (!parsed.length) { Toast.show('Tidak ada baris yang bisa dibaca', 'error'); return; }
    rows = parsed;
    renderPreview();
  };

  document.getElementById('mImport').onclick = () => {
    const mode = document.getElementById('bulkMode').value;
    const existing = Store.materials(projectId);
    let added = 0, updated = 0, skipped = 0;
    rows.forEach(r => {
      const nama = r.nama.trim(), satuan = r.satuan.trim();
      if (!nama || !satuan) { skipped++; return; }
      const rab = parseFlexNumber(r.rabRaw);
      const match = mode === 'gabung' ? existing.find(m => m.nama.trim().toLowerCase() === nama.toLowerCase()) : null;
      if (match) { Store.updateMaterial(match.id, { kategori: r.kategori.trim(), satuan, rabKebutuhan: rab }); updated++; }
      else { const rec = Store.addMaterial({ projectId, nama, kategori: r.kategori.trim(), satuan, rabKebutuhan: rab }); existing.push(rec); added++; }
    });
    Toast.show(`Import selesai: ${added} bahan baru, ${updated} diperbarui${skipped ? `, ${skipped} baris dilewati` : ''}`, 'success');
    Modal.close();
    App.renderView();
  };
};

/* ---- Salin bahan RAB dari proyek lain (template antar-proyek) ---- */
Views.openDuplicateRabModal = function (projectId) {
  const others = Store.projects().filter(p => p.id !== projectId);
  if (!others.length) { Toast.show('Belum ada proyek lain untuk disalin', 'error'); return; }

  const renderList = (sourceId) => {
    const mats = Store.materials(sourceId);
    const wrap = document.getElementById('dupListWrap');
    wrap.innerHTML = mats.length ? `
      <div class="table-wrap" style="max-height:260px;overflow-y:auto;border:1px solid var(--gray-100);border-radius:10px">
        <table class="data-table"><thead><tr><th style="width:34px"><input type="checkbox" id="dupAll" checked /></th><th>Nama Bahan</th><th>Satuan</th><th>RAB Kebutuhan</th></tr></thead>
        <tbody>${mats.map(m => `<tr>
          <td><input type="checkbox" class="dupItem" value="${m.id}" checked /></td>
          <td>${esc(m.nama)}</td><td>${esc(m.satuan)}</td>
          <td class="num">${m.rabKebutuhan == null ? '<span style="color:var(--gray-500)">-</span>' : fmtNum(m.rabKebutuhan)}</td>
        </tr>`).join('')}</tbody></table>
      </div>` : `<div class="empty-state">${ic('layers')}<h4>Proyek ini belum punya bahan</h4></div>`;

    const allBox = document.getElementById('dupAll');
    if (allBox) allBox.addEventListener('change', () => wrap.querySelectorAll('.dupItem').forEach(cb => cb.checked = allBox.checked));
  };

  Modal.open('Salin Bahan RAB dari Proyek Lain', `
    <div class="form-grid">
      <div class="field full">
        <label>Salin dari proyek</label>
        <select id="dupSource">${others.map(p => `<option value="${p.id}">${esc(p.nama)}</option>`).join('')}</select>
      </div>
      <div class="field full">
        <label style="display:flex;align-items:center;gap:6px"><input type="checkbox" id="dupIncludeRab" checked style="width:auto" /> Sertakan angka RAB Kebutuhan</label>
        <div class="hint">Nonaktifkan bila volume RAB proyek ini pasti berbeda &mdash; nama &amp; satuan tetap disalin, RAB dikosongkan untuk diisi manual.</div>
      </div>
    </div>
    <div id="dupListWrap"></div>
  `, `<button class="btn btn-ghost" id="mCancel">Batal</button><button class="btn btn-primary" id="mDup">Salin Bahan Terpilih</button>`);

  document.getElementById('mCancel').onclick = Modal.close;
  const srcSel = document.getElementById('dupSource');
  renderList(srcSel.value);
  srcSel.addEventListener('change', () => renderList(srcSel.value));

  document.getElementById('mDup').onclick = () => {
    const includeRab = document.getElementById('dupIncludeRab').checked;
    const sourceId = srcSel.value;
    const chosenIds = Array.from(document.querySelectorAll('.dupItem:checked')).map(cb => cb.value);
    if (!chosenIds.length) { Toast.show('Pilih minimal satu bahan', 'error'); return; }
    const existingNames = new Set(Store.materials(projectId).map(m => m.nama.trim().toLowerCase()));
    let added = 0, skipped = 0;
    chosenIds.forEach(id => {
      const m = Store.material(id);
      if (!m) return;
      if (existingNames.has(m.nama.trim().toLowerCase())) { skipped++; return; }
      Store.addMaterial({ projectId, nama: m.nama, kategori: m.kategori, satuan: m.satuan, rabKebutuhan: includeRab ? m.rabKebutuhan : null });
      existingNames.add(m.nama.trim().toLowerCase());
      added++;
    });
    Toast.show(`${added} bahan disalin${skipped ? `, ${skipped} dilewati (nama sudah ada)` : ''}`, 'success');
    Modal.close();
    App.renderView();
  };
};

Views.openMaterialModal = function (projectId, material) {
  const isEdit = !!material;
  Modal.open(isEdit ? 'Edit Bahan' : 'Tambah Bahan', `
    <div class="form-grid">
      <div class="field full"><label>Nama Bahan</label><input id="fNama" value="${esc(material?.nama || '')}" placeholder="Contoh: Semen PC" /></div>
      <div class="field"><label>Satuan</label><input id="fSatuan" value="${esc(material?.satuan || '')}" placeholder="zak / m3 / rit" /></div>
      <div class="field"><label>Kategori</label><input id="fKategori" value="${esc(material?.kategori || '')}" placeholder="Beton / Perkerasan / dst" /></div>
      <div class="field full">
        <label>RAB Kebutuhan (opsional) <span class="help-tip" title="Kosongkan bila data volume RAB belum tersedia. Status akan ditandai 'Belum ada RAB' dan tidak mengganggu perhitungan stok masuk/keluar.">${ic('info')}</span></label>
        <input id="fRab" type="number" step="any" value="${material?.rabKebutuhan ?? ''}" placeholder="Kosongkan jika belum tersedia" />
        <div class="hint">Boleh dikosongkan. Sistem tetap menghitung stok masuk/keluar walau RAB belum ada.</div>
      </div>
      <div class="field full">
        <label>Kelompok Bahan / Katalog (opsional) <span class="help-tip" title="Kalau bahan yang sama namanya beda-beda di tiap proyek (misal 'Semen PC' vs 'Semen Portland 50kg'), ketik/pilih nama kelompok yang sama di sini supaya bisa direkap total lintas proyek di halaman Katalog Bahan. Nama bahan di atas TIDAK ikut berubah.">${ic('info')}</span></label>
        <input id="fCatalog" list="catalogDatalist" value="${esc(material?.catalogId ? (Store.catalogItem(material.catalogId)?.nama || '') : '')}" placeholder="Ketik atau pilih dari daftar, kosongkan bila tidak perlu" />
        <datalist id="catalogDatalist">${Store.catalog().map(c => `<option value="${esc(c.nama)}">`).join('')}</datalist>
        <div class="hint">Kalau nama belum ada di daftar, entri katalog baru dibuat otomatis saat disimpan.</div>
      </div>
    </div>
  `, `<button class="btn btn-ghost" id="mCancel">Batal</button><button class="btn btn-primary" id="mSave">${isEdit ? 'Simpan' : 'Tambah'}</button>`);

  document.getElementById('mCancel').onclick = Modal.close;
  document.getElementById('mSave').onclick = () => {
    const nama = document.getElementById('fNama').value.trim();
    const satuan = document.getElementById('fSatuan').value.trim();
    if (!nama || !satuan) { Toast.show('Nama dan satuan wajib diisi', 'error'); return; }
    const rabVal = document.getElementById('fRab').value;
    const catalogName = document.getElementById('fCatalog').value.trim();
    let catalogId = null;
    if (catalogName) {
      const existingCat = Store.catalog().find(c => c.nama.trim().toLowerCase() === catalogName.toLowerCase());
      catalogId = existingCat ? existingCat.id : Store.addCatalog({ nama: catalogName, satuan, kategori: document.getElementById('fKategori').value.trim() }).id;
    }
    const payload = { nama, satuan, kategori: document.getElementById('fKategori').value.trim(), rabKebutuhan: rabVal === '' ? null : Number(rabVal), catalogId };
    if (isEdit) Store.updateMaterial(material.id, payload);
    else Store.addMaterial(Object.assign({ projectId }, payload));
    Toast.show(isEdit ? 'Bahan diperbarui' : 'Bahan ditambahkan', 'success');
    Modal.close();
    App.renderView();
  };
};

Views.tabMingguan = function (body, project) {
  const weeks = Calc.weekOptions(project.id);
  body.innerHTML = `
    <div class="card">
      <div class="card-head">
        <div><h3>Laporan Mingguan</h3><div class="sub">Rekap masuk/keluar per minggu berjalan</div></div>
        <select id="weekSel">${weeks.map((w, i) => `<option value="${w}">Minggu ${fmtDate(w)} &ndash; ${fmtDate(addDays(w, 6))}</option>`).join('')}</select>
      </div>
      <div class="card-body pad-0"><div class="table-wrap"><table class="data-table">
        <thead><tr><th>No</th><th>Nama Bahan</th><th>Satuan</th><th>Masuk Minggu Ini</th><th>Keluar Minggu Ini</th><th>Sisa Stok s/d Minggu Ini</th></tr></thead>
        <tbody id="weekRows"></tbody>
      </table></div></div>
    </div>`;

  const render = () => {
    const week = document.getElementById('weekSel').value;
    const rows = Calc.weeklyRecap(project.id, week);
    document.getElementById('weekRows').innerHTML = rows.length ? rows.map((r, i) => `
      <tr>
        <td>${i + 1}</td><td><strong>${esc(r.material.nama)}</strong></td><td>${esc(r.material.satuan)}</td>
        <td class="num">${fmtNum(r.masukMinggu)}</td><td class="num">${fmtNum(r.keluarMinggu)}</td><td class="num">${fmtNum(r.sisaSdMinggu)}</td>
      </tr>`).join('') : `<tr><td colspan="6"><div class="empty-state">${ic('calendar')}<h4>Belum ada bahan</h4></div></td></tr>`;
  };
  document.getElementById('weekSel').addEventListener('change', render);
  render();
};

function addDays(iso, n) { const d = new Date(iso); d.setDate(d.getDate() + n); return d.toISOString().slice(0, 10); }

/* ================= KATALOG BAHAN (rekap lintas proyek) ================= */
Views.catalog = function (root) {
  App.setTopbar('Katalog Bahan', 'Satu barang, boleh beda nama di tiap RAB proyek');
  const rows = Calc.catalogSummary();
  const unlinked = Calc.unlinkedMaterialCount();

  root.innerHTML = `
    <div class="view">
      <div class="page-head">
        <div>
          <h2>Katalog Bahan</h2>
          <p>Hubungkan bahan yang penulisannya beda-beda di tiap RAB proyek ke satu entri di sini, supaya bisa direkap totalnya lintas proyek &mdash; tanpa mengubah nama asli di RAB masing-masing proyek.</p>
        </div>
        <div class="actions"><button class="btn btn-primary" id="newCatBtn">${ic('plus')} Entri Katalog Baru</button></div>
      </div>

      ${unlinked ? `<div class="note-callout warn" style="margin-bottom:16px">${ic('alert')} ${unlinked} bahan di berbagai proyek belum dihubungkan ke katalog, jadi belum ikut ke rekap lintas proyek di bawah. Hubungkan lewat tab "RAB &amp; Bahan" tiap proyek (kolom "Kelompok Bahan").</div>` : ''}

      <div class="card">
        <div class="card-head"><div><h3>Rekap Lintas Proyek</h3><div class="sub">${rows.length} entri katalog</div></div></div>
        <div class="card-body pad-0">
          <div class="table-wrap"><table class="data-table">
            <thead><tr><th>Katalog Bahan</th><th>Satuan Baku</th><th>Proyek</th><th>Nama di Tiap RAB Proyek</th><th>Total Masuk</th><th>Total Keluar</th><th>Total RAB</th><th></th></tr></thead>
            <tbody id="catRows"></tbody>
          </table></div>
        </div>
      </div>
    </div>`;

  const tbody = document.getElementById('catRows');
  tbody.innerHTML = rows.length ? rows.map(r => `
    <tr>
      <td><strong>${esc(r.catalog.nama)}</strong>${r.catalog.kategori ? `<div style="font-size:11px;color:var(--gray-500)">${esc(r.catalog.kategori)}</div>` : ''}</td>
      <td>${esc(r.catalog.satuan)}</td>
      <td class="num">${r.projectsInvolved.length}</td>
      <td>${r.linked.length ? r.linked.map(m => {
          const proj = Store.project(m.projectId);
          const mismatch = m.satuan.trim().toLowerCase() !== r.catalog.satuan.trim().toLowerCase();
          return `<div style="font-size:12px;margin-bottom:3px">${esc(m.nama)} <span style="color:var(--gray-500)">&middot; ${esc(proj ? proj.nama : '-')}</span>${mismatch ? ` <span class="badge habis" title="Satuan bahan ini (${esc(m.satuan)}) beda dari satuan baku katalog (${esc(r.catalog.satuan)}), jadi tidak ikut dijumlahkan otomatis">satuan beda</span>` : ''}</div>`;
        }).join('') : `<span style="font-size:12px;color:var(--gray-500)">Belum ada bahan proyek yang dihubungkan ke sini</span>`}</td>
      <td class="num">${fmtNum(r.totalMasuk)}</td>
      <td class="num">${fmtNum(r.totalKeluar)}</td>
      <td class="num">${r.totalRab == null ? '<span style="color:var(--gray-500)">-</span>' : fmtNum(r.totalRab)}</td>
      <td style="white-space:nowrap"><button class="btn btn-ghost btn-sm" data-edit="${r.catalog.id}">${ic('edit')}</button><button class="btn btn-ghost btn-sm" data-del="${r.catalog.id}">${ic('trash')}</button></td>
    </tr>`).join('') : `<tr><td colspan="8"><div class="empty-state">${ic('layers')}<h4>Belum ada entri katalog</h4><p>Buat entri katalog untuk mulai menggabungkan bahan-bahan sejenis dari berbagai proyek.</p></div></td></tr>`;

  document.getElementById('newCatBtn').onclick = () => Views.openCatalogModal();
  tbody.querySelectorAll('[data-edit]').forEach(b => b.onclick = () => Views.openCatalogModal(Store.catalogItem(b.dataset.edit)));
  tbody.querySelectorAll('[data-del]').forEach(b => b.onclick = () => {
    if (confirm('Hapus entri katalog ini? Bahan di tiap proyek tidak akan ikut terhapus, hanya tautannya yang lepas.')) {
      Store.deleteCatalog(b.dataset.del);
      Toast.show('Entri katalog dihapus', 'success');
      App.renderView();
    }
  });
};

Views.openCatalogModal = function (cat) {
  const isEdit = !!cat;
  Modal.open(isEdit ? 'Edit Katalog Bahan' : 'Entri Katalog Baru', `
    <div class="note-callout">${ic('info')} Ini nama "kelompok"/baku, dipakai untuk menggabungkan bahan yang penulisannya beda-beda di tiap RAB proyek (misal "Semen PC" vs "Semen Portland 50kg") agar bisa direkap total pemakaiannya lintas proyek.</div>
    <div class="form-grid" style="margin-top:14px">
      <div class="field full"><label>Nama Katalog</label><input id="fCatNama" value="${esc(cat?.nama || '')}" placeholder="Contoh: Semen PC 50kg" /></div>
      <div class="field"><label>Satuan Baku</label><input id="fCatSatuan" value="${esc(cat?.satuan || '')}" placeholder="zak / m3 / rit" /></div>
      <div class="field"><label>Kategori</label><input id="fCatKategori" value="${esc(cat?.kategori || '')}" placeholder="Beton / Perkerasan / dst" /></div>
    </div>
  `, `<button class="btn btn-ghost" id="mCancel">Batal</button><button class="btn btn-primary" id="mSave">${isEdit ? 'Simpan' : 'Buat'}</button>`);

  document.getElementById('mCancel').onclick = Modal.close;
  document.getElementById('mSave').onclick = () => {
    const nama = document.getElementById('fCatNama').value.trim();
    const satuan = document.getElementById('fCatSatuan').value.trim();
    if (!nama || !satuan) { Toast.show('Nama dan satuan wajib diisi', 'error'); return; }
    const payload = { nama, satuan, kategori: document.getElementById('fCatKategori').value.trim() };
    if (isEdit) Store.updateCatalog(cat.id, payload); else Store.addCatalog(payload);
    Toast.show(isEdit ? 'Katalog diperbarui' : 'Katalog dibuat', 'success');
    Modal.close();
    App.renderView();
  };
};

/* ================= QUICK INPUT (mode lapangan) ================= */
Views.quickInput = function (root) {
  App.setTopbar('Input Transaksi', 'Catat bahan masuk atau keluar');
  const projects = Store.projects();
  const defaultProj = App.session.projectId && Store.project(App.session.projectId) ? App.session.projectId : (projects[0] ? projects[0].id : '');

  root.innerHTML = `
    <div class="view" style="max-width:760px">
      <div class="page-head"><div><h2>Input Transaksi</h2><p>Pilih proyek dan bahan, lalu catat transaksi masuk atau keluar.</p></div></div>

      <div class="card" style="margin-bottom:16px">
        <div class="card-body">
          <div class="form-grid">
            <div class="field full"><label>Proyek</label><select id="qProj">${projects.map(p => `<option value="${p.id}" ${p.id === defaultProj ? 'selected' : ''}>${esc(p.nama)}</option>`).join('')}</select></div>
          </div>
          <div class="quickpad">
            <div class="qp-btn in active" data-tipe="masuk">${ic('in')}<strong>Bahan Masuk</strong><span>Barang diterima di lapangan</span></div>
            <div class="qp-btn out" data-tipe="keluar">${ic('out')}<strong>Bahan Terpakai</strong><span>Bahan digunakan untuk pekerjaan</span></div>
          </div>
          <div class="form-grid">
            <div class="field full"><label>Bahan</label><select id="qMat"></select></div>
            <div class="field"><label>Volume</label><input id="qVol" type="number" step="any" min="0" placeholder="0" /></div>
            <div class="field"><label>Tanggal</label><input id="qTgl" type="date" value="${todayISO()}" /></div>
            <div class="field"><label id="qRefLabel">No. Surat Jalan</label><input id="qRef" placeholder="SJ-0001" /></div>
            <div class="field"><label>Item Pekerjaan (opsional)</label><input id="qItem" placeholder="Contoh: 5.1.(1) Lapis Pondasi Agregat A" /></div>
            <div class="field full"><label>Keterangan</label><textarea id="qKet" rows="2" placeholder="Catatan tambahan (opsional)"></textarea></div>
          </div>
          <button class="btn btn-primary btn-block" id="qSubmit">${ic('plus')} Simpan Transaksi</button>
        </div>
      </div>

      <div class="card">
        <div class="card-head"><h3>Transaksi Hari Ini</h3></div>
        <div class="card-body pad-0"><div class="table-wrap"><table class="data-table">
          <thead><tr><th>Waktu</th><th>Proyek</th><th>Bahan</th><th>Tipe</th><th>Volume</th></tr></thead>
          <tbody id="qToday"></tbody>
        </table></div></div>
      </div>
    </div>`;

  let tipe = 'masuk';
  const matSel = document.getElementById('qMat');
  const fillMaterials = () => {
    const pid = document.getElementById('qProj').value;
    const mats = Store.materials(pid);
    matSel.innerHTML = mats.length ? mats.map(m => `<option value="${m.id}">${esc(m.nama)} (${esc(m.satuan)})</option>`).join('') : `<option value="">Belum ada bahan di proyek ini</option>`;
  };
  fillMaterials();
  document.getElementById('qProj').addEventListener('change', fillMaterials);

  root.querySelectorAll('.qp-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      root.querySelectorAll('.qp-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      tipe = btn.dataset.tipe;
      document.getElementById('qRefLabel').textContent = tipe === 'masuk' ? 'No. Surat Jalan' : 'Referensi (opsional)';
    });
  });

  const renderToday = () => {
    const all = Store.transactions().filter(t => t.tanggal === todayISO()).sort((a, b) => b.dibuatPada.localeCompare(a.dibuatPada));
    document.getElementById('qToday').innerHTML = all.length ? all.map(t => {
      const m = Store.material(t.materialId);
      const proj = m ? Store.project(m.projectId) : null;
      return `<tr><td>${new Date(t.dibuatPada).toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' })}</td><td>${esc(proj ? proj.nama : '-')}</td><td>${esc(m ? m.nama : '-')}</td><td>${statusBadge(t.tipe)}</td><td class="num">${fmtNum(t.volume)} ${esc(m ? m.satuan : '')}</td></tr>`;
    }).join('') : `<tr><td colspan="5"><div class="empty-state">${ic('clipboard')}<h4>Belum ada input hari ini</h4></div></td></tr>`;
  };
  renderToday();

  document.getElementById('qSubmit').addEventListener('click', () => {
    const projectId = document.getElementById('qProj').value;
    const materialId = matSel.value;
    const volume = Number(document.getElementById('qVol').value);
    const tanggal = document.getElementById('qTgl').value || todayISO();
    if (!materialId) { Toast.show('Pilih bahan terlebih dahulu', 'error'); return; }
    if (!volume || volume <= 0) { Toast.show('Volume harus lebih dari 0', 'error'); return; }
    Store.addTransaction({
      materialId, tipe, tanggal, volume,
      noSuratJalan: document.getElementById('qRef').value.trim(),
      itemPekerjaan: document.getElementById('qItem').value.trim(),
      keterangan: document.getElementById('qKet').value.trim(),
      diinputOleh: App.session.name,
    });
    Toast.show(`Bahan ${tipe === 'masuk' ? 'masuk' : 'keluar'} tercatat`, 'success');
    document.getElementById('qVol').value = '';
    document.getElementById('qRef').value = '';
    document.getElementById('qItem').value = '';
    document.getElementById('qKet').value = '';
    renderToday();
  });
};

Views.openTransactionModal = function (projectId, tx) {
  const materials = Store.materials(projectId);
  if (!materials.length) { Toast.show('Tambahkan bahan dulu lewat tab RAB & Bahan', 'error'); return; }
  const isEdit = !!tx;
  Modal.open(isEdit ? 'Edit Transaksi' : 'Input Transaksi', `
    <div class="form-grid">
      <div class="field full"><label>Bahan</label><select id="tMat">${materials.map(m => `<option value="${m.id}" ${tx?.materialId === m.id ? 'selected' : ''}>${esc(m.nama)} (${esc(m.satuan)})</option>`).join('')}</select></div>
      <div class="field"><label>Tipe</label><select id="tTipe"><option value="masuk" ${tx?.tipe === 'masuk' ? 'selected' : ''}>Masuk</option><option value="keluar" ${tx?.tipe === 'keluar' ? 'selected' : ''}>Keluar</option></select></div>
      <div class="field"><label>Volume</label><input id="tVol" type="number" step="any" value="${tx?.volume ?? ''}" /></div>
      <div class="field"><label>Tanggal</label><input id="tTgl" type="date" value="${tx?.tanggal || todayISO()}" /></div>
      <div class="field"><label>No. Surat/Ref</label><input id="tRef" value="${esc(tx?.noSuratJalan || '')}" /></div>
      <div class="field full"><label>Item Pekerjaan (opsional)</label><input id="tItem" value="${esc(tx?.itemPekerjaan || '')}" /></div>
      <div class="field full"><label>Keterangan</label><textarea id="tKet" rows="2">${esc(tx?.keterangan || '')}</textarea></div>
    </div>
  `, `<button class="btn btn-ghost" id="mCancel">Batal</button><button class="btn btn-primary" id="mSave">${isEdit ? 'Simpan' : 'Tambah'}</button>`);

  document.getElementById('mCancel').onclick = Modal.close;
  document.getElementById('mSave').onclick = () => {
    const volume = Number(document.getElementById('tVol').value);
    if (!volume || volume <= 0) { Toast.show('Volume harus lebih dari 0', 'error'); return; }
    const payload = {
      materialId: document.getElementById('tMat').value,
      tipe: document.getElementById('tTipe').value,
      volume,
      tanggal: document.getElementById('tTgl').value || todayISO(),
      noSuratJalan: document.getElementById('tRef').value.trim(),
      itemPekerjaan: document.getElementById('tItem').value.trim(),
      keterangan: document.getElementById('tKet').value.trim(),
    };
    if (isEdit) Store.updateTransaction(tx.id, payload);
    else Store.addTransaction(Object.assign({ diinputOleh: App.session.name }, payload));
    Toast.show(isEdit ? 'Transaksi diperbarui' : 'Transaksi ditambahkan', 'success');
    Modal.close();
    App.renderView();
  };
};

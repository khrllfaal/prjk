/* ===========================================================
   app.js — router, rendering, dan interaksi UI
   =========================================================== */

const fmtNum = (n, dec) => {
  if (n === null || n === undefined || isNaN(n)) return '-';
  return Number(n).toLocaleString('id-ID', { maximumFractionDigits: dec === undefined ? 2 : dec, minimumFractionDigits: 0 });
};
const fmtCurrency = (n) => {
  if (n === null || n === undefined || isNaN(n)) return '-';
  return 'Rp ' + Math.round(n).toLocaleString('id-ID');
};
const fmtDate = (iso) => {
  if (!iso) return '-';
  const d = new Date(iso);
  if (isNaN(d)) return iso;
  return d.toLocaleDateString('id-ID', { day: '2-digit', month: 'short', year: 'numeric' });
};
// Terima angka dari copy-paste Excel dalam format apa pun: "1.234,56" (id-ID),
// "1234.56", "1,234.56", atau kosong. Dipakai oleh fitur import massal RAB.
const parseFlexNumber = (raw) => {
  if (raw === undefined || raw === null) return null;
  let s = String(raw).trim().replace(/[^0-9.,-]/g, '');
  if (s === '' || s === '-') return null;
  const hasComma = s.includes(','), hasDot = s.includes('.');
  if (hasComma && hasDot) {
    s = s.lastIndexOf(',') > s.lastIndexOf('.') ? s.replace(/\./g, '').replace(',', '.') : s.replace(/,/g, '');
  } else if (hasComma && !hasDot) {
    s = s.replace(',', '.');
  }
  const n = parseFloat(s);
  return isNaN(n) ? null : n;
};

const esc = (s) => String(s === undefined || s === null ? '' : s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
const todayISO = () => new Date().toISOString().slice(0, 10);

function statusBadge(status) {
  return `<span class="badge ${status}">${STATUS_LABEL[status] || status}</span>`;
}
function progressBar(pct, cls) {
  const p = Math.max(0, Math.min(100, (pct || 0) * 100));
  return `<div class="progress ${cls || ''}"><span style="width:${p.toFixed(1)}%"></span></div>`;
}
function progressClassFor(statusStok, statusRab) {
  if (statusStok === 'habis' || statusRab === 'over') return 'danger';
  if (statusStok === 'perlu-order' || statusRab === 'perlu-perhatian') return 'warn';
  if (statusStok === 'belum-ada-data' || statusRab === 'belum-ada-rab') return '';
  return 'ok';
}

/* ---------------- Toast ---------------- */
const Toast = {
  show(msg, type) {
    const wrap = document.getElementById('toastWrap');
    const el = document.createElement('div');
    el.className = 'toast' + (type ? ' ' + type : '');
    el.innerHTML = `${type === 'success' ? ic('check') : type === 'error' ? ic('alert') : ic('info')}<span>${esc(msg)}</span>`;
    wrap.appendChild(el);
    setTimeout(() => { el.style.opacity = '0'; el.style.transition = '.25s'; setTimeout(() => el.remove(), 250); }, 2800);
  },
};

/* ---------------- Modal ---------------- */
const Modal = {
  open(title, bodyHtml, footHtml) {
    const root = document.getElementById('modalRoot');
    root.innerHTML = `
      <div class="modal-overlay" id="modalOverlay">
        <div class="modal">
          <div class="modal-head"><h3>${esc(title)}</h3><button id="modalCloseBtn" type="button">${ic('x')}</button></div>
          <div class="modal-body">${bodyHtml}</div>
          ${footHtml ? `<div class="modal-foot">${footHtml}</div>` : ''}
        </div>
      </div>`;
    document.getElementById('modalCloseBtn').onclick = Modal.close;
    document.getElementById('modalOverlay').addEventListener('click', (e) => { if (e.target.id === 'modalOverlay') Modal.close(); });
  },
  close() { document.getElementById('modalRoot').innerHTML = ''; },
};

/* ---------------- App state / session ---------------- */
const App = {
  session: null,
  route: { name: 'dashboard', params: {} },

  init() {
    this.session = Session.get();
    window.addEventListener('hashchange', () => this.route = this.parseHash());
    if (!this.session) { this.renderLogin(); return; }
    this.boot();
  },

  boot() {
    this.route = this.parseHash();
    this.renderShell();
    window.addEventListener('hashchange', () => { this.route = this.parseHash(); this.renderView(); });
  },

  parseHash() {
    const h = (location.hash || '#/dashboard').replace(/^#\/?/, '');
    const parts = h.split('/').filter(Boolean);
    if (parts[0] === 'proyek' && parts[1] === 'baru') return { name: 'project-new', params: {} };
    if (parts[0] === 'proyek' && parts[1]) return { name: 'project-detail', params: { id: parts[1], tab: parts[2] || 'ringkasan' } };
    if (parts[0] === 'proyek') return { name: 'projects', params: {} };
    if (parts[0] === 'input') return { name: 'quick-input', params: {} };
    if (parts[0] === 'katalog') return { name: 'catalog', params: {} };
    return { name: 'dashboard', params: {} };
  },

  navigate(hash) { location.hash = hash; },

  logout() {
    Session.clear();
    this.session = null;
    location.hash = '';
    this.renderLogin();
  },

  /* ============== LOGIN ============== */
  renderLogin() {
    document.getElementById('app').innerHTML = `
      <div class="login-screen">
        <div class="login-card">
          <div class="login-brand">
            <div>
              <div class="brand-mark"><span class="logo-dot"></span>MatTrack</div>
              <h1>Rekap bahan masuk &amp; keluar, dari lapangan sampai ke owner &mdash; realtime.</h1>
              <p>Satu sistem untuk mencatat bahan di lapangan dan memantau stok terhadap RAB, tanpa spreadsheet yang gampang rusak.</p>
            </div>
            <ul class="login-feature-list">
              <li>${ic('check')} Input cepat oleh admin lapangan, dari HP maupun laptop</li>
              <li>${ic('check')} Rekap stok &amp; status terhitung otomatis, real-time</li>
              <li>${ic('check')} Tetap jalan walau data RAB volume bahan belum lengkap</li>
              <li>${ic('check')} Siap multi-proyek &amp; multi-perangkat sejak awal</li>
            </ul>
            <div class="login-foot">MatTrack &middot; Material Management &middot; v1.0 (Frontend Demo)</div>
          </div>
          <div class="login-form-wrap">
            <h2>Masuk ke akun Anda</h2>
            <p class="sub">Pilih peran dan isi nama untuk mulai mode demo.</p>
            <div class="role-picker" id="rolePicker">
              <button type="button" class="role-opt active" data-role="lapangan">
                ${ic('clipboard')}<strong>Admin Lapangan</strong><span>Input bahan masuk &amp; keluar harian per proyek</span>
              </button>
              <button type="button" class="role-opt" data-role="owner">
                ${ic('trending')}<strong>Admin Pusat / Owner</strong><span>Pantau semua proyek, stok, dan RAB</span>
              </button>
            </div>
            <div class="field">
              <label for="loginName">Nama</label>
              <input id="loginName" type="text" placeholder="Nama Anda" autocomplete="name" />
            </div>
            <div class="field">
              <label for="loginProject">Proyek utama (opsional)</label>
              <select id="loginProject"><option value="">Semua proyek</option></select>
            </div>
            <button class="btn btn-primary btn-block" id="loginBtn" type="button">Masuk</button>
            <div class="login-demo-note">${ic('info')} Mode demo: data tersimpan di browser ini saja (localStorage). Struktur data sudah disiapkan agar tinggal disambungkan ke backend nyata.</div>
          </div>
        </div>
      </div>`;

    const projSel = document.getElementById('loginProject');
    Store.projects().forEach(p => {
      const o = document.createElement('option'); o.value = p.id; o.textContent = p.nama; projSel.appendChild(o);
    });

    let role = 'lapangan';
    document.getElementById('rolePicker').querySelectorAll('.role-opt').forEach(btn => {
      btn.addEventListener('click', () => {
        document.querySelectorAll('.role-opt').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        role = btn.dataset.role;
      });
    });

    document.getElementById('loginBtn').addEventListener('click', () => {
      const name = document.getElementById('loginName').value.trim() || (role === 'owner' ? 'Admin Pusat' : 'Admin Lapangan');
      const projectId = document.getElementById('loginProject').value || null;
      Session.set({ name, role, projectId, loginAt: new Date().toISOString() });
      this.session = Session.get();
      this.boot();
    });
    document.getElementById('loginName').addEventListener('keydown', (e) => { if (e.key === 'Enter') document.getElementById('loginBtn').click(); });
  },

  /* ============== SHELL ============== */
  navItems() {
    const items = [
      { key: 'dashboard', label: 'Dashboard', icon: 'home', hash: '#/dashboard' },
      { key: 'projects', label: 'Daftar Proyek', icon: 'folder', hash: '#/proyek' },
      { key: 'quick-input', label: 'Input Transaksi', icon: 'plus', hash: '#/input' },
    ];
    if (this.session && this.session.role === 'owner') {
      items.push({ key: 'catalog', label: 'Katalog Bahan', icon: 'copy', hash: '#/katalog' });
    }
    return items;
  },

  renderShell() {
    const s = this.session;
    const initials = (s.name || '?').trim().split(/\s+/).map(w => w[0]).slice(0, 2).join('').toUpperCase();
    document.getElementById('app').innerHTML = `
      <div class="app-shell">
        <div class="sidebar-backdrop" id="sbBackdrop"></div>
        <aside class="sidebar" id="sidebar">
          <div class="sidebar-brand"><span class="logo-dot"></span>MatTrack</div>
          <div class="sidebar-scope">Menu</div>
          <nav class="sidebar-nav" id="sidebarNav"></nav>
          <div class="sidebar-user">
            <div class="avatar">${esc(initials)}</div>
            <div class="who">
              <div class="name">${esc(s.name)}</div>
              <div class="role">${s.role === 'owner' ? 'Admin Pusat / Owner' : 'Admin Lapangan'}</div>
            </div>
            <button id="logoutBtn" title="Keluar">${ic('logout')}</button>
          </div>
        </aside>
        <div class="main-col">
          <header class="topbar">
            <button class="menu-btn" id="menuBtn">${ic('menu')}</button>
            <div>
              <h1 id="topbarTitle">Dashboard</h1>
              <div class="crumb" id="topbarCrumb"></div>
            </div>
            <div class="spacer"></div>
            <div class="topbar-actions">
              <span class="badge-role ${s.role === 'owner' ? 'owner' : ''}">${s.role === 'owner' ? 'Admin Pusat / Owner' : 'Admin Lapangan'}</span>
            </div>
          </header>
          <main id="viewRoot"></main>
        </div>
      </div>
      <div class="toast-wrap" id="toastWrap"></div>
      <div id="modalRoot"></div>`;

    document.getElementById('logoutBtn').addEventListener('click', () => this.logout());
    document.getElementById('menuBtn').addEventListener('click', () => {
      document.getElementById('sidebar').classList.toggle('open');
      document.getElementById('sbBackdrop').classList.toggle('show');
    });
    document.getElementById('sbBackdrop').addEventListener('click', () => {
      document.getElementById('sidebar').classList.remove('open');
      document.getElementById('sbBackdrop').classList.remove('show');
    });

    // move toast/modal roots to body level so they aren't affected by innerHTML resets of #app
    document.body.appendChild(document.getElementById('toastWrap'));
    document.body.appendChild(document.getElementById('modalRoot'));

    this.renderNav();
    this.renderView();
  },

  renderNav() {
    const nav = document.getElementById('sidebarNav');
    if (!nav) return;
    const items = this.navItems();
    nav.innerHTML = items.map(it => `
      <div class="nav-item" data-hash="${it.hash}">${ic(it.icon)}<span>${it.label}</span></div>
    `).join('');
    nav.querySelectorAll('.nav-item').forEach(el => {
      el.addEventListener('click', () => {
        this.navigate(el.dataset.hash);
        document.getElementById('sidebar').classList.remove('open');
        document.getElementById('sbBackdrop').classList.remove('show');
      });
    });
  },

  setTopbar(title, crumb) {
    document.getElementById('topbarTitle').textContent = title;
    document.getElementById('topbarCrumb').textContent = crumb || '';
  },

  highlightNav() {
    const items = this.navItems();
    const active = items.find(it => it.key === this.route.name) || (this.route.name.startsWith('project') ? items.find(i => i.key === 'projects') : null);
    document.querySelectorAll('.nav-item').forEach(el => el.classList.toggle('active', active && el.dataset.hash === active.hash));
  },

  renderView() {
    this.highlightNav();
    const root = document.getElementById('viewRoot');
    if (!root) return;
    switch (this.route.name) {
      case 'dashboard': return Views.dashboard(root);
      case 'projects': return Views.projects(root);
      case 'project-detail': return Views.projectDetail(root, this.route.params.id, this.route.params.tab);
      case 'quick-input': return Views.quickInput(root);
      case 'catalog': return Views.catalog(root);
      default: return Views.dashboard(root);
    }
  },
};

window.addEventListener('DOMContentLoaded', () => App.init());

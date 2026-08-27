/* Bridges the app's in-memory DB object (unchanged shape, see seedDB()
   in index.html) to the PHP + MySQL backend. Set API_BASE_URL in
   backend-config.js to point at it; leave it empty to stay in local
   mode (localStorage only), same as the original app. Loaded after
   backend-config.js, before auth.js. */

function isMysqlConfigured(){
  return !!(window.API_BASE_URL && window.API_BASE_URL.length);
}
function isBackendConfigured(){
  return isMysqlConfigured();
}
function activeBackend(){
  return isMysqlConfigured() ? 'mysql' : null;
}

/* ---- PHP/MySQL fetch client ---- */
async function apiFetch(path, opts){
  opts = opts || {};
  opts.credentials = 'include';
  opts.headers = Object.assign({'Content-Type':'application/json'}, opts.headers||{});
  var res = await fetch(window.API_BASE_URL + path, opts);
  var data = {};
  try{ data = await res.json(); }catch(e){}
  if(!res.ok) throw new Error(data.error || ('HTTP '+res.status));
  return data;
}

/* ---- db row (snake_case) <-> app row (camelCase) mapping ---- */
function txnFromDb(r){
  return {id:r.id, jenis:r.jenis, tgl:r.tgl, ref:r.ref, akunKas:r.akun_kas, akunLawan:r.akun_lawan,
    project:r.project||'', relasi:r.relasi||'', customerId:r.customer_id, vendorId:r.vendor_id,
    ket:r.ket||'', debet:Number(r.debet)||0, kredit:Number(r.kredit)||0};
}
function txnToDb(obj){
  var isIn=/masuk$/.test(obj.jenis);
  return {id:obj.id, jenis:obj.jenis, tgl:obj.tgl, ref:obj.ref, akun_kas:obj.akunKas, akun_lawan:obj.akunLawan,
    project:obj.project||'', relasi:obj.relasi||'',
    customer_id: isIn ? (obj.customerId||null) : null,
    vendor_id: !isIn ? (obj.vendorId||null) : null,
    ket:obj.ket||'', debet:obj.debet||0, kredit:obj.kredit||0};
}
function coaFromDb(r){ return {id:r.id, kode:r.kode, nama:r.nama, level:r.level, tipe:r.tipe}; }
function coaToDb(obj){ return {id:obj.id, kode:obj.kode, nama:obj.nama, level:obj.level, tipe:obj.tipe}; }

function relasiFromDb(r){ return {id:r.id, kode:r.kode, nama:r.nama, alamat:r.alamat||'', telp:r.telp||'', email:r.email||''}; }
function relasiToDb(obj){ return {id:obj.id, kode:obj.kode, nama:obj.nama, alamat:obj.alamat||'', telp:obj.telp||'', email:obj.email||''}; }

function projectFromDb(r){
  return {id:r.id, nama:r.nama, ledgerName:r.ledger_name||'', kontrak:Number(r.kontrak)||0, rap:Number(r.rap)||0,
    progress:(r.progress===null||r.progress===undefined)?null:Number(r.progress), pemberiProyek:r.pemberi_proyek||'',
    costCenter:Number(r.cost_center)||0, admFee:Number(r.adm_fee)||0};
}
function projectToDb(obj){
  return {id:obj.id, nama:obj.nama, ledger_name:obj.ledgerName||'', kontrak:obj.kontrak||0, rap:obj.rap||0,
    progress:(obj.progress===null||obj.progress===undefined)?null:obj.progress,
    pemberi_proyek:obj.pemberiProyek||'', cost_center:obj.costCenter||0, adm_fee:obj.admFee||0};
}
function jurnalFromDb(r){
  return {id:r.id, tgl:r.tgl, ref:r.ref, akun:r.akun, project:r.project||'', relasi:r.relasi||'',
    kategori:r.kategori||'', ket:r.ket||'', debet:Number(r.debet)||0, kredit:Number(r.kredit)||0};
}
function jurnalToDb(obj){
  return {id:obj.id, tgl:obj.tgl, ref:obj.ref, akun:obj.akun, project:obj.project||'', relasi:obj.relasi||'',
    kategori:obj.kategori||'', ket:obj.ket||'', debet:obj.debet||0, kredit:obj.kredit||0};
}

var TABLE_MAP = {
  customers: {from:relasiFromDb, to:relasiToDb},
  vendors:   {from:relasiFromDb, to:relasiToDb},
  projects:  {from:projectFromDb, to:projectToDb},
  coa:       {from:coaFromDb, to:coaToDb},
  transactions: {from:txnFromDb, to:txnToDb},
  jurnal_umum:  {from:jurnalFromDb, to:jurnalToDb},
};
var MYSQL_ENDPOINT = {
  customers: '/customers.php', vendors: '/vendors.php', projects: '/projects.php',
  coa: '/coa.php', transactions: '/transactions.php', jurnal_umum: '/jurnal_umum.php',
};

/* Fetch everything into the shape seedDB()/loadDB() already produce,
   so the rest of the app (buildNav/registerPages/all PAGES.*) needs
   zero changes. */
async function fetchAllData(){
  var m = await Promise.all([
    apiFetch('/customers.php'), apiFetch('/vendors.php'), apiFetch('/projects.php'),
    apiFetch('/coa.php'), apiFetch('/transactions.php'), apiFetch('/jurnal_umum.php'),
    apiFetch('/hutang_overrides.php'),
  ]);
  var hutangOverrides={};
  m[6].forEach(function(o){ hutangOverrides[o.nota_id]={paid:Number(o.paid), status:o.status}; });
  return {
    customers: m[0].map(relasiFromDb), vendors: m[1].map(relasiFromDb), projects: m[2].map(projectFromDb),
    coa: m[3].map(coaFromDb), txns: m[4].map(txnFromDb), jurnal: m[5].map(jurnalFromDb),
    hutangOverrides: hutangOverrides,
  };
}

/* Called right alongside the existing saveDB() at every mutation site.
   Table name is one of: customers, vendors, projects, coa, transactions,
   jurnal_umum. */
async function syncUpsert(table, obj){
  if(!isBackendConfigured()) return; // local mode — saveDB() already persisted it
  try{
    var mapper = TABLE_MAP[table];
    var row = mapper.to(obj);
    await apiFetch(MYSQL_ENDPOINT[table], {method:'POST', body:JSON.stringify(row)});
  }catch(e){
    console.error('syncUpsert failed', table, e);
    toast('Gagal menyimpan ke server: '+(e.message||e)+'. Perubahan tersimpan lokal saja.', 'danger');
  }
}
async function syncDelete(table, id){
  if(!isBackendConfigured()) return; // local mode — saveDB() already persisted it
  try{
    await apiFetch(MYSQL_ENDPOINT[table]+'?id='+encodeURIComponent(id), {method:'DELETE'});
  }catch(e){
    console.error('syncDelete failed', table, e);
    toast('Gagal menghapus di server: '+(e.message||e)+'. Perubahan tersimpan lokal saja.', 'danger');
  }
}

/* Trial Hutang manual overrides — separate from TABLE_MAP since it's a
   small side table keyed by nota_id, not one of the main resources. */
async function syncHutangOverride(notaId, paid, status){
  if(!isBackendConfigured()) return; // local mode: stays localStorage-only
  try{
    await apiFetch('/hutang_overrides.php', {method:'POST',
      body:JSON.stringify({nota_id:notaId, paid:paid, status:status})});
  }catch(e){
    console.error('syncHutangOverride failed', e);
    toast('Gagal menyimpan status hutang ke server: '+(e.message||e)+'. Perubahan tersimpan lokal saja.', 'danger');
  }
}
async function syncHutangOverrideDelete(notaId){
  if(!isBackendConfigured()) return;
  try{
    await apiFetch('/hutang_overrides.php?id='+encodeURIComponent(notaId), {method:'DELETE'});
  }catch(e){
    console.error('syncHutangOverrideDelete failed', e);
  }
}

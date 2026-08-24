/* Bridges the app's in-memory DB object (unchanged shape, see seedDB()
   in index.html) to whichever backend is configured. Two backends are
   supported — pick one by filling in its config file:
     - backend-config.js  -> API_BASE_URL set  => PHP + MySQL (primary)
     - supabase-config.js -> SUPABASE_URL set   => Supabase (optional alt.)
   Neither configured => local mode (localStorage only), same as the
   original app. Loaded after supabase-js + supabase-config.js +
   backend-config.js, before auth.js. */

function isMysqlConfigured(){
  return !!(window.API_BASE_URL && window.API_BASE_URL.length);
}
function isSupabaseConfigured(){
  return !!(window.SUPABASE_URL && window.SUPABASE_URL.indexOf('YOUR-PROJECT-REF')===-1);
}
function isBackendConfigured(){
  return isMysqlConfigured() || isSupabaseConfigured();
}
function activeBackend(){
  if(isMysqlConfigured()) return 'mysql';
  if(isSupabaseConfigured()) return 'supabase';
  return null;
}

var supabaseClient = null;
function getSupabase(){
  if(!window.supabase || !window.supabase.createClient){
    throw new Error('Library Supabase gagal dimuat (cek koneksi internet / CDN diblokir), atau supabase-config.js belum diisi.');
  }
  if(!supabaseClient){
    supabaseClient = window.supabase.createClient(window.SUPABASE_URL, window.SUPABASE_ANON_KEY);
  }
  return supabaseClient;
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

/* ---- db row (snake_case) <-> app row (camelCase) mapping ----
   Shared by both backends — the PHP API and the Supabase schema use
   the same column names on purpose. */
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
  if(activeBackend()==='mysql'){
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

  var sb = getSupabase();
  var [customers, vendors, projects, coa, txns, jurnal] = await Promise.all([
    sb.from('customers').select('*').order('kode'),
    sb.from('vendors').select('*').order('kode'),
    sb.from('projects').select('*').order('nama'),
    sb.from('coa').select('*').order('kode'),
    sb.from('transactions').select('*').order('tgl', {ascending:false}),
    sb.from('jurnal_umum').select('*').order('tgl', {ascending:false}),
  ]);
  [customers, vendors, projects, coa, txns, jurnal].forEach(function(r){
    if(r.error) throw r.error;
  });
  return {
    customers: customers.data.map(relasiFromDb),
    vendors: vendors.data.map(relasiFromDb),
    projects: projects.data.map(projectFromDb),
    coa: coa.data.map(coaFromDb),
    txns: txns.data.map(txnFromDb),
    jurnal: jurnal.data.map(jurnalFromDb),
    // Trial Hutang manual overrides aren't backed by a Supabase table yet,
    // so carry over whatever was cached locally rather than losing them.
    hutangOverrides: (loadDB().hutangOverrides || {}),
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
    if(activeBackend()==='mysql'){
      await apiFetch(MYSQL_ENDPOINT[table], {method:'POST', body:JSON.stringify(row)});
      return;
    }
    var sb = getSupabase();
    var session = (await sb.auth.getSession()).data.session;
    if(table==='transactions' && session) row.created_by = session.user.id;
    var res = await sb.from(table).upsert(row);
    if(res.error) throw res.error;
  }catch(e){
    console.error('syncUpsert failed', table, e);
    toast('Gagal menyimpan ke server: '+(e.message||e)+'. Perubahan tersimpan lokal saja.', 'danger');
  }
}
async function syncDelete(table, id){
  if(!isBackendConfigured()) return; // local mode — saveDB() already persisted it
  try{
    if(activeBackend()==='mysql'){
      await apiFetch(MYSQL_ENDPOINT[table]+'?id='+encodeURIComponent(id), {method:'DELETE'});
      return;
    }
    var sb = getSupabase();
    var res = await sb.from(table).delete().eq('id', id);
    if(res.error) throw res.error;
  }catch(e){
    console.error('syncDelete failed', table, e);
    toast('Gagal menghapus di server: '+(e.message||e)+'. Perubahan tersimpan lokal saja.', 'danger');
  }
}

/* Trial Hutang manual overrides — separate from TABLE_MAP since it's a
   small side table keyed by nota_id, not one of the main resources. */
async function syncHutangOverride(notaId, paid, status){
  if(activeBackend()!=='mysql') return; // local mode / Supabase: stays localStorage-only for now
  try{
    await apiFetch('/hutang_overrides.php', {method:'POST',
      body:JSON.stringify({nota_id:notaId, paid:paid, status:status})});
  }catch(e){
    console.error('syncHutangOverride failed', e);
    toast('Gagal menyimpan status hutang ke server: '+(e.message||e)+'. Perubahan tersimpan lokal saja.', 'danger');
  }
}
async function syncHutangOverrideDelete(notaId){
  if(!isBackendConfigured() || activeBackend()!=='mysql') return;
  try{
    await apiFetch('/hutang_overrides.php?id='+encodeURIComponent(notaId), {method:'DELETE'});
  }catch(e){
    console.error('syncHutangOverrideDelete failed', e);
  }
}

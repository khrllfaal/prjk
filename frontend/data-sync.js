/* Bridges the app's in-memory DB object (unchanged shape, see seedDB()
   in index.html) to the Supabase backend. Loaded after supabase-js and
   supabase-config.js, before auth.js. */

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
  return {id:r.id, nama:r.nama, kontrak:Number(r.kontrak)||0, rap:Number(r.rap)||0,
    progress:Number(r.progress)||0, pemberiProyek:r.pemberi_proyek||'',
    costCenter:r.cost_center||'', admFee:Number(r.adm_fee)||0};
}
function projectToDb(obj){
  return {id:obj.id, nama:obj.nama, kontrak:obj.kontrak||0, rap:obj.rap||0, progress:obj.progress||0,
    pemberi_proyek:obj.pemberiProyek||'', cost_center:obj.costCenter||'', adm_fee:obj.admFee||0};
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

/* Fetch everything into the shape seedDB()/loadDB() already produce,
   so the rest of the app (buildNav/registerPages/all PAGES.*) needs
   zero changes. */
async function fetchAllData(){
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
   Table name is one of: customers, vendors, projects, coa, transactions. */
async function syncUpsert(table, obj){
  if(!isBackendConfigured()) return; // local mode — saveDB() already persisted it
  try{
    var mapper = TABLE_MAP[table];
    var row = mapper.to(obj);
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
    var sb = getSupabase();
    var res = await sb.from(table).delete().eq('id', id);
    if(res.error) throw res.error;
  }catch(e){
    console.error('syncDelete failed', table, e);
    toast('Gagal menghapus di server: '+(e.message||e)+'. Perubahan tersimpan lokal saja.', 'danger');
  }
}

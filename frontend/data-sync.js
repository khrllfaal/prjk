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
function coaFromDb(r){ return {id:r.id, kode:r.kode, nama:r.nama, level:r.level, tipe:r.tipe, saldoAwal:Number(r.saldo_awal)||0}; }
function coaToDb(obj){ return {id:obj.id, kode:obj.kode, nama:obj.nama, level:obj.level, tipe:obj.tipe, saldo_awal:obj.saldoAwal||0}; }

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
    kategori:r.kategori||'', noFaktur:r.no_faktur||'', status:r.status||'posted',
    ket:r.ket||'', debet:Number(r.debet)||0, kredit:Number(r.kredit)||0};
}
function jurnalToDb(obj){
  return {id:obj.id, tgl:obj.tgl, ref:obj.ref, akun:obj.akun, project:obj.project||'', relasi:obj.relasi||'',
    kategori:obj.kategori||'', no_faktur:obj.noFaktur||'', status:obj.status||'posted',
    ket:obj.ket||'', debet:obj.debet||0, kredit:obj.kredit||0};
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

/* Cheap poll target — see pollForRemoteChanges() in auth.js. A tiny
   aggregate query per table server-side, nothing like fetchAllData()'s
   full row dump, so calling this every ~30s is fine even on a modest
   host. */
async function fetchSyncStatus(){
  var res = await apiFetch('/sync_status.php');
  return res.signature;
}

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

/* ---- Pending-sync queue ----
   A syncUpsert/syncDelete failure (server down, InfinityFree hiccup,
   offline) used to just toast and stop — the edit stayed correct in
   this tab's live DB and in localStorage, but nothing retried it, and
   the NEXT login/reload's background fetchAllData() would silently
   overwrite DB with the server's (still-old) copy, quietly discarding
   that edit with no further warning. This queue closes that gap: every
   failed write is recorded here (keyed by table+id, so only the latest
   attempt for a given row survives), auth.js retries the whole queue
   before ever letting a fresh server fetch replace DB, and anything
   that still can't reach the server gets re-applied on top of that
   fresh data instead of being dropped. */
var PENDING_SYNC_KEY = 'prks_pending_sync_v1';
var DB_ARRAY_FOR_TABLE = {customers:'customers', vendors:'vendors', projects:'projects',
  coa:'coa', transactions:'txns', jurnal_umum:'jurnal'};

function loadPendingSync(){
  try{ return JSON.parse(localStorage.getItem(PENDING_SYNC_KEY))||[]; }catch(e){ return []; }
}
function savePendingSync(list){
  try{ localStorage.setItem(PENDING_SYNC_KEY, JSON.stringify(list)); }catch(e){}
}
function queuePendingSync(entry){
  var list = loadPendingSync().filter(function(p){
    return !(p.table===entry.table && p.id===entry.id); // keep only the latest op per row
  });
  list.push(entry);
  savePendingSync(list);
}
function pendingSyncCount(){ return loadPendingSync().length; }

/* Retries every queued write against the server, in order. Entries that
   succeed are dropped from the queue; entries that still fail stay in
   it (nothing is ever silently lost — worst case it just keeps retrying
   on the next boot). Returns the list of entries still pending after
   the attempt, so the caller can re-apply them locally. */
async function flushPendingSync(){
  var list = loadPendingSync();
  if(!list.length) return [];
  var stillPending=[];
  for(var i=0;i<list.length;i++){
    var p=list[i];
    try{
      if(p.action==='upsert'){
        var row = TABLE_MAP[p.table].to(p.obj);
        await apiFetch(MYSQL_ENDPOINT[p.table], {method:'POST', body:JSON.stringify(row)});
      }else if(p.action==='delete'){
        await apiFetch(MYSQL_ENDPOINT[p.table]+'?id='+encodeURIComponent(p.id), {method:'DELETE'});
      }else if(p.action==='hutangOverride'){
        await apiFetch('/hutang_overrides.php', {method:'POST',
          body:JSON.stringify({nota_id:p.id, paid:p.obj.paid, status:p.obj.status})});
      }else if(p.action==='hutangOverrideDelete'){
        await apiFetch('/hutang_overrides.php?id='+encodeURIComponent(p.id), {method:'DELETE'});
      }
    }catch(e){
      stillPending.push(p);
    }
  }
  savePendingSync(stillPending);
  return stillPending;
}

/* Re-applies whatever is still stuck in the queue on top of a freshly
   fetched DB, so a write the server still won't accept (rather than
   just "not yet retried") stays visible locally instead of vanishing
   the moment fresh server data replaces DB. */
function reapplyPendingToDb(db){
  loadPendingSync().forEach(function(p){
    if(p.action==='hutangOverride'){ db.hutangOverrides[p.id]={paid:p.obj.paid, status:p.obj.status}; return; }
    if(p.action==='hutangOverrideDelete'){ delete db.hutangOverrides[p.id]; return; }
    var arrName = DB_ARRAY_FOR_TABLE[p.table];
    if(!arrName || !db[arrName]) return;
    var arr = db[arrName];
    if(p.action==='upsert'){
      var idx = arr.findIndex(function(x){ return x.id===p.obj.id; });
      if(idx>=0) arr[idx]=p.obj; else arr.push(p.obj);
    }else if(p.action==='delete'){
      var idx2 = arr.findIndex(function(x){ return x.id===p.id; });
      if(idx2>=0) arr.splice(idx2,1);
    }
  });
  return db;
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
    queuePendingSync({table:table, id:obj.id, action:'upsert', obj:obj});
    toast('Gagal menyimpan ke server: '+(e.message||e)+'. Perubahan tersimpan lokal, akan dicoba lagi otomatis.', 'danger');
  }
}
async function syncDelete(table, id){
  if(!isBackendConfigured()) return; // local mode — saveDB() already persisted it
  try{
    await apiFetch(MYSQL_ENDPOINT[table]+'?id='+encodeURIComponent(id), {method:'DELETE'});
  }catch(e){
    console.error('syncDelete failed', table, e);
    queuePendingSync({table:table, id:id, action:'delete'});
    toast('Gagal menghapus di server: '+(e.message||e)+'. Perubahan tersimpan lokal, akan dicoba lagi otomatis.', 'danger');
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
    queuePendingSync({table:'hutangOverride', id:notaId, action:'hutangOverride', obj:{paid:paid, status:status}});
    toast('Gagal menyimpan status hutang ke server: '+(e.message||e)+'. Perubahan tersimpan lokal, akan dicoba lagi otomatis.', 'danger');
  }
}
async function syncHutangOverrideDelete(notaId){
  if(!isBackendConfigured()) return;
  try{
    await apiFetch('/hutang_overrides.php?id='+encodeURIComponent(notaId), {method:'DELETE'});
  }catch(e){
    console.error('syncHutangOverrideDelete failed', e);
    queuePendingSync({table:'hutangOverride', id:notaId, action:'hutangOverrideDelete'});
  }
}

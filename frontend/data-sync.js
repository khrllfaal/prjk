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
  if(!res.ok){
    // Status + full body attached to the error (not just its message) so
    // callers like syncUpsert() can tell a real conflict (409, two admins
    // editing the same row) apart from a plain network/server failure —
    // the two need very different handling (see handleSyncConflict()).
    var err = new Error(data.error || ('HTTP '+res.status));
    err.status = res.status;
    err.data = data;
    throw err;
  }
  return data;
}

/* ---- db row (snake_case) <-> app row (camelCase) mapping ---- */
function txnFromDb(r){
  return {id:r.id, jenis:r.jenis, tgl:r.tgl, ref:r.ref, akunKas:r.akun_kas, akunLawan:r.akun_lawan,
    project:r.project||'', relasi:r.relasi||'', customerId:r.customer_id, vendorId:r.vendor_id,
    ket:r.ket||'', debet:Number(r.debet)||0, kredit:Number(r.kredit)||0, updatedAt:r.updated_at||null};
}
function txnToDb(obj){
  var isIn=/masuk$/.test(obj.jenis);
  return {id:obj.id, jenis:obj.jenis, tgl:obj.tgl, ref:obj.ref, akun_kas:obj.akunKas, akun_lawan:obj.akunLawan,
    project:obj.project||'', relasi:obj.relasi||'',
    customer_id: isIn ? (obj.customerId||null) : null,
    vendor_id: !isIn ? (obj.vendorId||null) : null,
    ket:obj.ket||'', debet:obj.debet||0, kredit:obj.kredit||0,
    _expected_updated_at: obj.updatedAt||null};
}
function coaFromDb(r){ return {id:r.id, kode:r.kode, nama:r.nama, level:r.level, tipe:r.tipe, saldoAwal:Number(r.saldo_awal)||0, updatedAt:r.updated_at||null}; }
function coaToDb(obj){ return {id:obj.id, kode:obj.kode, nama:obj.nama, level:obj.level, tipe:obj.tipe, saldo_awal:obj.saldoAwal||0, _expected_updated_at:obj.updatedAt||null}; }

function relasiFromDb(r){ return {id:r.id, kode:r.kode, nama:r.nama, alamat:r.alamat||'', telp:r.telp||'', email:r.email||'', updatedAt:r.updated_at||null}; }
function relasiToDb(obj){ return {id:obj.id, kode:obj.kode, nama:obj.nama, alamat:obj.alamat||'', telp:obj.telp||'', email:obj.email||'', _expected_updated_at:obj.updatedAt||null}; }

function projectFromDb(r){
  return {id:r.id, nama:r.nama, ledgerName:r.ledger_name||'', kontrak:Number(r.kontrak)||0, rap:Number(r.rap)||0,
    progress:(r.progress===null||r.progress===undefined)?null:Number(r.progress), pemberiProyek:r.pemberi_proyek||'',
    costCenter:Number(r.cost_center)||0, admFee:Number(r.adm_fee)||0, updatedAt:r.updated_at||null};
}
function projectToDb(obj){
  return {id:obj.id, nama:obj.nama, ledger_name:obj.ledgerName||'', kontrak:obj.kontrak||0, rap:obj.rap||0,
    progress:(obj.progress===null||obj.progress===undefined)?null:obj.progress,
    pemberi_proyek:obj.pemberiProyek||'', cost_center:obj.costCenter||0, adm_fee:obj.admFee||0,
    _expected_updated_at:obj.updatedAt||null};
}
function jurnalFromDb(r){
  return {id:r.id, tgl:r.tgl, ref:r.ref, akun:r.akun, project:r.project||'', relasi:r.relasi||'',
    kategori:r.kategori||'', noFaktur:r.no_faktur||'', status:r.status||'posted',
    ket:r.ket||'', debet:Number(r.debet)||0, kredit:Number(r.kredit)||0, updatedAt:r.updated_at||null};
}
function jurnalToDb(obj){
  return {id:obj.id, tgl:obj.tgl, ref:obj.ref, akun:obj.akun, project:obj.project||'', relasi:obj.relasi||'',
    kategori:obj.kategori||'', no_faktur:obj.noFaktur||'', status:obj.status||'posted',
    ket:obj.ket||'', debet:obj.debet||0, kredit:obj.kredit||0,
    _expected_updated_at:obj.updatedAt||null};
}

var TABLE_MAP = {
  customers: {from:relasiFromDb, to:relasiToDb},
  vendors:   {from:relasiFromDb, to:relasiToDb},
  projects:  {from:projectFromDb, to:projectToDb},
  coa:       {from:coaFromDb, to:coaToDb},
  transactions: {from:txnFromDb, to:txnToDb},
  jurnal_umum:  {from:jurnalFromDb, to:jurnalToDb},
};
// table name -> key of the matching array on DB (transactions/jurnal_umum
// are the two whose DB key doesn't match their table name) — used by
// handleSyncConflict() to drop a row that turned out to be deleted by
// someone else, since removing it from the wrong array would silently
// leave the real one stale.
var DB_ARRAY_KEY = {
  customers: 'customers', vendors: 'vendors', projects: 'projects',
  coa: 'coa', transactions: 'txns', jurnal_umum: 'jurnal',
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

/* After THIS browser's own successful write, re-baseline the 30s poll's
   signature (see startRemotePolling() in auth.js) to the post-write
   server state. Without this, the very next poll tick sees the save
   this same tab just made as "someone else changed something" and
   force-reloads the whole page (go(CURRENT)) moments after every save
   — not just the odd Ref No collision, but literally every successful
   Tambah/Edit/Hapus across the app. The data is already correct on
   screen (this call pushed it there), so there's nothing to pull.
   Fire-and-forget: a concurrent edit from another device landing in
   this same window just surfaces on the next real external change
   instead of this one, which is a fair trade against reloading the
   page out from under the user after their own save. */
function markOwnSyncChange(){
  if(!isBackendConfigured()) return;
  fetchSyncStatus().then(function(sig){
    if(typeof _lastSyncSignature!=='undefined') _lastSyncSignature=sig;
  }).catch(function(){}); // next poll tick just re-checks normally
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
    var result = await apiFetch(MYSQL_ENDPOINT[table], {method:'POST', body:JSON.stringify(row)});
    // The server can renumber `ref` on save (two users adding a Kas/Bank
    // transaction within the same ~30s sync window computing the same
    // "next" Ref No from their own stale copy — see reserve_unique_ref()
    // in helpers.php). obj is the SAME object already sitting in
    // DB.txns/DB.jurnal (pushed by reference before this call), so
    // updating it here fixes what's on screen too, not just what's in
    // the DB — otherwise the user would keep seeing the ref they typed
    // in, which the server silently didn't actually use.
    if(table==='transactions' && result && result.ref && result.ref!==obj.ref){
      var oldRef=obj.ref;
      obj.ref=result.ref;
      saveDB();
      toast('Ref No disesuaikan otomatis ke '+result.ref+' (bentrok dengan input dari user lain di waktu yang sama; sebelumnya '+oldRef+').', 'danger');
      // The form that created this row is already closed by the time this
      // resolves (syncUpsert is fired without await), so it's always safe
      // to re-render in place — see softRerender() in auth.js.
      if(typeof softRerender==='function') softRerender();
    }
    // Re-baseline this row's own "last known updated_at" to what the
    // server just wrote, so the row's NEXT edit (by anyone) is checked
    // against this save, not a stale value from before it.
    if(result && result.updated_at) obj.updatedAt = result.updated_at;
    markOwnSyncChange();
  }catch(e){
    if(e.status===409){
      handleSyncConflict(table, obj, e.data);
      return;
    }
    console.error('syncUpsert failed', table, e);
    queuePendingSync({table:table, id:obj.id, action:'upsert', obj:obj});
    toast('Gagal menyimpan ke server: '+(e.message||e)+'. Perubahan tersimpan lokal, akan dicoba lagi otomatis.', 'danger');
  }
}

/* Two admins editing the SAME existing row within the same window: the
   second save to reach the server is rejected (409, see the
   _expected_updated_at check in resource_crud.php) instead of silently
   overwriting the first admin's edit — the usual INSERT..ON DUPLICATE
   KEY UPDATE has no idea two people touched the same row, so without
   this check whichever save lands last would just clobber the other
   one with no trace beyond audit_log.
   Recovery: pull this row back to what the OTHER admin's save actually
   left in the database (never a silent merge/guess), update it in place
   — obj is the exact object already rendered on screen, same as the
   ref-reassignment case above — and tell the user plainly that THEIR
   edit was NOT saved, so they know to redo it against the fresh value
   rather than assume it went through. */
function handleSyncConflict(table, obj, errData){
  var mapper = TABLE_MAP[table];
  var msg;
  if(errData && errData.current){
    // The 409 body already carries the row exactly as the OTHER admin's
    // save left it (see resource_crud.php) — use that directly rather
    // than a second round-trip, which would leave a (tiny but real)
    // window for yet another save to land in between.
    var mapped = mapper.from(errData.current);
    Object.keys(mapped).forEach(function(k){ obj[k]=mapped[k]; });
    saveDB();
    msg = 'PERUBAHAN TIDAK TERSIMPAN: data ini sudah diubah oleh pengguna lain sejak Anda membukanya. Tampilan sudah diperbarui ke versi terbaru dari server — silakan ulangi perubahan Anda jika masih diperlukan.';
  }else{
    // current===null: the row was deleted by someone else in the
    // meantime — nothing to merge, it just needs to disappear from this
    // tab's own copy too, instead of this save silently resurrecting it.
    var arrKey = DB_ARRAY_KEY[table];
    if(arrKey && DB[arrKey]) DB[arrKey] = DB[arrKey].filter(function(x){ return x.id!==obj.id; });
    saveDB();
    msg = 'PERUBAHAN TIDAK TERSIMPAN: data ini sudah DIHAPUS oleh pengguna lain sejak Anda membukanya.';
  }
  toast(msg, 'danger');
  if(typeof softRerender==='function') softRerender();
}
async function syncDelete(table, id){
  if(!isBackendConfigured()) return; // local mode — saveDB() already persisted it
  try{
    await apiFetch(MYSQL_ENDPOINT[table]+'?id='+encodeURIComponent(id), {method:'DELETE'});
    markOwnSyncChange();
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
    markOwnSyncChange();
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
    markOwnSyncChange();
  }catch(e){
    console.error('syncHutangOverrideDelete failed', e);
    queuePendingSync({table:'hutangOverride', id:notaId, action:'hutangOverrideDelete'});
  }
}

/* Login gate. Runs after the main app script has defined DB/PAGES/go/
   buildNav/toast etc., but BEFORE any of them are used with real data —
   see the DOMContentLoaded handler in index.html which calls
   initAuthGate() instead of loading data directly. Backend is PHP +
   MySQL sessions (see data-sync.js's activeBackend()); not configured
   => local mode, same as the original ACCV2. */

var CURRENT_PROFILE = null;

function bootLocalMode(){
  DB = loadDB();
  document.getElementById('tbUserName').textContent = 'Mode Lokal (belum terhubung server)';
  document.getElementById('tbAvatar').textContent = 'LC';
  document.getElementById('btnLogout').style.display = 'none';
  hideLogin();
  var start=(location.hash||'').replace('#/','');
  go(PAGES[start]?start:'dashboard');
}

function showLogin(msg){
  hideBootLoading(); // logging in again after a logout must show the form, not a stale spinner
  document.getElementById('loginScreen').style.display='flex';
  document.getElementById('appRoot').classList.add('pre-auth');
  var err=document.getElementById('loginErr');
  if(msg){ err.textContent=msg; err.classList.add('on'); } else { err.classList.remove('on'); err.textContent=''; }
}
function hideLogin(){
  document.getElementById('loginScreen').style.display='none';
  document.getElementById('appRoot').classList.remove('pre-auth');
}
/* Swaps the login card's form for a spinner while fetchAllData() runs —
   covers both a fresh login AND restoring an existing session on page
   load, since both funnel through bootAfterLogin(). Without this, a slow
   connection made the app look frozen on an empty-looking login card
   while the full dataset downloaded in the background. */
function showBootLoading(msg){
  document.getElementById('loginForm').style.display='none';
  document.getElementById('loginLoadingText').textContent=msg||'Memuat data…';
  document.getElementById('loginLoading').style.display='flex';
}
function hideBootLoading(){
  document.getElementById('loginLoading').style.display='none';
  document.getElementById('loginForm').style.display='';
}

function enterApp(){
  hideLogin();
  var start=(location.hash||'').replace('#/','');
  go(PAGES[start]?start:'dashboard');
  startRemotePolling();
}

/* Pulls the latest data from the server and folds it into the live DB —
   shared by the cache-first boot's background refresh and by the
   periodic multi-user poll below. Always retries any locally-queued
   write first (see flushPendingSync() in data-sync.js) so a fresh
   server copy never silently erases an edit that just hadn't reached
   the server yet; whatever still can't be pushed gets re-applied on
   top of the fresh data instead of disappearing.
   opts.rerender (default true): re-render the current page afterwards,
   skipped while a Tambah/Edit modal is open so a live poll never yanks
   a form out from under someone mid-edit. */
async function refreshDbFromServer(opts){
  opts = opts || {};
  var fresh = await fetchAllData();
  var stillPending = await flushPendingSync();
  if(stillPending.length) fresh = reapplyPendingToDb(fresh);
  DB = fresh; saveDB();
  if(opts.rerender !== false){
    var modalOpen=document.getElementById('modalBack').classList.contains('on');
    if(!modalOpen) go(CURRENT);
  }
  if(stillPending.length){
    toast(stillPending.length+' perubahan masih belum tersinkron ke server — akan dicoba lagi otomatis.', 'danger');
  }
  return stillPending;
}

/* profile: {id, email, nama, role} — same shape regardless of backend. */
async function bootAfterLogin(profile){
  CURRENT_PROFILE = profile;
  document.getElementById('tbUserName').textContent = profile.nama+' ('+(profile.role==='admin'?'Admin':'Owner')+')';
  document.getElementById('tbAvatar').textContent = (profile.nama||'?').slice(0,2).toUpperCase();
  document.getElementById('btnLogout').style.display = '';

  // Cache-first boot: if this browser already has a real previous sync,
  // show it immediately instead of blocking on the network — the app
  // feels instant even on a slow connection. refreshDbFromServer() still
  // runs right after, silently replacing DB once it resolves and
  // re-rendering whatever page is open, so every report picks up the
  // fresh data right away instead of quietly showing stale numbers
  // until the user happens to navigate away and back.
  var cached=tryLoadCachedDB();
  if(cached){
    DB=cached;
    enterApp();
    refreshDbFromServer().catch(function(e){
      console.error('background refresh failed, keeping cached data', e);
      toast('Tidak bisa memperbarui data dari server — menampilkan data terakhir yang tersimpan.', 'danger');
    });
    return;
  }

  showBootLoading('Memuat data…');
  try{
    var fresh = await fetchAllData();
    var stillPending = await flushPendingSync();
    DB = stillPending.length ? reapplyPendingToDb(fresh) : fresh;
    saveDB(); // keep a local cache so a flaky connection later still shows last-known data
    if(stillPending.length){
      toast(stillPending.length+' perubahan masih belum tersinkron ke server — akan dicoba lagi otomatis.', 'danger');
    }
  }catch(e){
    console.error('fetchAllData failed, falling back to local cache', e);
    DB = loadDB();
    toast('Tidak bisa terhubung ke server, menampilkan data cache terakhir.', 'danger');
  }

  enterApp();
}

/* ---------------- Multi-user live-ish refresh ----------------
   A cheap poll (see fetchSyncStatus() in data-sync.js — one small
   aggregate query per table, nothing like the full fetchAllData() dump)
   every 30s while the tab is visible. A changed signature means
   somebody (this browser or another device/tab) saved something since
   the last check, so the whole report the user is looking at could now
   be stale — pull fresh data and silently re-render. Paused while the
   tab is in the background (no point spending requests on a report
   nobody's looking at) and while a Tambah/Edit modal is open (never
   pull a form out from under someone mid-edit); both resume checking
   again once that condition clears, on the next tick. */
var REMOTE_POLL_INTERVAL_MS = 30000;
var _remotePollTimer = null;
var _lastSyncSignature = null;

function stopRemotePolling(){
  if(_remotePollTimer){ clearInterval(_remotePollTimer); _remotePollTimer=null; }
  _lastSyncSignature = null;
}
function startRemotePolling(){
  if(!isBackendConfigured() || _remotePollTimer) return;
  _remotePollTimer = setInterval(async function(){
    if(document.hidden) return; // tab in background — check again next tick
    var modalOpen=document.getElementById('modalBack').classList.contains('on');
    if(modalOpen) return; // don't yank a form mid-edit — check again next tick
    try{
      var sig = await fetchSyncStatus();
      if(_lastSyncSignature===null){ _lastSyncSignature=sig; return; } // first check this session: just baseline it
      if(sig===_lastSyncSignature) return; // nothing changed since last check
      _lastSyncSignature = sig;
      await refreshDbFromServer();
    }catch(e){
      console.error('remote poll failed (will retry next tick)', e);
    }
  }, REMOTE_POLL_INTERVAL_MS);
}

function initAuthGate(){
  if(!isBackendConfigured()){
    bootLocalMode();
    return;
  }
  return initAuthGateMysql();
}

/* ---------------- PHP + MySQL session login ---------------- */
function initAuthGateMysql(){
  document.getElementById('loginForm').addEventListener('submit', async function(e){
    e.preventDefault();
    var email=document.getElementById('loginEmail').value.trim();
    var password=document.getElementById('loginPassword').value;
    var btn=document.getElementById('loginSubmit');
    btn.disabled=true; btn.textContent='Memproses…';
    showLogin(null);
    try{
      var res = await apiFetch('/auth_login.php', {method:'POST', body:JSON.stringify({email:email, password:password})});
      await bootAfterLogin(res.user);
    }catch(err){
      showLogin(err.message||'Login gagal.');
    }finally{
      btn.disabled=false; btn.textContent='Masuk';
    }
  });

  document.getElementById('btnLogout').onclick=async function(){
    stopRemotePolling();
    try{ await apiFetch('/auth_logout.php', {method:'POST'}); }catch(e){}
    CURRENT_PROFILE=null;
    location.hash='';
    showLogin(null);
  };

  apiFetch('/auth_me.php').then(function(res){
    if(res.user) bootAfterLogin(res.user);
    else showLogin(null);
  }).catch(function(err){
    showLogin('Tidak bisa terhubung ke server: '+(err.message||err));
  });
}

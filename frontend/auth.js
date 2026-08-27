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
  document.getElementById('loginScreen').style.display='flex';
  document.getElementById('appRoot').classList.add('pre-auth');
  var err=document.getElementById('loginErr');
  if(msg){ err.textContent=msg; err.classList.add('on'); } else { err.classList.remove('on'); err.textContent=''; }
}
function hideLogin(){
  document.getElementById('loginScreen').style.display='none';
  document.getElementById('appRoot').classList.remove('pre-auth');
}

/* profile: {id, email, nama, role} — same shape regardless of backend. */
async function bootAfterLogin(profile){
  CURRENT_PROFILE = profile;
  document.getElementById('tbUserName').textContent = profile.nama+' ('+(profile.role==='admin'?'Admin':'Owner')+')';
  document.getElementById('tbAvatar').textContent = (profile.nama||'?').slice(0,2).toUpperCase();
  document.getElementById('btnLogout').style.display = '';

  try{
    DB = await fetchAllData();
    saveDB(); // keep a local cache so a flaky connection later still shows last-known data
  }catch(e){
    console.error('fetchAllData failed, falling back to local cache', e);
    DB = loadDB();
    toast('Tidak bisa terhubung ke server, menampilkan data cache terakhir.', 'danger');
  }

  hideLogin();
  var start=(location.hash||'').replace('#/','');
  go(PAGES[start]?start:'dashboard');
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

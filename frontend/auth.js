/* Login gate. Runs after the main app script has defined DB/PAGES/go/
   buildNav/toast etc., but BEFORE any of them are used with real data —
   see the DOMContentLoaded handler in index.html which calls
   initAuthGate() instead of loading data directly. */

var CURRENT_PROFILE = null;

/* Backend (Supabase/MySQL) is optional for now — until it's configured,
   the app runs the same way the original ACCV2 did: local-only, data in
   this browser's localStorage. Once supabase-config.js has real
   credentials, the login gate below takes over automatically. */
function isBackendConfigured(){
  return !!(window.SUPABASE_URL && window.SUPABASE_URL.indexOf('YOUR-PROJECT-REF')===-1);
}
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

async function loadProfile(userId){
  var sb=getSupabase();
  var res=await sb.from('profiles').select('*').eq('id', userId).maybeSingle();
  if(res.error) throw res.error;
  return res.data;
}

async function bootAfterLogin(session){
  var profile;
  try{
    profile = await loadProfile(session.user.id);
  }catch(e){
    showLogin('Gagal memuat profil pengguna: '+(e.message||e));
    return;
  }
  if(!profile){
    showLogin('Akun ini belum terdaftar sebagai admin/owner. Hubungi administrator sistem.');
    await getSupabase().auth.signOut();
    return;
  }
  CURRENT_PROFILE = profile;
  document.getElementById('tbUserName').textContent = profile.nama+' ('+(profile.role==='admin'?'Admin':'Owner')+')';
  document.getElementById('tbAvatar').textContent = (profile.nama||'?').slice(0,2).toUpperCase();

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
  var sb;
  try{
    sb=getSupabase();
  }catch(e){
    showLogin(e.message);
    document.getElementById('loginSubmit').disabled=true;
    return;
  }

  document.getElementById('loginForm').addEventListener('submit', async function(e){
    e.preventDefault();
    var email=document.getElementById('loginEmail').value.trim();
    var password=document.getElementById('loginPassword').value;
    var btn=document.getElementById('loginSubmit');
    btn.disabled=true; btn.textContent='Memproses…';
    showLogin(null);
    try{
      var res = await sb.auth.signInWithPassword({email:email, password:password});
      if(res.error) throw res.error;
      await bootAfterLogin(res.data.session);
    }catch(err){
      showLogin(err.message==='Invalid login credentials' ? 'Email atau password salah.' : (err.message||'Login gagal.'));
    }finally{
      btn.disabled=false; btn.textContent='Masuk';
    }
  });

  document.getElementById('btnLogout').onclick=async function(){
    await sb.auth.signOut();
    CURRENT_PROFILE=null;
    location.hash='';
    showLogin(null);
  };

  sb.auth.getSession().then(function(res){
    var session=res.data.session;
    if(session) bootAfterLogin(session);
    else showLogin(null);
  });

  /* Multi-device support: Supabase issues an independent JWT per browser/
     device on each sign-in, and does not revoke other sessions — so the
     same admin/owner account can be logged in on a phone, laptop and
     tablet at once, each with its own session refreshed automatically
     by supabase-js. If the session on THIS device is revoked/expired,
     drop back to the login screen instead of leaving stale data on screen. */
  sb.auth.onAuthStateChange(function(event){
    if(event==='SIGNED_OUT') showLogin(null);
  });
}

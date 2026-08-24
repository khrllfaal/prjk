/* Login gate. Runs after the main app script has defined DB/PAGES/go/
   buildNav/toast etc., but BEFORE any of them are used with real data —
   see the DOMContentLoaded handler in index.html which calls
   initAuthGate() instead of loading data directly. Supports two
   backends (see data-sync.js's activeBackend()): PHP+MySQL sessions
   (primary) or Supabase Auth (optional alternative). Neither
   configured => local mode, same as the original ACCV2. */

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
  if(activeBackend()==='mysql') return initAuthGateMysql();
  return initAuthGateSupabase();
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

/* ---------------- Supabase Auth login (alternative backend) ---------------- */
function initAuthGateSupabase(){
  var sb;
  try{
    sb=getSupabase();
  }catch(e){
    showLogin(e.message);
    document.getElementById('loginSubmit').disabled=true;
    return;
  }

  async function loadProfile(userId){
    var res=await sb.from('profiles').select('*').eq('id', userId).maybeSingle();
    if(res.error) throw res.error;
    return res.data;
  }
  async function bootAfterSupabaseLogin(session){
    var profile;
    try{
      profile = await loadProfile(session.user.id);
    }catch(e){
      showLogin('Gagal memuat profil pengguna: '+(e.message||e));
      return;
    }
    if(!profile){
      showLogin('Akun ini belum terdaftar sebagai admin/owner. Hubungi administrator sistem.');
      await sb.auth.signOut();
      return;
    }
    await bootAfterLogin(profile);
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
      await bootAfterSupabaseLogin(res.data.session);
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
    if(session) bootAfterSupabaseLogin(session);
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

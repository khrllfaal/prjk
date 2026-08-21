/* Supabase project connection info.
   The anon key is safe to publish — it only grants what Row Level
   Security policies in backend/supabase/migrations/0001_init.sql allow
   (i.e. nothing, unless the caller is a logged-in user with a `profiles`
   row). Fill these in after creating your Supabase project — see
   docs/SETUP.md — then this file can be committed as-is. */
window.SUPABASE_URL = 'https://YOUR-PROJECT-REF.supabase.co';
window.SUPABASE_ANON_KEY = 'YOUR-ANON-PUBLIC-KEY';

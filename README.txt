PEAKSTATE - GITHUB PAGES + SUPABASE CLOUD SYNC

FILES
- index.html: website (upload to the root of your GitHub Pages repository)
- .nojekyll: disables GitHub Pages Jekyll processing
- supabase-schema.sql: create the secure cloud table and policies

ONE-TIME SETUP
1. Create a project at https://supabase.com/ and wait until it is ready.
2. In Supabase, open SQL Editor -> New query.
3. Open supabase-schema.sql, copy all its contents into the SQL Editor, and Run.
4. In Supabase, open Project Settings -> API. Copy the Project URL and the public anon/publishable key. NEVER use a service_role or secret key in a browser.
5. In Supabase -> Authentication -> URL Configuration, set Site URL to your GitHub Pages URL, for example:
   https://YOUR-GITHUB-USERNAME.github.io/peakstate/
   Add that same URL (and, if shown, https://YOUR-GITHUB-USERNAME.github.io/**) to the allowed Redirect URLs.
6. In Supabase -> Authentication -> Providers -> Email, leave Email enabled.
7. Open your GitHub Pages website. Tap Cloud account. Paste the Project URL and public anon/publishable key, then tap Save connection settings.
8. Enter your email and password. Tap Create account once. If email confirmation is enabled, open the confirmation email, then return to the website and Sign in.
9. Use the same email/password on your other devices. Your routines, activity times, checkmarks, reading, sleep settings, priorities and history sync through the cloud.
10. After your one account is created, you may disable new user sign-ups in Supabase Auth settings if you want the app to remain single-user. Do not disable existing-user sign-in.

GITHUB PAGES DEPLOYMENT
- Extract the ZIP.
- Upload index.html and .nojekyll to the ROOT of your existing repository (not inside another folder).
- You may also keep supabase-schema.sql and README.txt in the repository; they are not required by the website.
- Commit the changes and wait for GitHub Pages to publish.

IMPORTANT
- Supabase URL and public anon/publishable key are intended for browser use. Row Level Security in the SQL file ensures each signed-in user can access only their own record.
- Never put a Supabase service_role/secret key in index.html or share it.
- Data is saved locally first, then synced to Supabase when signed in and online. Real-time updates are sent to other signed-in devices. If offline, the local copy remains available and cloud sync resumes after reconnecting and making a change.
- The live clock refreshes every second. The date rollover checks every 30 seconds and uses each device's local timezone. Supabase updated_at is generated on the server.
- This package includes the integration, but it cannot connect to a real project until you enter your own Project URL and public key in Cloud account.

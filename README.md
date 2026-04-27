# Kleper.studio

Lead-capture website for Kleper — websites, CRM, automations and AI agents for ambitious operators.

**Stack:** static HTML, hosted on **Vercel**, source on **GitHub**, contact form writes to **Supabase**.

## Folder

| File | Purpose |
|---|---|
| `index.html` | The whole site — single self-contained HTML page |
| `config.js` | Supabase URL + anon key (you fill these in once) |
| `404.html` | Branded "lost in orbit" not-found page |
| `logo.svg` | Wordmark |
| `vercel.json` | Vercel config — clean URLs, security headers, asset caching |
| `supabase-schema.sql` | SQL to set up the `leads` table + RLS policies |
| `robots.txt` / `sitemap.xml` | Search-engine basics |
| `env.example` | Reference of which env vars exist |
| `.gitignore` | Keeps `.env.local`, OS noise and PDFs out of git |

No build step, no node_modules. Open `index.html` in a browser to preview.

## First-time setup (15 minutes total)

### 1 · Supabase — set up the database (5 min)

1. Open your Supabase project (or create a new one at [supabase.com](https://supabase.com)).
2. Go to **SQL Editor → New query**.
3. Paste the contents of `supabase-schema.sql` and click **Run**.
4. Go to **Project Settings → API** and copy:
   - **Project URL** (looks like `https://abcdefgh.supabase.co`)
   - **Project API key** under "Project API keys" → the **anon / public** one
5. Open `config.js` and paste both values.
6. Test it in **Table Editor → leads** — click "Insert row" once to make sure the table exists.

> ⚠️ Use the **anon** key, never the **service_role** key. The anon key is designed to be public; the service_role key bypasses Row Level Security.

### 2 · GitHub — push the code (3 min)

```bash
cd kleper.studio
git init
git add .
git commit -m "Initial commit: Kleper.studio v1"
git branch -M main
git remote add origin git@github.com:YOUR-USERNAME/kleper-studio.git
git push -u origin main
```

### 3 · Vercel — deploy (5 min)

1. [vercel.com/new](https://vercel.com/new) → import the GitHub repo.
2. Framework preset: **Other**. Build command: leave empty. Output dir: `./`.
3. Click **Deploy**. You get a `*.vercel.app` URL in ~30 seconds.
4. **Add custom domain:** Project → Settings → Domains → add `kleper.studio` and `www.kleper.studio`.
5. Vercel will tell you which DNS records to add at your registrar (where you bought the domain).

That's it. Push to `main` from now on and Vercel auto-deploys.

### 4 · Test the form (2 min)

1. Open the deployed site.
2. Fill in the contact form with your own email.
3. Submit → you should see the success state.
4. In Supabase **Table Editor → leads**, the row should be there.

If the form fails: open the browser console. The most common error is `401 Unauthorized` (wrong anon key) or `42501 row-level security` (you skipped step 1, run the schema).

## Email setup (`hello@kleper.studio`)

You already have your DNS set up, so add MX records pointing to whichever email host you prefer. Quick comparison:

| Service | Cost | Best for |
|---|---|---|
| **Cloudflare Email Routing** | Free | Forwarding to your existing inbox — fastest free start |
| **Fastmail** | $5/mo | Privacy-first, full mailbox, great UI |
| **Google Workspace** | £4.60/mo | If your team needs Drive/Calendar/Meet too |

## Getting notified when a lead lands

Three options, in order of effort:

**Option A — Supabase Database Webhook → Slack/Discord (10 min, no code).**
Database → Webhooks → Create. Trigger: insert on `public.leads`. URL: a Slack/Discord incoming webhook. You'll see new leads in your channel within seconds.

**Option B — Supabase Edge Function → Resend/Loops email (30 min, light TypeScript).**
Lets you send a custom HTML email to yourself with the lead details. Skeleton: `supabase/functions/notify-new-lead/index.ts` if you want to add it later.

**Option C — Polling Zapier / n8n (always-on, paid above free tier).**
Read from the `leads` table on a schedule. Simplest if you already have Zapier.

## Editing the site

Everything important lives in `index.html`. Useful anchors:

- Hero headline → search for `<h1>Websites that capture`
- Pricing tiers → search for `<!-- PRICING -->`
- FAQ items → search for `<!-- FAQ -->`
- Form fields → search for `<form class="lead-form"` (and update `supabase-schema.sql` if you add new fields)

CSS lives in the `<style>` block at the top of the file. JS lives at the bottom in two `<script>` blocks (one for the sticky-nav, one for the form submit).

## Things to do before/after launch

- [ ] **Fill in `config.js`** with real Supabase URL + anon key
- [ ] **Run `supabase-schema.sql`** in your Supabase SQL editor
- [ ] **Push to GitHub** and connect to Vercel
- [ ] **Add the custom domain** in Vercel and update DNS
- [ ] **Set up `hello@kleper.studio`** with Cloudflare Email Routing or Workspace
- [ ] **Submit the form yourself** to confirm it lands in Supabase
- [ ] **Add a real `og-image.png`** (1200×630, branded) so link previews look proper
- [ ] **Add Plausible / GA snippet** to the `<head>` for analytics
- [ ] **Set up a Slack/Discord webhook** for new-lead notifications

## License

Private — © 2026 Kleper Studio. All rights reserved.

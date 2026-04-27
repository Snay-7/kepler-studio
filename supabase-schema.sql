-- ============================================================
-- Kepler.studio · Supabase schema
-- Run this in: Supabase Dashboard → SQL Editor → New query
-- ============================================================

-- 1. The `leads` table — captures every contact-form submission.
create table if not exists public.leads (
  id            uuid          primary key default gen_random_uuid(),
  name          text          not null,
  email         text          not null,
  business      text          not null,
  budget        text,
  need          text          not null,
  products      text[]        default '{}',
  source        text          default 'kepler.studio',
  user_agent    text,
  referrer      text,
  submitted_at  timestamptz   default now(),
  created_at    timestamptz   default now(),
  status        text          default 'new'    -- new | contacted | qualified | won | lost
                              check (status in ('new', 'contacted', 'qualified', 'won', 'lost')),
  notes         text
);

-- Helpful indexes for the dashboard later.
create index if not exists leads_created_at_idx on public.leads (created_at desc);
create index if not exists leads_status_idx     on public.leads (status);
create index if not exists leads_email_idx      on public.leads (email);

-- ============================================================
-- 2. Row Level Security
-- ============================================================
-- The anon key is exposed in the client. We must lock down what it can do.
-- Policy: anon role can INSERT only. Read/update/delete require authentication.

alter table public.leads enable row level security;

-- Allow anyone (anon) to insert a lead.
drop policy if exists "Anyone can submit a lead" on public.leads;
create policy "Anyone can submit a lead"
  on public.leads
  for insert
  to anon, authenticated
  with check (true);

-- Only authenticated users (you, signed into Supabase Studio) can read leads.
drop policy if exists "Authenticated users can read leads" on public.leads;
create policy "Authenticated users can read leads"
  on public.leads
  for select
  to authenticated
  using (true);

-- Only authenticated users can update / delete (e.g. moving a lead through stages).
drop policy if exists "Authenticated users can update leads" on public.leads;
create policy "Authenticated users can update leads"
  on public.leads
  for update
  to authenticated
  using (true)
  with check (true);

drop policy if exists "Authenticated users can delete leads" on public.leads;
create policy "Authenticated users can delete leads"
  on public.leads
  for delete
  to authenticated
  using (true);

-- ============================================================
-- 3. (Optional) Email-on-new-lead notification
-- ============================================================
-- Quick way: Supabase → Database → Webhooks → "Send a new lead to Slack/email"
-- Trigger: insert on public.leads
-- Endpoint: a Slack incoming webhook URL or a Resend/Loops email API
--
-- Or use a Database Webhook → Edge Function. Skeleton in: /supabase/functions/notify-new-lead.ts

-- ============================================================
-- 4. Sanity check: insert a fake row, then delete it
-- ============================================================
-- Uncomment to verify the table works:
-- insert into public.leads (name, email, business, budget, need, products)
-- values ('Test Lead', 'test@example.com', 'Test Co', '£500 – £1,500 / mo', 'Just checking the form works.', array['CRM','Automations']);
-- delete from public.leads where email = 'test@example.com';

-- PeakState: one private cloud record per signed-in user.
-- Run this entire script in Supabase Dashboard -> SQL Editor -> New query.

create table if not exists public.peakstate_user_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.peakstate_user_data enable row level security;

-- Each signed-in user can read only their own record.
drop policy if exists "Users can read their own PeakState data" on public.peakstate_user_data;
create policy "Users can read their own PeakState data"
  on public.peakstate_user_data for select to authenticated
  using (auth.uid() = user_id);

-- Each signed-in user can create only their own record.
drop policy if exists "Users can insert their own PeakState data" on public.peakstate_user_data;
create policy "Users can insert their own PeakState data"
  on public.peakstate_user_data for insert to authenticated
  with check (auth.uid() = user_id);

-- Each signed-in user can update only their own record.
drop policy if exists "Users can update their own PeakState data" on public.peakstate_user_data;
create policy "Users can update their own PeakState data"
  on public.peakstate_user_data for update to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Set updated_at on the server for every update.
create or replace function public.peakstate_set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists peakstate_updated_at on public.peakstate_user_data;
create trigger peakstate_updated_at
before update on public.peakstate_user_data
for each row execute function public.peakstate_set_updated_at();

-- Allow the authenticated browser client to use the table (RLS still applies).
grant select, insert, update on public.peakstate_user_data to authenticated;

-- Enable Realtime for this table. If this reports that it is already a member,
-- that is fine. You can also enable it in Database -> Publications -> supabase_realtime.
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'peakstate_user_data'
  ) then
    alter publication supabase_realtime add table public.peakstate_user_data;
  end if;
end;
$$;

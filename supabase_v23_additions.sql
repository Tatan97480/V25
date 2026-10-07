-- BE STRONGER V25
-- Separate coach/client entry points + one-time coaching codes.

create table if not exists public.coach_invite_codes (
  id uuid primary key default gen_random_uuid(),
  coach_id uuid not null references public.profiles(id) on delete cascade,
  code text not null unique,
  used_by uuid references public.profiles(id) on delete set null,
  used_at timestamptz,
  created_at timestamptz not null default now()
);

alter table public.coach_invite_codes enable row level security;

create policy "coach_manage_own_codes"
on public.coach_invite_codes for all
to authenticated
using (coach_id=auth.uid())
with check (coach_id=auth.uid());

create or replace function public.create_coach_code()
returns text
language plpgsql
security definer
set search_path=public
as $$
declare c text;
begin
  c := 'BS-' || upper(substr(md5(random()::text || clock_timestamp()::text),1,10));
  insert into public.coach_invite_codes(coach_id,code) values(auth.uid(),c);
  return c;
end;
$$;

create or replace function public.consume_coach_code(p_code text,p_client_id uuid)
returns boolean
language plpgsql
security definer
set search_path=public
as $$
declare v record;
begin
  select * into v from public.coach_invite_codes
  where code=upper(trim(p_code)) and used_by is null
  for update;
  if not found then return false; end if;

  insert into public.coach_clients(coach_id,client_id)
  values(v.coach_id,p_client_id)
  on conflict do nothing;

  update public.coach_invite_codes
  set used_by=p_client_id,used_at=now()
  where id=v.id;

  update public.profiles set access='coaching' where id=p_client_id;
  return true;
end;
$$;

-- Important: never put coach passwords in frontend code in production.
-- Create the real coach user through Supabase Auth, then assign role='coach' in profiles.

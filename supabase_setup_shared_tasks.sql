-- FP&A Checklist: shared tasks, groups and team members
-- Paste this whole script into Supabase → SQL Editor → New query → Run.
-- Safe to run more than once.

create table if not exists public.task_groups (
  id         integer primary key,
  name       text not null,
  color      text not null default '#888780',
  updated_at timestamptz default now()
);

create table if not exists public.team_members (
  name       text primary key,
  created_at timestamptz default now()
);

create table if not exists public.tasks (
  id           integer primary key,
  group_id     integer,
  owner        text,
  name         text not null,
  days         integer[] not null default '{}',
  week_pattern text,
  sop_url      text,
  updated_at   timestamptz default now()
);

-- Row Level Security with open read/write (same setup as checks and overrides)
alter table public.task_groups  enable row level security;
alter table public.team_members enable row level security;
alter table public.tasks        enable row level security;

drop policy if exists "open access" on public.task_groups;
drop policy if exists "open access" on public.team_members;
drop policy if exists "open access" on public.tasks;

create policy "open access" on public.task_groups  for all to anon, authenticated using (true) with check (true);
create policy "open access" on public.team_members for all to anon, authenticated using (true) with check (true);
create policy "open access" on public.tasks        for all to anon, authenticated using (true) with check (true);

grant select, insert, update, delete on public.task_groups, public.team_members, public.tasks to anon, authenticated;

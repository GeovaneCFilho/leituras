-- Cole no Supabase: SQL Editor > New query > Run
create table books (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null default auth.uid(),
  title text not null, author text, isbn text, pages int, cover_url text,
  tags text[] default '{}', created_at timestamptz default now()
);
create table readings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null default auth.uid(),
  book_id uuid references books on delete cascade not null,
  status text not null check (status in ('quero_ler','lendo','lido','abandonado')),
  priority int, current_page int default 0, started_on date, finished_on date,
  rating numeric(2,1) check (rating between 0 and 5), review text,
  created_at timestamptz default now()
);
create table notes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null default auth.uid(),
  reading_id uuid references readings on delete cascade not null,
  kind text check (kind in ('resumo','fichamento','citacao','reflexao')),
  page int, body_md text not null, created_at timestamptz default now()
);
alter table books enable row level security;
alter table readings enable row level security;
alter table notes enable row level security;
create policy own_books on books for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy own_readings on readings for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy own_notes on notes for all using (user_id = auth.uid()) with check (user_id = auth.uid());

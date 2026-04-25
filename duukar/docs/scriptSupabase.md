
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  nickname text not null,
  age_range text not null check (age_range in ('6-11', '12-17')),
  coins integer not null default 0,
  current_level integer not null default 1,
  streak_days integer not null default 0,
  created_at timestamp with time zone default now()
);

create table public.lesson_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  lesson_key text not null,
  completed boolean not null default false,
  points_earned integer not null default 0,
  completed_at timestamp with time zone,
  created_at timestamp with time zone default now()
);



create table public.analysis_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  input_type text not null check (input_type in ('image', 'text', 'link')),
  source_text text,
  source_link text,
  risk_level text not null check (risk_level in ('low', 'medium', 'high')),
  explanation text not null,
  signals jsonb not null default '[]'::jsonb,
  recommended_actions jsonb not null default '[]'::jsonb,
  created_at timestamp with time zone default now()
);

create table public.reports (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  category text not null,
  platform text not null,
  source_link text,
  notes text,
  status text not null default 'submitted',
  created_at timestamp with time zone default now()
);

alter table public.profiles enable row level security;
alter table public.lesson_progress enable row level security;
alter table public.analysis_history enable row level security;
alter table public.reports enable row level security;

--policies

create policy "Users can view own profile"
on public.profiles
for select
using (auth.uid() = id);
create policy "Users can insert own profile"
on public.profiles
for insert
with check (auth.uid() = id);
create policy "Users can update own profile"
on public.profiles
for update
using (auth.uid() = id);

--Lesson progress

create policy "Users can view own lesson progress"
on public.lesson_progress
for select
using (auth.uid() = user_id);
create policy "Users can insert own lesson progress"
on public.lesson_progress
for insert
with check (auth.uid() = user_id);
create policy "Users can update own lesson progress"
on public.lesson_progress
for update
using (auth.uid() = user_id);

--Analysis history
create policy "Users can view own analysis history"
on public.analysis_history
for select
using (auth.uid() = user_id);
create policy "Users can insert own analysis history"
on public.analysis_history
for insert
with check (auth.uid() = user_id);

--Reports
create policy "Users can view own reports"
on public.reports
for select
using (auth.uid() = user_id);
create policy "Users can insert own reports"
on public.reports
for insert
with check (auth.uid() = user_id);

--Trigger para crear profile automático

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
as $$
begin
  insert into public.profiles (id, nickname, age_range)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'nickname', 'Usuario'),
    coalesce(new.raw_user_meta_data ->> 'age_range', '12-17')
  );
  return new;
end;
$$;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();
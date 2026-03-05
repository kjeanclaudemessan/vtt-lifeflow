-- ═══════════════════════════════════════════════════════════════════════════
-- Device Tokens (FCM Push Notification Tokens)
-- ═══════════════════════════════════════════════════════════════════════════
-- Stores FCM tokens per user per device for push notification delivery.
-- Each user can have multiple devices; each device has one token.

create table if not exists public.device_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  token text not null,
  platform text not null check (platform in ('android', 'ios', 'web')),
  device_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  -- One token per user per platform
  unique (user_id, token)
);

-- Indexes
create index idx_device_tokens_user_id on public.device_tokens(user_id);

-- RLS
alter table public.device_tokens enable row level security;

-- Users can manage their own tokens
create policy "Users can view own tokens"
  on public.device_tokens
  for select
  using (auth.uid() = user_id);

create policy "Users can insert own tokens"
  on public.device_tokens
  for insert
  with check (auth.uid() = user_id);

create policy "Users can update own tokens"
  on public.device_tokens
  for update
  using (auth.uid() = user_id);

create policy "Users can delete own tokens"
  on public.device_tokens
  for delete
  using (auth.uid() = user_id);

-- Trigger for updated_at
create or replace function update_device_tokens_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger set_device_tokens_updated_at
  before update on public.device_tokens
  for each row
  execute function update_device_tokens_updated_at();

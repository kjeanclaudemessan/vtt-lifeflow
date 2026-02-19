# Supabase — Copilot Instructions

> **Supabase layer** of the VTT monorepo template.
> Handles: Auth, Database (PostgreSQL), Storage, Realtime.

---

## Role

Supabase is the **source of truth** for the database schema. Neither Flutter nor FastAPI create tables — all DDL lives here in SQL migrations.

### Responsibilities

| Concern | Owner |
|---------|-------|
| User registration, login, OAuth, token refresh | Supabase Auth |
| Database schema (tables, indexes, RLS, triggers) | Supabase Migrations |
| File storage (avatars, attachments) | Supabase Storage |
| Real-time subscriptions | Supabase Realtime |
| Edge Functions | Supabase Functions (optional) |

---

## Migration Structure

```
supabase/
├── config.toml                 # Local dev config (ports, auth, storage)
└── migrations/                 # Ordered SQL migrations
    ├── 20260122000000_create_profiles.sql        # Core (always present)
    ├── 20260123000001_create_organizations.sql   # Optional
    ├── 20260123000002_create_rbac.sql            # Optional
    ├── 20260123000003_create_invitations.sql     # Optional
    ├── 20260123000004_create_subscriptions.sql   # Optional
    ├── 20260123000005_create_payments.sql        # Optional
    ├── 20260123000006_create_tags.sql            # Optional
    ├── 20260123000007_create_attachments.sql     # Optional
    ├── 20260123000008_create_comments.sql        # Optional
    ├── 20260123000009_create_favorites.sql       # Optional
    ├── 20260123000010_create_activities.sql      # Optional
    ├── 20260124000001_fix_organization_members_rls.sql
    ├── 20260129000001_create_ai_agent.sql        # Optional
    ├── 20260129000002_create_chat_platform.sql   # Optional
    ├── 20260130000001_create_widget_templates.sql # Optional (chat dep)
    └── 20260130000002_create_scheduled_messages.sql # Optional (chat dep)
```

---

## Migration File Format

Every migration follows this structure:

```sql
-- ════════════════════════════════════════════════════════════════════════════
-- Migration: Create [table_name] table
-- Description: [What this migration does]
-- Created: YYYY-MM-DD
-- Dependencies: [Other tables that must exist first]
-- ════════════════════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════════════════════
-- TABLE: table_name
-- [Table description]
-- ════════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.table_name (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Core fields
  name            TEXT NOT NULL,

  -- References
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

  -- Flexible JSONB
  metadata        JSONB DEFAULT '{}',

  -- Timestamps
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW(),
  deleted_at      TIMESTAMPTZ             -- Soft delete
);

-- ════════════════════════════════════════════════════════════════════════════
-- INDEXES
-- ════════════════════════════════════════════════════════════════════════════
CREATE INDEX IF NOT EXISTS idx_table_name_user ON public.table_name(user_id);

-- ════════════════════════════════════════════════════════════════════════════
-- TRIGGERS
-- ════════════════════════════════════════════════════════════════════════════
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON public.table_name
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- ════════════════════════════════════════════════════════════════════════════
-- RLS (Row Level Security)
-- ════════════════════════════════════════════════════════════════════════════
ALTER TABLE public.table_name ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own records"
  ON public.table_name FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own records"
  ON public.table_name FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own records"
  ON public.table_name FOR UPDATE
  USING (auth.uid() = user_id);
```

---

## Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Migration files | `YYYYMMDDHHMMSS_description.sql` | `20260122000000_create_profiles.sql` |
| Table names | `snake_case`, plural | `profiles`, `organization_members` |
| Column names | `snake_case` | `first_name`, `created_at`, `avatar_url` |
| Primary keys | `id UUID DEFAULT gen_random_uuid()` | — |
| Foreign keys | `<entity>_id UUID REFERENCES ...` | `user_id`, `organization_id` |
| Indexes | `idx_<table>_<column>` | `idx_profiles_role` |
| RLS policies | Descriptive English sentence | `"Users can read own profile"` |
| Triggers | `set_<action>` | `set_updated_at` |
| Functions | `handle_<action>` | `handle_updated_at()` |
| Section banners | `-- ═══...═══` separators | — |

---

## Common Patterns

### Soft Delete

```sql
deleted_at TIMESTAMPTZ  -- NULL = active, timestamp = deleted
-- Partial index for active records:
CREATE INDEX idx_table_active ON public.table(id) WHERE deleted_at IS NULL;
```

### Polymorphic Relations

Used by comments, attachments, tags, favorites, activities:

```sql
commentable_type TEXT NOT NULL,   -- 'organization', 'profile', etc.
commentable_id   UUID NOT NULL,
-- Composite index:
CREATE INDEX idx_comments_target ON public.comments(commentable_type, commentable_id);
```

### JSONB Fields

```sql
metadata    JSONB DEFAULT '{}',   -- Business-specific extensible data
preferences JSONB DEFAULT '{}',   -- UI/UX preferences
settings    JSONB DEFAULT '{}',   -- Configuration
-- GIN index for queries:
CREATE INDEX idx_table_metadata ON public.table USING GIN (metadata);
```

### Auto-update `updated_at`

```sql
-- Function (defined in profiles migration, reused everywhere):
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger per table:
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON public.table_name
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();
```

### Auto-create Profile on Signup

```sql
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id) VALUES (NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

---

## RLS Patterns

### User Owns Record

```sql
CREATE POLICY "Users can read own" ON table FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own" ON table FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own" ON table FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own" ON table FOR DELETE USING (auth.uid() = user_id);
```

### Organization Members

```sql
CREATE POLICY "Org members can read" ON table FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM public.organization_members
    WHERE organization_id = table.organization_id
    AND user_id = auth.uid()
    AND status = 'active'
  )
);
```

### Service Role Bypass

RLS is automatically bypassed when using the service role key (used by FastAPI backend).

---

## Key Rules

1. **Timestamps must be ordered** — new migrations get the next available `YYYYMMDDHHMMSS`.
2. **Use `IF NOT EXISTS`** — all `CREATE TABLE`, `CREATE INDEX` statements.
3. **Always enable RLS** — `ALTER TABLE ... ENABLE ROW LEVEL SECURITY`.
4. **profiles.id references auth.users(id)** — profiles are 1:1 with auth users.
5. **Use `gen_random_uuid()`** for primary keys — not `uuid_generate_v4()`.
6. **Use `TIMESTAMPTZ`** — not `TIMESTAMP` (timezone-aware).
7. **Soft delete** via `deleted_at` column — not hard delete.
8. **Section banners** — use `-- ═══` separators for readability.
9. **Dependencies noted in header** — list required tables in migration header comment.
10. **Module names match across layers** — table names align with Flutter/FastAPI module names.

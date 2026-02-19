-- ════════════════════════════════════════════════════════════════════════════
-- Migration: Create domains table
-- Description: Life domains for categorizing habits, routines, and tasks
-- Created: 2026-02-20
-- Phase: 1 — Daily Foundations
-- ════════════════════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════════════════════
-- TABLE: domains
-- ════════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.domains (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name        TEXT NOT NULL,
  icon        TEXT NOT NULL DEFAULT '🎯',
  color       TEXT NOT NULL DEFAULT '#6200EE',
  sort_order  INTEGER NOT NULL DEFAULT 0,
  is_archived BOOLEAN NOT NULL DEFAULT FALSE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ════════════════════════════════════════════════════════════════════════════
-- INDEXES
-- ════════════════════════════════════════════════════════════════════════════
CREATE INDEX IF NOT EXISTS idx_domains_user_id ON public.domains(user_id);
CREATE INDEX IF NOT EXISTS idx_domains_user_active ON public.domains(user_id, sort_order) WHERE is_archived = FALSE;

-- ════════════════════════════════════════════════════════════════════════════
-- RLS
-- ════════════════════════════════════════════════════════════════════════════
ALTER TABLE public.domains ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own domains"
  ON public.domains FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own domains"
  ON public.domains FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own domains"
  ON public.domains FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own domains"
  ON public.domains FOR DELETE
  USING (auth.uid() = user_id);

-- ════════════════════════════════════════════════════════════════════════════
-- UPDATED_AT TRIGGER
-- ════════════════════════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION public.handle_domains_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_domains_updated
  BEFORE UPDATE ON public.domains
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_domains_updated_at();

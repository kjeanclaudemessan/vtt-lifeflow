-- ════════════════════════════════════════════════════════════════════════════
-- Migration: Create inbox_items table
-- Description: GTD inbox for capturing raw thoughts before triaging
-- Created: 2026-02-20
-- Phase: 1 — Daily Foundations
-- ════════════════════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════════════════════
-- TABLE: inbox_items
-- ════════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.inbox_items (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  raw_text        TEXT NOT NULL,
  status          TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processed', 'discarded')),
  processed_as    TEXT CHECK (processed_as IN ('task', 'habit', NULL)),
  linked_task_id  UUID REFERENCES public.tasks(id) ON DELETE SET NULL,
  linked_habit_id UUID REFERENCES public.habits(id) ON DELETE SET NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ════════════════════════════════════════════════════════════════════════════
-- INDEXES
-- ════════════════════════════════════════════════════════════════════════════
CREATE INDEX IF NOT EXISTS idx_inbox_items_user_id ON public.inbox_items(user_id);
CREATE INDEX IF NOT EXISTS idx_inbox_items_user_pending ON public.inbox_items(user_id) WHERE status = 'pending';

-- ════════════════════════════════════════════════════════════════════════════
-- RLS
-- ════════════════════════════════════════════════════════════════════════════
ALTER TABLE public.inbox_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own inbox items"
  ON public.inbox_items FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own inbox items"
  ON public.inbox_items FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own inbox items"
  ON public.inbox_items FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own inbox items"
  ON public.inbox_items FOR DELETE
  USING (auth.uid() = user_id);

-- ════════════════════════════════════════════════════════════════════════════
-- UPDATED_AT TRIGGER
-- ════════════════════════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION public.handle_inbox_items_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_inbox_items_updated
  BEFORE UPDATE ON public.inbox_items
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_inbox_items_updated_at();

-- ════════════════════════════════════════════════════════════════════════════
-- Migration: Create tasks table
-- Description: One-time actionable items with priority and due date
-- Created: 2026-02-20
-- Phase: 1 — Daily Foundations
-- ════════════════════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════════════════════
-- TABLE: tasks
-- ════════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.tasks (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  domain_id    UUID REFERENCES public.domains(id) ON DELETE SET NULL,
  title        TEXT NOT NULL,
  description  TEXT,
  priority     TEXT NOT NULL DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high')),
  due_date     DATE,
  completed_at TIMESTAMPTZ,
  is_archived  BOOLEAN NOT NULL DEFAULT FALSE,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ════════════════════════════════════════════════════════════════════════════
-- INDEXES
-- ════════════════════════════════════════════════════════════════════════════
CREATE INDEX IF NOT EXISTS idx_tasks_user_id ON public.tasks(user_id);
CREATE INDEX IF NOT EXISTS idx_tasks_user_active ON public.tasks(user_id) WHERE is_archived = FALSE AND completed_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_tasks_domain_id ON public.tasks(domain_id) WHERE domain_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_tasks_due_date ON public.tasks(due_date) WHERE due_date IS NOT NULL AND completed_at IS NULL;

-- ════════════════════════════════════════════════════════════════════════════
-- RLS
-- ════════════════════════════════════════════════════════════════════════════
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own tasks"
  ON public.tasks FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own tasks"
  ON public.tasks FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own tasks"
  ON public.tasks FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own tasks"
  ON public.tasks FOR DELETE
  USING (auth.uid() = user_id);

-- ════════════════════════════════════════════════════════════════════════════
-- UPDATED_AT TRIGGER
-- ════════════════════════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION public.handle_tasks_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_tasks_updated
  BEFORE UPDATE ON public.tasks
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_tasks_updated_at();

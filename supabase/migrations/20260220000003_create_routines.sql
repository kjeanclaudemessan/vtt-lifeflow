-- ════════════════════════════════════════════════════════════════════════════
-- Migration: Create routines, routine_steps, and routine_logs tables
-- Description: Routines with ordered steps and execution logging
-- Created: 2026-02-20
-- Phase: 1 — Daily Foundations
-- ════════════════════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════════════════════
-- TABLE: routines
-- ════════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.routines (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  domain_id   UUID REFERENCES public.domains(id) ON DELETE SET NULL,
  name        TEXT NOT NULL,
  description TEXT,
  is_archived BOOLEAN NOT NULL DEFAULT FALSE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ════════════════════════════════════════════════════════════════════════════
-- TABLE: routine_steps
-- ════════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.routine_steps (
  id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  routine_id         UUID NOT NULL REFERENCES public.routines(id) ON DELETE CASCADE,
  name               TEXT NOT NULL,
  description        TEXT,
  estimated_duration INTEGER NOT NULL DEFAULT 300,
  sort_order         INTEGER NOT NULL DEFAULT 0,
  created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ════════════════════════════════════════════════════════════════════════════
-- TABLE: routine_logs
-- ════════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.routine_logs (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  routine_id      UUID NOT NULL REFERENCES public.routines(id) ON DELETE CASCADE,
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  started_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at    TIMESTAMPTZ,
  total_duration  INTEGER,
  status          TEXT NOT NULL DEFAULT 'completed' CHECK (status IN ('completed', 'abandoned')),
  steps_completed INTEGER NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ════════════════════════════════════════════════════════════════════════════
-- INDEXES
-- ════════════════════════════════════════════════════════════════════════════
CREATE INDEX IF NOT EXISTS idx_routines_user_id ON public.routines(user_id);
CREATE INDEX IF NOT EXISTS idx_routines_user_active ON public.routines(user_id) WHERE is_archived = FALSE;
CREATE INDEX IF NOT EXISTS idx_routines_domain_id ON public.routines(domain_id) WHERE domain_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_routine_steps_routine_id ON public.routine_steps(routine_id, sort_order);
CREATE INDEX IF NOT EXISTS idx_routine_logs_routine_id ON public.routine_logs(routine_id);
CREATE INDEX IF NOT EXISTS idx_routine_logs_user_id ON public.routine_logs(user_id);

-- ════════════════════════════════════════════════════════════════════════════
-- RLS
-- ════════════════════════════════════════════════════════════════════════════
ALTER TABLE public.routines ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.routine_steps ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.routine_logs ENABLE ROW LEVEL SECURITY;

-- routines policies
CREATE POLICY "Users can view their own routines"
  ON public.routines FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own routines"
  ON public.routines FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own routines"
  ON public.routines FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own routines"
  ON public.routines FOR DELETE
  USING (auth.uid() = user_id);

-- routine_steps policies (via routine ownership)
CREATE POLICY "Users can view steps of their own routines"
  ON public.routine_steps FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM public.routines WHERE routines.id = routine_steps.routine_id AND routines.user_id = auth.uid()
  ));

CREATE POLICY "Users can create steps for their own routines"
  ON public.routine_steps FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1 FROM public.routines WHERE routines.id = routine_steps.routine_id AND routines.user_id = auth.uid()
  ));

CREATE POLICY "Users can update steps of their own routines"
  ON public.routine_steps FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM public.routines WHERE routines.id = routine_steps.routine_id AND routines.user_id = auth.uid()
  ));

CREATE POLICY "Users can delete steps of their own routines"
  ON public.routine_steps FOR DELETE
  USING (EXISTS (
    SELECT 1 FROM public.routines WHERE routines.id = routine_steps.routine_id AND routines.user_id = auth.uid()
  ));

-- routine_logs policies
CREATE POLICY "Users can view their own routine logs"
  ON public.routine_logs FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own routine logs"
  ON public.routine_logs FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own routine logs"
  ON public.routine_logs FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own routine logs"
  ON public.routine_logs FOR DELETE
  USING (auth.uid() = user_id);

-- ════════════════════════════════════════════════════════════════════════════
-- UPDATED_AT TRIGGER
-- ════════════════════════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION public.handle_routines_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_routines_updated
  BEFORE UPDATE ON public.routines
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_routines_updated_at();

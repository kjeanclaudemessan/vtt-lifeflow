-- ════════════════════════════════════════════════════════════════════════════
-- Migration: Create habits and habit_logs tables
-- Description: Habit tracking (binary/quantitative) with daily logs
-- Created: 2026-02-20
-- Phase: 1 — Daily Foundations
-- ════════════════════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════════════════════
-- TABLE: habits
-- ════════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.habits (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  domain_id     UUID REFERENCES public.domains(id) ON DELETE SET NULL,
  name          TEXT NOT NULL,
  description   TEXT,
  type          TEXT NOT NULL DEFAULT 'binary' CHECK (type IN ('binary', 'quantitative')),
  target_value  NUMERIC,
  unit          TEXT,
  estimated_duration_minutes INTEGER NOT NULL DEFAULT 15,
  start_time    TIME,
  end_time      TIME,
  frequency     TEXT NOT NULL DEFAULT 'daily' CHECK (frequency IN ('daily', 'weekly', 'custom')),
  frequency_days INTEGER[] DEFAULT '{}',
  is_archived   BOOLEAN NOT NULL DEFAULT FALSE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ════════════════════════════════════════════════════════════════════════════
-- TABLE: habit_logs
-- ════════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.habit_logs (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  habit_id    UUID NOT NULL REFERENCES public.habits(id) ON DELETE CASCADE,
  log_date    DATE NOT NULL,
  completed   BOOLEAN NOT NULL DEFAULT FALSE,
  value       NUMERIC,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(habit_id, log_date)
);

-- ════════════════════════════════════════════════════════════════════════════
-- INDEXES
-- ════════════════════════════════════════════════════════════════════════════
CREATE INDEX IF NOT EXISTS idx_habits_user_id ON public.habits(user_id);
CREATE INDEX IF NOT EXISTS idx_habits_user_active ON public.habits(user_id) WHERE is_archived = FALSE;
CREATE INDEX IF NOT EXISTS idx_habits_domain_id ON public.habits(domain_id) WHERE domain_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_habit_logs_habit_id ON public.habit_logs(habit_id);
CREATE INDEX IF NOT EXISTS idx_habit_logs_date ON public.habit_logs(log_date);
CREATE INDEX IF NOT EXISTS idx_habit_logs_habit_date ON public.habit_logs(habit_id, log_date);

-- ════════════════════════════════════════════════════════════════════════════
-- RLS
-- ════════════════════════════════════════════════════════════════════════════
ALTER TABLE public.habits ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.habit_logs ENABLE ROW LEVEL SECURITY;

-- habits policies
CREATE POLICY "Users can view their own habits"
  ON public.habits FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own habits"
  ON public.habits FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own habits"
  ON public.habits FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own habits"
  ON public.habits FOR DELETE
  USING (auth.uid() = user_id);

-- habit_logs policies (via habit ownership)
CREATE POLICY "Users can view their own habit logs"
  ON public.habit_logs FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM public.habits WHERE habits.id = habit_logs.habit_id AND habits.user_id = auth.uid()
  ));

CREATE POLICY "Users can create logs for their own habits"
  ON public.habit_logs FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1 FROM public.habits WHERE habits.id = habit_logs.habit_id AND habits.user_id = auth.uid()
  ));

CREATE POLICY "Users can update their own habit logs"
  ON public.habit_logs FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM public.habits WHERE habits.id = habit_logs.habit_id AND habits.user_id = auth.uid()
  ));

CREATE POLICY "Users can delete their own habit logs"
  ON public.habit_logs FOR DELETE
  USING (EXISTS (
    SELECT 1 FROM public.habits WHERE habits.id = habit_logs.habit_id AND habits.user_id = auth.uid()
  ));

-- ════════════════════════════════════════════════════════════════════════════
-- UPDATED_AT TRIGGER
-- ════════════════════════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION public.handle_habits_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_habits_updated
  BEFORE UPDATE ON public.habits
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_habits_updated_at();

-- ════════════════════════════════════════════════════════════════════════════
-- Migration: Enhance habits and habit_logs for advanced tracking
-- Description: 
--   1. habits: add notifications_enabled, reminder_offset_minutes
--   2. habit_logs: add actual_start_time, actual_end_time for time adherence
--   3. habits: endTime becomes computed (startTime + duration), kept for backward compat
-- Created: 2026-03-05
-- Phase: 1.1 — Advanced Habit Tracking
-- ════════════════════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════════════════════
-- ALTER TABLE: habits — notification config
-- ════════════════════════════════════════════════════════════════════════════

ALTER TABLE public.habits
  ADD COLUMN IF NOT EXISTS notifications_enabled BOOLEAN NOT NULL DEFAULT TRUE;

ALTER TABLE public.habits
  ADD COLUMN IF NOT EXISTS reminder_offset_minutes INTEGER NOT NULL DEFAULT 5;

-- ════════════════════════════════════════════════════════════════════════════
-- ALTER TABLE: habit_logs — actual time tracking
-- ════════════════════════════════════════════════════════════════════════════

ALTER TABLE public.habit_logs
  ADD COLUMN IF NOT EXISTS actual_start_time TIME;

ALTER TABLE public.habit_logs
  ADD COLUMN IF NOT EXISTS actual_end_time TIME;

-- ════════════════════════════════════════════════════════════════════════════
-- COMMENTS
-- ════════════════════════════════════════════════════════════════════════════

COMMENT ON COLUMN public.habits.notifications_enabled IS
  'Whether local reminders are enabled for this habit (default: true)';

COMMENT ON COLUMN public.habits.reminder_offset_minutes IS
  'Minutes before startTime to send the reminder notification (default: 5)';

COMMENT ON COLUMN public.habit_logs.actual_start_time IS
  'The actual time the habit was started (defaults to habit.start_time on log)';

COMMENT ON COLUMN public.habit_logs.actual_end_time IS
  'The actual time the habit was ended (defaults to start + estimated_duration_minutes)';

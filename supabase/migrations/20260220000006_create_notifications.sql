-- ============================================================================
-- NOTIFICATIONS TABLE
-- Stores in-app notifications for each user.
-- Types: reminder, streak, bilan, general, alert, success
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.notifications (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title       TEXT NOT NULL,
    body        TEXT NOT NULL,
    type        TEXT NOT NULL DEFAULT 'general'
                    CHECK (type IN ('general', 'reminder', 'alert', 'success', 'streak', 'bilan')),
    channel     TEXT NOT NULL DEFAULT 'general'
                    CHECK (channel IN ('reminders', 'streaks', 'bilan', 'general')),
    is_read     BOOLEAN NOT NULL DEFAULT FALSE,
    action_url  TEXT,
    metadata    JSONB DEFAULT '{}',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Index for fast user queries ordered by date
CREATE INDEX idx_notifications_user_date
    ON public.notifications (user_id, created_at DESC);

-- Index for unread count badge
CREATE INDEX idx_notifications_user_unread
    ON public.notifications (user_id, is_read)
    WHERE is_read = FALSE;

-- ============================================================================
-- RLS — each user sees only their own notifications
-- ============================================================================

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own notifications"
    ON public.notifications FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can update own notifications"
    ON public.notifications FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own notifications"
    ON public.notifications FOR DELETE
    USING (auth.uid() = user_id);

-- Server-side inserts only (via service_role or triggers)
CREATE POLICY "Service can insert notifications"
    ON public.notifications FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- Function: create welcome notification on user signup
-- ============================================================================

CREATE OR REPLACE FUNCTION public.handle_new_user_notification()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.notifications (user_id, title, body, type, channel)
    VALUES (
        NEW.id,
        'Bienvenue sur LifeFlow ! 🎉',
        'Commence par créer tes domaines de vie et tes premières habitudes.',
        'general',
        'general'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger: fire after profile creation (which happens after auth signup)
CREATE TRIGGER on_profile_created_notification
    AFTER INSERT ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user_notification();

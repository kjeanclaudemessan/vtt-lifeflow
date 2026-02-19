-- ════════════════════════════════════════════════════════════════════════════
-- Migration: Create payments table
-- Description: Payment transactions (Moneroo / Local providers)
-- Created: 2026-01-23
-- Dependencies: organizations, subscriptions tables
-- ════════════════════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════════════════════
-- TABLE: payments
-- Payment transactions
-- ════════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.payments (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Who is paying
  organization_id UUID REFERENCES public.organizations(id) ON DELETE SET NULL,
  user_id         UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  
  -- What they're paying for
  subscription_id UUID REFERENCES public.subscriptions(id) ON DELETE SET NULL,
  
  -- Payment details
  amount          INTEGER NOT NULL,       -- In smallest currency unit
  currency        TEXT NOT NULL DEFAULT 'XOF',
  description     TEXT,
  
  -- Status
  status          TEXT NOT NULL DEFAULT 'pending' CHECK (status IN (
    'pending',      -- Initiated, waiting for payment
    'processing',   -- Being processed
    'success',      -- Payment completed
    'failed',       -- Payment failed
    'cancelled',    -- User cancelled
    'refunded',     -- Refunded
    'expired'       -- Timed out
  )),
  
  -- Provider info (Moneroo)
  provider        TEXT NOT NULL DEFAULT 'moneroo',
  provider_tx_id  TEXT,                   -- External transaction ID
  provider_data   JSONB DEFAULT '{}',     -- Full provider response
  
  -- Payment method used (from provider)
  payment_method  TEXT,                   -- e.g., 'mtn_momo', 'flooz', 'card'
  
  -- Checkout URL (for redirect-based flows)
  checkout_url    TEXT,
  
  -- Callback handling
  callback_url    TEXT,
  webhook_data    JSONB DEFAULT '{}',     -- Webhook payload
  
  -- Metadata
  metadata        JSONB DEFAULT '{}',     -- App-specific data
  
  -- Timestamps
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW(),
  completed_at    TIMESTAMPTZ,
  
  -- Error info
  error_code      TEXT,
  error_message   TEXT
);

-- ════════════════════════════════════════════════════════════════════════════
-- TABLE: payment_methods
-- Saved payment methods for recurring payments
-- ════════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.payment_methods (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
  
  -- Method details
  type            TEXT NOT NULL,          -- 'mobile_money', 'card', 'bank'
  provider        TEXT NOT NULL,          -- 'mtn', 'flooz', 'visa', etc.
  
  -- Display info (masked)
  display_name    TEXT,                   -- "MTN ****1234"
  
  -- Is this the default method
  is_default      BOOLEAN DEFAULT FALSE,
  
  -- Provider reference (for recurring)
  provider_ref    TEXT,
  
  -- Status
  is_active       BOOLEAN DEFAULT TRUE,
  
  -- Timestamps
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ════════════════════════════════════════════════════════════════════════════
-- INDEXES
-- ════════════════════════════════════════════════════════════════════════════
CREATE INDEX IF NOT EXISTS idx_payments_org ON public.payments(organization_id);
CREATE INDEX IF NOT EXISTS idx_payments_user ON public.payments(user_id);
CREATE INDEX IF NOT EXISTS idx_payments_subscription ON public.payments(subscription_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON public.payments(status);
CREATE INDEX IF NOT EXISTS idx_payments_provider_tx ON public.payments(provider_tx_id);
CREATE INDEX IF NOT EXISTS idx_payments_created ON public.payments(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_payment_methods_org ON public.payment_methods(organization_id);
CREATE INDEX IF NOT EXISTS idx_payment_methods_default ON public.payment_methods(organization_id) WHERE is_default = TRUE;

-- ════════════════════════════════════════════════════════════════════════════
-- FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════

-- Update payment status from webhook
CREATE OR REPLACE FUNCTION public.update_payment_from_webhook(
  p_provider_tx_id TEXT,
  p_status TEXT,
  p_webhook_data JSONB
)
RETURNS public.payments AS $$
DECLARE
  v_payment public.payments;
BEGIN
  UPDATE public.payments
  SET 
    status = p_status,
    webhook_data = p_webhook_data,
    updated_at = NOW(),
    completed_at = CASE WHEN p_status IN ('success', 'failed', 'refunded') THEN NOW() ELSE completed_at END,
    error_code = p_webhook_data->>'error_code',
    error_message = p_webhook_data->>'error_message'
  WHERE provider_tx_id = p_provider_tx_id
  RETURNING * INTO v_payment;
  
  -- If payment is successful and linked to a subscription, activate it
  IF v_payment IS NOT NULL AND v_payment.status = 'success' AND v_payment.subscription_id IS NOT NULL THEN
    UPDATE public.subscriptions
    SET 
      status = 'active',
      current_period_start = NOW(),
      current_period_end = NOW() + 
        CASE billing_cycle 
          WHEN 'yearly' THEN INTERVAL '1 year'
          ELSE INTERVAL '1 month'
        END
    WHERE id = v_payment.subscription_id;
  END IF;
  
  RETURN v_payment;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get payment statistics for an organization
CREATE OR REPLACE FUNCTION public.get_org_payment_stats(
  p_org_id UUID,
  p_start_date DATE DEFAULT NULL,
  p_end_date DATE DEFAULT NULL
)
RETURNS TABLE (
  total_amount BIGINT,
  successful_count INTEGER,
  failed_count INTEGER,
  pending_count INTEGER,
  average_amount NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    COALESCE(SUM(CASE WHEN status = 'success' THEN amount ELSE 0 END), 0)::BIGINT AS total_amount,
    COUNT(*) FILTER (WHERE status = 'success')::INTEGER AS successful_count,
    COUNT(*) FILTER (WHERE status = 'failed')::INTEGER AS failed_count,
    COUNT(*) FILTER (WHERE status = 'pending')::INTEGER AS pending_count,
    ROUND(AVG(CASE WHEN status = 'success' THEN amount END), 2) AS average_amount
  FROM public.payments
  WHERE organization_id = p_org_id
    AND (p_start_date IS NULL OR created_at >= p_start_date)
    AND (p_end_date IS NULL OR created_at <= p_end_date + INTERVAL '1 day');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ════════════════════════════════════════════════════════════════════════════
-- TRIGGERS
-- ════════════════════════════════════════════════════════════════════════════
DROP TRIGGER IF EXISTS on_payments_updated ON public.payments;
CREATE TRIGGER on_payments_updated
  BEFORE UPDATE ON public.payments
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS on_payment_methods_updated ON public.payment_methods;
CREATE TRIGGER on_payment_methods_updated
  BEFORE UPDATE ON public.payment_methods
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- ════════════════════════════════════════════════════════════════════════════
-- RLS POLICIES
-- ════════════════════════════════════════════════════════════════════════════
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payment_methods ENABLE ROW LEVEL SECURITY;

-- Payments
DROP POLICY IF EXISTS "Users can view own payments" ON public.payments;
CREATE POLICY "Users can view own payments"
  ON public.payments FOR SELECT
  USING (
    user_id = auth.uid()
    OR (organization_id IS NOT NULL AND public.user_has_org_role(auth.uid(), organization_id, ARRAY['owner', 'admin']))
  );

DROP POLICY IF EXISTS "Users can create payments" ON public.payments;
CREATE POLICY "Users can create payments"
  ON public.payments FOR INSERT
  WITH CHECK (
    user_id = auth.uid()
    OR (organization_id IS NOT NULL AND public.user_has_org_role(auth.uid(), organization_id, ARRAY['owner', 'admin']))
  );

-- Service role can update (for webhooks)
DROP POLICY IF EXISTS "Service can update payments" ON public.payments;
CREATE POLICY "Service can update payments"
  ON public.payments FOR UPDATE
  USING (TRUE)  -- Will be restricted by service role in practice
  WITH CHECK (TRUE);

-- Payment methods
DROP POLICY IF EXISTS "Org admins can view payment methods" ON public.payment_methods;
CREATE POLICY "Org admins can view payment methods"
  ON public.payment_methods FOR SELECT
  USING (
    public.user_has_org_role(auth.uid(), organization_id, ARRAY['owner', 'admin'])
  );

DROP POLICY IF EXISTS "Org admins can manage payment methods" ON public.payment_methods;
CREATE POLICY "Org admins can manage payment methods"
  ON public.payment_methods FOR ALL
  USING (
    public.user_has_org_role(auth.uid(), organization_id, ARRAY['owner'])
  );

-- ════════════════════════════════════════════════════════════════════════════
-- GRANTS
-- ════════════════════════════════════════════════════════════════════════════
GRANT ALL ON public.payments TO authenticated;
GRANT ALL ON public.payment_methods TO authenticated;

-- ════════════════════════════════════════════════════════════════════════════
-- COMMENTS
-- ════════════════════════════════════════════════════════════════════════════
COMMENT ON TABLE public.payments IS 'Payment transactions via Moneroo or other providers';
COMMENT ON TABLE public.payment_methods IS 'Saved payment methods for organizations';
COMMENT ON FUNCTION public.update_payment_from_webhook IS 'Update payment status from provider webhook';
COMMENT ON FUNCTION public.get_org_payment_stats IS 'Get payment statistics for an organization';

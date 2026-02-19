-- ════════════════════════════════════════════════════════════════════════════
-- Migration: Create profiles table
-- Description: Core user profiles extending auth.users
-- Created: 2026-01-22
-- ════════════════════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════════════════════
-- TABLE: profiles
-- Extension de auth.users pour données publiques
-- ════════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Profile
  first_name      TEXT,
  last_name       TEXT,
  display_name    TEXT,
  avatar_url      TEXT,
  
  -- Settings
  locale          TEXT DEFAULT 'fr',
  timezone        TEXT DEFAULT 'Europe/Paris',
  
  -- Role (always present, used or not)
  role            TEXT DEFAULT 'user',
  
  -- Multi-tenant (optional, NULL if not used)
  organization_id UUID,
  
  -- Flexible JSONB fields
  metadata        JSONB DEFAULT '{}',   -- Business-specific data
  preferences     JSONB DEFAULT '{}',   -- UI/UX preferences
  
  -- Timestamps
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW(),
  deleted_at      TIMESTAMPTZ             -- Soft delete
);

-- ════════════════════════════════════════════════════════════════════════════
-- INDEXES
-- ════════════════════════════════════════════════════════════════════════════
CREATE INDEX IF NOT EXISTS idx_profiles_role ON public.profiles(role);
CREATE INDEX IF NOT EXISTS idx_profiles_org ON public.profiles(organization_id) WHERE organization_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_profiles_metadata ON public.profiles USING GIN (metadata);
CREATE INDEX IF NOT EXISTS idx_profiles_active ON public.profiles(id) WHERE deleted_at IS NULL;

-- ════════════════════════════════════════════════════════════════════════════
-- FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Auto-create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, first_name, last_name, display_name, avatar_url)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'first_name',
    NEW.raw_user_meta_data->>'last_name',
    COALESCE(
      NEW.raw_user_meta_data->>'display_name',
      NEW.raw_user_meta_data->>'first_name',
      split_part(NEW.email, '@', 1)
    ),
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ════════════════════════════════════════════════════════════════════════════
-- TRIGGERS
-- ════════════════════════════════════════════════════════════════════════════
DROP TRIGGER IF EXISTS on_profiles_updated ON public.profiles;
CREATE TRIGGER on_profiles_updated
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ════════════════════════════════════════════════════════════════════════════
-- RLS POLICIES
-- ════════════════════════════════════════════════════════════════════════════
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if any
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;

-- Select: own profile only (exclude soft-deleted)
CREATE POLICY "Users can view own profile"
  ON public.profiles FOR SELECT
  USING (auth.uid() = id AND deleted_at IS NULL);

-- Update: own profile only
CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id AND deleted_at IS NULL);

-- ════════════════════════════════════════════════════════════════════════════
-- COMMENTS
-- ════════════════════════════════════════════════════════════════════════════
COMMENT ON TABLE public.profiles IS 'User profiles extending auth.users with additional data';
COMMENT ON COLUMN public.profiles.role IS 'User role: user, premium, admin, super_admin';
COMMENT ON COLUMN public.profiles.organization_id IS 'Optional organization reference for multi-tenant apps';
COMMENT ON COLUMN public.profiles.metadata IS 'Flexible JSONB for business-specific data';
COMMENT ON COLUMN public.profiles.preferences IS 'Flexible JSONB for UI/UX preferences';
COMMENT ON COLUMN public.profiles.deleted_at IS 'Soft delete timestamp, NULL if active';

-- ════════════════════════════════════════════════════════════════════════════
-- VIEWS
-- ════════════════════════════════════════════════════════════════════════════

-- Active profiles (excludes soft-deleted)
CREATE OR REPLACE VIEW public.active_profiles AS
SELECT 
  p.id,
  p.first_name,
  p.last_name,
  p.display_name,
  p.avatar_url,
  p.locale,
  p.timezone,
  p.role,
  p.organization_id,
  p.metadata,
  p.preferences,
  p.created_at,
  p.updated_at,
  -- Computed fields
  COALESCE(p.display_name, p.first_name, split_part(u.email, '@', 1)) AS computed_display_name,
  TRIM(CONCAT(p.first_name, ' ', p.last_name)) AS full_name,
  u.email,
  u.phone,
  u.email_confirmed_at IS NOT NULL AS is_email_verified,
  u.phone_confirmed_at IS NOT NULL AS is_phone_verified,
  u.last_sign_in_at
FROM public.profiles p
JOIN auth.users u ON u.id = p.id
WHERE p.deleted_at IS NULL;

COMMENT ON VIEW public.active_profiles IS 'Active user profiles with computed fields and auth data';

-- ════════════════════════════════════════════════════════════════════════════
-- RPC FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════

-- Get current user profile (with auth data)
CREATE OR REPLACE FUNCTION public.get_my_profile()
RETURNS TABLE (
  id UUID,
  email TEXT,
  phone TEXT,
  first_name TEXT,
  last_name TEXT,
  display_name TEXT,
  full_name TEXT,
  avatar_url TEXT,
  locale TEXT,
  timezone TEXT,
  role TEXT,
  organization_id UUID,
  metadata JSONB,
  preferences JSONB,
  is_email_verified BOOLEAN,
  is_phone_verified BOOLEAN,
  created_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ,
  last_sign_in_at TIMESTAMPTZ
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT 
    p.id,
    u.email,
    COALESCE(u.phone, p.metadata->>'phone') AS phone,
    p.first_name,
    p.last_name,
    COALESCE(p.display_name, p.first_name, split_part(u.email, '@', 1)) AS display_name,
    TRIM(CONCAT(p.first_name, ' ', p.last_name)) AS full_name,
    p.avatar_url,
    p.locale,
    p.timezone,
    p.role,
    p.organization_id,
    p.metadata,
    p.preferences,
    u.email_confirmed_at IS NOT NULL AS is_email_verified,
    u.phone_confirmed_at IS NOT NULL AS is_phone_verified,
    p.created_at,
    p.updated_at,
    u.last_sign_in_at
  FROM public.profiles p
  JOIN auth.users u ON u.id = p.id
  WHERE p.id = auth.uid()
    AND p.deleted_at IS NULL;
$$;

COMMENT ON FUNCTION public.get_my_profile IS 'Get current authenticated user profile with computed fields';

-- Update current user profile
CREATE OR REPLACE FUNCTION public.update_my_profile(
  p_first_name TEXT DEFAULT NULL,
  p_last_name TEXT DEFAULT NULL,
  p_display_name TEXT DEFAULT NULL,
  p_avatar_url TEXT DEFAULT NULL,
  p_locale TEXT DEFAULT NULL,
  p_timezone TEXT DEFAULT NULL,
  p_metadata JSONB DEFAULT NULL,
  p_preferences JSONB DEFAULT NULL
)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_profile public.profiles;
BEGIN
  UPDATE public.profiles
  SET
    first_name = COALESCE(p_first_name, first_name),
    last_name = COALESCE(p_last_name, last_name),
    display_name = COALESCE(p_display_name, display_name),
    avatar_url = COALESCE(p_avatar_url, avatar_url),
    locale = COALESCE(p_locale, locale),
    timezone = COALESCE(p_timezone, timezone),
    metadata = CASE 
      WHEN p_metadata IS NOT NULL THEN metadata || p_metadata
      ELSE metadata
    END,
    preferences = CASE 
      WHEN p_preferences IS NOT NULL THEN preferences || p_preferences
      ELSE preferences
    END
  WHERE id = auth.uid()
    AND deleted_at IS NULL
  RETURNING * INTO v_profile;
  
  RETURN v_profile;
END;
$$;

COMMENT ON FUNCTION public.update_my_profile IS 'Update current user profile. JSONB fields are merged, not replaced.';

-- Soft delete current user profile
CREATE OR REPLACE FUNCTION public.delete_my_account()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.profiles
  SET deleted_at = NOW()
  WHERE id = auth.uid()
    AND deleted_at IS NULL;
  
  RETURN FOUND;
END;
$$;

COMMENT ON FUNCTION public.delete_my_account IS 'Soft delete current user account';

-- Check if user has specific role
CREATE OR REPLACE FUNCTION public.has_role(required_role TEXT)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid()
      AND deleted_at IS NULL
      AND (
        role = required_role
        OR role = 'super_admin'
        OR (role = 'admin' AND required_role IN ('user', 'premium', 'moderator'))
      )
  );
$$;

COMMENT ON FUNCTION public.has_role IS 'Check if current user has the required role (with hierarchy)';

-- Check if user is admin
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid()
      AND deleted_at IS NULL
      AND role IN ('admin', 'super_admin')
  );
$$;

COMMENT ON FUNCTION public.is_admin IS 'Check if current user is admin or super_admin';

-- Update metadata field (merge)
CREATE OR REPLACE FUNCTION public.update_my_metadata(p_metadata JSONB)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_metadata JSONB;
BEGIN
  UPDATE public.profiles
  SET metadata = metadata || p_metadata
  WHERE id = auth.uid()
    AND deleted_at IS NULL
  RETURNING metadata INTO v_metadata;
  
  RETURN v_metadata;
END;
$$;

COMMENT ON FUNCTION public.update_my_metadata IS 'Merge new data into user metadata JSONB';

-- Update preferences field (merge)
CREATE OR REPLACE FUNCTION public.update_my_preferences(p_preferences JSONB)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_preferences JSONB;
BEGIN
  UPDATE public.profiles
  SET preferences = preferences || p_preferences
  WHERE id = auth.uid()
    AND deleted_at IS NULL
  RETURNING preferences INTO v_preferences;
  
  RETURN v_preferences;
END;
$$;

COMMENT ON FUNCTION public.update_my_preferences IS 'Merge new data into user preferences JSONB';
COMMENT ON COLUMN public.profiles.deleted_at IS 'Soft delete timestamp, NULL if active';

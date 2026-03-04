import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

/**
 * Creates a Supabase admin client using the service role key.
 *
 * This client bypasses RLS — use only in Edge Functions for
 * server-side operations (cron jobs, notifications, etc.).
 *
 * Usage:
 *   import { createAdminClient } from '../_shared/supabase-admin.ts'
 *   const supabase = createAdminClient()
 */
export function createAdminClient() {
  return createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
    {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    },
  )
}

/**
 * Creates a Supabase client scoped to a user's JWT.
 *
 * Respects RLS — use for operations that should be limited
 * to the calling user's permissions.
 *
 * Usage:
 *   import { createUserClient } from '../_shared/supabase-admin.ts'
 *   const supabase = createUserClient(req)
 */
export function createUserClient(req: Request) {
  const authHeader = req.headers.get('Authorization')
  if (!authHeader) throw new Error('Missing Authorization header')

  return createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_ANON_KEY') ?? '',
    {
      global: {
        headers: { Authorization: authHeader },
      },
    },
  )
}

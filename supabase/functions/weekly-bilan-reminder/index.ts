/**
 * weekly-bilan-reminder
 *
 * Cron Edge Function — runs every Sunday at 19:00 UTC.
 * Inserts a "bilan" notification for every user who has at least 1 active habit.
 *
 * Schedule via Supabase Dashboard → Edge Functions → Schedules:
 *   cron: "0 19 * * 0"
 *   function: weekly-bilan-reminder
 *
 * This complements the local notification scheduled on-device.
 * The DB notification appears in the in-app notification center;
 * the local notification fires even if the app hasn't been opened.
 */
import { createAdminClient } from '../_shared/supabase-admin.ts'
import { jsonResponse, errorResponse, optionsResponse } from '../_shared/response.ts'

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return optionsResponse()

  try {
    const supabase = createAdminClient()

    // Get distinct user_ids that have at least 1 active habit
    const { data: users, error: usersErr } = await supabase
      .from('habits')
      .select('user_id')
      .eq('is_archived', false)

    if (usersErr) throw usersErr

    // Deduplicate user IDs
    const uniqueUserIds = [...new Set((users ?? []).map((u: { user_id: string }) => u.user_id))]

    // Insert bilan notification for each user
    const notifications = uniqueUserIds.map((userId) => ({
      user_id: userId,
      title: '📊 Bilan hebdomadaire',
      body: "C'est dimanche ! Fais le point sur ta semaine et prépare la suivante.",
      type: 'bilan',
      channel: 'bilan',
    }))

    let inserted = 0
    if (notifications.length > 0) {
      const { error: insertErr, count } = await supabase
        .from('notifications')
        .insert(notifications)

      if (insertErr) throw insertErr
      inserted = count ?? notifications.length
    }

    return jsonResponse({
      users: uniqueUserIds.length,
      notifications: inserted,
    })
  } catch (err) {
    console.error('weekly-bilan-reminder error:', err)
    return errorResponse(err.message ?? 'Internal error', 500)
  }
})

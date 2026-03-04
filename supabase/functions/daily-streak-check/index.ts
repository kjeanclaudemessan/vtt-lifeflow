/**
 * daily-streak-check
 *
 * Cron Edge Function — runs daily at 01:00 UTC.
 * For each active habit that was NOT completed yesterday:
 *   - Resets current_streak to 0
 *   - Inserts a "streak broken" notification
 *
 * Schedule via Supabase Dashboard → Edge Functions → Schedules:
 *   cron: "0 1 * * *"
 *   function: daily-streak-check
 *
 * Environment: uses SUPABASE_URL + SUPABASE_SERVICE_ROLE_KEY (auto-injected).
 */
import { createAdminClient } from '../_shared/supabase-admin.ts'
import { jsonResponse, errorResponse, optionsResponse } from '../_shared/response.ts'

Deno.serve(async (req) => {
  // CORS preflight
  if (req.method === 'OPTIONS') return optionsResponse()

  try {
    const supabase = createAdminClient()
    const yesterday = new Date()
    yesterday.setDate(yesterday.getDate() - 1)
    const yesterdayStr = yesterday.toISOString().split('T')[0]

    // 1. Get all active (non-archived) habits
    const { data: habits, error: habitsErr } = await supabase
      .from('habits')
      .select('id, user_id, name, current_streak')
      .eq('is_archived', false)

    if (habitsErr) throw habitsErr

    // 2. Get yesterday's completed logs
    const { data: logs, error: logsErr } = await supabase
      .from('habit_logs')
      .select('habit_id')
      .eq('date', yesterdayStr)
      .eq('completed', true)

    if (logsErr) throw logsErr

    const completedHabitIds = new Set((logs ?? []).map((l: { habit_id: string }) => l.habit_id))

    // 3. Find habits that missed yesterday AND had a streak
    const brokenStreaks = (habits ?? []).filter(
      (h: { id: string; current_streak: number }) =>
        !completedHabitIds.has(h.id) && h.current_streak > 0,
    )

    let resetCount = 0
    let notifCount = 0

    for (const habit of brokenStreaks) {
      // Reset streak
      const { error: updateErr } = await supabase
        .from('habits')
        .update({ current_streak: 0 })
        .eq('id', habit.id)

      if (!updateErr) resetCount++

      // Insert notification for the user
      const { error: notifErr } = await supabase.from('notifications').insert({
        user_id: habit.user_id,
        title: '🔥 Série perdue',
        body: `Ta série de ${habit.current_streak} jours pour "${habit.name}" a été cassée. Recommence aujourd'hui !`,
        type: 'streak',
        channel: 'streaks',
      })

      if (!notifErr) notifCount++
    }

    return jsonResponse({
      checked: (habits ?? []).length,
      broken: brokenStreaks.length,
      reset: resetCount,
      notifications: notifCount,
      date: yesterdayStr,
    })
  } catch (err) {
    console.error('daily-streak-check error:', err)
    return errorResponse(err.message ?? 'Internal error', 500)
  }
})

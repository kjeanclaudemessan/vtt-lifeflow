/**
 * push-notification
 *
 * Webhook Edge Function — triggered by a Supabase Database Webhook
 * on INSERT into the `notifications` table.
 *
 * Sends a push notification via FCM to the user's registered device token.
 *
 * Setup:
 * 1. Store FCM server key as Edge Function secret: FIREBASE_SERVER_KEY
 * 2. Create a `device_tokens` table (user_id, token, platform, updated_at)
 * 3. Create Database Webhook in Supabase Dashboard:
 *    - Table: notifications
 *    - Events: INSERT
 *    - Function: push-notification
 *
 * This function is optional — it only activates when Firebase is configured.
 */
import { createAdminClient } from '../_shared/supabase-admin.ts'
import { jsonResponse, errorResponse, optionsResponse } from '../_shared/response.ts'

interface WebhookPayload {
  type: 'INSERT'
  table: string
  record: {
    id: string
    user_id: string
    title: string
    body: string
    type: string
    channel: string
  }
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return optionsResponse()

  try {
    const firebaseKey = Deno.env.get('FIREBASE_SERVER_KEY')
    if (!firebaseKey) {
      return jsonResponse({ skipped: true, reason: 'FIREBASE_SERVER_KEY not set' })
    }

    const payload: WebhookPayload = await req.json()
    const { record } = payload

    if (!record?.user_id) {
      return errorResponse('Missing user_id in payload')
    }

    const supabase = createAdminClient()

    // Get user's device tokens
    const { data: tokens, error: tokensErr } = await supabase
      .from('device_tokens')
      .select('token')
      .eq('user_id', record.user_id)

    if (tokensErr) throw tokensErr
    if (!tokens || tokens.length === 0) {
      return jsonResponse({ skipped: true, reason: 'No device tokens' })
    }

    // Send FCM push to each token
    let sent = 0
    for (const { token } of tokens) {
      const fcmResponse = await fetch('https://fcm.googleapis.com/fcm/send', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `key=${firebaseKey}`,
        },
        body: JSON.stringify({
          to: token,
          notification: {
            title: record.title,
            body: record.body,
          },
          data: {
            type: record.type,
            channel: record.channel,
            notification_id: record.id,
          },
        }),
      })

      if (fcmResponse.ok) sent++
    }

    return jsonResponse({
      user_id: record.user_id,
      tokens: tokens.length,
      sent,
    })
  } catch (err) {
    console.error('push-notification error:', err)
    return errorResponse(err.message ?? 'Internal error', 500)
  }
})

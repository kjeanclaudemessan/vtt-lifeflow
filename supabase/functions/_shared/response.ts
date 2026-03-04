/**
 * Common response helpers for Edge Functions.
 *
 * Standardizes JSON responses with CORS headers.
 */
import { corsHeaders } from './cors.ts'

/** 200 OK with JSON body */
export function jsonResponse(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  })
}

/** Error response */
export function errorResponse(message: string, status = 400) {
  return new Response(JSON.stringify({ error: message }), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  })
}

/** CORS preflight response */
export function optionsResponse() {
  return new Response('ok', { headers: corsHeaders })
}

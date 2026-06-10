#!/bin/bash
# chmod +x backend/test-api.sh
# Usage: ./backend/test-api.sh   (server must be running on :3000)

BASE="http://localhost:3000"
PASS=0
FAIL=0

# ── helpers ────────────────────────────────────────────────────────────────────

check_status() {
  local label="$1" expected="$2" actual="$3"
  if [ "$actual" -eq "$expected" ]; then
    echo "✅ PASS: $label"
    PASS=$((PASS + 1))
  else
    echo "❌ FAIL: $label (expected $expected, got $actual)"
    FAIL=$((FAIL + 1))
  fi
}

# Runs curl, populates $BODY and $STATUS
req() {
  local raw
  raw=$(curl -s -w "\n%{http_code}" "$@")
  STATUS=$(printf '%s' "$raw" | tail -1)
  BODY=$(printf '%s' "$raw" | sed '$d')
}

# ── tests ──────────────────────────────────────────────────────────────────────

echo "======================================"
echo "  QuickSlot API Smoke Tests"
echo "======================================"
echo ""

# 1. GET /health
req "$BASE/health"
check_status "GET /health" 200 "$STATUS"

# 2. GET /venues
req "$BASE/venues"
check_status "GET /venues" 200 "$STATUS"
VENUE_COUNT=$(printf '%s' "$BODY" | grep -o '"id"' | wc -l | tr -d ' ')
echo "   → $VENUE_COUNT venues"

# 3. GET /venues/1/slots?date=2026-06-15
req "$BASE/venues/1/slots?date=2026-06-15"
check_status "GET /venues/1/slots?date=2026-06-15" 200 "$STATUS"
SLOT_COUNT=$(printf '%s' "$BODY" | grep -o '"id"' | wc -l | tr -d ' ')
echo "   → $SLOT_COUNT slots"

# 4. GET /venues/1/slots — no date param
req "$BASE/venues/1/slots"
check_status "GET /venues/1/slots (no date param)" 400 "$STATUS"

# 5. POST /bookings — new booking, capture booking_id
req -X POST "$BASE/bookings" \
  -H "Content-Type: application/json" \
  -H "X-User-Id: 1" \
  -d '{"slot_id":1,"date":"2026-06-15"}'
check_status "POST /bookings (new booking)" 201 "$STATUS"
BOOKING_ID=$(printf '%s' "$BODY" | grep -o '"booking_id":[0-9]*' | grep -o '[0-9]*')
echo "   → booking_id: $BOOKING_ID"

# 6. POST /bookings — same slot/date, different user → SLOT_TAKEN
req -X POST "$BASE/bookings" \
  -H "Content-Type: application/json" \
  -H "X-User-Id: 2" \
  -d '{"slot_id":1,"date":"2026-06-15"}'
check_status "POST /bookings (double-booking same slot)" 409 "$STATUS"

# 7. GET /bookings/users/1/bookings
req "$BASE/bookings/users/1/bookings"
check_status "GET /bookings/users/1/bookings" 200 "$STATUS"
echo "   → $BODY"

# 8. DELETE /bookings/:id — correct owner
req -X DELETE "$BASE/bookings/$BOOKING_ID" \
  -H "X-User-Id: 1"
check_status "DELETE /bookings/$BOOKING_ID (cancel)" 200 "$STATUS"

# 9. DELETE /bookings/:id — already cancelled
req -X DELETE "$BASE/bookings/$BOOKING_ID" \
  -H "X-User-Id: 1"
check_status "DELETE /bookings/$BOOKING_ID (already cancelled)" 404 "$STATUS"

# 10. GET /bookings/users/1/bookings — confirm cancelled status
req "$BASE/bookings/users/1/bookings"
check_status "GET /bookings/users/1/bookings (after cancel)" 200 "$STATUS"
CANCELLED=$(printf '%s' "$BODY" | grep -o '"status":"cancelled"' | wc -l | tr -d ' ')
echo "   → $CANCELLED booking(s) with status=cancelled"

# 11. POST /bookings — no X-User-Id header
req -X POST "$BASE/bookings" \
  -H "Content-Type: application/json" \
  -d '{"slot_id":2,"date":"2026-06-15"}'
check_status "POST /bookings (no auth header)" 401 "$STATUS"

# ── summary ────────────────────────────────────────────────────────────────────

TOTAL=$((PASS + FAIL))
echo ""
echo "======================================"
echo "  $PASS/$TOTAL tests passed"
echo "======================================"

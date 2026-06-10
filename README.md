# QuickSlot

A sports slot booking app — browse badminton courts and turf grounds, pick a date, book a slot. Built as a monorepo: `/backend` (Node.js + Express + SQLite) and `/app` (Flutter + BLoC).

**Live backend:** https://quickslot-production-a43d.up.railway.app

---

## Setup

### Prerequisites

- Node.js 18+
- Flutter 3.x (`flutter doctor` clean)
- Android emulator or physical device

### 1. Backend (local)

```bash
cd backend
npm install
npm start
# API running at http://localhost:3000
```

The database is created and seeded automatically on first boot (5 venues, 16 slots each, 3 users).

### 2. Flutter app

```bash
cd app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

> The app points to the deployed Railway backend (`https://quickslot-production-a43d.up.railway.app`). No local server required — runs on any emulator or physical device out of the box.

### 3. Backend smoke tests

```bash
# In a separate terminal while the server is running
chmod +x backend/test-api.sh
./backend/test-api.sh
```

---

## Project Structure

```
quickslot/
├── backend/
│   ├── index.js                  # Entry point — seed + listen
│   └── src/
│       ├── app.js                # Express app, routes, CORS
│       ├── db.js                 # SQLite init, schema, partial index
│       ├── seed.js               # Idempotent seed (venues, slots, users)
│       ├── middleware/
│       │   ├── auth.js           # X-User-Id header guard
│       │   └── errorHandler.js   # Centralised error → HTTP status
│       ├── routes/
│       │   ├── venues.js         # GET /venues, GET /venues/:id/slots
│       │   └── bookings.js       # POST, DELETE /bookings, GET /users/:id/bookings
│       └── utils/time.js         # addOneHour() for end_time calculation
│
└── app/
    └── lib/
        ├── core/
        │   ├── api/              # ApiClient (Dio), endpoints, exceptions
        │   ├── constants/        # AppColors, seeded AppUser list
        │   ├── di/               # get_it setup
        │   ├── router/           # GoRouter + AppShell (bottom nav)
        │   └── theme/            # Light + dark MaterialTheme
        └── features/
            ├── auth/             # UserSelectScreen, AuthBloc
            ├── venues/           # VenueListScreen, VenueDetailScreen, VenuesBloc, SlotsBloc
            ├── slots/            # SlotGrid, SlotTile, SlotModel
            └── bookings/         # BookingBloc, MyBookingsBloc, MyBookingsScreen, BookingCard
```

---

## API Reference

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/health` | — | Liveness check |
| GET | `/venues` | — | List all venues |
| GET | `/venues/:id/slots?date=YYYY-MM-DD` | — | Slots for a venue + date with live status |
| POST | `/bookings` | X-User-Id | Book a slot — concurrency-safe |
| DELETE | `/bookings/:id` | X-User-Id | Soft-cancel a booking |
| GET | `/bookings/users/:id/bookings` | — | All bookings for a user |

**Auth:** Pass `X-User-Id: 1` (Rahul), `2` (Priya), or `3` (Arjun) as a request header. Missing header returns `401`. Per the problem statement, hardcoded users + X-User-Id header is the intentional auth approach.

**Status codes:**

| Code | Meaning |
|------|---------|
| 201 | Booking created |
| 400 | Missing/invalid input (e.g. no `date` param) |
| 401 | Missing X-User-Id header |
| 404 | Slot or booking not found |
| 409 | `SLOT_TAKEN` — slot already booked for that date |

---

## Architecture

### Backend

**Runtime:** Node.js + Express + `better-sqlite3` (synchronous SQLite, no ORM).

**Schema:**

```
venues  (id, name, sport, address)
slots   (id, venue_id, start_time)          -- 16 slots per venue, 06:00–21:00
users   (id, name)
bookings (id, slot_id, user_id, date, status, created_at)
```

**Concurrency safety — the hard rule:**

Two concurrent `POST /bookings` for the same `(slot_id, date)` are handled at two layers:

1. **Transaction serialization:** `better-sqlite3` transactions are synchronous and run to completion before the next one starts. Within the transaction, the code checks for an existing active booking before inserting. The second concurrent request finds the row already there and throws `SLOT_TAKEN` before it ever reaches the database constraint.

2. **Database backstop:** A partial unique index ensures the DB itself rejects duplicates even if the application check is bypassed:

```sql
CREATE UNIQUE INDEX uq_active_booking
ON bookings(slot_id, date)
WHERE status = 'active';
```

Using `WHERE status = 'active'` (not a plain UNIQUE constraint) means a cancelled booking never blocks a fresh booking of the same slot — the correct behaviour for a booking system.

### Flutter

**State management:** `flutter_bloc` (v9) with Dart 3 sealed classes for events and states. Every BLoC owns one responsibility. No business logic inside widgets.

**Key BLoCs:**

| BLoC | Responsibility |
|------|---------------|
| `AuthBloc` | User selection; sets `ApiClient.currentUserId` |
| `VenuesBloc` | Loads venue list |
| `SlotsBloc` | Loads + silently refreshes slots for a venue/date |
| `BookingBloc` | Single booking attempt; `ResetBooking` clears state |
| `MyBookingsBloc` | Loads user's bookings; cancel → auto re-fetch |

**Double-booking UX:** After a `409` from the server, `BookingBloc` emits `BookingConflict`. A `BlocListener` in `VenueDetailScreen` catches it, dismisses the sheet, shows a snackbar ("Someone just booked this slot. Refreshing…"), and fires `RefreshSlots` — which re-fetches silently without showing a loading state so the user sees the updated grid immediately.

**Navigation:** `go_router` with `StatefulShellRoute.indexedStack` — two branches (Venues / My Bookings) with persistent state across tab switches.

**Models:** Freezed + json_serializable. All four models (`AppUser`, `Venue`, `Slot`, `Booking`) are immutable value types with generated `==`, `copyWith`, and `fromJson`.

**DI:** `get_it` singleton for `ApiClient`. BLoCs that need the client receive it via constructor injection (testable).

**HTTP:** `Dio` with an interceptor that injects the `X-User-Id` header automatically. `_mapError` returns `Never` — callers don't need a redundant `throw` after calling it.

---

## Test Suite

### Backend — Smoke Tests (`backend/test-api.sh`)

11 end-to-end tests against the running server. Run with `./backend/test-api.sh`.

| # | Test | Expected |
|---|------|----------|
| 1 | `GET /health` | 200 |
| 2 | `GET /venues` | 200 |
| 3 | `GET /venues/1/slots?date=2026-06-15` | 200, 16 slots |
| 4 | `GET /venues/1/slots` (no date param) | 400 |
| 5 | `POST /bookings` — new booking | 201, returns `booking_id` |
| 6 | `POST /bookings` — same slot/date, different user | **409 SLOT_TAKEN** |
| 7 | `GET /bookings/users/1/bookings` | 200 |
| 8 | `DELETE /bookings/:id` — correct owner | 200 |
| 9 | `DELETE /bookings/:id` — already cancelled | 404 |
| 10 | `GET /bookings/users/1/bookings` — after cancel | 200, status=cancelled |
| 11 | `POST /bookings` — no `X-User-Id` header | 401 |

Test 6 is the double-booking guard. Tests 8 + 9 verify soft-cancel and idempotency.

---

### Flutter — BLoC Unit Tests (`app/test/`)

10 unit tests using `bloc_test` + `mocktail`. No real HTTP calls — `ApiClient` is mocked.

#### `auth_bloc_test.dart` — 2 tests

| Test | What it verifies |
|------|-----------------|
| initial state is `AuthInitial` | Bloc starts in the correct state |
| emits `AuthAuthenticated` when `SelectUser` is added | Emitted user matches input; `ApiClient.currentUserId` is set as a side-effect |

#### `venues_bloc_test.dart` — 3 tests

| Test | What it verifies |
|------|-----------------|
| initial state is `VenuesInitial` | — |
| emits `[VenuesLoading, VenuesLoaded]` when `LoadVenues` succeeds | Loaded state holds the exact venue list returned by mock |
| emits `[VenuesLoading, VenuesError]` when `LoadVenues` throws `ApiException` | Error state on 500 |

#### `booking_bloc_test.dart` — 5 tests

| Group | Test | What it verifies |
|-------|------|-----------------|
| `BookSlot` | emits `[BookingLoading, BookingSuccess]` on success | `BookingSuccess.booking` equals the mock-returned `Booking` object |
| `BookSlot` | emits `[BookingLoading, BookingConflict]` on `SlotTakenException` | 409 maps to `BookingConflict` (not generic error) |
| `BookSlot` | emits `[BookingLoading, BookingError]` on `ApiException` | Generic server error path |
| `ResetBooking` | emits `BookingIdle` after `BookingSuccess` | Uses `seed:` to pre-set state; verifies reset clears it |

> The `seed:` param on the reset test is intentional — it skips triggering a real booking and directly tests the reset path in isolation.

#### `my_bookings_bloc_test.dart` — 5 tests

| Test | What it verifies |
|------|-----------------|
| initial state is `MyBookingsInitial` | — |
| emits `[Loading, Loaded]` with bookings list | Loaded state holds full typed `List<Booking>` |
| emits `[Loading, Loaded]` with empty list | No bookings case (separate from error) |
| emits `[Loading, Error]` on `ApiException` | Server error path |
| re-fetches after `CancelMyBooking` succeeds | `cancelBooking` called once; `getMyBookings` called once; emitted list reflects updated data |

---

## What I Cut and Why

| Cut | Reason |
|-----|--------|
| JWT / Firebase auth | Problem statement explicitly said: *"Keep auth light: hardcoded users plus an X-User-Id header is acceptable. Do not burn time building full auth."* Spent zero time here. |
| Slot status polling | Bonus item. Core flow was prioritised first. Would add next. |
| Offline cache for My Bookings | Bonus item. Would use `shared_preferences` or `hive`. |
| Dockerized backend | Bonus item. Deployed directly to Railway instead. |
| Filter slots by time of day | Bonus item. |
| iOS support | Built and tested on Android only. The deployed backend is HTTPS so there are no cleartext / ATS blockers, but iOS was not tested. |

---

## What I'd Do With One More Day

1. **Live slot polling** — `SlotsBloc` already has a `RefreshSlots` event. Add a `Timer.periodic` (30s) in `VenueDetailScreen` so booked slots flip live on another phone without a manual refresh.
2. **Offline My Bookings cache** — persist the last fetched list with `shared_preferences`; show it instantly on mount before the network call returns.
3. **SlotsBloc unit tests** — `LoadSlots` success/error and `RefreshSlots` silent-retry paths are not yet covered.
4. **Widget test for booking confirm flow** — pump `BookingConfirmSheet` with a seeded `BookingBloc`, tap "Book Now", verify the loading spinner appears and then the success snackbar.

---

## AI Usage Note

Used Claude (claude-sonnet-4-6) throughout — backend scaffolding, Flutter BLoC boilerplate, Freezed model setup, go_router config, and the full unit test suite.

**One thing it got wrong that I caught and fixed:**

In `BookingConfirmSheet`, the AI generated:
```dart
BookSlot(
  slotId: slot.id,
  date: DateFormat('yyyy-MM-dd').format(date),
  userId: 0, // ApiClient.currentUserId handles auth
)
```

The `userId: 0` parameter was wrong on two levels — the `BookSlot` event doesn't need a `userId` at all (the Dio interceptor already injects `X-User-Id` on every request), and passing it as `0` would have silently sent the wrong user ID in the request body. Fixed by removing the `userId` field from `BookSlot` entirely and updating the confirm sheet to call `BookSlot(slotId:, date:)` only.

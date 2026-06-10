const path = require('path');
const Database = require('better-sqlite3');

const db = new Database(path.join(__dirname, '..', 'quickslot.db'));

db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

db.exec(`
  CREATE TABLE IF NOT EXISTS venues (
    id      INTEGER PRIMARY KEY AUTOINCREMENT,
    name    TEXT NOT NULL,
    sport   TEXT NOT NULL,
    address TEXT NOT NULL
  );

  CREATE TABLE IF NOT EXISTS slots (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    venue_id   INTEGER NOT NULL REFERENCES venues(id),
    start_time TEXT NOT NULL
  );

  CREATE TABLE IF NOT EXISTS users (
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
  );

  CREATE TABLE IF NOT EXISTS bookings (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    slot_id    INTEGER NOT NULL REFERENCES slots(id),
    user_id    INTEGER NOT NULL REFERENCES users(id),
    date       TEXT NOT NULL,
    status     TEXT NOT NULL DEFAULT 'active',
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    UNIQUE(slot_id, date)
  );
`);

module.exports = db;

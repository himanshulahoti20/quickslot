const db = require('./db');

const VENUES = [
  { name: 'Smash Arena Badminton Club',    sport: 'badminton', address: '14, Koramangala 4th Block, Bengaluru' },
  { name: 'Rally Point Badminton Centre',  sport: 'badminton', address: '23, Andheri West, Mumbai' },
  { name: 'Ace Badminton Academy',         sport: 'badminton', address: '7, Sector 18, Noida' },
  { name: 'Green Turf Football Ground',    sport: 'turf',      address: '55, Madhapur, Hyderabad' },
  { name: 'Kickoff Arena Turf Ground',     sport: 'turf',      address: '9, Anna Nagar, Chennai' },
];

const USERS = ['Rahul', 'Priya', 'Arjun'];

function generateSlotTimes() {
  const times = [];
  for (let h = 6; h <= 21; h++) {
    times.push(`${String(h).padStart(2, '0')}:00`);
  }
  return times; // 06:00 … 21:00 — 16 slots
}

function seed() {
  const alreadySeeded = db.prepare('SELECT COUNT(*) AS cnt FROM venues').get().cnt > 0;
  if (alreadySeeded) {
    console.log('Already seeded, skipping.');
    return;
  }

  const insertVenue = db.prepare('INSERT INTO venues (name, sport, address) VALUES (?, ?, ?)');
  const insertSlot  = db.prepare('INSERT INTO slots  (venue_id, start_time) VALUES (?, ?)');
  const insertUser  = db.prepare('INSERT INTO users  (name) VALUES (?)');

  const slotTimes = generateSlotTimes();

  db.transaction(() => {
    for (const venue of VENUES) {
      const { lastInsertRowid: venueId } = insertVenue.run(venue.name, venue.sport, venue.address);
      for (const time of slotTimes) {
        insertSlot.run(venueId, time);
      }
    }
    for (const name of USERS) {
      insertUser.run(name);
    }
  })();

  console.log('Database seeded.');
}

module.exports = seed;

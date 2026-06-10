const express = require('express');
const db      = require('../db');

const router = express.Router();

const DATE_RE = /^\d{4}-\d{2}-\d{2}$/;

function isValidDate(str) {
  if (!DATE_RE.test(str)) return false;
  const d = new Date(str);
  return !isNaN(d.getTime());
}

function addOneHour(time) {
  const [h, m] = time.split(':').map(Number);
  return `${String(h + 1).padStart(2, '0')}:${String(m).padStart(2, '0')}`;
}

// GET /venues
router.get('/', (req, res) => {
  const venues = db.prepare('SELECT id, name, sport, address FROM venues ORDER BY id').all();
  res.json(venues);
});

// GET /venues/:id/slots?date=YYYY-MM-DD
router.get('/:id/slots', (req, res) => {
  const { date } = req.query;

  if (!date || !isValidDate(date)) {
    return res.status(400).json({
      error:   'INVALID_DATE',
      message: 'date query param required, format YYYY-MM-DD',
    });
  }

  const venueId = Number(req.params.id);

  const rows = db.prepare(`
    SELECT s.id, s.venue_id, s.start_time,
           b.user_id AS booked_by_user_id
    FROM   slots s
    LEFT JOIN bookings b
           ON b.slot_id = s.id
          AND b.date    = ?
          AND b.status  = 'active'
    WHERE  s.venue_id = ?
    ORDER  BY s.start_time
  `).all(date, venueId);

  const slots = rows.map(row => ({
    id:               row.id,
    venue_id:         row.venue_id,
    start_time:       row.start_time,
    end_time:         addOneHour(row.start_time),
    status:           row.booked_by_user_id !== null ? 'booked' : 'available',
    booked_by_user_id: row.booked_by_user_id,
  }));

  res.json(slots);
});

module.exports = router;

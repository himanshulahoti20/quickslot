const express     = require('express');
const db          = require('../db');
const requireUser = require('../middleware/auth');

const router = express.Router();

// POST /bookings
router.post('/', requireUser, (req, res) => {
  const { slot_id, date } = req.body;

  if (!slot_id || !date) {
    return res.status(400).json({
      error:   'BAD_REQUEST',
      message: 'slot_id and date are required',
    });
  }

  let booking;

  try {
    // better-sqlite3 transactions are synchronous and serialized at the Node.js level.
    // Two concurrent POST /bookings requests for the same slot will queue — the second
    // will find the booking already inserted and throw SLOT_TAKEN.
    // The UNIQUE(slot_id, date) constraint is a database-level backstop.
    booking = db.transaction(() => {
      const slot = db.prepare('SELECT id FROM slots WHERE id = ?').get(slot_id);
      if (!slot) throw { code: 'NOT_FOUND' };

      const existing = db
        .prepare("SELECT id FROM bookings WHERE slot_id = ? AND date = ? AND status = 'active'")
        .get(slot_id, date);
      if (existing) throw { code: 'SLOT_TAKEN' };

      const { lastInsertRowid } = db
        .prepare(`
          INSERT INTO bookings (slot_id, user_id, date, status, created_at)
          VALUES (?, ?, ?, 'active', datetime('now'))
        `)
        .run(slot_id, req.userId, date);

      return lastInsertRowid;
    })();
  } catch (err) {
    if (err.code === 'SLOT_TAKEN') {
      return res.status(409).json({
        error:   'SLOT_TAKEN',
        message: 'This slot was just booked. Please choose another.',
      });
    }
    if (err.code === 'NOT_FOUND') {
      return res.status(404).json({
        error:   'NOT_FOUND',
        message: 'Slot not found',
      });
    }
    throw err;
  }

  res.status(201).json({
    booking_id: booking,
    slot_id,
    date,
    user_id: req.userId,
    message: 'Slot booked successfully',
  });
});

// DELETE /bookings/:id
router.delete('/:id', requireUser, (req, res) => {
  const { changes } = db
    .prepare(`
      UPDATE bookings SET status = 'cancelled'
      WHERE id = ? AND user_id = ? AND status = 'active'
    `)
    .run(Number(req.params.id), req.userId);

  if (changes === 0) {
    return res.status(404).json({ error: 'NOT_FOUND' });
  }

  res.json({ message: 'Booking cancelled' });
});

module.exports = router;

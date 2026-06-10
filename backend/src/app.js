const express        = require('express');
const cors           = require('cors');
const venuesRouter   = require('./routes/venues');
const bookingsRouter = require('./routes/bookings');
const errorHandler   = require('./middleware/errorHandler');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.use('/venues',   venuesRouter);
app.use('/bookings', bookingsRouter);

app.use(errorHandler);

module.exports = app;

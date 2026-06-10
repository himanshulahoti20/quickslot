const express      = require('express');
const cors         = require('cors');
const venuesRouter   = require('./routes/venues');
const bookingsRouter = require('./routes/bookings');

const app = express();

app.use(cors());
app.use(express.json());

app.use('/venues',   venuesRouter);
app.use('/bookings', bookingsRouter);

module.exports = app;

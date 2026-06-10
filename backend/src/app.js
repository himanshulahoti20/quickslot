const express      = require('express');
const cors         = require('cors');
const venuesRouter = require('./routes/venues');

const app = express();

app.use(cors());
app.use(express.json());

app.use('/venues', venuesRouter);

module.exports = app;

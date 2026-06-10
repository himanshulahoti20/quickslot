const express = require('express');
const cors    = require('cors');
const seed    = require('./src/seed');

const app = express();

app.use(cors());
app.use(express.json());

seed();

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`QuickSlot API running on :${PORT}`);
});

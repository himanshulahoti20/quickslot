const app  = require('./src/app');
const seed = require('./src/seed');

seed();

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`QuickSlot API running on :${PORT}`);
});

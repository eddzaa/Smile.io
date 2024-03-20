// app.js
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.json({ message: 'Hello Smile' });
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
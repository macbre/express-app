const express = require('express');
const morgan = require('morgan');
const app = express();
const port = 3000;

app.use(morgan('tiny'));

app.get('/', (req, res) => {
  res.send('Hello World!');
});

// Ctrl+C pressed
process.on('SIGINT', function() {
  console.log('Got SIGINT signal');
  process.exit();
});

// container stopped
process.on('SIGTERM', function() {
  console.log('Got SIGTERM signal');
  process.exit();
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});

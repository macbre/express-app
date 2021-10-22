const express = require('express');
const morgan = require('morgan');
const app = express();
const port = 3000;

app.use(morgan('tiny'));

app.get('/', (req, res) => {
  res.send('Hello World!');
});

process.on('SIGINT', function() {
  console.log('Got SIGINT signal');
  process.exit();
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
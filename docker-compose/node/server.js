const express = require('express');
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

const port = 3000;

app.get('/', (req, res) => {
  return res.status(200).json({
    status: true,
    message: 'Docker is online',
  });
});

app.listen(port, () => {
  console.log(`server listening on port: ${port}`);
});

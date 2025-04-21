const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mysql = require('mysql2');
require('dotenv').config();

const app = express();
app.use(bodyParser.json());
const PORT = process.env.PORT || 3306;

app.use(bodyParser.json());
app.use(cors());

const db = mysql.createConnection({
  host: process.env.MYSQLHOST,
  port: process.env.MYSQLPORT,
  user: process.env.MYSQLUSER,
  password: process.env.MYSQLPASSWORD,
  database: process.env.MYSQLDATABASE
});

db.connect((err) => {
  if (err) throw err;
  console.log('MySQL connected.');
});

module.exports = db;

const matchRoutes = require('./match');
const playerRoutes = require('./player');
const leaderboardRoutes = require('./leaderboard');
const eventsRoutes = require("./events");
const teamRoutes = require('./team');

app.use('/api', matchRoutes);
app.use('/api', playerRoutes);
app.use('/api', leaderboardRoutes);
app.use('/api', eventsRoutes);
app.use('/api', teamRoutes);

app.listen(PORT, () => {
  console.log(`Server is running`);
});

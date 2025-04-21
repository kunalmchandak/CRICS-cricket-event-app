const express = require('express');
const router = express.Router();
const db = require('./index');

// Match Model
const Match = {
  getUpcomingMatches: (callback) => {
    const query = 'SELECT * FROM matches where status = "Scheduled"';
    db.query(query, callback);
  },

  getAllMatches: (callback) => {
    const query = 'SELECT * FROM matches';
    db.query(query, callback);
  },

  addMatch: (match, callback) => {
    const query = `INSERT INTO matches (team_1, team_2, date_time, status) VALUES (?, ?, ?, ?)`;
    db.query(query, [match.team_1, match.team_2, match.date_time, match.status], callback);
  }
};

// Match Controller
const getAllMatches = (req, res) => {
  Match.getAllMatches((err, results) => {
    if (err) {
      res.status(500).json({ error: err.message });
    } else {
      res.status(200).json(results);
    }
  });
};

const getUpcomingMatches = (req, res) => {
  Match.getUpcomingMatches((err, results) => {
    if (err) {
      res.status(500).json({ error: err.message });
    } else {
      res.status(200).json(results);
    }
  });
};

const addMatch = (req, res) => {
  const { team_1, team_2, date_time, status } = req.body;
  if (!team_1 || !team_2 || !date_time || !status) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  const newMatch = { team_1, team_2, date_time, status };
  Match.addMatch(newMatch, (err, result) => {
    if (err) {
      res.status(500).json({ error: err.message });
    } else {
      res.status(201).json({ message: 'Match added successfully', matchId: result.insertId });
    }
  });
};

// Match Routes
router.get('/matches', getAllMatches);
router.get('/matches/upcoming', getUpcomingMatches);
router.post('/matches', addMatch);

module.exports = router;

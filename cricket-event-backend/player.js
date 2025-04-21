const express = require('express');
const router = express.Router();
const db = require('./index');

// app.use('/api', require('./routes/player'));

// Player Model
const Player = {
    addPlayer: (player, callback) => {
      const query = 'INSERT INTO players (name, team, role) VALUES (?, ?, ?)';
      db.query(query, [player.name, player.team, player.role], callback);
    },
  
    getAllPlayers: (callback) => {
      const query = 'SELECT * FROM players';
      db.query(query, callback);
    },
  
    getPlayerById: (playerId, callback) => {
      const query = 'SELECT * FROM players WHERE player_id = ?';
      db.query(query, [playerId], (err, result) => {
        if (err) return callback(err, null);
        if (result.length === 0) return callback(null, null);
        callback(null, result[0]);
      });
    },
  
    getPlayerByEmail: (email, callback) => {
      const query = 'SELECT * FROM players WHERE email = ?';
      db.query(query, [email], (err, result) => {
        if (err) return callback(err, null);
        if (result.length === 0) return callback(null, null);
        callback(null, result[0]);
      });
    }
  };
  

// Player Controller
const addPlayer = (req, res) => {
  const { name, team, role } = req.body;
  if (!name || !team || !role) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  const newPlayer = { name, team, role };
  Player.addPlayer(newPlayer, (err, result) => {
    if (err) {
      res.status(500).json({ error: err.message });
    } else {
      res.status(201).json({ message: 'Player added successfully', playerId: result.insertId });
    }
  });
};

const getAllPlayers = (req, res) => {
  Player.getAllPlayers((err, results) => {
    if (err) {
      res.status(500).json({ error: err.message });
    } else {
      res.status(200).json(results);
    }
  });
};

const getPlayerById = (req, res) => {
    const playerId = req.params.id;
    console.log(`Fetching stats for player ID: ${playerId}`);

    Player.getPlayerById(playerId, (err, player) => {
        if (err) {
            console.error("Database Error:", err);
            return res.status(500).json({ message: "Database error", error: err });
        }
        if (!player) {
            console.warn("Player not found:", playerId);
            return res.status(404).json({ message: "Player not found" });
        }
        res.status(200).json(player);
    });
};

// Register the route once
router.get('/players/:id', getPlayerById);


const getPlayerByEmail = (req, res) => {
    const email = req.params.email;
    console.log(`Fetching stats for player email: ${email}`);

    Player.getPlayerByEmail(email, (err, player) => {
        if (err) {
            console.error("Database Error:", err);
            return res.status(500).json({ message: "Database error", error: err });
        }
        if (!player) {
            console.warn("Player not found:", email);
            return res.status(404).json({ message: "Player not found" });
        }
        res.status(200).json(player);
    });
};

// Register the new route
router.get('/players/email/:email', getPlayerByEmail);


// Player Registration Route
router.post('/register', (req, res) => {
  const { name, email, password, role } = req.body;

  if (!name || !email || !password || !role) {
    return res.status(400).json({ message: 'Name, email, password, and role are required!' });
  }

  const query = 'INSERT INTO players (name, email, password, role) VALUES (?, ?, ?, ?)';
  db.query(query, [name, email, password, role], (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Database error', error: err });
    }
    res.status(201).json({ message: 'User registered successfully!' });
  });
});


router.get('/players/:id/recent-matches', async (req, res) => {
  const playerId = req.params.id;

  const query = `
    SELECT m.match_id, m.date_time, m.venue, ms.runs_scored, ms.wickets_taken, m.won
    FROM matches m
    JOIN match_statistics ms ON m.match_id = ms.match_id
    WHERE ms.player_id = ?
    ORDER BY m.date_time DESC
    LIMIT 5;
  `;

  try {
      const [results] = await db.promise().query(query, [playerId]);
      res.json(results);
  } catch (error) {
      console.error("Database error:", error);
      res.status(500).json({ message: "Database error", error });
  }
});

router.get('/players/id-by-email/:email', async (req, res) => {
  const email = req.params.email;

  if (!email) {
      return res.status(400).json({ error: 'Email is required' });
  }

  try {
      const result = await db.promise().query(
          'SELECT player_id FROM players WHERE email = ? LIMIT 1',
          [email]
      );

      const rows = result[0];

      if (rows.length > 0) {
          return res.json({ playerId: rows[0].player_id });
      } else {
          return res.status(404).json({ error: 'Player not found' });
      }
  } catch (error) {
      console.error('Error fetching player ID:', error);
      return res.status(500).json({ error: 'Database error', message: error.message });
  }
});

// Player Routes
router.post('/players', addPlayer);
router.get('/players', getAllPlayers);

module.exports = router;

const express = require('express');
const router = express.Router();
const db = require('./index');

router.get('/top-batsmen', async (req, res) => {
    try {
        const query = "SELECT player_id, name, total_runs FROM players where role = 'Batsman' or role = 'All-Rounder' or role = 'Wicket-Keeper' ORDER BY total_runs DESC LIMIT 10";
        const [rows] = await db.promise().query(query);
        res.json(rows);
    } catch (error) {
        console.error("Error fetching top batsmen:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

router.get('/top-bowlers', async (req, res) => {
    try {
        const query = "SELECT player_id, name, total_wickets FROM players where role = 'Bowler' or role = 'All-Rounder' ORDER BY total_wickets DESC LIMIT 10";
        const [rows] = await db.promise().query(query);
        res.json(rows);
    } catch (error) {
        console.error("Error fetching top bowlers:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

module.exports = router;

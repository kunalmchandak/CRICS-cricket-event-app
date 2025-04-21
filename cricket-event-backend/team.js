const express = require('express');
const router = express.Router();
const db = require('./index');

router.get('/team/my-team/:player_id', async (req, res) => {
    try {
        const playerId = req.params.player_id;

        const [team] = await db.promise().query(
            `SELECT t.team_id, t.team_name, t.total_matches, t.total_wins 
             FROM teams t 
             JOIN player_team pt ON t.team_id = pt.team_id 
             WHERE pt.player_id = ?`, 
            [playerId]
        );

        if (team.length == 0) {
            return res.status(404).json({ message: "Team not found for this player." });
        }

        const teamId = team[0].team_id;

        const [players] = await db.promise().query(
            `SELECT p.player_id, p.name, p.role, p.total_runs, p.total_wickets 
             FROM players p 
             JOIN player_team pt ON p.player_id = pt.player_id 
             WHERE pt.team_id = ?`, 
            [teamId]
        );

        return res.json({ team: team[0], players });
    } catch (error) {
        console.error("Error fetching team details:", error);
        res.status(500).json({ message: "Internal server error" });
    }
});

module.exports = router;

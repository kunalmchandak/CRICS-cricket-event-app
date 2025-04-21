const express = require("express");
const router = express.Router();
const db = require("./index");

// GET all events
router.get("/events/", (req, res) => {
    db.query("SELECT * FROM events WHERE start_date >= CURDATE() ORDER BY start_date ASC", (err, results) => {
        if (err) {
            console.error("Error fetching events:", err);
            return res.status(500).json({ error: "Internal Server Error" });
        }
        res.json(results);
    });
});

// GET event by ID
router.get("/events/:id", (req, res) => {
    const eventId = req.params.id;
    db.query("SELECT * FROM events WHERE event_id = ?", [eventId], (err, results) => {
        if (err) {
            console.error("Error fetching event:", err);
            return res.status(500).json({ error: "Internal Server Error" });
        }
        if (results.length === 0) {
            return res.status(404).json({ error: "Event not found" });
        }
        res.json(results[0]);
    });
});

// POST a new event
router.post("/events/", (req, res) => {
    const { event_name, start_date, end_date, location } = req.body;
    if (!event_name || !start_date || !end_date || !location) {
        return res.status(400).json({ error: "All fields are required" });
    }

    db.query(
        "INSERT INTO events (event_name, start_date, end_date, location) VALUES (?, ?, ?, ?)",
        [event_name, start_date, end_date, location],
        (err, result) => {
            if (err) {
                console.error("Error inserting event:", err);
                return res.status(500).json({ error: "Internal Server Error" });
            }
            res.status(201).json({ message: "Event added successfully", event_id: result.insertId });
        }
    );
});

// DELETE an event
router.delete("/events/:id", (req, res) => {
    const eventId = req.params.id;
    db.query("DELETE FROM events WHERE event_id = ?", [eventId], (err, result) => {
        if (err) {
            console.error("Error deleting event:", err);
            return res.status(500).json({ error: "Internal Server Error" });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: "Event not found" });
        }
        res.json({ message: "Event deleted successfully" });
    });
});

module.exports = router;  

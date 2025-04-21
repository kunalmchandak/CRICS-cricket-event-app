import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class UpmatchesScreen extends StatefulWidget {
  const UpmatchesScreen({super.key});

  @override
  _UpMatchesScreenState createState() => _UpMatchesScreenState();
}

class _UpMatchesScreenState extends State<UpmatchesScreen> {
  List<dynamic> _matches = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchMatches();
  }

  Future<void> _fetchMatches() async {
    try {
      final data = await ApiService.getupcomingMatches();
      setState(() {
        _matches = data;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      log("Error fetching matches: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.home, color: Colors.white, size: 26),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Upcoming Matches",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.white))
                  : _hasError
                  ? Center(
                child: Text(
                  "Error loading matches",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                ),
              )
                  : _buildMatchList(),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchList() {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: _matches.length,
      itemBuilder: (context, index) {
        return _buildMatchCard(_matches[index]);
      },
    );
  }

  Widget _buildMatchCard(Map<String, dynamic> match) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Match ID: ${match['match_id'].toString()}",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Teams: ${match['team_1'].toString()} vs ${match['team_2'].toString()}",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade700,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    match['match_type'],
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              "Date: ${_formatDate(match['date_time'])}",
              style: GoogleFonts.poppins(color: Colors.grey.shade700),
            ),
            Text(
              "Status: ${match['status']}",
              style: GoogleFonts.poppins(
                color: match['status'] == "Scheduled" ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Venue: ${match['venue']}",
              style: GoogleFonts.poppins(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    return DateFormat('yyyy-MM-dd | hh:mm a').format(parsedDate);
  }
}

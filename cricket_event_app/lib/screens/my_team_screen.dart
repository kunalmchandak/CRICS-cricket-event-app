import 'dart:developer';
import 'package:cricket_event_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTeamScreen extends StatefulWidget {
  final int playerId;

  const MyTeamScreen({super.key, required this.playerId});

  @override
  _MyTeamScreenState createState() => _MyTeamScreenState();
}

class _MyTeamScreenState extends State<MyTeamScreen> {
  Map<String, dynamic>? teamData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTeamData();
  }

  void fetchTeamData() async {
    try {
      var data = await ApiService.getMyTeam(widget.playerId);
      setState(() {
        teamData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.redAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child:
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : teamData == null
            ? Center(
            child: Text("No team assigned",
                style: GoogleFonts.poppins(
                    color: Colors.white, fontSize: 18)))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.home, color: Colors.white, size: 24),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        teamData!['team']['team_name'],
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
            const SizedBox(height: 10),
            Text(
              "Matches: ${teamData!['team']['total_matches']} | Wins: ${teamData!['team']['total_wins']}",
              style: GoogleFonts.poppins(
                  fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: teamData!['players'].length,
                itemBuilder: (context, index) {
                  var player = teamData!['players'][index];
                  return Card(
                    color: Colors.black.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.white),
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        player['name'],
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      subtitle: Text(
                        "${player['role']} | Runs: ${player['total_runs']} | Wickets: ${player['total_wickets']}",
                        style: GoogleFonts.poppins(
                            color: Colors.white70),
                      ),
                      leading: const Icon(Icons.person,
                          color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

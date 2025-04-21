import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late Future<List<Map<String, dynamic>>> topBatsmen;
  late Future<List<Map<String, dynamic>>> topBowlers;

  @override
  void initState() {
    super.initState();
    topBatsmen = ApiService.getTopBatsmen();
    topBowlers = ApiService.getTopBowlers();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purpleAccent, Colors.deepPurple],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
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
                        "Leaderboard",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSection("Top Batsmen", topBatsmen, "total_runs"),
                    const SizedBox(height: 20),
                    _buildSection("Top Bowlers", topBowlers, "total_wickets"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Future<List<Map<String, dynamic>>> futureData, String statKey) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              decoration: TextDecoration.none
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}", style: GoogleFonts.poppins(color: Colors.white)));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No data available", style: GoogleFonts.poppins(color: Colors.white)));
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final player = snapshot.data![index];
                    return _buildPlayerCard(player, index, statKey);
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(Map<String, dynamic> player, int index, String statKey) {
    String displayKey = statKey == "total_runs" ? "Runs" : "Wickets";

    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Text(
            "${index + 1}",
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          player['name'],
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        subtitle: Text(
          "$displayKey: ${player[statKey] ?? '0'}",
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }
}

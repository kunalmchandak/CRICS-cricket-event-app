import 'dart:developer';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerStatsScreen extends StatefulWidget {
  final int playerId;

  const PlayerStatsScreen({super.key, required this.playerId});

  @override
  _PlayerStatsScreenState createState() => _PlayerStatsScreenState();
}

class _PlayerStatsScreenState extends State<PlayerStatsScreen> {
  Map<String, dynamic>? _playerDetails;
  List<Map<String, dynamic>> _recentMatches = [];
  double _winContribution = 0.0;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      log("Fetching player stats for ID: ${widget.playerId}");

      final details = await ApiService.fetchPlayerStats(widget.playerId);
      log("Player details response: $details");

      final matches = await ApiService.fetchRecentMatches(widget.playerId);
      log("Recent matches response: $matches");

      int totalMatches = matches.length;
      int matchesWon = matches.where((match) => match['won'] == 1).length;
      int matchesLost = totalMatches - matchesWon;

      double winPercentage = (totalMatches > 0) ? (matchesWon / totalMatches) * 100 : 0.0;

      setState(() {
        _playerDetails = details.isNotEmpty ? details : null;
        _recentMatches = matches.take(5).toList();
        _winContribution = winPercentage;
        _isLoading = false;
      });

      log("Win %: $winPercentage%");
    } catch (error) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      log("Error fetching data: $error");
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    log("Building PlayerStatsScreen");
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent, Colors.teal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50),
            _buildHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : _hasError
                  ? Center(child: Text("Error loading stats", style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)))
                  : _buildStatsCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Center(
          child: Text(
            "Player Profile",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: 0,
          bottom: 0,
          child: IconButton(
            icon: const Icon(Icons.home, color: Colors.white, size: 26),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return SingleChildScrollView(
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _playerDetails?['name'] ?? 'Unknown',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _playerDetails?['role'] ?? 'Role: Unknown',
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              const Divider(thickness: 1),
              const SizedBox(height: 12),
              _buildStatGrid(),
              const SizedBox(height: 20),
              _buildRecentMatches(),
              const SizedBox(height: 20),
              _buildWinContribution(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatGrid() {
    int totalMatches = _playerDetails?['total_matches'] ?? 1;
    int totalRuns = _playerDetails?['total_runs'] ?? 0;
    int totalWickets = _playerDetails?['total_wickets'] ?? 0;
    double runsPerMatch = totalMatches > 0 ? totalRuns / totalMatches : 0;
    double wicketsPerMatch = totalMatches > 0 ? totalWickets / totalMatches : 0;

    return Column(
      children: [
        _buildStatRow("Total Runs", totalRuns),
        _buildStatRow("Runs per Match", runsPerMatch.toStringAsFixed(1)),
        _buildStatRow("Total Wickets", totalWickets),
        _buildStatRow("Wickets per Match", wicketsPerMatch.toStringAsFixed(1)),
        _buildStatRow("Highest Score", _playerDetails?['highest_score']),
        _buildStatRow("Best Bowling", _playerDetails?['best_bowling']),
      ],
    );
  }

  Widget _buildStatRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value?.toString() ?? "N/A",
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMatches() {
    if (_recentMatches.isEmpty) {
      return Center(child: Text("No recent matches", style: GoogleFonts.poppins()));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Matches",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        ..._recentMatches.map(
          (match) => ListTile(
            title: Text("vs ${match['opponent']}"),
            subtitle: Text(
              "Runs: ${match['runs']}, Wickets: ${match['wickets']}",
            ),
            leading: const Icon(Icons.sports_cricket, color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _buildWinContribution() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Win Contribution",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: _winContribution > 0 ? _winContribution : 1,
                      title:
                          _winContribution > 0
                              ? "${_winContribution.toStringAsFixed(1)}%"
                              : "",
                      color: Colors.green,
                      radius: 35,
                      titleStyle: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value:
                          (100 - _winContribution) > 0
                              ? (100 - _winContribution)
                              : 1,
                      title:
                          (100 - _winContribution) > 0
                              ? "${(100 - _winContribution).toStringAsFixed(1)}%"
                              : "",
                      color: Colors.redAccent,
                      radius: 35,
                      titleStyle: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 25,
                ),
              ),
            ),
            Text(
              "${_winContribution.toStringAsFixed(1)}%",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

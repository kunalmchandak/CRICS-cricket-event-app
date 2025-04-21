import 'dart:developer';

import 'package:cricket_event_app/screens/my_team_screen.dart';
import 'package:cricket_event_app/screens/player_stats_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  final int playerId;

  const DashboardScreen({super.key, required this.playerId});

  @override
  Widget build(BuildContext context) {
    log("Player ID received in Dashboard: $playerId");
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dashboard',
                    style: GoogleFonts.poppins(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => _logout(context),
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'CRICS',
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                  children: [
                    _buildCard(
                      title: 'My Stats',
                      icon: Icons.auto_graph,
                      color1: Colors.greenAccent,
                      color2: Colors.teal,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayerStatsScreen(playerId: playerId),
                          ),
                        );
                      },
                    ),
                    _buildCard(
                      title: 'Upcoming Matches',
                      icon: Icons.sports_cricket_outlined,
                      color1: Colors.orangeAccent,
                      color2: Colors.deepOrange,
                      onTap: () {
                        Navigator.pushNamed(context, '/upmatches');
                      },
                    ),
                    _buildCard(
                      title: 'Leaderboard',
                      icon: Icons.leaderboard,
                      color1: Colors.purpleAccent,
                      color2: Colors.deepPurple,
                      onTap: () {
                        Navigator.pushNamed(context, '/leaderboard');
                      },
                    ),
                    _buildCard(
                      title: 'My Team',
                      icon: Icons.group,
                      color1: Colors.pinkAccent,
                      color2: Colors.redAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyTeamScreen(playerId: playerId),
                          ),
                        );
                      },
                    ),
                    _buildCard(
                      title: 'Events',
                      icon: Icons.event,
                      color1: Colors.blueAccent,
                      color2: Colors.indigo,
                      onTap: () {
                        Navigator.pushNamed(context, '/event');
                      },
                    ),
                    _buildCard(
                      title: 'All Matches',
                      icon: Icons.sports_cricket_rounded,
                      color1: Colors.amberAccent,
                      color2: Colors.deepOrangeAccent,
                      onTap: () {
                        Navigator.pushNamed(context, '/allmatches');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    } catch (e) {
      log("Logout error: $e");
    }
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Color color1,
    required Color color2,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color2.withOpacity(0.7),
              offset: const Offset(3, 3),
              blurRadius: 8,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

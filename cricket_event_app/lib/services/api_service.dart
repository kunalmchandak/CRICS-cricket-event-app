import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://cricsbackend-production.up.railway.app/api';

  static Future<List<dynamic>> getupcomingMatches() async {
    final response = await http.get(Uri.parse('$baseUrl/matches/upcoming'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load matches');
    }
  }

  static Future<List<dynamic>> getAllMatches() async {
    final response = await http.get(Uri.parse('$baseUrl/matches'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load matches');
    }
  }

  static Future<bool> addPlayer(String name, String email, String password,
      String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "role": role,
      })
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      log("Error: \${response.body}");
      return false;
    }
  }

  static Future<Map<String, dynamic>> fetchPlayerStats(int playerId) async {
    final response = await http.get(Uri.parse('$baseUrl/players/$playerId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load player stats');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchPlayerPerformance(int playerId) async {
    final response = await http.get(Uri.parse('$baseUrl/players/$playerId/stats'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load player performance');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchRecentMatches(int playerId) async {
    final url = '$baseUrl/players/$playerId/recent-matches';
    log("Fetching: $url");
    final response = await http.get(Uri.parse(url));
    log("Response Status: ${response.statusCode}");
    log("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load recent matches: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> fetchWinContribution(int playerId) async {
    final response = await http.get(Uri.parse('$baseUrl/players/$playerId/win-contribution'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load win contribution');
    }
  }

  static Future<Map<String, dynamic>> fetchPlayerSummary(int playerId) async {
    final response = await http.get(Uri.parse('$baseUrl/players/$playerId/summary'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load player summary');
    }
  }

  static Future<Map<String, dynamic>> fetchPlayerTeam(int playerId) async {
    final response = await http.get(Uri.parse('$baseUrl/players/$playerId/team'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load player team details');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchMatchContributions(int playerId) async {
    final response = await http.get(Uri.parse('$baseUrl/players/$playerId/match-contributions'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load match contributions');
    }
  }

  static Future<int?> getPlayerIdByEmail(String email) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/players/id-by-email/$email"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['playerId'];
      } else {
        log("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      log("Exception: $e");
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getTopBatsmen() async {
    final response = await http.get(Uri.parse('$baseUrl/top-batsmen'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load top batsmen");
    }
  }

  static Future<List<Map<String, dynamic>>> getTopBowlers() async {
    final response = await http.get(Uri.parse('$baseUrl/top-bowlers'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load top bowlers");
    }
  }

  static Future<List<Map<String, dynamic>>> getEvents() async {
    final url = Uri.parse('$baseUrl/events');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception("Failed to load events");
      }
    } catch (e) {
      throw Exception("Error fetching events: $e");
    }
  }

  static Future<Map<String, dynamic>> getMyTeam(int playerId) async {
    final response = await http.get(Uri.parse('$baseUrl/team/my-team/$playerId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load team details");
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

class ApiService {
  // Update this depending on your device/emulator
  // Android emulator: 10.0.2.2
  // iOS simulator / web: 127.0.0.1
  static const String baseUrl = 'http://10.0.2.2:8000';

  /// Register a new user
  /// Returns user_id on success, null on failure
  static Future<int?> registerUser(String name, String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['user_id'];
      } else {
        logger.e('Error registering user: ${response.body}');
        return null;
      }
    } catch (e) {
      logger.e('Exception registering user: $e');
      return null;
    }
  }

  /// Update user's location
  /// Returns true on success, false on failure
  static Future<bool> updateLocation(int userId, double lat, double lng) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update-location'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'lat': lat, 'lng': lng}),
      );

      if (response.statusCode != 200) {
        logger.w('Failed to update location: ${response.body}');
      }

      return response.statusCode == 200;
    } catch (e) {
      logger.e('Exception updating location: $e');
      return false;
    }
  }

  /// Get nearby users
  /// Returns a list of nearby users or empty list on failure
  static Future<List<dynamic>> getNearbyUsers(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/nearby-users/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['nearby_users'];
      } else {
        logger.e('Error getting nearby users: ${response.body}');
        return [];
      }
    } catch (e) {
      logger.e('Exception getting nearby users: $e');
      return [];
    }
  }
}

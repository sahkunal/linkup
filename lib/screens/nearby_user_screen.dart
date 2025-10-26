import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/api_service.dart'; // Make sure this path matches your project

class NearbyUsersScreen extends StatefulWidget {
  final int userId;
  const NearbyUsersScreen({required this.userId, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NearbyUsersScreenState createState() => _NearbyUsersScreenState();
}

class _NearbyUsersScreenState extends State<NearbyUsersScreen> {
  List nearbyUsers = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchNearbyUsers();
  }

  Future<void> _fetchNearbyUsers() async {
    setState(() => loading = true);

    try {
      // Get current GPS location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update location on backend
      bool updated = await ApiService.updateLocation(
        widget.userId,
        position.latitude,
        position.longitude,
      );

      if (!updated) {
        throw Exception('Failed to update location');
      }

      // Fetch nearby users
      List users = await ApiService.getNearbyUsers(widget.userId);

      setState(() {
        nearbyUsers = users;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Users')),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : nearbyUsers.isEmpty
              ? const Center(child: Text('No nearby users found'))
              : ListView.builder(
                itemCount: nearbyUsers.length,
                itemBuilder: (context, index) {
                  final user = nearbyUsers[index];
                  return ListTile(
                    title: Text(user['name'] ?? 'Unknown'),
                    subtitle: Text(
                      '${user['distance_km']?.toStringAsFixed(2) ?? '-'} km away',
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchNearbyUsers,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

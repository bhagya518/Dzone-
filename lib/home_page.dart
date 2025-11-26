import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'google_map.dart';
import 'weekly_reports_page.dart';
import 'mapped_zones_page.dart';
import 'your_streak.dart';
import 'utils/feedback_dialog.dart';
import 'utils/location_fun_fact.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // Show a fun fact
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final fact = await getFunLocationFact();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(fact),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    // Check dead zone proximity
    _checkLocationAndProximity();
  }

  String gravatarUrl(String email) {
    final normalizedEmail = email.trim().toLowerCase();
    final hash = md5.convert(utf8.encode(normalizedEmail)).toString();
    return 'https://www.gravatar.com/avatar/$hash?d=identicon';
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> _checkLocationAndProximity() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return;
        }
      }

      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final snapshot =
      await FirebaseFirestore.instance.collection('dead_zones').get();

      for (var doc in snapshot.docs) {
        final lat = doc['latitude'];
        final lng = doc['longitude'];

        double distanceInMeters = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          lat,
          lng,
        );

        if (distanceInMeters <= 1000) {
          if (mounted) {
            _showNearDeadZoneDialog();
          }
          break;
        }
      }
    } catch (e) {
      debugPrint('Error checking proximity: $e');
    }
  }

  void _showNearDeadZoneDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text('⚠️ Alert', style: TextStyle(color: Colors.white)),
        content: const Text(
          'You are within 1km of a reported dead zone. Consider updating the signal status.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E21),
        elevation: 0,
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
              child: Builder(
                builder: (context) {
                  final user = FirebaseAuth.instance.currentUser;
                  final email = user?.email ?? 'unknown@example.com';
                  final avatarUrl = gravatarUrl(email);

                  return CircleAvatar(
                    backgroundImage: NetworkImage(avatarUrl),
                    backgroundColor: Colors.white,
                  );
                },
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Grid Section
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildCategoryCard(
                    context,
                    icon: Icons.map,
                    label: 'Google Maps',
                    page: const MapScreen(),
                  ),
                  _buildCategoryCard(
                    context,
                    icon: Icons.bar_chart,
                    label: 'Weekly Reports',
                    page: const WeeklyReportsPage(),
                  ),
                  _buildCategoryCard(
                    context,
                    icon: Icons.location_on,
                    label: 'Mapped Zones',
                    page: const MappedZonesPage(),
                  ),
                  _buildCategoryCard(
                    context,
                    icon: Icons.emoji_events,
                    label: 'Your Streak',
                    page: const YourStreakPage(),
                  ),
                ],
              ),
            ),

            // Lottie animation below the Grid
            SizedBox(
              height: 250,
              child: Lottie.asset(
                'assets/lottie/Animation - 1747340042836.json',
                repeat: true,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.feedback),
        onPressed: () => showFeedbackDialog(context),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context,
      {required IconData icon, required String label, required Widget page}) {
    return GestureDetector(
      onTap: () => _navigateTo(context, page),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1D1E33),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.redAccent),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}

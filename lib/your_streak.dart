import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class YourStreakPage extends StatefulWidget {
  const YourStreakPage({super.key});

  @override
  State<YourStreakPage> createState() => _YourStreakPageState();
}

class _YourStreakPageState extends State<YourStreakPage> {
  int mappedZones = 0;
  String badge = 'Loading...';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMappedZones();
  }

  Future<void> fetchMappedZones() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          badge = 'User not logged in';
          isLoading = false;
        });
        return;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('dead_zones')
          .where('userId', isEqualTo: user.uid)
          .get();

      int count = querySnapshot.docs.length;

      String badgeLabel = '';
      if (count >= 10) {
        badgeLabel = '🏆 Gold Streak';
      } else if (count >= 5) {
        badgeLabel = '🥈 Silver Streak';
      } else if (count >= 1) {
        badgeLabel = '🥉 Bronze Streak';
      } else {
        badgeLabel = '😅 No streak yet';
      }

      setState(() {
        mappedZones = count;
        badge = badgeLabel;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        badge = 'Error loading data';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text('Your Streak'),
        backgroundColor: const Color(0xFFB0B0B0),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Zones You Mapped:',
              style: TextStyle(fontSize: 20,color: Colors.white,),

            ),
            Text(
              '$mappedZones',
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold,color: Colors.white,),
            ),
            const SizedBox(height: 20),
            Text(
              'Your Badge: $badge',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500,color: Colors.white,),
            ),
          ],
        ),
      ),
    );
  }
}

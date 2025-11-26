import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Generates a Gravatar identicon URL using MD5 hash of the email
  String gravatarUrl(String email) {
    final normalizedEmail = email.trim().toLowerCase();
    final hash = md5.convert(utf8.encode(normalizedEmail)).toString();
    return 'https://www.gravatar.com/avatar/$hash?d=identicon';
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'unknown@example.com';
    final avatarUrl = gravatarUrl(email); // Always use Gravatar identicon

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E21),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(height: 20),
              Text(
                email,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => _signOut(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

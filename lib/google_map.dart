import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Set<Circle> _circles = {};
  GoogleMapController? _mapController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }


  Future<void> _loadData() async {
    await Permission.location.request();
    await _loadDeadZonesFromFirestore();
  }

  Future<void> _loadDeadZonesFromFirestore() async {
    setState(() => _isLoading = true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('dead_zones')
          .get();
      Set<Circle> circles = {};
      int id = 1;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data.containsKey('lat') && data.containsKey('lng')) {
          circles.add(
            Circle(
              circleId: CircleId("circle$id"),
              center: LatLng(data['lat'], data['lng']),
              radius: 50,
              fillColor: Colors.red.withOpacity(0.3),
              strokeColor: Colors.red,
              strokeWidth: 2,
            ),
          );
          id++;
        }
      }

      setState(() => _circles = circles);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _reportCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance.collection('dead_zones').add({
          'lat': position.latitude,
          'lng': position.longitude,
          'userId': user.uid,
          'email': user.email, // optional
          'displayName': user.displayName ?? '', // optional
          'timestamp': FieldValue.serverTimestamp(),
        });

        await _loadDeadZonesFromFirestore();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location reported successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dead Zone Heatmap")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(15.3647, 75.1240),
          zoom: 13,
        ),
        circles: _circles,
        mapType: MapType.normal,
        myLocationEnabled: true,
        onMapCreated: (controller) => _mapController = controller,
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
          child: FloatingActionButton.extended(
            onPressed: _reportCurrentLocation,
            icon: const Icon(Icons.location_on),
            label: const Text("Report Location"),
            backgroundColor: Colors.red.shade700,
          ),
        ),
      ),
    );
  }
}

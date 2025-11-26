import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class MappedZonesPage extends StatefulWidget {
  const MappedZonesPage({super.key});

  @override
  State<MappedZonesPage> createState() => _MappedZonesPageState();
}

class _MappedZonesPageState extends State<MappedZonesPage> {
  final Map<String, String> _locationCache = {};

  Future<String> getPlaceName(double lat, double lng, String docId) async {
    if (_locationCache.containsKey(docId)) return _locationCache[docId]!;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final locationName = '${place.locality ?? 'Unknown'}, ${place.administrativeArea ?? ''}';
        _locationCache[docId] = locationName;
        return locationName;
      }
    } catch (_) {
      return 'Unknown location';
    }

    return 'Unknown location';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapped Dead Zones'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('dead_zones').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('No dead zones mapped yet.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final lat = doc['lat']?.toDouble() ?? 0.0;
              final lng = doc['lng']?.toDouble() ?? 0.0;
              final docId = doc.id;

              return FutureBuilder<String>(
                future: getPlaceName(lat, lng, docId),
                builder: (context, snapshot) {
                  final placeName = snapshot.data ?? 'Loading...';

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.location_off_outlined),
                      title: Text('Lat: $lat, Lng: $lng'),
                      subtitle: Text('Approximate Location: $placeName'),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

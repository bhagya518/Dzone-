import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

Future<String> getFunLocationFact() async {
  try {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return "Location services are off.";

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return "Location permission not granted.";
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);

    String place = placemarks.first.locality ?? "your area";

    return "Hey there from $place 👋! Stay connected, keep mapping! 🌍";
  } catch (e) {
    return "Couldn't fetch location fun fact.";
  }
}

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationServiceException implements Exception {
  final String message;
  LocationServiceException(this.message);

  @override
  String toString() => "LocationServiceException: $message";
}

class LocationService {
  static String? cityName;

  static Future<void> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationServiceException('Location services are disabled. Please enable them in your device settings.');
      }

      // Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationServiceException('Location permissions are denied. Please allow access in your app settings.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        throw LocationServiceException('Location permissions are permanently denied, we cannot request permissions. Please allow access in your app settings.');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // Use position to get the place
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      cityName = placemarks[0].locality;

      print("Current city is $cityName");
    } catch (e) {
      // Catch any other exceptions and wrap them in our custom exception
      throw LocationServiceException('Failed to get current location: ${e.toString()}');
    }
  }
}

import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> requestPermissionAndGetLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        throw Exception('Location permission not granted');
      }
    }
    return await Geolocator.getCurrentPosition();
  }
}
// ignore_for_file: deprecated_member_use

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  static Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  static Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      timeLimit: const Duration(seconds: 8),
    );
  }

  static Future<String> getCityFromPosition(Position pos) async {
    final List<Placemark> placemarks = await placemarkFromCoordinates(
      pos.latitude,
      pos.longitude,
    );
    if (placemarks.isEmpty) return 'Unknown location';
    final p = placemarks.first;
    final nameParts = [
      if ((p.locality ?? '').isNotEmpty) p.locality,
      if ((p.subAdministrativeArea ?? '').isNotEmpty) p.subAdministrativeArea,
      if ((p.administrativeArea ?? '').isNotEmpty) p.administrativeArea,
      if ((p.country ?? '').isNotEmpty) p.country,
    ];
    return nameParts.join(', ');
  }
}

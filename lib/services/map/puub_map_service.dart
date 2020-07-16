import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PuubMapService {
  static Future<LatLng> getCurrentUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);
    return currentLatLng;
  }

  static Future<Map<String, dynamic>> getNEAndSWLatLng(
      GoogleMapController controller) async {
    LatLngBounds latLngBound;
    Map<String, dynamic> swNECorners;
    await controller.getVisibleRegion().then((LatLngBounds value) {
      latLngBound = value;
    });

    try {
      if (latLngBound == null) {
        return null;
      }
      swNECorners = new Map();
      swNECorners.putIfAbsent(
          'swLat', () => latLngBound.southwest.latitude.toString());
      swNECorners.putIfAbsent(
          'swLon', () => latLngBound.southwest.longitude.toString());
      swNECorners.putIfAbsent(
          'neLat', () => latLngBound.northeast.latitude.toString());
      swNECorners.putIfAbsent(
          'neLon', () => latLngBound.northeast.longitude.toString());
      return swNECorners;
    } catch (e) {
      return null;
    }
  }
}

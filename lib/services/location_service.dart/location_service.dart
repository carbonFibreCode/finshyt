import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;

class LocationService {

  static Future<({String city, Position pos})?> getCity() async {

    if (!await Geolocator.isLocationServiceEnabled()) {
      return null;
    }


    var status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
    }
   

    if (status == LocationPermission.denied ||
        status == LocationPermission.deniedForever) {
      return null;
    }

    // get the  location
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
      ),
    );

    // reversing the-geocode
    final placemarks =
        await geo.placemarkFromCoordinates(pos.latitude, pos.longitude);

    return (city: placemarks.first.locality ?? 'Unknown', pos: pos);
  }
}

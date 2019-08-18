import 'package:geolocator/geolocator.dart';

class GPSGeoLocator {
  static const int _gpsCaptureTimeOut = 15; // in seconds

  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator().isLocationServiceEnabled();
  }

  static Future<Position> getOneTimeLocation() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((_position) {
          return _position;
        })  
        .timeout(Duration(seconds: _gpsCaptureTimeOut))
        .catchError((error) {
          return null;
        });
  }
}

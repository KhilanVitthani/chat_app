import 'package:geolocator/geolocator.dart';

Future<List<double>> getUserCurrentCoordinates() async {
  List<double> coordinates = [0, 0];
  LocationPermission permission = await Geolocator.requestPermission();
  print(permission);
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  } else {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      coordinates = [position.latitude, position.longitude];
    }).catchError((e) {
      print(e);
    });
  }

  return coordinates;
}

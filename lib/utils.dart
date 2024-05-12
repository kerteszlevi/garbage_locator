import 'package:garbage_locator/models/garbage_location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';

Future<LocationData?> getCurrentLocation() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  locationData = await location.getLocation();

  return locationData;
}

// Future<GarbageLocation> buildGarbageLocation(LocationData locationData) async {
//   List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(locationData.latitude!, locationData.longitude!);
//
//   return GarbageLocation(
//     latitude: locationData.latitude,
//     longitude: locationData.longitude,
//     placemarkString: '${(placemarks)[0].locality!}, ${(placemarks)[0].isoCountryCode!}'
//   );
// }

Future<String> getPlacemarkString(double? latitude, double? longitude) async {
  if(latitude == null || longitude == null) {
    return 'Unknown location';
  }else{
    final List<geo.Placemark> placemarks;
    try {
      placemarks = await geo.placemarkFromCoordinates(latitude, longitude);
    }catch(e){
      return 'lat: $latitude, long: $longitude';
    }

    return '${(placemarks)[0].locality!}, ${(placemarks)[0].isoCountryCode!}';
  }
}
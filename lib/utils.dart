import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
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

Future<String> getPlacemarkString(double? latitude, double? longitude) async {
  if (latitude == null || longitude == null) {
    return 'Unknown place';
  } else {
    final List<geo.Placemark> placemarks;
    try {
      placemarks = await geo.placemarkFromCoordinates(latitude, longitude);
    } catch (e) {
      return 'lat: $latitude\nlon: $longitude';
    }

    return '${(placemarks)[0].locality!}, ${(placemarks)[0].isoCountryCode!}';
  }
}


Future<void> logOut() {
  return FirebaseAuth.instance.signOut();
}

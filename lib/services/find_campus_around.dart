import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

Future<String> findCampusAround(LatLng currentPosition) async {
  Geolocator geolocator = Geolocator();

  QuerySnapshot firestore =
      await Firestore.instance.collection('campus').getDocuments();

  for (DocumentSnapshot document in firestore.documents) {
    List<Placemark> placemark = await geolocator.placemarkFromAddress(
      document.data['street'] +
          ' ' +
          document.data['number'] +
          ' ' +
          document.data['city'],
    );

    double result = await geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        placemark[0].position.latitude,
        placemark[0].position.longitude);

    if (result <= 100) return document.documentID;
  }

  return null;
}

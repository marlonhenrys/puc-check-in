import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_serverless/components/alert_dialog.dart';
import 'package:flutter_serverless/services/find_campus_around.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> mapController;
  Geolocator geolocator = Geolocator();

  static LatLng _currentPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _listenUserLocation();
  }

  _tryCheckIn() async {
    String campus = await findCampusAround(_currentPosition);
    if (campus != null) alertDialog(context, campus);
  }

  _listenUserLocation() {
    geolocator
        .getPositionStream(LocationOptions(
            accuracy: LocationAccuracy.best,
            timeInterval: 1000,
            distanceFilter: 50))
        .listen((position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      _tryCheckIn();
    });
  }

  _getUserLocation() async {
    Position position = await geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController.complete(controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PUC Minas | Check-In'),
      ),
      body: _currentPosition == null
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 15,
                ),
                onMapCreated: _onMapCreated,
                zoomGesturesEnabled: true,
                myLocationEnabled: true,
                compassEnabled: true,
                zoomControlsEnabled: false,
              ),
            ),
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer';

class GoogleMapScreen extends StatefulWidget{
  final Position destination;

  @override
  State<StatefulWidget> createState() => GoogleMapScreenState();
  GoogleMapScreen({Key key, this.destination}): super(key:key);
}

class GoogleMapScreenState extends State<GoogleMapScreen>{

  static const String M_API_KEY = "AIzaSyDZtEhhzbICEi7JpTlTD9qjfYK1V5NIYmM";
  final Set<Polyline> polyLine = {};
  final GoogleMapPolyline googleMapPolyLine = new GoogleMapPolyline(apiKey: M_API_KEY);
  final double initialZoomRatio = 14.0;

  LatLng destination;
  LatLng currentLocation;
  Completer<GoogleMapController> mapControllerCompleter = Completer();


  // Set initial coordinate to Malaysia to prevent assert thrown from camera position in google Map
  GoogleMapScreenState({
    this.destination = const LatLng(
        4.2105,
        101.9758
    ),
    this.currentLocation = const LatLng(
        4.2105,
        101.9758)
  });

  @override
  void initState() {
    super.initState();
    initRoute();
  }

  void initRoute()async
  {
    if(!await Permission.location.request().isGranted)
      exit(-1);

    // Temporary set to INTI College Penang
    destination = LatLng(
        widget.destination.latitude,
        widget.destination.longitude
    );

    // Get current location
    Position position = await getCurrentPosition();
    currentLocation = LatLng(
      position.latitude,
      position.longitude
    );

    // Find list of coordinate for route
    List<LatLng> routeCoordinate = await googleMapPolyLine.getCoordinatesWithLocation(
        origin: currentLocation,
        destination: destination,
        mode: RouteMode.driving
    );

    GoogleMapController controller = await mapControllerCompleter.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(
            new CameraPosition(
              target: currentLocation,
              zoom: initialZoomRatio,
            )
        )
    );

    // Update the state
    setState(() {
      polyLine.add(
          Polyline(
              polylineId: PolylineId("routeFromSrcToDest"),
              visible: true,
              points: routeCoordinate,
              width:4,
              color: Colors.blue,
              startCap: Cap.roundCap,
              endCap: Cap.buttCap
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    log("Current location lat and long" + currentLocation.latitude.toString() + ", " + currentLocation.longitude.toString());
    return Scaffold(
      body: GoogleMap(
        onMapCreated: onMapCreated,
        polylines: polyLine,
        initialCameraPosition: CameraPosition(
          target: currentLocation,
          zoom: initialZoomRatio,
        ),
        mapType: MapType.normal,
      ),
    );
  }

  void onMapCreated(GoogleMapController controller)
  {
      mapControllerCompleter.complete(controller);
  }
}
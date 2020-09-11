import 'dart:async';
import 'dart:developer' as debug;
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Utility/AppLauncher.dart';
import 'package:gps_tracking_system/Utility/RestApi.dart';
import 'package:gps_tracking_system/components/rounded_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';

class ViewModel
{
  static const String _API_KEY =  "AIzaSyDZtEhhzbICEi7JpTlTD9qjfYK1V5NIYmM";
  static const double _INITIAL_CAMERA_ZOOM_RATIO = 14.0;

  final GoogleMapPolyline _googleMapPolyLine;
  final Completer<GoogleMapController> _mapControllerCompleter;
  final Function _callBackNotifyChanges;
  final Function(String, String) _callBackShowAlertDialog;

  GoogleMap _googleMap;
  RoundedButton _navigationButton;
  LatLng destination;
  int _totalDistanceInMeter, _totalDurationInSeconds;

  ViewModel({@required this.destination, @required Function notifyChanges, Function showAlertDialog}):
        _googleMapPolyLine = new GoogleMapPolyline(apiKey: _API_KEY),
        _mapControllerCompleter = Completer(),
        _callBackNotifyChanges = notifyChanges,
        _callBackShowAlertDialog = showAlertDialog,
        _totalDurationInSeconds = 0,
        _totalDistanceInMeter = 0 {
    this.initRoute();
  }

  // Draw polyline, calculate time, calculate distance
  Future<void> initRoute() async
  {
    // Get permission
    if (!await Permission.location
        .request()
        .isGranted)
      exit(-1);

    // Get current location
    final Position position = await getCurrentPosition();
    LatLng currentLocation = LatLng(
        position.latitude,
        position.longitude
    );

    // Get route
    List<LatLng> routeCoordinate = await _googleMapPolyLine
        .getCoordinatesWithLocation(
        origin: currentLocation,
        destination: destination,
        mode: RouteMode.driving
    );

    // Check if route is valid
    if (routeCoordinate == null || routeCoordinate.length <= 0) {
        _callBackShowAlertDialog("Oops!",
            "We could not calculate driving directions from your current location to destination.");
    }
    else {
      GoogleMapController controller = await _mapControllerCompleter.future;
      final List<Marker> marker = [];
      marker.add(
          Marker(
            markerId: MarkerId(destination.toString()),
            position: destination,
          )
      );

      marker.add(
          Marker(
              markerId: MarkerId(currentLocation.toString()),
              position: currentLocation,
              icon: await BitmapDescriptor.fromAssetImage(
                  ImageConfiguration(size: Size(40, 40)),
                  "assets/images/car.png")
          )
      );

      /*
      Sample Json (Duration)                 Way to read the json
      +------------------------------+       +----------+------+------+
      |   {                          |       |   |   A  |   B  |   C  |
      |    "durations":[             |       +---+------+------+------+    Data interested: A->B->C
      |       [                      |       | A | A->A | A->B | A->C |    A->B : row 0 col1
      |          0.0,                |       | B | B->A | B->B | B->C |    B->C : row 1 col2
      |          1181.7              |       | C | C->A | C->B | C->C |    col = row + 1
      |       ],                     |       +---+------+------+------+
      |       [                      |
      |          1167.1,             |       Refer https://docs.mapbox.com/help/glossary/matrix-api/
      |          0.0                 |
      |       ]                      |
      |     ]                        |
      |   }                          |
      +------------------------------+
      */

      Map<String, dynamic> jsonTimeTakenAndDistance = await RestApi.getTimeTaken([currentLocation,destination]);
      List<dynamic> timeTaken = jsonTimeTakenAndDistance["durations"];
      List<dynamic> distance = jsonTimeTakenAndDistance["distances"];

      int row = timeTaken.length;
      _totalDurationInSeconds = 0;
      _totalDistanceInMeter   = 0;
      for(int i = 0 ; i < row - 1; i++){
        double second = timeTaken[i][i + 1];
        double d = distance[i][i+1] ;
        _totalDurationInSeconds += second.toInt();
        _totalDistanceInMeter += d.toInt();
      }

      Set<Polyline> polyLine = {};
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

      _constructView(marker, polyLine, currentLocation);
      _animateCameraToRouteBound(controller, routeCoordinate);
      _callBackNotifyChanges();
    }
  }

  String getTotalDistance()
  {
    int totalDistance = _totalDistanceInMeter;
    int kiloMeter = totalDistance ~/ 1000;
    totalDistance %= 1000;
    int meter = totalDistance;

    if(kiloMeter > 0)
      return kiloMeter.toString() + " km";
    else
      return meter.toString() + " m";
  }

  String getTotalDurations()
  {
    int minute = _totalDurationInSeconds ~/ 60;
    int hour = minute ~/ 60;
    minute %= 60;

    if(hour > 0)
      return hour.toString() +  " h " + minute.toString() + " min";
    else
      return minute.toString() + " min";
  }

  void setGoogleMapController(GoogleMapController controller)
  {
    _mapControllerCompleter.complete(controller);
  }

  void _animateCameraToRouteBound(GoogleMapController controller, List<LatLng> routeCoordinate)
  {
    double maxLat, minLat, maxLon, minLon;
    maxLat = minLat = routeCoordinate[0].latitude;
    maxLon = minLon = routeCoordinate[0].longitude;

    for (int i = 1; i < routeCoordinate.length; i ++) {
      maxLat = max(maxLat, routeCoordinate[i].latitude);
      minLat = min(minLat, routeCoordinate[i].latitude);
      maxLon = max(maxLon, routeCoordinate[i].longitude);
      minLon = min(minLon, routeCoordinate[i].longitude);
    }

    controller.animateCamera(
        CameraUpdate.newLatLngBounds(
            LatLngBounds(
                southwest: LatLng(
                    minLat,
                    minLon
                ),
                northeast: LatLng(
                    maxLat,
                    maxLon
                )
            ),
            17 // Padding
        )
    );
  }

  void _constructView(List<Marker>marker, Set<Polyline> polyLine, LatLng currentLocation)
  {
    debug.log("Constructing google map");
    _googleMap = GoogleMap(
        mapType: MapType.normal,
        markers: Set.from(marker),
        polylines:polyLine,
        onMapCreated:setGoogleMapController,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target:currentLocation,
          zoom:_INITIAL_CAMERA_ZOOM_RATIO,
        )
    );

    _navigationButton = RoundedButton(
        text: "Navigation",
        press: (){
          try {
            AppLauncher.openMap(
                latLng: [currentLocation.latitude, currentLocation.longitude, destination.latitude, destination.longitude]
            );
          }
          catch(e){
            _callBackShowAlertDialog("Error", e);
          }
        }
    );
  }

  GoogleMap getMap()
  {
    if(_googleMap == null) {
      debug.log("Map is null");
      return GoogleMap(
          onMapCreated:setGoogleMapController,
          initialCameraPosition: CameraPosition(
            target: destination,
            zoom: _INITIAL_CAMERA_ZOOM_RATIO,
          )
      );
    }
    return _googleMap;
  }


  RoundedButton getNavigationButton()
  {
    if(_navigationButton == null) {
      debug.log("Navigation button is null");
      return RoundedButton(
        text: "Navigation",
      );
    }
    return _navigationButton;
  }
}
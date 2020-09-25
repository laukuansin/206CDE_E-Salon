import 'dart:async';
import 'dart:developer' as debug;
<<<<<<< HEAD
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Utility/app_launcher.dart';
import 'package:gps_tracking_system/Utility/rest_api.dart';
import 'package:gps_tracking_system/components/rounded_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';

class ViewModel
{
  static const double _INITIAL_CAMERA_ZOOM_RATIO = 14.0;

  final Completer<GoogleMapController> _mapControllerCompleter;
  final Function _callBackNotifyChanges;
  final Function(String, String) _callBackShowAlertDialog;

  GoogleMap _googleMap;
  RoundedButton _navigationButton;
  LatLng destination;
  int _totalDistanceInMeter, _totalDurationInSeconds;

  ViewModel({@required this.destination, @required Function notifyChanges, Function showAlertDialog}):
        _mapControllerCompleter = Completer(),
=======
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Utility/app_launcher.dart';
import 'package:gps_tracking_system/Utility/map_helper.dart';
import 'package:gps_tracking_system/Utility/rest_api.dart';
import 'package:gps_tracking_system/components/rounded_button.dart';
import 'dart:math';
import 'dart:ui' as ui;

class ViewModel
{
  // Config
  static const double _INITIAL_CAMERA_ZOOM_RATIO  = 14.0;
  static const double _MAP_BOUNDS_PADDING         = 30.0;
  static const int _CAR_MARKER_SIZE               = 75;
  static const String _MARKER_DESTINATION_ID      = "destination";
  static const String _MARKER_ORIGIN_ID           = "origin";
  static const int _REFRESH_RATE                  = 30;

  final Set<Marker> markerSet = {
    Marker(markerId: MarkerId(_MARKER_DESTINATION_ID)),
    Marker(markerId: MarkerId(_MARKER_ORIGIN_ID))
  };


  final Function _callBackNotifyChanges;
  final Function(String, String) _callBackShowAlertDialog;
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();

  Uint8List _carMarkerIcon; double _carMarkerIconRotation;
  String customerAddress;
  LatLng _customerLatLng, workerLatLng;
  int _totalDistanceInMeter, _totalDurationInSeconds;

  ViewModel({@required this.customerAddress, @required this.workerLatLng, @required Function notifyChanges, Function showAlertDialog}):
        _customerLatLng = LatLng(0,0),
        _carMarkerIconRotation = 0,
>>>>>>> development
        _callBackNotifyChanges = notifyChanges,
        _callBackShowAlertDialog = showAlertDialog,
        _totalDurationInSeconds = 0,
        _totalDistanceInMeter = 0 {
    this.initRoute();
  }

<<<<<<< HEAD
  // calculate time, calculate distance
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

    _constructView(marker, currentLocation);
    _animateCameraToRouteBound(controller, currentLocation);
    _callBackNotifyChanges();
  }

=======
  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  Future<void> initRoute({bool isWorkerReady = true}) async
  {
    if(_carMarkerIcon == null){
      _carMarkerIcon = await _getBytesFromAsset('assets/images/car.png', _CAR_MARKER_SIZE);
    }

    _customerLatLng = await MapHelper.addressToLatLng(customerAddress);

    _calcDurationDistance(); // Async but i don't care if you slow, so no need await
    updateMarkerLocation();

    // Animate camera if worker lat lng not ready
    if(!isWorkerReady) {
      animateCameraToRouteBound();
    }

    _callBackNotifyChanges();
  }

  void updateWorkerLocation(bool isWorkerReady, LatLng newWorkerLatLng){
    _carMarkerIconRotation = bearingBetween(this.workerLatLng.latitude, this.workerLatLng.longitude, newWorkerLatLng.latitude, newWorkerLatLng.longitude);
    this.workerLatLng = newWorkerLatLng;
    initRoute(isWorkerReady: isWorkerReady);
  }

  void updateMarkerLocation(){
    markerSet.clear();

    // Add dest marker
    markerSet.add(
      Marker(
        markerId: MarkerId(_MARKER_DESTINATION_ID),
        position: _customerLatLng,
      )
    );

    // Add src marker
    markerSet.add(
      Marker(
        markerId: MarkerId(_MARKER_ORIGIN_ID),
        rotation: _carMarkerIconRotation,
        position: workerLatLng,
        draggable: false,
        zIndex: 2,
        flat: true,
        icon: BitmapDescriptor.fromBytes(_carMarkerIcon)
      )
    );
  }

>>>>>>> development
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

<<<<<<< HEAD
  void _animateCameraToRouteBound(GoogleMapController controller, LatLng currentLocation)
  {
    double maxLat, minLat, maxLon, minLon;
    maxLat = max(currentLocation.latitude, destination.latitude);
    maxLon = max(currentLocation.longitude, destination.longitude);
    minLat = min(currentLocation.latitude, destination.latitude);
    minLon = min(currentLocation.longitude, destination.longitude);
=======
  Future<void> _calcDurationDistance() async {
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
    Map<String, dynamic> jsonTimeTakenAndDistance = await RestApi
        .getRouteTimeDistance([workerLatLng, _customerLatLng]);

    try {
      List<dynamic> timeTaken = jsonTimeTakenAndDistance["durations"];
      List<dynamic> distance = jsonTimeTakenAndDistance["distances"];

      int row = timeTaken.length;
      _totalDurationInSeconds = 0;
      _totalDistanceInMeter = 0;
      for (int i = 0; i < row - 1; i++) {
        double second = timeTaken[i][i + 1];
        double d = distance[i][i + 1];
        _totalDurationInSeconds += second.toInt();
        _totalDistanceInMeter += d.toInt();
      }
    }
    catch (error) {
      debug.log(error.toString());
    }
  }

  void animateCameraToRouteBound() async
  {
    GoogleMapController controller = await _mapControllerCompleter.future;
    double maxLat, minLat, maxLon, minLon;
    maxLat = max(workerLatLng.latitude, _customerLatLng.latitude);
    maxLon = max(workerLatLng.longitude, _customerLatLng.longitude);
    minLat = min(workerLatLng.latitude, _customerLatLng.latitude);
    minLon = min(workerLatLng.longitude, _customerLatLng.longitude);
>>>>>>> development

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
<<<<<<< HEAD
            17 // Padding
=======
            _MAP_BOUNDS_PADDING // Padding
>>>>>>> development
        )
    );
  }

<<<<<<< HEAD
  void _constructView(List<Marker>marker, LatLng currentLocation)
  {
    debug.log("Constructing google map");
    _googleMap = GoogleMap(
        mapType: MapType.normal,
        markers: Set.from(marker),
        onMapCreated:setGoogleMapController,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target:currentLocation,
          zoom:_INITIAL_CAMERA_ZOOM_RATIO,
        )
    );

    _navigationButton = RoundedButton(
=======
  GoogleMap buildMap() => GoogleMap(
        mapType: MapType.normal,
        markers: markerSet,
        onMapCreated: setGoogleMapController,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: workerLatLng,
          zoom: _INITIAL_CAMERA_ZOOM_RATIO,
        )
    );


  RoundedButton buildNavigationButton()=>
    RoundedButton(
>>>>>>> development
        text: "Navigation",
        press: (){
          try {
            AppLauncher.openMap(
<<<<<<< HEAD
                latLng: [currentLocation.latitude, currentLocation.longitude, destination.latitude, destination.longitude]
=======
                srcLatLng: [workerLatLng.latitude, workerLatLng.longitude],
                destAddress: customerAddress
>>>>>>> development
            );
          }
          catch(e){
            _callBackShowAlertDialog("Error", e);
          }
        }
    );
<<<<<<< HEAD
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
=======
>>>>>>> development
}
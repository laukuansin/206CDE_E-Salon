import 'dart:async';
import 'dart:developer' as debug;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Utility/app_launcher.dart';
import 'package:gps_tracking_system/Utility/map_helper.dart';
import 'package:gps_tracking_system/Utility/rest_api.dart';
import 'package:gps_tracking_system/components/rounded_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
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

  final Map<String, Marker> markerList = {
    _MARKER_DESTINATION_ID:  Marker(markerId: MarkerId(_MARKER_DESTINATION_ID)),
    _MARKER_ORIGIN_ID: Marker(markerId: MarkerId(_MARKER_ORIGIN_ID))
  };

  final String _apiKey = "AIzaSyDZtEhhzbICEi7JpTlTD9qjfYK1V5NIYmM";
  final Function _callBackNotifyChanges;
  final Function(String, String) _callBackShowAlertDialog;
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();

  GoogleMap _googleMap;
  RoundedButton _navigationButton;
  Uint8List _carMarkerIcon;
  String destAddress;
  LatLng _customerLatLng, _workerLatLng;
  int _totalDistanceInMeter, _totalDurationInSeconds;

  ViewModel({@required this.destAddress, @required Function notifyChanges, Function showAlertDialog}):
        _customerLatLng = LatLng(0,0),
        _callBackNotifyChanges = notifyChanges,
        _callBackShowAlertDialog = showAlertDialog,
        _totalDurationInSeconds = 0,
        _totalDistanceInMeter = 0 {
    this.initRoute();
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }


  Future<void> initRoute() async
  {
    // Get permission
    if (!await Permission.location
        .request()
        .isGranted)
      exit(-1);

    final Future<Uint8List> carMarkerIconFuture = _getBytesFromAsset('assets/images/car.png', _CAR_MARKER_SIZE);
    final Future<LatLng> destLatLngFuture = MapHelper.addressToLatLng(destAddress, _apiKey);

    _workerLatLng= MapHelper.positionToLatLng(await getCurrentPosition());
    _customerLatLng = await destLatLngFuture;
    final Future<void> calculateDistanceFuture = _calcDurationDistance();

    // Wait map created
    _carMarkerIcon = await carMarkerIconFuture;
    updateMarkerLocation(_workerLatLng);
    GoogleMapController controller = await _mapControllerCompleter.future;

    
    await calculateDistanceFuture;
    _constructView();
    _animateCameraToRouteBound(controller);
    _callBackNotifyChanges();
  }


  void updateMarkerLocation(LatLng originLocation){
    // Add dest marker
    markerList[_MARKER_DESTINATION_ID] = Marker(
      markerId: MarkerId(_MARKER_DESTINATION_ID),
      position: _customerLatLng,
    );

    // Add src marker
    markerList[_MARKER_ORIGIN_ID] = Marker(
      markerId: MarkerId("origin"),
      rotation: bearingBetween(_workerLatLng.latitude, _workerLatLng.longitude, originLocation.latitude, originLocation.longitude),
      position: originLocation,
      draggable: false,
      zIndex: 2,
      flat: true,
      icon: BitmapDescriptor.fromBytes(_carMarkerIcon)
    );

    _workerLatLng = originLocation;
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

  Future<void> _calcDurationDistance() async{
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
    Map<String, dynamic> jsonTimeTakenAndDistance = await RestApi.getRouteTimeDistance([_workerLatLng,_customerLatLng]);
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
  }

  void _animateCameraToRouteBound(GoogleMapController controller)
  {
    double maxLat, minLat, maxLon, minLon;
    maxLat = max(_workerLatLng.latitude, _customerLatLng.latitude);
    maxLon = max(_workerLatLng.longitude, _customerLatLng.longitude);
    minLat = min(_workerLatLng.latitude, _customerLatLng.latitude);
    minLon = min(_workerLatLng.longitude, _customerLatLng.longitude);

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
            _MAP_BOUNDS_PADDING // Padding
        )
    );
  }

  void _constructView()
  {
    debug.log("Constructing google map");

    Set<Marker>markerSet = {};
    markerList.forEach((key, value) {markerSet.add(value);});

    _googleMap = GoogleMap(
        mapType: MapType.normal,
        markers: markerSet,
        onMapCreated:setGoogleMapController,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target:_workerLatLng,
          zoom:_INITIAL_CAMERA_ZOOM_RATIO,
        )
    );

    _navigationButton = RoundedButton(
        text: "Navigation",
        press: (){
          try {
            AppLauncher.openMap(
              srcLatLng: [_workerLatLng.latitude, _workerLatLng.longitude],
              destAddress: destAddress
            );
          }
          catch(e){
            _callBackShowAlertDialog("Error", e);
          }
        }
    );
  }

  GoogleMap buildMap()
  {
    if(_googleMap == null) {
      debug.log("Map is null");
      return GoogleMap(
          onMapCreated:setGoogleMapController,
          initialCameraPosition: CameraPosition(
            target: _customerLatLng,
            zoom: _INITIAL_CAMERA_ZOOM_RATIO,
          )
      );
    }
    return _googleMap;
  }


  RoundedButton buildNavigationButton()
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
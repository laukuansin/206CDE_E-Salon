import 'dart:async';
import 'dart:developer' as debug;
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Utility/app_launcher.dart';
import 'package:gps_tracking_system/Utility/map_helper.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/Components/rounded_button.dart';
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


  void setGoogleMapController(GoogleMapController controller)
  {
    _mapControllerCompleter.complete(controller);
  }

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
    Map<String, int> timeDistance = await MapHelper
        .getRouteTimeDistance([workerLatLng, _customerLatLng]);
    _totalDurationInSeconds = timeDistance['duration'];
    _totalDistanceInMeter   = timeDistance['distance'];

  }

  void animateCameraToRouteBound() async
  {
    GoogleMapController controller = await _mapControllerCompleter.future;
    double maxLat, minLat, maxLon, minLon;
    maxLat = max(workerLatLng.latitude, _customerLatLng.latitude);
    maxLon = max(workerLatLng.longitude, _customerLatLng.longitude);
    minLat = min(workerLatLng.latitude, _customerLatLng.latitude);
    minLon = min(workerLatLng.longitude, _customerLatLng.longitude);

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
        text: "Navigation",
        press: (){
          try {
            AppLauncher.openMap(
                srcLatLng: [workerLatLng.latitude, workerLatLng.longitude],
                destAddress: customerAddress
            );
          }
          catch(e){
            _callBackShowAlertDialog("Error", e);
          }
        }
    );

}
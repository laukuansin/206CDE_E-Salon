import 'dart:async';
import 'dart:developer' as debug;
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  final Set<Marker> markerSet = {
    Marker(markerId: MarkerId(_MARKER_DESTINATION_ID)),
    Marker(markerId: MarkerId(_MARKER_ORIGIN_ID))
  };

  final Set<Polyline> _polyLine = {};


  final Function _callBackNotifyChanges;
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();

  Uint8List _carMarkerIcon; double _carMarkerIconRotation;
  String customerAddress;
  LatLng _customerLatLng, workerLatLng;
  List<LatLng> latLngPolylineList;

  ViewModel({@required this.customerAddress, @required this.workerLatLng, @required Function notifyChanges, @required this.latLngPolylineList}):
        _customerLatLng = LatLng(0,0),
        _carMarkerIconRotation = 0,
        _callBackNotifyChanges = notifyChanges{
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

    if(workerLatLng != null)
      _calcDurationDistance(); // Async but i don't care if you slow, so no need await
    updateMarkerLocation();

    // Animate camera if worker lat lng not ready
    if(workerLatLng == null ||  !isWorkerReady) {
      animateCameraToRouteBound();
    }

    _callBackNotifyChanges();
  }

  void updateWorkerLocation(bool isWorkerReady, LatLng newWorkerLatLng){
    _carMarkerIconRotation = bearingBetween((this.workerLatLng??newWorkerLatLng).latitude, (this.workerLatLng??newWorkerLatLng).longitude, newWorkerLatLng.latitude, newWorkerLatLng.longitude);
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
    if(workerLatLng != null) {
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
  }

  void animateCameraToRouteBound() async
  {
    GoogleMapController controller = await _mapControllerCompleter.future;

    double maxLat, minLat, maxLon, minLon;
    if(latLngPolylineList.isNotEmpty) {
      maxLat = (latLngPolylineList.reduce((value, element) => value.latitude > element.latitude? value : element)).latitude;
      maxLon = (latLngPolylineList.reduce((value, element) => value.longitude > element.longitude? value : element)).longitude;
      minLat = (latLngPolylineList.reduce((value, element) => value.latitude < element.latitude? value : element)).latitude;
      minLon = (latLngPolylineList.reduce((value, element) => value.longitude < element.longitude? value : element)).longitude;
    }

    else if(workerLatLng != null) {
      maxLat = max(workerLatLng.latitude, _customerLatLng.latitude);
      maxLon = max(workerLatLng.longitude, _customerLatLng.longitude);
      minLat = min(workerLatLng.latitude, _customerLatLng.latitude);
      minLon = min(workerLatLng.longitude, _customerLatLng.longitude);
    }

    else{
      maxLat = _customerLatLng.latitude + 0.001;
      minLat = _customerLatLng.latitude - 0.001;
      maxLon = _customerLatLng.longitude + 0.001;
      minLon = _customerLatLng.longitude - 0.001;
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
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
    });
  }

  GoogleMap buildMap() {
    if(latLngPolylineList.isNotEmpty){
      markerSet.clear();
      markerSet.add(
          Marker(
            markerId: MarkerId(_MARKER_DESTINATION_ID),
            position: latLngPolylineList.last,
          )
      );

      markerSet.add(
          Marker(
              markerId: MarkerId(_MARKER_ORIGIN_ID),
              rotation: _carMarkerIconRotation,
              position: latLngPolylineList.first,
              draggable: false,
              zIndex: 2,
              flat: true,
              icon: BitmapDescriptor.fromBytes(_carMarkerIcon)
          )
      );

      _polyLine.add(
          Polyline(
            polylineId: PolylineId(latLngPolylineList.last.toString()),
            visible: true,
            points: latLngPolylineList,
            color: Colors.blue,
            width: 3
          )
      );

      return GoogleMap(
          polylines: _polyLine,
          mapType: MapType.normal,
          markers: markerSet,
          onMapCreated: setGoogleMapController,
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
            target: workerLatLng == null ? _customerLatLng : workerLatLng,
            zoom: _INITIAL_CAMERA_ZOOM_RATIO,
          )
      );
    }

    return GoogleMap(
        mapType: MapType.normal,
        markers: markerSet,
        onMapCreated: setGoogleMapController,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: workerLatLng == null ? _customerLatLng : workerLatLng,
          zoom: _INITIAL_CAMERA_ZOOM_RATIO,
        )
    );
  }

}
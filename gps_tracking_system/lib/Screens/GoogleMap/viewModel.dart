import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Utility/AppLauncher.dart';
import 'package:gps_tracking_system/components/rounded_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';

class ViewModel
{
  final String _apiKey;
  final double _initialZoomRatio;
  final Set<Polyline> _polyLine;
  final GoogleMapPolyline _googleMapPolyLine;
  final List<Marker> _marker;
  final Completer<GoogleMapController> _mapControllerCompleter;
  final Function _callBackNotifyChanges;
  final Function(String, String) _callBackShowAlertDialog;

  LatLng destination;
  LatLng currentLocation;
  List<LatLng> routeCoordinate;

  double get initialZoomRatio => _initialZoomRatio;

  ViewModel({@required this.destination, @required Function notifyChanges, Function showAlertDialog}):
        _apiKey =  "AIzaSyDZtEhhzbICEi7JpTlTD9qjfYK1V5NIYmM",
        _initialZoomRatio = 14.0,
        _polyLine = {},
        _googleMapPolyLine = new GoogleMapPolyline(apiKey: "AIzaSyDZtEhhzbICEi7JpTlTD9qjfYK1V5NIYmM"),
        _marker = [],
        _mapControllerCompleter = Completer(),
        _callBackNotifyChanges = notifyChanges,
        _callBackShowAlertDialog = showAlertDialog,
        currentLocation = destination
  {
    this.initRoute();
  }

  String get apiKey => _apiKey;
  Set<Polyline> get polyLine => _polyLine;
  GoogleMapPolyline get googleMapPolyLine => _googleMapPolyLine;
  List<Marker> get marker => _marker;

  Future<void> initRoute() async
  {
    if (!await Permission.location
        .request()
        .isGranted)
      exit(-1);

    // Get current location
    final Position position = await getCurrentPosition();
    currentLocation = LatLng(
        position.latitude,
        position.longitude
    );

    // Find list of coordinate for route
    routeCoordinate = await _googleMapPolyLine
        .getCoordinatesWithLocation(
        origin: currentLocation,
        destination: destination,
        mode: RouteMode.driving
    );

    if (routeCoordinate == null || routeCoordinate.length <= 0) {
        _callBackShowAlertDialog("Oops!",
            "We could not calculate driving directions from your current location to destination.");
    }
    else {
      GoogleMapController controller = await _mapControllerCompleter.future;
      _animateCameraToRouteBound(controller, routeCoordinate);

      _marker.add(
          Marker(
            markerId: MarkerId(destination.toString()),
            position: destination,
          )
      );

      _marker.add(
          Marker(
              markerId: MarkerId(currentLocation.toString()),
              position: currentLocation,
              icon: await BitmapDescriptor.fromAssetImage(
                  ImageConfiguration(size: Size(40, 40)),
                  "assets/images/car.png")
          )
      );

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

      _callBackNotifyChanges();
    }
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

  GoogleMap getMap()
  {
    return GoogleMap(
        mapType: MapType.normal,
        markers: Set.from(marker),
        polylines:polyLine,
        onMapCreated:setGoogleMapController,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target:currentLocation,
          zoom:initialZoomRatio,
        )
    );
  }

  RoundedButton getNavigationButton()
  {
    return RoundedButton(
        text: "Navigation",
        press: (){
          try {
            AppLauncher.openMap(
              address: '38,Lorong 7 / SS9, Bandar Tasek Mutiara, 14120, Simpang Ampat, Pulau Pinang',
              // latLng: destination
            );
          }
          catch(e){
            _callBackShowAlertDialog("Error", e);
          }
        }
    );
  }
}


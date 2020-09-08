import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/components/rounded_button.dart';
import 'package:gps_tracking_system/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {

  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}


class GoogleMapScreen extends StatefulWidget{
  final Position destination;

  @override
  State<StatefulWidget> createState() => GoogleMapScreenState();
  GoogleMapScreen({Key key, this.destination}): super(key:key);
}

class GoogleMapScreenState extends State<GoogleMapScreen>{

  static const String _M_API_KEY = "AIzaSyDZtEhhzbICEi7JpTlTD9qjfYK1V5NIYmM";
  final Set<Polyline> _polyLine = {};
  final GoogleMapPolyline _googleMapPolyLine = new GoogleMapPolyline(apiKey: _M_API_KEY);
  final double _initialZoomRatio = 14.0;
  final List<Marker> _marker = [];

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

    GoogleMapController controller = await mapControllerCompleter.future;

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
    List<LatLng> routeCoordinate = await _googleMapPolyLine.getCoordinatesWithLocation(
        origin: currentLocation,
        destination: destination,
        mode: RouteMode.driving
    );

    if(routeCoordinate == null) {
      SchedulerBinding.instance.addPostFrameCallback((_)=>{
        showAlertDialog(context)
      });
      return;
    }

    if(routeCoordinate.length > 0) {
      double maxLat, minLat, maxLon, minLon;
      maxLat = minLat = routeCoordinate[0].latitude;
      maxLon = minLon = routeCoordinate[0].longitude;

      for (int i = 1; i < routeCoordinate.length; i ++) {
        maxLat = max(maxLat, routeCoordinate[i].latitude);
        minLat = min(minLat, routeCoordinate[i].latitude);
        maxLon = max(maxLon, routeCoordinate[i].longitude);
        minLon = min(minLon, routeCoordinate[i].longitude);
      }

      LatLngBounds bounds = new LatLngBounds(
          southwest: LatLng(
            minLat,
            minLon
          ),
          northeast: LatLng(
            maxLat,
            maxLon
          )
      );

      controller.animateCamera(
          CameraUpdate.newLatLngBounds(
              bounds,
              17
          )
      );
    }

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
        icon:await BitmapDescriptor.fromAssetImage(ImageConfiguration(size:Size(40,40)), "assets/images/car.png")
      )
    );

    // Update the state
    setState(() {
      _polyLine.add(
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:Container(
        width:size.width,
        height:size.height,
        child:Stack(
            children: <Widget>[
              SizedBox(
                width:size.width,
                height:size.height,
                child:GoogleMap(
                  onMapCreated: onMapCreated,
                  polylines: _polyLine,
                  initialCameraPosition: CameraPosition(
                    target: currentLocation,
                    zoom: _initialZoomRatio,
                  ),
                  mapType: MapType.normal,
                  markers: Set.from(_marker),
                )
              ),

            Positioned(
              bottom: 0,
              left: 0,
              child: FlatButton(
                color:kPrimaryColor,
                child:Text(
                  "Navigation",
                  style:TextStyle(
                    color: kPrimaryLightColor
                  ),
                ),
                onPressed: navigateToMap,
              ),
            )
          ]
        )
      )
    );
  }

  void onMapCreated(GoogleMapController controller) {
      mapControllerCompleter.complete(controller);
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Oops!"),
          content: Text("Route not found."),
          actions: [
            FlatButton(
              child: Text("Ok"),
              onPressed: (){Navigator.pop(context);},
            )
          ]
        );
      }
    );
  }

  void navigateToMap()
  {
    MapUtils.openMap(destination.latitude, destination.longitude);
  }
}
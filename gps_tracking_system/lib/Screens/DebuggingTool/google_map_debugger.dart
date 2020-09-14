import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Model/Worker.dart';
import 'package:gps_tracking_system/Screens/GoogleMap/googlemap_screen.dart';
import 'package:gps_tracking_system/Utility/map_helper.dart';
import 'package:permission_handler/permission_handler.dart';


class GoogleMapDebugger extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_GoogleMapDebuggerState();
}

class _GoogleMapDebuggerState extends State<GoogleMapDebugger>{

  Worker worker;
  final GlobalKey<GoogleMapScreenState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMapScreen(
        key: _key,
        workerLatLng: worker.latLng(),
        customerAddress: "Sunshine Farlim",
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    worker = Worker(workerId: "P18010220", syncDB: true, callback: callBackFromModel);
    initRealTimeLocationUpdate();
  }

  void initRealTimeLocationUpdate() async{
    Timer timer = Timer.periodic(Duration(seconds: 5), (timer) async{
      Position position = await getCurrentPosition();
      worker.setLatLng(position);
    });
  }

  void callBackFromModel(double latitude, double longitude){
    _key.currentState.updateWorkerLocation(LatLng(latitude, longitude));
  }
}
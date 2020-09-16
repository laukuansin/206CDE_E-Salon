import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Model/User.dart';
import 'package:gps_tracking_system/Model/Worker.dart';
import 'package:gps_tracking_system/Screens/GoogleMap/googlemap_screen.dart';
import 'package:gps_tracking_system/Utility/real_time_db.dart';

class GoogleMapDebugger extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_GoogleMapDebuggerState(Worker(workerId: "P18010220"));
}

class _GoogleMapController{
  final Worker _worker;
  final Function(double, double) _workerLocationUpdated;
  Timer _timer;

  _GoogleMapController({
    @required Worker worker,
    @required Function(double, double)workerLocationUpdated,
    Duration refreshRate = const Duration(seconds: 5)
  })
      :_worker = worker,
      _workerLocationUpdated = workerLocationUpdated
  {
    if(User.isAuthenticated()) {
      switch(User.getRole()){
        case Role.CUSTOMER:
          RealTimeDb.onWorkerLocationChanges(worker.workerId, _locationReceived);
          break;

        case Role.WORKER:
          _timer = Timer.periodic(refreshRate, (timer) {
            _sendRealtimeLocation();
          });
          break;

        case Role.OWNER:
          break;
      }
    }
  }

  void _locationReceived(double latitude, double longitude){
    _worker.latitude = latitude;
    _worker.longitude = longitude;
    _workerLocationUpdated(latitude, longitude);
  }

  void _sendRealtimeLocation() async{
    Position position = await getCurrentPosition();
    _worker.latitude = position.latitude;
    _worker.longitude = position.longitude;
    _workerLocationUpdated(position.latitude, position.longitude);
    RealTimeDb.saveWorkerChanges(_worker);
  }
}

class _GoogleMapDebuggerState extends State<GoogleMapDebugger>{

  bool _isWorkerReady;
  Worker _worker;
  _GoogleMapController _googleMapController;
  GlobalKey<GoogleMapScreenState> _key;

  _GoogleMapDebuggerState(Worker worker)
  {
    _isWorkerReady = false;
    _worker = worker;
    _googleMapController = _GoogleMapController(worker: worker, workerLocationUpdated: onLocationReceived);
    _key = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMapScreen(
        key: _key,
        workerLatLng: LatLng(_worker.latitude, _worker.longitude),
        customerAddress: "Sunshine Farlim",
      ),
    );
  }


  // Firebase will invoke the listener once even there is no changing. Hence, when the first value returned by firebase,
  // we need to animate the camera
  void onLocationReceived(double latitude, double longitude){
    _key.currentState.updateWorkerLocation(_isWorkerReady, LatLng(latitude, longitude));
    _isWorkerReady = true;
  }
}
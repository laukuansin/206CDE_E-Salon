import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gps_tracking_system/Model/User.dart';
import 'package:gps_tracking_system/Model/Worker.dart';
import 'package:gps_tracking_system/Utility/real_time_db.dart';

class GoogleMapListener{
  final Worker _worker;
  final Function(double, double) _workerLocationUpdated;
  Timer _timer;

  GoogleMapListener({
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
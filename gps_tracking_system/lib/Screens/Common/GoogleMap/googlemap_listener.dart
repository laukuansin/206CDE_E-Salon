import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gps_tracking_system/Model/location.dart';
import 'package:gps_tracking_system/Model/user.dart';
import 'package:gps_tracking_system/Model/worker.dart';
import 'package:gps_tracking_system/Model/worker_location.dart';
import 'package:gps_tracking_system/Utility/real_time_db.dart';

class GoogleMapListener{
  final WorkerLocation _workerLocation;
  final Function(double, double) _workerLocationUpdated;
  Timer _timer;

  GoogleMapListener({
    @required Worker worker,
    @required Function(double, double)workerLocationUpdated,
    Duration refreshRate = const Duration(seconds: 5)
  })
      :_workerLocation = WorkerLocation(workerId: worker.id),
        _workerLocationUpdated = workerLocationUpdated
  {
    if(User.isAuthenticated()) {
      switch(User.getRole()){
        case Role.CUSTOMER:
          RealTimeDb.onWorkerLocationChanges(worker.id, _locationReceived);
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
    _workerLocation.latitude = latitude;
    _workerLocation.longitude = longitude;
    _workerLocationUpdated(latitude, longitude);
  }

  void _sendRealtimeLocation() async{
    Position position = await getCurrentPosition();
    _workerLocation.latitude = position.latitude;
    _workerLocation.longitude = position.longitude;
    _workerLocationUpdated(position.latitude, position.longitude);
    RealTimeDb.saveWorkerChanges(_workerLocation);
  }
}
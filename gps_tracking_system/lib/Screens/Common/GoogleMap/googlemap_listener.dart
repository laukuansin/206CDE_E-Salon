import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gps_tracking_system/Model/logged_user.dart';
import 'package:gps_tracking_system/Model/worker_location.dart';
import 'package:gps_tracking_system/Utility/real_time_db.dart';

class GoogleMapListener{
  static const platForm = const MethodChannel('gps_tracking_system/firebase');
  final String appointmentId;
  final WorkerLocation _workerLocation;
  final Function(double, double) _workerLocationUpdated;

  GoogleMapListener({
    @required this.appointmentId,
    @required String workerId,
    @required Function(double, double)workerLocationUpdated,
  })
      :_workerLocation = WorkerLocation(workerId: workerId),
       _workerLocationUpdated = workerLocationUpdated;

  Future<void> startServices()async{
    switch(LoggedUser.getRole()){
      case Role.CUSTOMER:
        RealTimeDb.startListenWorkerLocationChanges(_workerLocation.workerId, _locationReceived);
        break;

      case Role.WORKER:
        platForm.invokeMethod('firebaseAutoLocationUpdateService',{"worker_id": _workerLocation.workerId, "appointment_id": appointmentId});
        RealTimeDb.startListenWorkerLocationChanges(_workerLocation.workerId, _locationReceived);
        break;

      case Role.OWNER:
        RealTimeDb.startListenWorkerLocationChanges(_workerLocation.workerId, _locationReceived);
        break;
    }
  }

  Future<void> stopServices()async{
    switch(LoggedUser.getRole()){
      case Role.CUSTOMER:
        RealTimeDb.stopListenWorkerLocationChanges();
        break;

      case Role.WORKER:
        platForm.invokeMethod('stopFirebaseAutoLocationUpdateService');
        RealTimeDb.stopListenWorkerLocationChanges();
        break;

      case Role.OWNER:
        RealTimeDb.stopListenWorkerLocationChanges();
        break;
    }
  }

  void _locationReceived(double latitude, double longitude){
    _workerLocation.latitude = latitude;
    _workerLocation.longitude = longitude;
    _workerLocationUpdated(latitude, longitude);
  }

}
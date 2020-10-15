import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gps_tracking_system/Model/logged_user.dart';
import 'package:gps_tracking_system/Model/worker_location.dart';
import 'package:gps_tracking_system/Utility/real_time_db.dart';

class GoogleMapListener{
  static const platForm = const MethodChannel('gps_tracking_system/firebase');
  final WorkerLocation _workerLocation;
  final Function(double, double) _workerLocationUpdated;

  GoogleMapListener({
    @required String workerId,
    @required Function(double, double)workerLocationUpdated,
  })
      :_workerLocation = WorkerLocation(workerId: workerId),
       _workerLocationUpdated = workerLocationUpdated;

  void startServices(){
    switch(LoggedUser.getRole()){
      case Role.CUSTOMER:
        RealTimeDb.startListenWorkerLocationChanges(_workerLocation.workerId, _locationReceived);
        break;

      case Role.WORKER:
        platForm.invokeMethod('firebaseAutoLocationUpdateService',{"worker_id": _workerLocation.workerId});
        RealTimeDb.startListenWorkerLocationChanges(_workerLocation.workerId, _locationReceived);
        break;

      case Role.OWNER:
        RealTimeDb.startListenWorkerLocationChanges(_workerLocation.workerId, _locationReceived);
        break;
    }
  }

  void stopServices(){
    switch(LoggedUser.getRole()){
      case Role.CUSTOMER:
        RealTimeDb.stopListenWorkerLocationChanges();
        break;

      case Role.WORKER:
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
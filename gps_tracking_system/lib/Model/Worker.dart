import 'package:flutter/cupertino.dart';
import 'package:gps_tracking_system/Utility/real_time_db.dart';
import 'dart:developer';

class Worker{
  static const String KEY_WORKER_ID  = "WorkerID";
  static const String KEY_LATITUDE   = "Lat";
  static const String KEY_LONGITUDE  = "Lon";
  static const String KEY_CUSTOMER_ID   = "CustomerID";

  final String workerId;
  double latitude;
  double longitude;
  String customerId;

  /*
  READ ME
  -------
  Parameter syncDB is used to synchronize latitude and longitude with firebase.
  1. If end user is worker, please pass false to syncDB to avoid callback
  2. If end user is customer, please pass true to syncDB to invoke callback.
   */
  Worker({
    @required workerId,
    @required syncDB,
    latitude = 0.0,
    longitude=0.0,
    customerId="",
  }):
    workerId = workerId,
    latitude = latitude,
    longitude = longitude,
    customerId = customerId{

    if(syncDB){
      RealTimeDb.onWorkerLocationChanges(workerId, _updateLatLonFromDB);
    }
  }

  void _updateLatLonFromDB(double latitude, double longitude){
    log("Latitude and longitude updated to ${latitude.toString()} , ${longitude.toString()}");
    latitude = latitude;
    longitude = longitude;
  }

  void save() {
    RealTimeDb.saveWorkerChanges(this);
  }

}
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Utility/real_time_db.dart';
import 'dart:developer';

class Worker{
  static const String KEY_WORKER_ID  = "WorkerID";
  static const String KEY_LATITUDE   = "Lat";
  static const String KEY_LONGITUDE  = "Lon";
  static const String KEY_CUSTOMER_ID   = "CustomerID";

  final String workerId;
  double latitude = 0.0;
  double longitude = 0.0;
  String customerId = "";
  Function(double, double) callback;
  bool syncDB;

  /*
  READ ME
  -------
  Parameter syncDB is used to synchronize latitude and longitude with firebase.
  1. If end user is worker, please pass false to syncDB to avoid callback
  2. If end user is customer, please pass true to syncDB to invoke callback.
   */
  Worker({
    @required workerId,
    @required this.syncDB,
    this.latitude = 4.2105,
    this.longitude = 101.9758,
    this.customerId = "",
    this.callback
  }):
    workerId = workerId{
    if(syncDB){
      RealTimeDb.onWorkerLocationChanges(workerId, _updateLatLonFromDB);
      save();
    }
  }

  void _updateLatLonFromDB(double latitude, double longitude){
    log("Latitude and longitude updated to ${latitude.toString()} , ${longitude.toString()}");
    this.latitude = latitude;
    this.longitude = longitude;
    if(callback != null)
      callback(latitude, longitude);
  }

  void save() {
    RealTimeDb.saveWorkerChanges(this);
  }

  void remove(){
    RealTimeDb.removeWorker(workerId);
  }

  LatLng latLng()=>LatLng(latitude, longitude);
  void setLatLng(Position latLng){
    this.latitude = latLng.latitude; this.longitude = latLng.longitude;
    if(syncDB)
      save();
  }

}
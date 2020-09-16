import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:gps_tracking_system/Model/Worker.dart' as MyWorker;
import 'package:gps_tracking_system/Utility/rest_api.dart';


class RealTimeDb{

  /*
  Structure of Realtime DB
  ------------------------
  {
    worker:{
      workerId:{
        lat:
        lng:
      }
    },
    address:{
      customerAddress:{
        lat:
        lng:
      }
    }
  }

  address is a cache to minimize the api call
   */
  static const String KEY_WORKER_ID     = "WorkerID";
  static const String KEY_LATITUDE      = "Lat";
  static const String KEY_LONGITUDE     = "Lng";
  static const String KEY_CUSTOMER_ID   = "Customer";
  static const String GROUP_WORKER      = "Worker";
  static const String GROUP_ADDRESS     = "Address";
  static DatabaseReference _db          = FirebaseDatabase.instance.reference();
  static Map<String,List<double>> _localCache = {}; // Cache data to reduce number of calling firebase
  RealTimeDb._();

  static void saveWorkerChanges(MyWorker.Worker worker)
  {
    _db.child(GROUP_WORKER).child(worker.workerId).set({
      KEY_LATITUDE: worker.latitude,
      KEY_LONGITUDE: worker.longitude,
      KEY_CUSTOMER_ID: worker.customerId
    });
  }

  static void onWorkerLocationChanges(String workerId, Function(double,double) callBack)
  {
    if(callBack == null) return;

    // Firebase will automatically call this at first time even without changing value
    _db .child(GROUP_WORKER)
        .child(workerId)
        .onValue
        .listen((event) {
      var snapshot = event.snapshot;
      dynamic latitude = snapshot.value[KEY_LATITUDE];
      dynamic longitude = snapshot.value[KEY_LONGITUDE];

      callBack(
          latitude is double ? latitude : 0.0,
          longitude is double? longitude: 0.0
      );
    });
  }

  static void removeWorker(String workerId){
    _db.child(workerId).remove();
  }

  // Store lat and lng into cache to reduce latency
  static Future<List<double>> getAddressLatLng(String address)async{
    if (_localCache.containsKey(address)) return _localCache[address];

    List<double> coordinate = [];
    Map<dynamic, dynamic> snapshot =  (await _db.child(GROUP_ADDRESS).child(address).once()).value;
    if(snapshot == null) {
      Map<String,dynamic> json = await RestApi.addressToCoordinate(address);
      Map<String,dynamic> coord = json["results"][0]["geometry"]["location"];
      _db.child(GROUP_ADDRESS).child(address).set({KEY_LATITUDE: coord["lat"], KEY_LONGITUDE: coord["lng"]});
      coordinate = [coord["lat"], coord["lng"]];
    }
    else {
      coordinate = [snapshot[KEY_LATITUDE], snapshot[KEY_LONGITUDE]];
    }
    _localCache[address] = coordinate;
    return coordinate;
  }
}
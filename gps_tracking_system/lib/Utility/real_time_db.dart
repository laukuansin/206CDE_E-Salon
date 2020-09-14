import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:gps_tracking_system/Model/Worker.dart' as MyWorker;


class RealTimeDb{

  RealTimeDb._();

  static DatabaseReference _db = FirebaseDatabase.instance.reference();

  static void saveWorkerChanges(MyWorker.Worker worker)
  {
    _db.child(worker.workerId).set({
      MyWorker.Worker.KEY_LATITUDE: worker.latitude,
      MyWorker.Worker.KEY_LONGITUDE: worker.longitude,
      MyWorker.Worker.KEY_CUSTOMER_ID: worker.customerId
    });
  }

  static void onWorkerLocationChanges(String workerId, Function(double,double) callBack)
  {
    if(callBack != null) {
      _db
          .child(workerId)
          .onValue
          .listen((event) {
        var snapshot = event.snapshot;
        callBack(
            double.parse(
                snapshot.value[MyWorker.Worker.KEY_LATITUDE].toString()),
            double.parse(
                snapshot.value[MyWorker.Worker.KEY_LONGITUDE].toString())
        );
      });
    }
  }

  static void removeWorker(String workerId){
    _db.child(workerId).remove();
  }
}
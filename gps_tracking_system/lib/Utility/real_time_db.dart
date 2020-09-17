import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class RealTimeDb{

  static DatabaseReference _db;

  RealTimeDb._();

  static void createInstance()
  {
    if(_db == null)
      _db = FirebaseDatabase.instance.reference();
  }

}
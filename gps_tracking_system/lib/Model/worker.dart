import 'package:flutter/cupertino.dart';
import 'package:gps_tracking_system/Model/end_user.dart';

class Worker extends EndUser{

  double latitude;
  double longitude;

  Worker(String workerId,
      {
        this.latitude = 4.2105,
        this.longitude = 101.9758,
        String contactNo,
        String name,
      }):
    super(workerId,
      name: name,
      contactNo: contactNo);

}
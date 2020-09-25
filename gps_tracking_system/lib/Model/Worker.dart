import 'package:flutter/cupertino.dart';

class Worker{

  final String workerId;
  double latitude;
  double longitude;
  String customerId;

  Worker({
    @required workerId,
    this.latitude = 4.2105,
    this.longitude = 101.9758,
    this.customerId = "",
  }):
    workerId = workerId;

}
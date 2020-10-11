import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Model/location.dart';

class WorkerLocation{

  String workerId;
  double latitude;
  double longitude;
  WorkerLocation({this.workerId,  this.latitude = 4.2105, this.longitude = 101.9758});
}
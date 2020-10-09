import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location{
  String userId;
  String address;
  double latitude;
  double longitude;

  Location({this.userId = "" , this.address = "", this.latitude = 4.2105, this.longitude = 101.9758});

  Position getPosition()=>Position(latitude: this.latitude, longitude: this.longitude);
  LatLng getLatLng()=>LatLng(this.latitude, this.longitude);
}
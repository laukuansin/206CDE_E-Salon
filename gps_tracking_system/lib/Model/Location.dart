import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location{
  String address;
  double latitude;
  double longitude;

  Location(this.address, this.latitude, this.longitude);

  Position getPosition()=>Position(latitude: this.latitude, longitude: this.longitude);
  LatLng getLatLng()=>LatLng(this.latitude, this.longitude);
}
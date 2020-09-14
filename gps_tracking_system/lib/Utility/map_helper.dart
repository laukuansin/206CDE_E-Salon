import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Utility/rest_api.dart';

class MapHelper{

  static Position latLngToPosition(LatLng latLng)=>Position(latitude: latLng.latitude, longitude: latLng.longitude);
  static LatLng positionToLatLng(Position position)=>LatLng(position.latitude, position.longitude);

  static Future<LatLng> addressToLatLng(String address, String apiKey) async{
    List<double> coord = await addressToCoordinate(address, apiKey);
    return LatLng(coord[0], coord[1]);
  }
  static Future<Position> addressToPosition(String address, String apiKey) async{
    List<double> coord = await addressToCoordinate(address, apiKey);
    return Position(latitude:coord[0], longitude: coord[1]);
  }
  static Future<List<double>> addressToCoordinate(String address, String apiKey) async {
    Map<String,dynamic> json = await RestApi.addressToCoordinate(address, apiKey);
    Map<String,dynamic> coord = json["results"][0]["geometry"]["location"];
    log("Location returned from Google Map : " + coord.toString());
    return [coord["lat"], coord["lng"]];
  }
  static LatLng listToLatLng(List<double>list)=>LatLng(list[0], list[1]);
}
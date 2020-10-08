import 'dart:developer';

import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Model/location.dart';
import 'package:gps_tracking_system/Utility/real_time_db.dart';
import 'package:gps_tracking_system/Utility/rest_api.dart';

/// This class is a helper call for coordinate conversion
class MapHelper{

  static Position latLngToPosition(LatLng latLng)=>Position(latitude: latLng.latitude, longitude: latLng.longitude);
  static LatLng positionToLatLng(Position position)=>LatLng(position.latitude, position.longitude);

  static Future<LatLng> addressToLatLng(String address) async{
    List<double> coord = await addressToCoordinate(address);
    return LatLng(coord[0], coord[1]);
  }

  static Future<Position> addressToPosition(String address) async{
    List<double> coord = await addressToCoordinate(address);
    return Position(latitude:coord[0], longitude: coord[1]);
  }

  static Future<List<double>> addressToCoordinate(String address) async {
    return RealTimeDb.getAddressLatLng(address);
  }

  static Future<String> positionToAddress(Position position) async{
    List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(MapHelper.positionToCoordinates(position));
    return addresses.first.addressLine;
  }

  static LatLng listToLatLng(List<double>list)=>LatLng(list[0], list[1]);

  static Coordinates positionToCoordinates(Position position)=>Coordinates(position.latitude, position.longitude);

  static Future<Map<String, int>> getRouteTimeDistance(List<LatLng> routeCoordinate) async {
    Map<String, dynamic> jsonTimeTakenAndDistance = await RestApi
        .getRouteTimeDistance(routeCoordinate);

    int totalDurationInSeconds, totalDistanceInMeter;
    totalDistanceInMeter = totalDurationInSeconds = 0;

    try {
      List<dynamic> timeTaken = jsonTimeTakenAndDistance["durations"];
      List<dynamic> distance = jsonTimeTakenAndDistance["distances"];

      int row = timeTaken.length;
      totalDurationInSeconds = 0;
      totalDistanceInMeter = 0;
      for (int i = 0; i < row - 1; i++) {
        double second = timeTaken[i][i + 1];
        double d = distance[i][i + 1];
        totalDurationInSeconds += second.toInt();
        totalDistanceInMeter += d.toInt();
      }
    }
    catch (error) {
      log(error.toString());
    }

    return { "duration" : totalDurationInSeconds, "distance":totalDistanceInMeter};
  }

}
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Utility/real_time_db.dart';

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

  static LatLng listToLatLng(List<double>list)=>LatLng(list[0], list[1]);

  static Coordinates positionToCoordinates(Position position)=>Coordinates(position.latitude, position.longitude);
}
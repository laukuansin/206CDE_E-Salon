import 'dart:convert';
import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RestApi
{
  RestApi._();

  static Future<Map<String, dynamic>> getTimeTaken(List<LatLng> routeCoordinate) async
  {
    String address = "https://api.mapbox.com/directions-matrix/v1/mapbox/driving-traffic/";
    String accessToken = "?annotations=duration,distance&access_token=pk.eyJ1IjoiamVmZnJleXRhbiIsImEiOiJja2V2ZGx2NXMwOWRnMzFwOXAxeWJ4OHliIn0.qdcdB0cFAtgG3rvmHAXOGw";

    for(int i = 0 ; i < routeCoordinate.length; i++){
      address += routeCoordinate[i].longitude.toString();
      address += ",";
      address += routeCoordinate[i].latitude.toString();
      address += ";";
    }

    address = address.substring(0, address.length - 1);

    address += accessToken;
    log(address);
    var response = await  http.get(address);
    return jsonDecode(response.body);
  }
}
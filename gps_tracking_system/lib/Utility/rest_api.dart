import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Response/AddStaffResponse.dart';
import 'package:gps_tracking_system/Utility/url_encoder.dart';
import 'package:http/http.dart' as http;

class RestApi
{
  RestApi._();
  //android emulator 10.0.2.2
  //real device use ur laptop/computer wifi ip address:192.168.8.103
  static const String DOMAIN_NAME ="http://192.168.8.103";

  static const String _GOOGLE_MAP_API_KEY = "AIzaSyBrNE3BrIA9VwrjmlsHo25fVdchca9H04g";
  static Future<Map<String, dynamic>> getRouteTimeDistance(List<LatLng> routeCoordinate) async {
    String url = "https://api.mapbox.com/directions-matrix/v1/mapbox/driving-traffic/";
    String accessToken = "?annotations=duration,distance&access_token=pk.eyJ1IjoiamVmZnJleXRhbiIsImEiOiJja2V2ZGx2NXMwOWRnMzFwOXAxeWJ4OHliIn0.qdcdB0cFAtgG3rvmHAXOGw";

    for(int i = 0 ; i < routeCoordinate.length; i++){
      url += routeCoordinate[i].longitude.toString();
      url += ",";
      url += routeCoordinate[i].latitude.toString();
      url += ";";
    }

    url = url.substring(0, url.length - 1);
    url += accessToken;
    log("Calling MapBox distance API : " + url);
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> addressToCoordinate(String address) async{
    address = URLEncoder.encodeURLParameter(address);
    String url = "https://maps.googleapis.com/maps/api/place/textsearch/json?query="+address+"&key=" + _GOOGLE_MAP_API_KEY;
    log("Calling google map API : " + url);
    var response = await http.get(url);
    return jsonDecode(response.body);
  }
  static Future<Map<String, dynamic>> latLngToAddress(LatLng position) async{
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng="+position.toString()+"&key=" + _GOOGLE_MAP_API_KEY;
    log("Calling google map API : " + url);
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

  static Future<AddStaffResponse> addStaff(String username,String userGroup,String firstName,String lastName,String email,String imagePath,String password,String status) async{
    String url=DOMAIN_NAME+"/index.php?route=api/staff/add_staff";
    log("Calling login API : " + url);
   /* var response = await http.post(url,body: {
      "username":username,
      "user_group":userGroup,
      "first_name":firstName,
      "last_name":lastName,
      "email":email,
      "image_path":imagePath,
      "password":password,
      "status":status
    });

    final String responseString =response.body;
    return addStaffResponseFromJson(responseString);*/
    var request = http.MultipartRequest("POST", Uri.parse(url));
    //add text fields
    request.fields["username"] = username;
    request.fields["user_group"] = userGroup;
    request.fields["first_name"] = firstName;
    request.fields["last_name"] = lastName;
    request.fields["email"] = email;
    request.fields["password"] = password;
    request.fields["status"] = status;
    //create multipart using filepath, string or bytes
    if(imagePath.isNotEmpty)
    {
      var pic = await http.MultipartFile.fromPath("image_path", imagePath);
      //add multipart to request
      request.files.add(pic);
    }

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    return addStaffResponseFromJson(responseString);
  }


}
import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AppLauncher
{
  AppLauncher._();
  static Future<void> openMap({String address, LatLng latLng}) async {
    String googleUrl = 'https://www.google.com/maps/search/';
    if(address != null) {
      address.replaceAll('/', "%2F");
      googleUrl += Uri.encodeFull(address).replaceAll('/', '%2F');
    }
    else if(latLng != null){
      googleUrl += '?api=1&query=${latLng.latitude},${latLng.longitude}';
    }
    else{
      throw 'Destination not found';
    }

    log(googleUrl);
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

}
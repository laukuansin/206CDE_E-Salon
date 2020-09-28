import 'dart:developer';
import 'dart:io';
import 'package:android_intent/android_intent.dart';
import 'package:gps_tracking_system/Utility/url_encoder.dart';
import 'package:url_launcher/url_launcher.dart';

class AppLauncher
{
  AppLauncher._();

  static Future<void> openMap({List<double>srcLatLng, String srcAddress, List<double> destLatLng, String destAddress}) async {
    String origin = "";
    String destination = "";

    if(srcLatLng != null){
      origin += srcLatLng[0].toString();
      origin += ",";
      origin += srcLatLng[1].toString();
    }
    else{
      origin = URLEncoder.encodeURLParameter(srcAddress);
    }

    if(destLatLng != null){
      destination += destLatLng[0].toString();
      destination += ",";
      destination += destLatLng[1].toString();
    }
    else{
      destination =  URLEncoder.encodeURLParameter(destAddress);
    }

    String googleUrl = 'https://www.google.com/maps/dir/?api=1&origin=';
    googleUrl += origin;
    googleUrl += "&destination=";
    googleUrl += destination;
    googleUrl += "&travelmode=driving&dir_action=navigate";

    log("Opening url : " + googleUrl);
    if(Platform.isAndroid){
      final androidIntent = new AndroidIntent(
        action: 'action_view',
        data: googleUrl,
        package: 'com.google.android.app.maps'
      );
      androidIntent.launch();
    }
    else{
      if(await canLaunch(googleUrl)){
        await launch(googleUrl);
      }
      else{
        throw 'Could not open the map.';
      }
    }
  }
}
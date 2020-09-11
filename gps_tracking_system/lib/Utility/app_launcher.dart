import 'dart:developer';
import 'dart:io';
import 'package:android_intent/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';

class AppLauncher
{
  AppLauncher._();

  static Future<void> openMap({List<double>latLng, List<String>address}) async {
    String origin = "";
    String destination = "";

    if(latLng != null){
      origin += latLng[0].toString();
      origin += ",";
      origin += latLng[1].toString();
      destination += latLng[2].toString();
      destination += ",";
      destination += latLng[3].toString();

    }else if(address != null){
      origin = Uri.encodeFull(address[0]).replaceAll('/', '%2F');
      destination =  Uri.encodeFull(address[1]).replaceAll('/', '%2F');
    }else{
      throw 'Could not open the map.';
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
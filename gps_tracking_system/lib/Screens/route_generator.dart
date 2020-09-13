import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Screens/DebuggingTool/firebase.dart';
import 'package:gps_tracking_system/Screens/GoogleMap/googlemap_screen.dart';
import 'package:gps_tracking_system/Screens/Login/login.dart';
import 'package:gps_tracking_system/Screens/SplashScreen/splash_screen.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings)
  {
    final args = settings.arguments;

    switch(settings.name)
    {
      case"/default":
        return MaterialPageRoute(
          builder: (_)=>Scaffold(
            body: SplashScreen(),
          )
        );

      case "/login":
        return MaterialPageRoute(
          builder:(_)=>Scaffold(
            body:LoginPage()
          )
        );
      case "/debug":
        return MaterialPageRoute(
          builder: (_)=>Scaffold(
            body: Firebase(),
          )
        );
      case "/map":
        return MaterialPageRoute(
          builder:(_)=>Scaffold(
            body: GoogleMapScreen(destAddr: "Sunshine Farlim"),
          )
        );
    }
  }
}
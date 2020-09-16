import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Screens/DebuggingTool/google_map_debugger.dart';
import 'package:gps_tracking_system/Screens/GoogleMap/googlemap_screen.dart';
import 'package:gps_tracking_system/Screens/Login/login.dart';
import 'package:gps_tracking_system/Screens/SplashScreen/splash_screen.dart';

class RouteGenerator{

  static const bool _DEBUG_MODE = true;

  static Route<dynamic> generateRoute(RouteSettings settings)
  {
    final args = settings.arguments;

    if(_DEBUG_MODE){
      switch(settings.name) {
        // case "/firebaseDebug":
        //   return MaterialPageRoute(
        //       builder: (_) =>
        //           Scaffold(
        //             body: Firebase(),
        //           )
        //   );
        case "/mapDebug":
          return MaterialPageRoute(
              builder: (_) =>
                  Scaffold(
                    body: GoogleMapDebugger(),
                  )
          );
      }
    }
    else{
      switch(settings.name)
      {
        case"/":
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
      }
    }
  }
}
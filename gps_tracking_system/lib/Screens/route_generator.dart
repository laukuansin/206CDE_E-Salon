import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Screens/Developing/appointment_info_screen.dart';
import 'package:gps_tracking_system/Screens/GoogleMap/googlemap_screen.dart';
import 'package:gps_tracking_system/Screens/Login/login.dart';
import 'package:gps_tracking_system/Screens/SplashScreen/splash_screen.dart';

class RouteGenerator{

  static const bool _DEBUG_MODE = false;

  static Route<dynamic> generateRoute(RouteSettings settings)
  {
    final args = settings.arguments;

    if(_DEBUG_MODE){
      switch(settings.name) {

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
        case "/appointmentInfo":
          return MaterialPageRoute(
              builder: (_) =>
                  Scaffold(
                    body: AppointmentInfo(),
                  )
          );
      }
    }
  }
}
import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Screens/Login/login.dart';
import 'package:gps_tracking_system/Screens/SplashScreen/splash_screen.dart';
import 'package:gps_tracking_system/Screens/Calendar/calendar.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings)
  {
    final args = settings.arguments;

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
            body:CalendarPage(),
          )
        );
    }
  }
}
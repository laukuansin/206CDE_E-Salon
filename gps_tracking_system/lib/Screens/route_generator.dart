import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Screens/Login/Login.dart';
import 'package:gps_tracking_system/Screens/SplashScreen/splash_screen.dart';

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
            body:LoginPage()
          )
        );
    }
  }
}
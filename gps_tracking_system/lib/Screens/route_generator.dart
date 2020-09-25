import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Screens/Login/login.dart';
import 'package:gps_tracking_system/Screens/SplashScreen/splash_screen.dart';
<<<<<<< Updated upstream
import 'package:gps_tracking_system/Screens/Calendar/calendar.dart';
=======
import 'package:gps_tracking_system/Screens/SignUp/signUp.dart';
>>>>>>> Stashed changes

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings)
  {
    final args = settings.arguments;

<<<<<<< Updated upstream
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
=======
      }
    }
    else{
      switch(settings.name)
      {
        case"/"                 :return _buildWidget(SplashScreen());
        case "/login"           :return _buildWidget(LoginPage());
        case "/signUp"           :return _buildWidget(SignUpPage());
        case "/appointmentInfo" :return _buildWidget(AppointmentInfo());
        case "/appointmentList" :return _buildWidget(AppointmentListScreen());
      }
>>>>>>> Stashed changes
    }
  }
}
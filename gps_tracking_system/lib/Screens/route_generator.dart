import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Screens/Developing/appointment_info_screen.dart';
import 'package:gps_tracking_system/Screens/Developing/appointment_list_screen.dart';
import 'package:gps_tracking_system/Screens/GoogleMap/googlemap_screen.dart';
import 'package:gps_tracking_system/Screens/Login/login.dart';
import 'package:gps_tracking_system/Screens/SplashScreen/splash_screen.dart';
import 'package:gps_tracking_system/user_appointment_info.dart';
import 'package:gps_tracking_system/user_appointment_list.dart';

class RouteGenerator{

  static const bool _DEBUG_MODE = false;

  static MaterialPageRoute _buildWidget(Widget widget, {AppBar appbar})=>MaterialPageRoute(
      builder: (_)=> Scaffold(
        appBar: appbar,
        body: SafeArea(
        child:widget
      ),
    )
  );

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
        case"/"                 :return _buildWidget(SplashScreen());
        case "/login"           :return _buildWidget(LoginPage());
        case "/appointmentInfo" :return _buildWidget(AppointmentInfo());
        case "/appointmentList" :return _buildWidget(AppointmentListScreen());
        case "/userAppointmentList" :return _buildWidget(UserAppointmentListScreen());
        case "/userAppointmentInfo" :return _buildWidget(UserAppointmentInfo());
      }
    }
  }
}
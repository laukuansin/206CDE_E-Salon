import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Model/Location.dart';
import 'package:gps_tracking_system/Screens/Developing/appointment_info_screen.dart';
import 'package:gps_tracking_system/Screens/Developing/appointment_list_screen.dart';
import 'package:gps_tracking_system/Screens/AddAppointment/add_appointment.dart';
import 'package:gps_tracking_system/Screens/LocationPicker/location_picker.dart';
import 'package:gps_tracking_system/Screens/Login/login.dart';
import 'package:gps_tracking_system/Screens/SplashScreen/splash_screen.dart';
import 'package:gps_tracking_system/overall_appointment.dart';

class RouteGenerator{

  static const bool _DEBUG_MODE = false;

  static Scaffold buildScaffold(Widget widget, {AppBar appbar})=> Scaffold(
      appBar: appbar,
      body: Material(
        child:SafeArea(
            child:widget
        ),
      )
    );

  static MaterialPageRoute _buildRoute(Widget scaffold)=>MaterialPageRoute(
      builder: (_)=> scaffold
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
        case"/"                                 :return _buildRoute(SplashScreen());
        case "/login"                           :return _buildRoute(LoginPage());
        case "/appointmentInfo"                 :return _buildRoute(AppointmentInfo());
        case "/appointmentList"                 :return _buildRoute(AppointmentListScreen());
        case "/add_appointment"                 :return _buildRoute(AddAppointment());
        case "/overall_appointment"             :return _buildRoute(OverallAppointment());
        case "/add_appointment_select_location" :
          if(args is Location)
            return _buildRoute(LocationPicker(args));
      }
    }
  }
}
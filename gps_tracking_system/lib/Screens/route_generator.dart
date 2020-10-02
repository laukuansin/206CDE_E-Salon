import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Model/location.dart';
import 'package:gps_tracking_system/Screens/Common/AppointmentInfo/appointment_info_screen.dart';
import 'package:gps_tracking_system/Screens/Common/AppointmentList/appointment_list_screen.dart';
import 'package:gps_tracking_system/Screens/User/AddAppointment/add_appointment_screen.dart';
import 'package:gps_tracking_system/Screens/Common/LocationPicker/location_picker_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/Login/login_screen.dart' as AdminLogin;
import 'package:gps_tracking_system/Screens/User/Login/login_screen.dart' as UserLogin;
import 'package:gps_tracking_system/Screens/Common/SplashScreen/splash_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/TodayAppointment/today_appointment_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/AddWorker/add_worker.dart';
import 'package:gps_tracking_system/Screens/Admin/Setting/settings.dart';
import 'package:gps_tracking_system/Screens/Admin/Calendar/calendar.dart';

class RouteGenerator{

  static const bool _DEBUG_MODE = false;
  static const bool _ADMIN_MODE = true;

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
      if(_ADMIN_MODE){
        switch(settings.name)
        {
          case"/"                                 :return _buildRoute(SplashScreen());
          case "/login"                           :return _buildRoute(AdminLogin.LoginScreen());
          case "/appointmentInfo"                 :return _buildRoute(AppointmentInfo());
          case "/appointmentList"                 :return _buildRoute(AppointmentListScreen());
          case "/add_appointment"                 :return _buildRoute(AddAppointmentScreen());
          case "/today_appointment"               :return _buildRoute(TodayAppointmentScreen());
          case "/add_worker"       				        :return _buildRoute(SettingPage());     // Original - AddWorker()
          case "/calendar"       				          :return _buildRoute(CalendarPage());
        }
      }
      else{
        switch(settings.name)
        {
          case"/"                                 :return _buildRoute(SplashScreen());
          case "/login"                           :return _buildRoute(UserLogin.LoginScreen());
          case "/appointmentInfo"                 :return _buildRoute(AppointmentInfo());
          case "/appointmentList"                 :return _buildRoute(AppointmentListScreen());
          case "/add_appointment"                 :return _buildRoute(AddAppointmentScreen());
          case "/location_picker" :
            if(args is Location)
              return _buildRoute(LocationPickerScreen(args));
        }
      }
    }
  }
}
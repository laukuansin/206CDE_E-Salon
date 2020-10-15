import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/location.dart';
import 'package:gps_tracking_system/Model/user.dart';

import 'package:gps_tracking_system/Screens/Admin/ManageAppointment/manage_appointment_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/Account/account_page_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/ChangePassword/change_password_screen.dart';
import 'package:gps_tracking_system/Screens/User/AddAppointment/choose_service_screen.dart';
import 'package:gps_tracking_system/Screens/User/AddAppointment/choose_time_screen.dart';
import 'package:gps_tracking_system/Utility/RestApi/appointment_list_response.dart';
import 'package:gps_tracking_system/Screens/Admin/payment/PaymentScreen.dart';
import 'package:gps_tracking_system/Screens/Common/AppointmentInfo/appointment_info_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/AppointmentList/appointment_list_screen.dart';
import 'package:gps_tracking_system/Screens/User/AddAppointment/add_appointment_screen.dart';
import 'package:gps_tracking_system/Screens/Common/LocationPicker/location_picker_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/Login/login_screen.dart' as AdminLogin;
import 'package:gps_tracking_system/Screens/User/Login/login_screen.dart' as UserLogin;
import 'package:gps_tracking_system/Screens/Common/SplashScreen/splash_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/TodayAppointment/today_appointment_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/AddWorker/add_worker.dart';
import 'package:gps_tracking_system/Screens/User/NotificationAppointments/notification_appointments.dart';
import 'package:gps_tracking_system/Screens/User/TopUp/top_up_screen.dart';
import 'package:gps_tracking_system/Screens/User/Home/home_page_screen.dart' as UserHome;
import 'package:gps_tracking_system/Screens/Admin/Home/home_page_screen.dart' as AdminHome;
import 'package:gps_tracking_system/Screens/User/QR_Payment/qr_payment_screen.dart';
import 'package:gps_tracking_system/Screens/User/SignUp/sign_up_screen.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'Admin/EditInfo/edit_info_screen.dart';


class RouteGenerator{


  static const bool _ADMIN_MODE = true;

  static Scaffold buildScaffold(Widget widget, {Key key, AppBar appbar, Drawer drawer, BuildContext context})=> Scaffold(
      key: key,
      appBar: appbar,
      body: Material(
        child:SafeArea(
            child:widget,
        ),
      ),
      drawer: drawer,
    );

  static Drawer buildDrawer(BuildContext context){
    return Drawer(
      child: new ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: primaryColor),
            accountName: Text(User.getUsername() ,style: TextStyleFactory.p(color: Colors.white),),
            accountEmail: Text(User.getEmail(),style: TextStyleFactory.p(color:Colors.white),),
            currentAccountPicture: CircleAvatar
              (
              backgroundColor: Colors.white,
              child: Text(User.getUsername()[0].toUpperCase(),style: TextStyleFactory.heading1(fontWeight: FontWeight.bold,color: primaryColor),),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home Page"),
            onTap: (){
              Navigator.of(context).pushNamedAndRemoveUntil("/home_page", (Route<dynamic> route) => false);
            },
          ),
          ListTile(
              leading: Icon(Icons.people),
              title: Text("Staff")
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("Appointment"),
            onTap: ()
            {
              Navigator.of(context).pushNamedAndRemoveUntil("/manage_appointment", (Route<dynamic> route) => false);

            },
          ),
          ListTile(
              leading: Icon(Icons.attach_money),
              title: Text("Sales")
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Account"),
            onTap: ()
            {
              Navigator.of(context).pushNamedAndRemoveUntil("/account_page", (Route<dynamic> route) => false);

            },

          ),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text("Setting")
          ),
          ListTile(
            leading: Icon(MdiIcons.logout),
            title: Text("Logout"),
            onTap: (){
              Navigator.of(context).pushNamedAndRemoveUntil("/login", (Route<dynamic> route) => false);
            },
          )
        ],
      ),
    );
  }


  static MaterialPageRoute _buildRoute(Widget scaffold)=>MaterialPageRoute(
      builder: (_)=> scaffold
  );

  static Route<dynamic> generateRoute(RouteSettings settings)
  {
    final args = settings.arguments;

    if(_ADMIN_MODE){
      switch(settings.name)
      {
        case"/"                                 :return _buildRoute(SplashScreen());
        case "/login"                           :return _buildRoute(AdminLogin.LoginScreen());
        case "/appointment_list"                :return _buildRoute(AppointmentListScreen());
        case "/today_appointment"               :return _buildRoute(TodayAppointmentScreen());
        case "/add_worker"       				        :return _buildRoute(AddWorker());
        case "/payment"       				          :return _buildRoute(PaymentScreen());
        case "/manage_appointment"              :return _buildRoute(ManageAppointmentScreen());
        case "/home_page"                       :return _buildRoute(AdminHome.HomePageScreen());
        case "/account_page"                    :return _buildRoute(AccountPageScreen());
        case "/edit_info"                       :return _buildRoute(EditInfoPageScreen());
        case "/change_password"                 :return _buildRoute(ChangePasswordPageScreen());
        case "/appointmentInfo"                 :if(args is Appointment) return _buildRoute(AppointmentInfo(args));break;
      }
    }
    else {
      switch (settings.name) {
        case "/"                                :return _buildRoute(SplashScreen());
        case "/sign_up"                         :return _buildRoute(SignUpScreen());
        case "/login"                           :return _buildRoute(UserLogin.LoginScreen());
	      case "/top_up"                          :return _buildRoute(TopUpScreen());
        case "/qr_code"                         :return _buildRoute(QRCodePaymentScreen());
        case "/home_page"                       :return _buildRoute(UserHome.HomePageScreen());
        case "/my_appointments"                 :return _buildRoute(NotificationAppointmentsScreen());
        case "/choose_service"                  :return _buildRoute(ChooseServiceScreen());
        case "/add_appointment"                 :if (args is Map<String, dynamic>)  return _buildRoute(AddAppointmentScreen(args)); break;
        case "/choose_time"                     :if (args is Map<String, dynamic>) return _buildRoute(ChooseTimeScreen(args)); break;
        case "/location_picker"                 :if (args is Location) return _buildRoute(LocationPickerScreen(args));break;
        case "/appointmentInfo"                 :if (args is Appointment) return _buildRoute(AppointmentInfo(args));break;
      }
    }
  }
}

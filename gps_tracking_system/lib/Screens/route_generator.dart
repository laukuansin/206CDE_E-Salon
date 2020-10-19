import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/admin.dart';
import 'package:gps_tracking_system/Model/appointment.dart';
import 'package:gps_tracking_system/Model/location.dart';
import 'package:gps_tracking_system/Model/logged_user.dart';
import 'package:gps_tracking_system/Model/service.dart';
import 'package:gps_tracking_system/Screens/Admin/Account/account_page_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/Account/change_password_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/Appointment/appointment_info_screen.dart'
    as AdminAppointmentInfo;
import 'package:gps_tracking_system/Screens/Admin/Appointment/appointment_list_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/Appointment/manage_appointment_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/Appointment/today_appointment_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/Home/home_page_screen.dart'
    as AdminHome;
import 'package:gps_tracking_system/Screens/Admin/Login/login_screen.dart'
    as AdminLogin;
import 'package:gps_tracking_system/Screens/Admin/Payment/add_service_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/Payment/payment_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/Setting/holiday_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/Setting/setting_page_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/Worker/add_worker_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/Worker/edit_worker_screen.dart';
import 'package:gps_tracking_system/Screens/Admin/Worker/manage_worker_screen.dart';
import 'package:gps_tracking_system/Screens/Common/LocationPicker/location_picker_screen.dart';
import 'package:gps_tracking_system/Screens/Common/SplashScreen/splash_screen.dart';
import 'package:gps_tracking_system/Screens/User/Account/account_screen.dart';
import 'package:gps_tracking_system/Screens/User/AddAppointment/add_appointment_screen.dart';
import 'package:gps_tracking_system/Screens/User/AddAppointment/choose_service_screen.dart';
import 'package:gps_tracking_system/Screens/User/AddAppointment/choose_time_screen.dart';
import 'package:gps_tracking_system/Screens/User/AppointmentInfo/appointment_info_screen.dart'
    as UserAppointmentInfo;
import 'package:gps_tracking_system/Screens/User/ChangePassword/change_password_screen.dart';
import 'package:gps_tracking_system/Screens/User/EditCustomerInfo/edit_info_screen.dart';
import 'package:gps_tracking_system/Screens/User/Home/home_page_screen.dart'
    as UserHome;
import 'package:gps_tracking_system/Screens/User/Login/login_screen.dart'
    as UserLogin;
import 'package:gps_tracking_system/Screens/User/NotificationAppointments/notification_appointments.dart';
import 'package:gps_tracking_system/Screens/User/QR_Payment/qr_payment_screen.dart';
import 'package:gps_tracking_system/Screens/User/Rating/rating_screen.dart';
import 'package:gps_tracking_system/Screens/User/SignUp/sign_up_screen.dart';
import 'package:gps_tracking_system/Screens/User/TopUp/top_up_screen.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'Admin/Account/edit_info_screen.dart';

class RouteGenerator {

  static bool ADMIN_MODE = false;


  static Scaffold buildScaffold(Widget widget,
          {Key key,
          AppBar appbar,
          Drawer drawer,
          BuildContext context,
          bool extendBodyBehindAppBar = false}) =>
      Scaffold(
        key: key,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        appBar: appbar,
        body: Material(
          child: SafeArea(
            child: widget,
          ),
        ),
        drawer: drawer,
      );

  static Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: new ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              accountName: Text(
                LoggedUser.getUsername(),
                style: TextStyleFactory.p(color: Colors.white),
              ),
              accountEmail: Text(
                LoggedUser.getEmail(),
                style: TextStyleFactory.p(color: Colors.white),
              ),
              currentAccountPicture: () {
                return LoggedUser.getUserImage() != null &&
                        LoggedUser.getUserImage().isNotEmpty
                    ? CircleAvatar(
                        backgroundImage:
                            NetworkImage(LoggedUser.getUserImage()),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          LoggedUser.getUsername()[0].toUpperCase(),
                          style: TextStyleFactory.heading1(
                              fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                      );
              }()),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home Page"),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "/home_page", (Route<dynamic> route) => false);
            },
          ),
          Visibility(
            child: ListTile(
              leading: Icon(Icons.people),
              title: Text("Worker"),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "/manage_worker", (route) => false);
              },
            ),
            visible: LoggedUser.getRole() == Role.OWNER,
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("Appointment"),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "/appointment_list", (Route<dynamic> route) => false);
            },
          ),
          Visibility(child:ListTile(leading: Icon(Icons.attach_money), title: Text("Sales")), visible: LoggedUser.getRole() == Role.OWNER,),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Account"),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "/account_page", (Route<dynamic> route) => false);
            },
          ),
          Visibility(
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text("Setting"),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "/setting_page", (Route<dynamic> route) => false);
              },
            ),
            visible: LoggedUser.getRole() == Role.OWNER,
          ),
          ListTile(
            leading: Icon(MdiIcons.logout),
            title: Text("Logout"),
            onTap: () {
              LoggedUser.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "/login", (Route<dynamic> route) => false);
            },
          )
        ],
      ),
    );
  }

  static MaterialPageRoute _buildRoute(Widget scaffold) =>
      MaterialPageRoute(builder: (_) => scaffold);

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    if (ADMIN_MODE) {
      switch (settings.name) {
        case "/":
          return _buildRoute(SplashScreen());
        case "/login":
          return _buildRoute(AdminLogin.LoginScreen());
        case "/appointment_list":
          return _buildRoute(AppointmentListScreen());
        case "/today_appointment":
          if (args is Map<DateTime, List<Appointment>>)
            return _buildRoute(TodayAppointmentScreen(args));
          break;
        case "/add_worker":
          return _buildRoute(AddWorker());
        case "/payment":
          if (args is Map<String, dynamic>)
            return _buildRoute(PaymentScreen(args));
          break;
        case "/manage_appointment":
          return _buildRoute(ManageAppointmentScreen());
        case "/home_page":
          return _buildRoute(AdminHome.HomePageScreen());
        case "/account_page":
          return _buildRoute(AccountPageScreen());
        case "/holiday_page":
          return _buildRoute(HolidayPageScreen());
        case "/edit_info":
          return _buildRoute(EditInfoPageScreen());
        case "/change_password":
          return _buildRoute(ChangePasswordPageScreen());
        case "/setting_page":
          return _buildRoute(SettingPageScreen());
        case "/manage_worker":
          return _buildRoute(ManageWorkerScreen());
        case "/add_service":
          if (args is List<Service>) return _buildRoute(AddServiceScreen(args));
          break;
        case "/edit_worker":
          if (args is Admin) return _buildRoute(EditWorkerScreen(args));
          break;
        case "/appointment_info":
          if (args is Appointment)
            return _buildRoute(AdminAppointmentInfo.AppointmentInfo(args));
          break;
      }
    } else {
      switch (settings.name) {
        case "/":
          return _buildRoute(SplashScreen());
        case "/appointment_info":
          if (args is Appointment)
            return _buildRoute(UserAppointmentInfo.AppointmentInfo(args));
          break;
        case "/account_page":
          return _buildRoute(AccountScreen());
        case "/add_appointment":
          if (args is Map<String, dynamic>)
            return _buildRoute(AddAppointmentScreen(args));
          break;
        case "/choose_service":
          return _buildRoute(ChooseServiceScreen());
        case "/choose_time":
          if (args is Map<String, dynamic>)
            return _buildRoute(ChooseTimeScreen(args));
          break;
        case "/change_password":
          return _buildRoute(ChangePasswordScreen());
        case "/edit_info":
          return _buildRoute(EditInfoScreen());
        case "/home_page":
          return _buildRoute(UserHome.HomePageScreen());
        case  "/rating":
          return _buildRoute(RatingPageScreen());
        case "/login":
          return _buildRoute(UserLogin.LoginScreen());
        case "/location_picker":
          if (args is Location) return _buildRoute(LocationPickerScreen(args));
          break;
        case "/my_appointments":
          return _buildRoute(NotificationAppointmentsScreen());
        case "/qr_code":
          return _buildRoute(QRCodePaymentScreen());
        case "/sign_up":
          return _buildRoute(SignUpScreen());
        case "/top_up":
          return _buildRoute(TopUpScreen());
      }
    }
  }
}

import 'package:gps_tracking_system/Model/appointment.dart';

class EndUser{
  String id;
  String firstName;
  String lastName;
  String email;
  String contactNo;
  String password;
  String confirm;
  List<Appointment> appointmentList;

  EndUser({
    this.id = ""
    ,this.firstName = ""
    ,this.lastName = ""
    ,this.email = ""
    ,this.contactNo = ""
    ,this.appointmentList = const []
  });
}
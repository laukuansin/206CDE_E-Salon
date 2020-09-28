import 'package:gps_tracking_system/Model/appointment.dart';

class EndUser{
  final String id;
  String firstName;
  String lastName;
  String email;
  String contactNo;
  List<Appointment> appointmentList;

  EndUser(String id,
      {this.firstName = ""
        ,this.lastName = ""
        ,this.email = ""
        , this.contactNo = ""
        , this.appointmentList = const []
      })
      :id = id;
}
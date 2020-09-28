import 'package:gps_tracking_system/Model/appointment.dart';

class EndUser{
  final String id;
  String name;
  String contactNo;
  List<Appointment> appointmentList;

  EndUser(String id,
      {this.name = ""
        , this.contactNo = ""
        , this.appointmentList = const []
      })
      :id = id;
}
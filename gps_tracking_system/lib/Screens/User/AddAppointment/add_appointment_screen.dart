import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/location.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/appointment_list_response.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:numberpicker/numberpicker.dart';

class AddAppointmentScreen extends StatefulWidget {
  AddAppointmentScreenState createState() => AddAppointmentScreenState();
}

class AddAppointmentScreenState extends State<AddAppointmentScreen> {
  Appointment appointment;
  Location location;
  FToast fToast;

  @override
  Widget build(BuildContext context) {
    return RouteGenerator.buildScaffold(
        SingleChildScrollView(
          child: Container(
            color: primaryLightColor,
            child: Column(children: <Widget>[
               GestureDetector(
                  onTap: () => _selectAppointmentDate(context),
                  child: ListTile(
                    leading: Icon(Icons.calendar_today, color:primaryColor),
                    title: Text("Date"),
                    subtitle: appointment.appointmentDate == null? Text("Select date"): Text(appointment.getAppointmentDateStringDateMonthYear()),
                    trailing: Icon(Icons.chevron_right),
                  )
               ),
               Divider(color:primaryDeepLightColor, thickness: 0.5,),
               GestureDetector(
                  child: ListTile(
                    leading: Icon(Icons.location_on, color: primaryColor,),
                    title: Text("Address"),
                    subtitle: location.address.isEmpty? Text("Select location") : Text(location.address),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/location_picker', arguments: this.location).
                    then((value){
                      setState(() {});
                    });
                  },
                ),
                Divider(color:primaryDeepLightColor, thickness: 0.5,),
            ])
          )
        ),
        appbar: AppBar(
          title: Text("Add Appointment", style: TextStyleFactory.p(color: primaryTextColor),),
          actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: addAppointment,
              child: Icon(Icons.check),
          ))
          ],
        ),
    );
  }
  
  //
  // String getLocation() {
  //   if (location.address.isEmpty ||
  //       location.latitude == 0 ||
  //       location.longitude == 0) {
  //     return "Select location";
  //   } else {
  //     return location.address;
  //   }
  // }
  //
  // String getDateTimeText() {
  //   if (dateTime == null) {
  //     return "Select date and Time";
  //   } else {
  //     return dateTimeStr;
  //   }
  // }

  void addAppointment() {

  }



  Future<void> _selectAppointmentDate(BuildContext context) async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: appointment.appointmentDate == null? DateTime.now() : appointment.appointmentDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101)
    );

    if (date != null) {
      setState(() {appointment.appointmentDate = date;});
    }
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    appointment = Appointment();
    location = Location();
  }

  // DateTime checkDate() {
  //   if (selectDate == null) {
  //     return new DateTime.now();
  //   } else {
  //     return selectDate;
  //   }
  // }
}

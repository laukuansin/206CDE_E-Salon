import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Model/Location.dart';
import 'file:///C:/Users/Jeffrey%20Tan/Desktop/GPSTracker/RealWorldProject/gps_tracking_system/lib/Screens/LocationPicker/location_picker.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:numberpicker/numberpicker.dart';

void main() {
  runApp(AddAppointment());
}

class AddAppointment extends StatefulWidget {
  AddAppointmentState createState() => AddAppointmentState();
}

class AddAppointmentState extends State<AddAppointment> {
  DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
  DateTime dateTime;
  DateTime selectDate;
  TimeOfDay selectTime;
  Location location;
  String dateTimeStr;
  String note;
  int adult, kid;
  FToast fToast;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Add Appointment"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: addAppointment,
                  child: Icon(Icons.check),
                ))
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: <Widget>[
          new GestureDetector(
              onTap: () => _selectDateTimePicker(context),
              child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(20),
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Row(children: [
                      Icon(Icons.calendar_today,
                          size: 24, color: primaryColor),
                      Padding(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Date and Time",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                getDateTimeText(),
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey[500]),
                              )
                            ]),
                        padding: EdgeInsets.only(left: 15),
                      )
                    ])),
                    Icon(Icons.chevron_right)
                  ]))),
          Divider(color: Colors.grey[500], height: 0),
          new GestureDetector(
            child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child: Row(children: <Widget>[
                  Expanded(
                      child: Row(children: [
                    Icon(Icons.location_on, size: 24, color: primaryColor),
                    Padding(
                      child: Wrap(direction: Axis.vertical, children: <Widget>[
                        Text(
                          "Location",
                          style: TextStyle(fontSize: 20),
                        ),
                        Expanded(
                            child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Text(
                                  getLocation(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 10,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[500]),
                                )))
                      ]),
                      padding: EdgeInsets.only(left: 15),
                    )
                  ])),
                  Icon(Icons.chevron_right)
                ])),
            onTap: () {
              Navigator.of(context).pushNamed('/add_appointment_select_location', arguments: this.location).
              then((value){
                setState(() {});
              });
            },
          ),
          Divider(color: Colors.grey[500], height: 0),
          Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(children: [
                      Icon(Icons.people, size: 24, color: primaryColor),
                      Padding(
                          child: Text("Pax", style: TextStyle(fontSize: 20)),
                          padding: EdgeInsets.only(left: 15))
                    ])),
                Padding(
                  child: Row(children: [
                    Expanded(
                        child: new GestureDetector(
                            child: Text("Adult: $adult",
                                style: TextStyle(fontSize: 20)),
                            onTap: _showAdultDialog)),
                    Expanded(
                        child: new GestureDetector(
                            child: Text("Kid: $kid",
                                style: TextStyle(fontSize: 20)),
                            onTap: _showKidDialog))
                  ]),
                  padding: EdgeInsets.only(left: 40),
                )
              ])),
          Divider(color: Colors.grey[500], height: 0),
          Container(
              color: Colors.white,
              child: Padding(
                  child: TextField(
                      decoration: new InputDecoration(
                          icon: Icon(
                            Icons.note_add,
                            color: primaryColor,
                          ),
                          labelText: "Note",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 20),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor)),
                          helperText: "*Optional"),
                      onChanged: (text) {
                        note = text;
                      }),
                  padding: EdgeInsets.only(
                      left: 20, top: 10, right: 20, bottom: 20))),
          Divider(color: Colors.grey[500], height: 0)
        ]))));
  }

  void _showAdultDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
            minValue: 0,
            maxValue: 100,
            initialIntegerValue: adult,
            title: new Text("Pick the the amount of adult"),
          );
        }).then((int value) {
      if (value != null) {
        setState(() {
          this.adult = value;
        });
      }
    });
  }

  void _showKidDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
            minValue: 0,
            maxValue: 100,
            initialIntegerValue: kid,
            title: new Text("Pick the the amount of kid"),
          );
        }).then((int value) {
      if (value != null) {
        setState(() {
          this.kid = value;
        });
      }
    });
  }

  String getLocation() {
    if (location.address.isEmpty ||
        location.latitude == 0 ||
        location.longitude == 0) {
      return "Select location";
    } else {
      return location.address;
    }
  }

  String getDateTimeText() {
    if (dateTime == null) {
      return "Select date and Time";
    } else {
      return dateTimeStr;
    }
  }

  void addAppointment() {
    bool check = true;
    if (dateTimeStr.isEmpty) {
      check = false;
      errorMessage("The date and time cannot be empty");
    } else if (location.latitude == 0 ||
        location.longitude == 0 ||
        location.address.isEmpty) {
      check = false;
      errorMessage("The location cannot be empty");
    } else if (adult == 0 && kid == 0) {
      check = false;
      errorMessage("The pax cannot be empty");
    }

    if (check) {
      successMessage("Add appointment successfully");
    }

    print(dateTime);
    print(location);
    print(note);
  }

  void errorMessage(String errMsg) {
    Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0), color: Colors.red),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.error_outline, color: Colors.white),
          SizedBox(width: 12.0),
          Expanded(
              child: Text(errMsg,
                  style: TextStyle(color: Colors.white, fontSize: 12))),
        ]));
    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        gravity: ToastGravity.BOTTOM);
  }

  void successMessage(String scsMsg) {
    Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.greenAccent),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.check, color: Colors.white),
          SizedBox(width: 12.0),
          Expanded(
              child: Text(scsMsg,
                  style: TextStyle(color: Colors.white, fontSize: 12)))
        ]));
    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        gravity: ToastGravity.BOTTOM);
  }

  Future<void> _selectDateTimePicker(BuildContext context) async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: selectDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (date != null) {
      final TimeOfDay time = await showTimePicker(
          context: context,
          initialTime:
              TimeOfDay(hour: selectTime.hour, minute: selectTime.minute));
      if (time != null) {
        setState(() {
          selectDate = date;
          selectTime = time;
          this.dateTime = DateTime(selectDate.year, selectDate.month,
              selectDate.day, selectTime.hour, selectTime.minute);
          dateTimeStr = dateFormat.format(dateTime);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    note = "";
    location = new Location("", 0, 0);
    dateTime = null;
    dateTimeStr = "";
    adult = 0;
    kid = 0;
    selectDate = new DateTime.now();
    selectTime = new TimeOfDay.now();
  }

  DateTime checkDate() {
    if (selectDate == null) {
      return new DateTime.now();
    } else {
      return selectDate;
    }
  }
}

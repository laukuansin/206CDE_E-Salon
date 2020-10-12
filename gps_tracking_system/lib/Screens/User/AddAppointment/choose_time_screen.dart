import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/appointment_list_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/get_services_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/Utility/RestApi/user_get_appointment_available_time_slot.dart';
import 'package:gps_tracking_system/color.dart';

class ChooseTimeScreen extends StatefulWidget {
  final Appointment appointment;
  final List<Service> service;

  ChooseTimeScreen(Map<String, dynamic> arg)
      : appointment = arg["appointment"],
        service = arg["services"];

  @override
  State<StatefulWidget> createState() =>
      ChooseTimeScreenState(appointment, service);
}

class ChooseTimeScreenState extends State<ChooseTimeScreen> {
  final Appointment appointment;
  final List<Service> services;
  List<String> _timeSlot = [];
  String selectedTime = "";

  ChooseTimeScreenState(this.appointment, this.services);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = 50;
    final double itemWidth = size.width / 3;

    return RouteGenerator.buildScaffold(
        Container(
            height: size.height,
            padding: EdgeInsets.only(top: 5),
            color: primaryBgColor,
            child: Column(
                children: [
                  Expanded(child:
              GridView.count(
                shrinkWrap: true,
                childAspectRatio: (itemWidth / itemHeight),
                crossAxisCount: 3,
                children: (_timeSlot.map((e) => Card(
                    elevation: 2,
                    child: InkWell(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          e,
                          style: TextStyleFactory.p(),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selectedTime = e;
                        });
                      },
                    ),
                    shape: () {
                      return (selectedTime == e)
                          ? RoundedRectangleBorder(
                              side: BorderSide(color: primaryColor, width: 2))
                          : RoundedRectangleBorder();
                    }()))).toList(),
              ),
                  ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      Navigator.of(context).pop(selectedTime);
                    },
                    color: primaryColor,
                    child: Text(
                      "SELECT",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              )
            ])),
        appbar: AppBar(
          title: Text(
            "Select time",
            style: TextStyleFactory.p(color: primaryTextColor),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    requestAvailableTimeSlot();
  }

  void requestAvailableTimeSlot() async {
    GetAppointmentAvailableTimeslotResponse result = await RestApi.customer
        .getAppointmentAvailableTimeSlot(
            appointment.getAppointmentDateStringDateMonthYear(), services);

    if (result.response.status == -1) {
      // Navigator.of(context).pushNamedAndRemoveUntil(newRouteName, (route) => false)
    } else {
      setState(() {
        _timeSlot = result.timeline;
      });
    }
  }
}

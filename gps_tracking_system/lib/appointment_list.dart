import 'package:flutter/material.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:gps_tracking_system/list_view.dart';

class AppointmentList extends StatefulWidget {
  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: primaryLightColor,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Appointment'),
          backgroundColor: primaryColor,
        ),
        body: Center(
            child: Container(
              height:size.height,
              width:size.width,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sep 2020",style: TextStyle(
                      color: primaryColor,
                    ),
                    ),
                    Icon(Icons.calendar_today, color: primaryColor,),
                  ]
                ),

                Container(
                  height: size.height * 0.8,
                  child: ListViewContainer(),

                )
              ],
            )

              //ListViewContainer(),
          ),
        )
    );
  }


}
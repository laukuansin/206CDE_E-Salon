import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/location.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/appointment_list_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/get_services_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/Utility/RestApi/user_make_appointment_response.dart';
import 'package:gps_tracking_system/color.dart';

class AddAppointmentScreen extends StatefulWidget {
  final Appointment appointment;
  final List<Service> services;
  final Location location;

  AddAppointmentScreen(Map<String, dynamic> arg)
      : appointment = arg["appointment"],
        services = arg["services"],
        location = arg["location"];

  AddAppointmentScreenState createState() =>
      AddAppointmentScreenState(appointment, services, location);
}

class AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final Appointment appointment;
  final List<Service> services;
  final Location location;
  String selectedTime = "";
  FToast fToast;

  AddAppointmentScreenState(this.appointment, this.services, this.location);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RouteGenerator.buildScaffold(
      // SingleChildScrollView(
         Container(
              height: size.height,
              width: size.width,
              color: primaryBgColor,
              child: Column(children: <Widget>[
                Expanded(
                    child: Column(children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 1),
                        color: primaryLightColor,
                        child: GestureDetector(
                            onTap: () => _selectAppointmentDate(context),
                            child: ListTile(
                              leading:
                                  Icon(Icons.calendar_today, color: primaryColor),
                              title: Text("Date"),
                              subtitle: appointment.appointmentDate == null
                                  ? Text("Select date")
                                  : Text(appointment
                                      .getAppointmentDateStringYYYYMMDD()),
                              trailing: Icon(Icons.chevron_right),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 1),
                        color: primaryLightColor,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("/choose_time",
                                  arguments: {
                                    "appointment": appointment,
                                    "services": services
                                  }).then((value) {
                                setState(() {
                                  if (value != null) selectedTime = value;
                                });
                              });
                            },
                            child: ListTile(
                              leading: Icon(Icons.access_time, color: primaryColor),
                              title: Text("Time"),
                              subtitle: selectedTime.isEmpty
                                  ? Text("Select time")
                                  : Text(selectedTime),
                              trailing: Icon(Icons.chevron_right),
                            )),
                      ),
                      Container(
                        color: primaryLightColor,
                        child: GestureDetector(
                          child: ListTile(
                            leading: Icon(
                              Icons.location_on,
                              color: primaryColor,
                            ),
                            title: Text("Address"),
                            subtitle: location.address.isEmpty
                                ? Text("Select location")
                                : Text(location.address),
                            trailing: Icon(Icons.chevron_right),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/location_picker',
                                    arguments: this.location)
                                .then((value) {
                              setState(() {});
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          width: size.width,
                          color: primaryLightColor,
                          child: Column(children: [
                            ListTile(
                              leading: Icon(
                                Icons.receipt,
                                color: primaryColor,
                              ),
                              title: Text("Services"),
                            ),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: _buildDataTable())
                          ])),
                ])),
                Container(
                    color: primaryLightColor,
                    margin: EdgeInsets.symmetric(horizontal: 5,),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child:FlatButton(
                      color: primaryColor,
                      child:Container(
                          child:Text(
                            "Make Appointment",
                            style: TextStyleFactory.p(color: primaryLightColor),
                          )
                      ),
                      onPressed: makeAppointment
                    )
                )
              ])),
      appbar: AppBar(
        title: Text(
          "Add Appointment",
          style: TextStyleFactory.p(color: primaryTextColor),
        ),
      ),
    );
  }

  void makeAppointment()  async{
    // appointment.address = location.address;
    // MakeAppointmentResponse result = await RestApi.customer.makeAppointment(appointment, services, selectedTime);
    // fToast.showToast(child: ToastWidget(status: result.response.status, msg: result.response.msg));
    //
    // if(result.response.status == 1){
    //   Navigator.of(context).pushNamedAndRemoveUntil('/home_page', ModalRoute.withName("/home_page"));
    // }
  }

  DataTable _buildDataTable() {
    Size size = MediaQuery.of(context).size;
    const MARGIN = 16.0;
    List<DataRow> dataRow = [];

    if (services.isNotEmpty)
      services.forEach((element) {
        if (element.quantity > 0)
          dataRow.add(DataRow(
              cells: [
            DataCell(Container(
                width: (size.width - MARGIN * 2) * 0.4,
                child: Text(element.serviceName))),
            DataCell(Container(
              width: (size.width - MARGIN * 2) * 0.4,
              child: Align(
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.remove,
                            size: 14,
                          ),
                          onPressed: () {
                            setState(() {
                              if (element.quantity > 0) element.quantity--;
                            });
                          },
                        ),
                        Text(element.quantity.toString()),
                        IconButton(
                          icon: Icon(Icons.add, size: 14),
                          onPressed: () {
                            setState(() {
                              element.quantity++;
                            });
                          },
                        ),
                      ])),
            )),
            DataCell(Container(
                width: (size.width - MARGIN * 2) * 0.2,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        (element.servicePrice * element.quantity).toString()))))
          ]));
      });

    dataRow.add(DataRow(
      cells:[
        DataCell(
          SizedBox(width: (size.width - MARGIN * 2) * 0.4),
        ),
        DataCell(
          Container(
            width: (size.width - MARGIN * 2) * 0.4,
            child:Align(
              alignment: Alignment.center,
                child:Text(
                  "Total Price",
                  style: TextStyleFactory.heading6(),
                )
            )
          )
        ),
        DataCell(Container(
            width: (size.width - MARGIN * 2) * 0.2,
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(_calcTotalPrice().toString())
            )))
      ]

    ));

    return DataTable(
        horizontalMargin: MARGIN,
        columnSpacing: 0,
        columns: [
          DataColumn(
              label: Container(
                  width: (size.width - MARGIN * 2) * 0.4,
                  child: Text(
                    "Service",
                    style: TextStyleFactory.p(),
                  ))),
          DataColumn(
              label: Container(
                  width: (size.width - MARGIN * 2) * 0.4,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Qty",
                        style: TextStyleFactory.p(),
                      )))),
          DataColumn(
              label: Container(
                  width: (size.width - MARGIN * 2) * 0.2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Sub(RM)",
                      style: TextStyleFactory.p(),
                    ),
                  ))),
        ],
        rows: dataRow
    );
  }

  double _calcTotalPrice(){
    double totalPrice = 0.0;
    services.forEach((element) {
      totalPrice += element.servicePrice * element.quantity;
    });
    return totalPrice;
  }

  Future<void> _selectAppointmentDate(BuildContext context) async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: appointment.appointmentDate == null
            ? DateTime.now()
            : appointment.appointmentDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));

    if (date != null) {
      setState(() {
        appointment.appointmentDate = date;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }
}

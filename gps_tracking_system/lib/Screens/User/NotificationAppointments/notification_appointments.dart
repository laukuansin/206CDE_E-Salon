import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/appointment.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/common_appointment_list_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class NotificationAppointmentsScreen extends StatefulWidget {
  @override
  NotificationAppointmentsScreenState createState() =>
      NotificationAppointmentsScreenState();
}

class NotificationAppointmentsScreenState
    extends State<NotificationAppointmentsScreen> {
  List<Appointment> _appointmentList;
  FToast fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
    requestMyAppointments();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RouteGenerator.buildScaffold(
        Container(
          height: size.height,
          width: size.width,
          color: primaryBgColor,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: isShowAppointmentList() ? _appointmentList.length : 0,
              itemBuilder: (context, index) {
                return Container(
                  color: primaryLightColor,
                  margin: EdgeInsets.only(bottom: 1),
                  child: Column(children: <Widget>[
                    Padding(
                        child: ListTile(
                          leading: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(_appointmentList[index].getAppointmentDateStringDD(),
                                  style: TextStyleFactory.heading1(
                                      color: dateColor)),
                              Text(_appointmentList[index].getAppointmentDateStringMMM(),
                                  style: TextStyleFactory.p())
                            ],
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(_appointmentList[index].services),
                              Padding(
                                  child: Text(_appointmentList[index].appointmentTime,
                                      style: TextStyleFactory.p()),
                                  padding: EdgeInsets.only(top: 10))
                            ],
                          ),
                          trailing:
                              statusWidget(_appointmentList[index].status),
                        ),
                        padding: EdgeInsets.all(10)),
                  ]),
                );
              }),
        ),
        appbar: AppBar(
            title: Text("Appointment Request", style: TextStyleFactory.p(color: primaryTextColor))));
  }

  bool isShowAppointmentList() {
    if (_appointmentList == null)
      return false;
    else
      return true;
  }

  Widget statusWidget(Status status) {
    Color color;
    IconData icon;
    if (status == Status.ACCEPTED) {
      color = Colors.greenAccent;
      icon = Icons.done;
    } else if (status == Status.REJECTED) {
      color = Colors.red;
      icon = Icons.close;
    } else if (status == Status.PENDING) {
      color = Colors.amber;
      icon = Icons.access_time;
    } else if (status == Status.CLOSE) {
      color = Colors.green;
      icon = Icons.done;
    } else if (status == Status.CANCELLED) {
      color = Colors.red;
      icon = Icons.close;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: color,
        ),
        Text(status.toString().split('.').last, style: TextStyleFactory.p(color: color))
      ],
    );
  }

  void requestMyAppointments() async {
    final ProgressDialog progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();
    AppointmentListResponse result = await RestApi.customer.getAppointmentRequest();
    progressDialog.hide();

    if (result.response.status == 1) {
      setState(() {
        _appointmentList = result.appointments;
      });
    } else {
      _appointmentList = null;
      fToast.showToast(
          child: ToastWidget(
        status: result.response.status,
        msg: result.response.msg,
      ));
    }
  }
}

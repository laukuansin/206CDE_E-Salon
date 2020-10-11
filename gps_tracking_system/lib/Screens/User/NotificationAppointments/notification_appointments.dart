import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/my_appointment_list_response.dart';
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
    return RouteGenerator.buildScaffold(
        Container(
          color: Colors.white,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: isShowAppointmentList() ? _appointmentList.length : 0,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Column(children: <Widget>[
                    Padding(
                        child: ListTile(
                          leading: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(_appointmentList[index].day,
                                  style: TextStyleFactory.heading1(
                                      color: dateColor)),
                              Text(_appointmentList[index].month,
                                  style: TextStyleFactory.p())
                            ],
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(_appointmentList[index].serviceName),
                              Padding(
                                  child: Text(_appointmentList[index].time,
                                      style: TextStyleFactory.p()),
                                  padding: EdgeInsets.only(top: 10))
                            ],
                          ),
                          trailing:
                              statusWidget(_appointmentList[index].status),
                        ),
                        padding: EdgeInsets.all(10)),
                    Divider(color: primaryDeepLightColor, thickness: 0.5)
                  ]),
                );
              }),
        ),
        appbar: AppBar(
            title: Text("My Appointments",
                style: TextStyleFactory.p(color: primaryTextColor))));
  }

  bool isShowAppointmentList() {
    if (_appointmentList == null)
      return false;
    else
      return true;
  }

  Widget statusWidget(String status) {
    Color color;
    IconData icon;
    if (status == "Accepted") {
      color = Colors.greenAccent;
      icon = Icons.done;
    } else if (status == "Rejected") {
      color = Colors.red;
      icon = Icons.close;
    } else if (status == "Pending") {
      color = Colors.yellowAccent[700];
      icon = MdiIcons.loading;
    } else if (status == "Completed") {
      color = Colors.green;
      icon = Icons.done;
    } else if (status == "Cancelled") {
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
        Text(status, style: TextStyleFactory.p(color: color))
      ],
    );
  }

  void requestMyAppointments() async {
    final ProgressDialog progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();
    MyAppointmentListResponse result =
        await RestApi.customer.getAppointmentList();
    progressDialog.hide();

    if (result.response.status == 1) {
      setState(() {
        _appointmentList = result.list;
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

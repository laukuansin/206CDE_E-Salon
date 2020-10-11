import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/manage_appointment_response.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/Utility/RestApi/update_appointment_response.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:multi_select_item/multi_select_item.dart';

class ManageAppointmentScreen extends StatefulWidget {
  @override
  ManageAppointmentScreenState createState() => ManageAppointmentScreenState();
}

class ManageAppointmentScreenState extends State<ManageAppointmentScreen> {
  List<Appointment> _appointmentList;
  FToast fToast;
  MultiSelectController controller = new MultiSelectController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
    requestGetAppointments();

  }

  @override
  Widget build(BuildContext context) {
    return RouteGenerator.buildScaffold(
        Container(
            color: Colors.white,
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                    isShowAppointmentList() ? _appointmentList.length : 0,
                itemBuilder: (context, index) {
                  Appointment appointment = _appointmentList[index];
                  return Dismissible(
                    key: Key(appointment.appointmentId.toString()),
                    onDismissed: (DismissDirection dir) {
                      setState(() {
                        if (dir == DismissDirection.startToEnd)
                          updateAppointmentStatus(appointment.appointmentId, 2);
                        else
                          updateAppointmentStatus(appointment.appointmentId, 1);

                        _appointmentList.removeAt(index);
                        controller.set(_appointmentList.length);
                      });
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(dir == DismissDirection.startToEnd
                            ? "Reject Appointment"
                            : "Accept Apoointment"),
                      ));
                    },
                    background: Container(
                      child: Padding(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.close, color: Colors.white),
                            Text("Reject",
                                style: TextStyleFactory.p(color: Colors.white))
                          ],
                        ),
                        padding: EdgeInsets.only(left: 30),
                      ),
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                    ),
                    secondaryBackground: Container(
                      child: Padding(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.done, color: Colors.white),
                            Text("Accept",
                                style: TextStyleFactory.p(color: Colors.white))
                          ],
                        ),
                        padding: EdgeInsets.only(right: 30),
                      ),
                      color: Colors.green,
                      alignment: Alignment.centerRight,
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Column(children: <Widget>[
                        Padding(
                            child: MultiSelectItem(
                              isSelecting: controller.isSelecting,
                              onSelected: () {
                                setState(() {
                                  _appointmentList[index].selected=true;
                                  controller.toggle(index);
                                });
                              },
                              child: ListTile(
                                leading: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(appointment.day,
                                        style: TextStyleFactory.heading1(
                                            color: dateColor)),
                                    Text(appointment.month,
                                        style: TextStyleFactory.p())
                                  ],
                                ),
                                title: itemBody(appointment),
                                trailing: controller.isSelected(index)?
                                    Icon(Icons.check_circle,color: Colors.green)
                               :null
                              ),
                            ),
                            padding: EdgeInsets.all(10)),
                        Divider(color: primaryDeepLightColor, thickness: 0.5)
                      ]),
                    ),
                  );
                })),
        appbar: AppBar(
            title: Text("Manage Appointment",
                style: TextStyleFactory.p(color: primaryTextColor)),
            leading: controller.isSelecting
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        controller.deselectAll();
                        _appointmentList.forEach((a) => a.selected = false);
                      });
                    },
                  )
                : null,
            actions: controller.isSelecting
                ? [
                    IconButton(icon: Icon(Icons.delete), onPressed: () {

                      for(Appointment appointment in _appointmentList)
                        {
                          if(appointment.selected)
                          {
                            updateAppointmentStatus(appointment.appointmentId, 2);
                          }
                        }
                        setState(() {
                          _appointmentList.clear();
                          requestGetAppointments();
                          controller.deselectAll();
                        });
                    }),
                    IconButton(icon: Icon(Icons.done), onPressed: () {
                      for(Appointment appointment in _appointmentList)
                      {
                        if(appointment.selected)
                        {
                          updateAppointmentStatus(appointment.appointmentId, 1);
                        }
                      }
                      setState(() {
                        _appointmentList.clear();
                        requestGetAppointments();
                        controller.deselectAll();
                      });
                    })
                  ]
                : null));
  }

  bool isShowAppointmentList() {
    if (_appointmentList == null)
      return false;
    else
      return true;
  }

  Widget itemBody(Appointment appointment) {
    String customerName = appointment.customerName;
    String serviceName = appointment.serviceName;
    String workerName = appointment.workerName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("$customerName - $serviceName"),
        Padding(
            child: Text(appointment.time, style: TextStyleFactory.p()),
            padding: EdgeInsets.only(top: 10)),
        Padding(
          child: Text("Worker- $workerName", style: TextStyleFactory.p()),
          padding: EdgeInsets.only(top: 10),
        )
      ],
    );
  }

  void requestGetAppointments() async {
    ManageAppointmentResponse result = await RestApi.admin.getAppointmentList();
    if (result.response.status == 1) {
      setState(() {
        _appointmentList = result.list;
        controller.disableEditingWhenNoneSelected = true;;
        controller.set(_appointmentList.length);
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

  void updateAppointmentStatus(int appointmentID, int statusID) async {
    UpdateAppointmentResponse result =
        await RestApi.admin.updateAppointment(appointmentID, statusID);
    if (result.response.status == 1) {
      fToast.showToast(
          child: ToastWidget(
        status: result.response.status,
        msg: result.response.msg,
      ));
    } else {
      fToast.showToast(
          child: ToastWidget(
        status: result.response.status,
        msg: result.response.msg,
      ));
    }
  }
}

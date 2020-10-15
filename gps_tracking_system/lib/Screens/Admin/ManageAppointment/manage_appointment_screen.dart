import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/appointment_list_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/Utility/RestApi/update_appointment_response.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:multi_select_item/multi_select_item.dart';

class ManageAppointmentScreen extends StatefulWidget {
  @override
  ManageAppointmentScreenState createState() => ManageAppointmentScreenState();
}

class ManageAppointmentScreenState extends State<ManageAppointmentScreen> {
  List<Appointment> _appointmentList = [];
  Map<String, bool> _selectedAppointment = {};
  FToast fToast;
  MultiSelectController _multiSelectionController = new MultiSelectController();

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    requestGetAppointments();
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
                itemCount: _appointmentList.length,
                itemBuilder: (context, index) {
                  Appointment appointment = _appointmentList[index];
                  return Container(
                      margin: EdgeInsets.only(top: 1),
                      color: primaryLightColor,
                      child: Dismissible(
                        key: Key(appointment.appointmentId.toString()),
                        onDismissed: (DismissDirection dir) {
                          setState(() {
                            if (dir == DismissDirection.startToEnd)
                              _updateAppointmentStatus(appointment.appointmentId, Status.REJECTED);
                            else
                              _updateAppointmentStatus(appointment.appointmentId, Status.ACCEPTED);

                            _appointmentList.removeAt(index);
                            _multiSelectionController.set(_appointmentList.length);
                          });
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text(dir == DismissDirection.startToEnd ? "Reject Appointment" : "Accept Appointment"),));
                        },
                        background: Container(
                          child: Padding(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.close, color: primaryLightColor),
                                Text("Reject", style: TextStyleFactory.p(color: primaryLightColor))
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
                                Icon(Icons.done, color: primaryLightColor),
                                Text("Accept", style: TextStyleFactory.p(color: primaryLightColor))
                              ],
                            ),
                            padding: EdgeInsets.only(right: 30),
                          ),
                          color: Colors.green,
                          alignment: Alignment.centerRight,
                        ),
                        child: _buildAppointmentContainer(index, appointment),
                      ));
                })),
        appbar: AppBar(
            title: Text("Manage Appointment", style: TextStyleFactory.p(color: primaryTextColor)),
            leading: _multiSelectionController.isSelecting
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _multiSelectionController.deselectAll();
                        _appointmentList.forEach((a) => _selectedAppointment[a.appointmentId] = false);
                      });
                    },
                  )
                : null,
            actions: _multiSelectionController.isSelecting
                ? [
                    IconButton(
                        icon: Icon(Icons.delete, color: primaryColor,),
                        onPressed: () {
                          setState(() {
                            _appointmentList.where((element)=> _selectedAppointment[element.appointmentId]).toList().forEach((element) {
                              _updateAppointmentStatus(element.appointmentId, Status.REJECTED);
                              _appointmentList.remove(element);
                            });
                            _multiSelectionController.deselectAll();
                          });
                        }),
                    IconButton(
                        icon: Icon(Icons.done, color: primaryColor,),
                        onPressed: () {
                          setState(() {
                            _appointmentList.where((element) =>
                            _selectedAppointment[element.appointmentId])
                                .toList()
                                .forEach((element) {
                              _updateAppointmentStatus(
                                  element.appointmentId, Status.ACCEPTED);
                              _appointmentList.remove(element);
                            });
                            _multiSelectionController.deselectAll();
                          });
                        })
                  ]
                : null),
    drawer: RouteGenerator.buildDrawer(context));
  }

  Container _buildAppointmentContainer(int index, Appointment appointment) {
    return Container(
      color: primaryLightColor,
      child: Column(children: <Widget>[
        Padding(
            child: MultiSelectItem(
              isSelecting: _multiSelectionController.isSelecting,
              onSelected: () {
                setState(() {
                  _selectedAppointment[_appointmentList[index].appointmentId] = true;
                  _multiSelectionController.toggle(index);
                });
              },
              child: ListTile(
                  leading: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center,
                    children: [
                      Text(appointment.getAppointmentDateStringDD(), style: TextStyleFactory.heading1(color: dateColor)),
                      Text(appointment.getAppointmentDateStringMMM().toUpperCase(), style: TextStyleFactory.p())
                    ],
                  ),
                  title: Text("${appointment.customerName}"),
                  subtitle: Text("${appointment.services}\n${appointment.appointmentTime}\nWorker - ${appointment.workerName}"),
                  trailing: _multiSelectionController.isSelected(index) ? Icon(Icons.check_circle, color: Colors.green) : null),
            ),
            padding: EdgeInsets.all(10)),
      ]),
    );
  }

  void requestGetAppointments() async {
    AppointmentListResponse result = await RestApi.admin.getAppointmentRequests();
    if (result.response.status == 1) {
      setState(() {
        _appointmentList = result.appointments;

        for (Appointment appointment in _appointmentList) {
          _selectedAppointment[appointment.appointmentId] = false;
        }

        _multiSelectionController.disableEditingWhenNoneSelected = true;
        _multiSelectionController.set(_appointmentList.length);
      });
    } else {
      fToast.showToast(
          child: ToastWidget(
        status: result.response.status,
        msg: result.response.msg,
      ));
    }
  }

  void _updateAppointmentStatus(String appointmentID, Status status) async {
    UpdateAppointmentResponse result = await RestApi.admin.updateAppointment(appointmentID, status);
    fToast.showToast(
        child: ToastWidget(
      status: result.response.status,
      msg: result.response.msg,
    ));
  }
}

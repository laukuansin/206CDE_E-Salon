import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/admin_setting_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/admin_edit_setting_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SettingPageScreen extends StatefulWidget {
  @override
  SettingPageScreenState createState() => SettingPageScreenState();
}

class SettingPageScreenState extends State<SettingPageScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FToast fToast;
  String _errCancelTime, _errTravelTime, _errAppointmentInterval;
  Setting setting;

  @override
  Widget build(BuildContext context) {
    return RouteGenerator.buildScaffold(
        setting != null ? SingleChildScrollView(
          child: Container(
            color: primaryLightColor,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.access_time,
                      color: primaryColor,
                    ),
                    title: Text("Business Hour", style: TextStyleFactory.p()),
                  ),
                  Column(
                    children: List<ListTile>.generate(
                        setting == null ? 0 : setting.businessHour.days.length,
                        (index) {
                      Map<String, Day> days = setting.businessHour.days;
                      List keys = days.keys.toList();

                      return ListTile(
                        leading: Text(
                          keys[index],
                          style: TextStyleFactory.p(),
                        ),
                        title: Text(
                          days[keys[index]].isOpen
                              ? "${days[keys[index]].getStartTime()} - ${days[keys[index]].getEndTime()}"
                              : "Closed",
                          textAlign: TextAlign.right,
                          style: TextStyleFactory.p(color: primaryTextColor),
                        ),
                        trailing: IconButton(
                            icon: Icon(
                              Icons.edit,
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return BusinessHourDialog(
                                        keys[index], days[keys[index]]);
                                  }).then((_) {
                                setState(() {});
                              });
                            }),
                      );
                    }),
                  ),
                  Divider(thickness: 0.5, color: primaryDeepLightColor),
                  _buildInputRow(_buildCancelTime()),
                  _buildInputRow(_buildTravelTime()),
                  _buildInputRow(_buildAppointmentInterval()),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      onTap: (){Navigator.of(context).pushNamed("/holiday_page");},
                      leading: Icon(
                                Icons.airplanemode_active,
                                color: primaryColor,
                              ),
                              title: Text(
                                "Holiday",
                                style: TextStyleFactory.p(),
                              ),
                              trailing: Icon(Icons.chevron_right),
                            )
                  )
                ],
              ),
            ),
          ),
        ): Container(),
        key: _scaffoldKey,
        appbar: AppBar(
            backgroundColor: Color(0xFF65CBF2),
            title: Text(
              "Account",
              style: TextStyleFactory.heading5(color: primaryLightColor),
            ),
            elevation: 0,
            iconTheme: IconThemeData(color: primaryLightColor),
            actions: <Widget>[
              IconButton(
                    onPressed: requestUpdateSetting,
                    icon: Icon(
                      Icons.check,
                      color: primaryLightColor,
                    ),
              )
            ]),
        drawer: RouteGenerator.buildDrawer(context));
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    requestGetSetting();
    clearErrorMessage();
  }

  Column _buildInputRow(Widget input, {isLast = false}) {
    return Column(
      children: <Widget>[
        ListTile(
          title: input,
        ),
        SizedBox(
          height: 5,
        ),
        (() {
          if (!isLast) {
            return Divider(
              color: primaryDeepLightColor,
              thickness: 0.5,
            );
          }
          return SizedBox(
            height: 10,
          );
        }()),
      ],
    );
  }

  void requestUpdateSetting() async {
    FocusScope.of(context).unfocus();
    _formKey.currentState.save();
    EditSettingResponse result = await RestApi.admin.editSetting(setting);

    if (result.response.status == 1) {
      fToast.init(_scaffoldKey.currentContext);
      fToast.showToast(
          child: ToastWidget(
        status: result.response.status,
        msg: result.response.msg,
      ));
    } else {
      setState(() {
        _errAppointmentInterval = result.error.appointment_interval;
        _errCancelTime = result.error.cancellation_time;
        _errTravelTime = result.error.travel_time;
      });
    }
  }

  void clearErrorMessage() {
    _errCancelTime = _errAppointmentInterval = _errTravelTime = "";
  }

  void requestGetSetting() async {
    final ProgressDialog progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();
    ServiceSettingResponse result = await RestApi.admin.getSetting();
    progressDialog.hide();

    this.setting = result.setting;
    if (result.response.status == 1) {
      setState(() {});
    } else {
      fToast.showToast(
          child: ToastWidget(
        status: result.response.status,
        msg: result.response.msg,
      ));
    }
  }

  InputDecoration standardInputDecoration(String label, IconData iconData) =>
      InputDecoration(
          icon: Icon(
            iconData,
            color: primaryColor,
          ),
          labelText: label,
          labelStyle: TextStyleFactory.p());

  TextFormField _buildCancelTime() {
    return TextFormField(
      key: Key(setting.cancellationTime.toString()),
      keyboardType: TextInputType.number,
      initialValue: setting.cancellationTime.toString(),
      validator: (_) => (_errCancelTime.isEmpty) ? null : _errCancelTime,
      onSaved: (value) {
        setting.cancellationTime = int.parse(value);
      },
      decoration: standardInputDecoration("Cancellation Time", Icons.cancel),
    );
  }

  TextFormField _buildTravelTime() {
    return TextFormField(
      key: Key(setting.travelTime.toString()),
      initialValue: setting.travelTime.toString(),
      validator: (_) => _errTravelTime.isEmpty ? null : _errTravelTime,
      decoration: standardInputDecoration("Travel Time", Icons.time_to_leave),
      keyboardType: TextInputType.number,
      onSaved: (value) {
        setting.travelTime = int.parse(value);
      },
    );
  }

  TextFormField _buildAppointmentInterval() {
    return TextFormField(
      key: Key(setting.appointmentInterval.toString()),
      initialValue: setting.appointmentInterval.toString(),
      keyboardType: TextInputType.number,
      validator: (_) =>
          _errAppointmentInterval.isEmpty ? null : _errAppointmentInterval,
      decoration:
          standardInputDecoration("Appointment Interval", Icons.all_inclusive),
      onSaved: (value) {
        setting.appointmentInterval = int.parse(value);
      },
    );
  }
}

class BusinessHourDialog extends StatefulWidget {
  final Day day;
  final String dayName;

  @override
  BusinessHourDialogState createState() =>
      new BusinessHourDialogState(dayName, day);

  BusinessHourDialog(this.dayName, this.day);
}

class BusinessHourDialogState extends State<BusinessHourDialog> {
  final DateFormat timeFormat = DateFormat.jm();
  Day day;
  String dayName;
  String startTime;
  String endTime;
  bool isOpen;
  FToast fToast;

  BusinessHourDialogState(this.dayName, this.day);

  Future<String> _selectTime(BuildContext context, String time) async {
    final TimeOfDay selectedTime = await showTimePicker(
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        },
        context: context,
        initialTime: TimeOfDay.fromDateTime(timeFormat.parse(time)));

    if (selectedTime == null) return time;
    String meridiem = selectedTime.hour > 12 ? "PM" : "AM";
    String min = selectedTime.minute >= 10
        ? selectedTime.minute.toString()
        : "0${selectedTime.minute}";
    return "${selectedTime.hour % 12}:$min $meridiem";
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(this.context);

    startTime = day.getStartTime();
    endTime = day.getEndTime();
    isOpen = day.isOpen;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(dayName,
            style: TextStyleFactory.heading5(), textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CheckboxListTile(
                title: Text("Closed"),
                contentPadding: EdgeInsets.zero,
                value: !isOpen,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (newValue) {
                  setState(() {
                    isOpen = !newValue;
                  });
                }),
            Visibility(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RawMaterialButton(
                    fillColor: primaryLightColor,
                    onPressed: () async {
                      _selectTime(context, startTime).then((value) {
                        setState(() {
                          startTime = value;
                        });
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(
                          bottom: 3, // space between underline and text
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: primaryColor, // Text colour here
                          width: 1.0, // Underline width
                        ))),
                        child: Text(
                          startTime,
                          style: TextStyleFactory.p(color: primaryTextColor),
                        )),
                    elevation: 0,
                  ),
                  Padding(
                    child: Text(
                      "To",
                      textAlign: TextAlign.center,
                      style: TextStyleFactory.p(color: primaryTextColor),
                    ),
                    padding: EdgeInsets.only(bottom: 5),
                  ),
                  RawMaterialButton(
                    fillColor: primaryLightColor,
                    onPressed: () async {
                      _selectTime(context, endTime).then((value) {
                        setState(() {
                          endTime = value;
                        });
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(
                          bottom: 3, // space between underline and text
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: primaryColor, // Text colour here
                          width: 1.0, // Underline width
                        ))),
                        child: Text(
                          endTime,
                          style: TextStyleFactory.p(color: primaryTextColor),
                        )),
                    elevation: 0,
                  ),
                ],
              ),
              visible: isOpen,
            )
          ],
        ),
        actions: <Widget>[
          MaterialButton(
            child: Text("Cancel",
                style: TextStyleFactory.heading6(color: primaryColor)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          MaterialButton(
            child: Text("Save",
                style: TextStyleFactory.heading6(color: primaryColor)),
            onPressed: () {
              if (timeFormat
                  .parse(startTime)
                  .isBefore(timeFormat.parse(endTime))) {
                day.startTime = startTime.split(" ")[0];
                day.startMeridiem = startTime.split(" ")[1];
                day.endTime = endTime.split(" ")[0];
                day.endMeridiem = endTime.split(" ")[1];
                day.isOpen = isOpen;
                Navigator.of(context).pop();
              } else {
                fToast.showToast(
                    child: ToastWidget(
                        status: 0, msg: "Close time must after open time!"),
                    toastDuration: Duration(seconds: 2),
                    gravity: ToastGravity.BOTTOM);
              }
            },
          )
        ]);
  }
}

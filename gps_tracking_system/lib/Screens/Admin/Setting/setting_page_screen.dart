import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/open_close_time.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/edit_setting_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/Utility/RestApi/setting_response.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SettingPageScreen extends StatefulWidget {
  @override
  SettingPageScreenState createState() => SettingPageScreenState();
}

class SettingPageScreenState extends State<SettingPageScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FToast fToast;
  int cancelTime=0,travelTime=0,appointmentInterval=0;
  String _errCancelTime,_errTravelTime,_errAppointmentInterval;
  String monOpenTime="",monCloseTime="";
  String tuesOpenTime="",tuesCloseTime="";
  String wedOpenTime="",wedCloseTime="";
  String thursOpenTime="",thursCloseTime="";
  String friOpenTime="",friCloseTime="";
  String satOpenTime="",satCloseTime="";
  String sunOpenTime="",sunCloseTime="";
  bool monCloseCheck=true,tuesCloseCheck=true,wedCloseCheck=true,thursCloseCheck=true,friCloseCheck=true,satCloseCheck=true,sunCloseCheck=true;


  @override
  Widget build(BuildContext context) {
    return RouteGenerator.buildScaffold(
        SingleChildScrollView(
          child: Container(
            color: primaryLightColor,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.access_time,color: primaryColor,),
                    title: Text("Business Hour", style: TextStyleFactory.p()),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(5),
                    leading: Text("Monday",style: TextStyleFactory.heading6()),
                    title:Text(monCloseCheck?"Closed":"$monOpenTime - $monCloseTime",textAlign: TextAlign.end),
                    trailing:RawMaterialButton(child:  Icon(Icons.edit),
                    onPressed:()
                    {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return MondayDialog(monOpenTime,monCloseTime,monCloseCheck);
                          }).then((value){
                            OpenCloseTime openCloseTime= value;
                            setState(() {
                                 monCloseCheck=openCloseTime.closed;
                                  monOpenTime=openCloseTime.openTime;
                                  monCloseTime=openCloseTime.closeTime;

                            });
                      });
                    }
                      ),
                  ),
                  ListTile(
                      contentPadding: EdgeInsets.all(5),
                      leading: Text("Tuesday",style: TextStyleFactory.heading6()),
                    title:Text(tuesCloseCheck?"Closed":"$tuesOpenTime - $tuesCloseTime",textAlign: TextAlign.end),
                      trailing:RawMaterialButton(child:  Icon(Icons.edit),
                      onPressed:()
                      {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return TuesdayDialog(tuesOpenTime,tuesCloseTime,tuesCloseCheck);
                            }).then((value){
                          OpenCloseTime openCloseTime= value;
                          setState(() {
                              tuesCloseCheck=openCloseTime.closed;
                              tuesOpenTime=openCloseTime.openTime;
                              tuesCloseTime=openCloseTime.closeTime;

                          });
                        });
                      }
                      )
                  ),
                  ListTile(
                      contentPadding: EdgeInsets.all(5),
                      leading: Text("Wednesday",style: TextStyleFactory.heading6()),
                    title:Text(wedCloseCheck?"Closed":"$wedOpenTime - $wedCloseTime",textAlign: TextAlign.end),
                      trailing:RawMaterialButton(child:  Icon(Icons.edit),
                          onPressed:()
                          {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return WednesdayDialog(wedOpenTime,wedCloseTime,wedCloseCheck);
                                }).then((value){
                              OpenCloseTime openCloseTime= value;
                              setState(() {
                                  wedCloseCheck=openCloseTime.closed;
                                  wedOpenTime=openCloseTime.openTime;
                                  wedCloseTime=openCloseTime.closeTime;
                              });
                            });
                          }
                      )
                  ),
                  ListTile(
                      contentPadding: EdgeInsets.all(5),
                      leading: Text("Thursday",style: TextStyleFactory.heading6()),
                    title:Text(thursCloseCheck?"Closed":"$thursOpenTime - $thursCloseTime",textAlign: TextAlign.end),
                      trailing:RawMaterialButton(child:  Icon(Icons.edit),
                          onPressed:()
                          {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return ThursdayDialog(thursOpenTime,thursCloseTime,thursCloseCheck);
                                }).then((value){
                              OpenCloseTime openCloseTime= value;
                              setState(() {
                                  thursCloseCheck=openCloseTime.closed;
                                  thursOpenTime=openCloseTime.openTime;
                                  thursCloseTime=openCloseTime.closeTime;
                              });
                            });
                          }
                      )
                  ),
                  ListTile(
                      contentPadding: EdgeInsets.all(5),
                      leading: Text("Friday",style: TextStyleFactory.heading6()),
                    title:Text(friCloseCheck?"Closed":"$friOpenTime - $friCloseTime",textAlign: TextAlign.end),
                      trailing:RawMaterialButton(child:  Icon(Icons.edit),
                          onPressed:()
                          {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return FridayDialog(friOpenTime,friCloseTime,friCloseCheck);
                                }).then((value){
                              OpenCloseTime openCloseTime= value;
                              setState(() {
                                friCloseCheck=openCloseTime.closed;
                                friOpenTime=openCloseTime.openTime;
                                friCloseTime=openCloseTime.closeTime;
                              });
                            });
                          }
                      )
                  ),
                  ListTile(
                      contentPadding: EdgeInsets.all(5),
                      leading: Text("Saturday",style: TextStyleFactory.heading6()),
                    title:Text(satCloseCheck?"Closed":"$satOpenTime - $satCloseTime",textAlign: TextAlign.end),
                      trailing:RawMaterialButton(child:  Icon(Icons.edit),
                          onPressed:()
                          {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return SaturdayDialog(satOpenTime,satCloseTime,satCloseCheck);
                                }).then((value){
                              OpenCloseTime openCloseTime= value;
                              setState(() {
                                satCloseCheck=openCloseTime.closed;
                                satOpenTime=openCloseTime.openTime;
                                satCloseTime=openCloseTime.closeTime;
                              });
                            });
                          }
                      )
                  ),
                ListTile(
                    contentPadding: EdgeInsets.all(5),
                    leading: Text("Sunday",style: TextStyleFactory.heading6()),
                  title:Text(sunCloseCheck?"Closed":"$sunOpenTime - $sunCloseTime",textAlign: TextAlign.end),
                  trailing:RawMaterialButton(child:  Icon(Icons.edit),
                      onPressed:()
                      {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return SundayDialog(sunOpenTime,sunCloseTime,sunCloseCheck);
                            }).then((value){
                          OpenCloseTime openCloseTime= value;
                          setState(() {
                            sunCloseCheck=openCloseTime.closed;
                            sunOpenTime=openCloseTime.openTime;
                            sunCloseTime=openCloseTime.closeTime;
                          });
                        });
                      }
                  )
                ),
                  Divider(thickness: 0.5,color: Colors.grey),
                  _buildInputRow(_buildCancelTime()),
                  _buildInputRow(_buildTravelTime()),
                  _buildInputRow(_buildAppointmentInterval(),isLast: true)
                ],
              ),
            ),
          ),
        ),
        key:_scaffoldKey,
        appbar: AppBar(
          backgroundColor: Color(0xFF65CBF2),
          title: Text(
            "Account",
            style: TextStyleFactory.heading5(color: primaryLightColor),
          ),
          elevation: 0,
          iconTheme: IconThemeData(color: primaryLightColor),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: updateSetting,
                  child: Icon(
                    Icons.check,
                    color: primaryLightColor,
                  ),
                )
            )
          ]
        ),
        drawer: RouteGenerator.buildDrawer(context));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
    getSetting();
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

  void updateSetting()async
  {
    final ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();

    _formKey.currentState.save();
    OpenCloseTime mon,tues,wed,thurs,fri,sat,sun;
    if(monCloseCheck)
    {
      monOpenTime="";
      monCloseTime="";
    }
    mon=OpenCloseTime(openTime: monOpenTime,closeTime: monCloseTime,closed: !monCloseCheck);

    if(tuesCloseCheck)
    {
      tuesOpenTime="";
      tuesCloseTime="";
    }
    tues=OpenCloseTime(openTime: tuesOpenTime,closeTime: tuesCloseTime,closed: !tuesCloseCheck);

    if(wedCloseCheck)
    {
      wedOpenTime="";
      wedCloseTime="";
    }
    wed=OpenCloseTime(openTime: wedOpenTime,closeTime: wedCloseTime,closed: !wedCloseCheck);

    if(thursCloseCheck)
    {
      thursOpenTime="";
      thursCloseTime="";
    }
    thurs=OpenCloseTime(openTime: thursOpenTime,closeTime: thursCloseTime,closed:!thursCloseCheck);

    if(friCloseCheck)
    {
      friOpenTime="";
      friCloseTime="";
    }
    fri=OpenCloseTime(openTime: friOpenTime,closeTime: friCloseTime,closed:!friCloseCheck);

    if(satCloseCheck)
    {
      satOpenTime="";
      satCloseTime="";
    }
    sat=OpenCloseTime(openTime: satOpenTime,closeTime: satCloseTime,closed:!satCloseCheck);
    if(sunCloseCheck)
    {
      sunOpenTime="";
      sunCloseTime="";
    }
    sun=OpenCloseTime(openTime: sunOpenTime,closeTime: sunCloseTime,closed:!sunCloseCheck);

    EditSettingResponse result= await RestApi.admin.editSetting(mon, tues, wed, thurs, fri, sat, sun, travelTime, cancelTime, appointmentInterval);
    progressDialog.hide();
    clearErrorMessage();

    if(result.response.status ==1)
    {
      fToast.init(_scaffoldKey.currentContext);
      fToast.showToast(
          child: ToastWidget(status: result.response.status, msg: result.response.msg),
          toastDuration: Duration(seconds: 2),
          gravity: ToastGravity.BOTTOM);
    }
    else{
      _errCancelTime     = result.error.cancellation_time;
      _errAppointmentInterval = result.error.appointment_interval;
      _errTravelTime  = result.error.travel_time;
      _formKey.currentState.validate();
    }
  }
  void clearErrorMessage()
  {
    _errCancelTime=_errAppointmentInterval=_errTravelTime="";
  }
  void getSetting()async
  {
    final ProgressDialog progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();
    SettingResponse result = await RestApi.admin.getSetting();
    progressDialog.hide();

    if (result.response.status == 1) {
      setState(() {
        monOpenTime=result.monday.openTime;
        monCloseTime=result.monday.closeTime;
        monCloseCheck=!result.monday.isOpen;

        tuesOpenTime=result.tuesday.openTime;
        tuesCloseTime=result.tuesday.closeTime;
        tuesCloseCheck=!result.tuesday.isOpen;

        wedOpenTime=result.wednesday.openTime;
        wedCloseTime=result.wednesday.closeTime;
        wedCloseCheck=!result.wednesday.isOpen;

        thursOpenTime=result.thursday.openTime;
        thursCloseTime=result.thursday.closeTime;
        thursCloseCheck=!result.thursday.isOpen;

        friOpenTime=result.friday.openTime;
        friCloseTime=result.friday.closeTime;
        friCloseCheck=!result.friday.isOpen;

        satOpenTime=result.saturday.openTime;
        satCloseTime=result.saturday.closeTime;
        satCloseCheck=!result.saturday.isOpen;

        sunOpenTime=result.sunday.openTime;
        sunCloseTime=result.sunday.closeTime;
        sunCloseCheck=!result.sunday.isOpen;

        cancelTime=result.cancelTime;
        appointmentInterval=result.appointmentInterval;
        travelTime=result.travelTime;
      });
    } else {
      fToast.showToast(
          child: ToastWidget(
            status: result.response.status,
            msg: result.response.msg,
          ));
    }
  }

  InputDecoration standardInputDecoration(String label, IconData iconData) => InputDecoration(
      icon: Icon(iconData, color: primaryColor,),
      labelText: label,
      labelStyle: TextStyleFactory.p()
  );

  TextFormField _buildCancelTime() {
    return TextFormField(
      keyboardType: TextInputType.number,
      key: Key(cancelTime.toString()),
      initialValue: cancelTime.toString(),
      validator: (_) => (_errCancelTime.isEmpty) ? null : _errCancelTime,
      onSaved: (value) {cancelTime = int.parse(value);},
      decoration: standardInputDecoration("Cancellation Time", Icons.cancel),
    );
  }

  TextFormField _buildTravelTime() {
    return TextFormField(
      key: Key(travelTime.toString()),
      initialValue: travelTime.toString(),
      validator: (_) => _errTravelTime.isEmpty ? null : _errTravelTime,
      decoration: standardInputDecoration("Travel Time", Icons.time_to_leave),
      keyboardType: TextInputType.number,

        onSaved: (value) {travelTime = int.parse(value);},
    );
  }

  TextFormField _buildAppointmentInterval() {
    return TextFormField(
      key: Key(appointmentInterval.toString()),
      initialValue: appointmentInterval.toString(),
      keyboardType: TextInputType.number,
      validator: (_) => _errAppointmentInterval.isEmpty ? null : _errAppointmentInterval,
      decoration: standardInputDecoration("Appointment Interval", Icons.all_inclusive),
      onSaved: (value) {appointmentInterval = int.parse(value);},
    );
  }

}


class MondayDialog extends StatefulWidget {
  String openTime,closeTime;
  bool isClosed;
  @override
  MondayDialogState createState() => new MondayDialogState(openTime,closeTime,isClosed);
  MondayDialog(this.openTime,this.closeTime,this.isClosed);
}
class TuesdayDialog extends StatefulWidget {
  String openTime,closeTime;
  bool isClosed;
  @override
  TuesdayDialogState createState() => new TuesdayDialogState(openTime,closeTime,isClosed);
  TuesdayDialog(this.openTime,this.closeTime,this.isClosed);
}
class WednesdayDialog extends StatefulWidget {
  String openTime,closeTime;
  bool isClosed;
  @override
  WednesdayDialogState createState() => new WednesdayDialogState(openTime,closeTime,isClosed);
  WednesdayDialog(this.openTime,this.closeTime,this.isClosed);

}
class ThursdayDialog extends StatefulWidget {
  String openTime,closeTime;
  bool isClosed;
  @override
  ThursdayDialogState createState() => new ThursdayDialogState(openTime,closeTime,isClosed);
  ThursdayDialog(this.openTime,this.closeTime,this.isClosed);

}
class FridayDialog extends StatefulWidget {
  String openTime,closeTime;
  bool isClosed;
  @override
  FridayDialogState createState() => new FridayDialogState(openTime,closeTime,isClosed);
  FridayDialog(this.openTime,this.closeTime,this.isClosed);

}
class SaturdayDialog extends StatefulWidget {
  String openTime,closeTime;
  bool isClosed;
  @override
  SaturdayDialogState createState() => new SaturdayDialogState(openTime,closeTime,isClosed);
  SaturdayDialog(this.openTime,this.closeTime,this.isClosed);

}
class SundayDialog extends StatefulWidget {
  String openTime,closeTime;
  bool isClosed;
  @override
  SundayDialogState createState() => new SundayDialogState(openTime,closeTime,isClosed);
  SundayDialog(this.openTime,this.closeTime,this.isClosed);

}


class MondayDialogState extends State<MondayDialog> {
  bool closedCheck=false;
  TimeOfDay _time = new TimeOfDay.now();
  TimeOfDay _openTime=null,_closeTime=null;
  String openTime="",closeTime="";
  FToast fToast;

  MondayDialogState(this.openTime, this.closeTime,this.closedCheck)
  {
    if(!closedCheck){
      final format=DateFormat.jm();
      _openTime=TimeOfDay.fromDateTime(format.parse(openTime));
      _closeTime=TimeOfDay.fromDateTime(format.parse(closeTime));
    }


  }

  Future<Null> _openTimePicker(BuildContext context)async{
    final TimeOfDay picked=await showTimePicker(context: context, initialTime: _time);

    if(picked !=null)
    {
      setState(() {
        _openTime=picked;
      });
    }
  }

  Future<Null> _closeTimePicker(BuildContext context)async{
    final TimeOfDay picked=await showTimePicker(context: context, initialTime: _time);

    if(picked !=null)
    {
      setState(() {
        _closeTime=picked;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(this.context);
  }
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
        title: Text("Monday",style: TextStyleFactory.heading5(),textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CheckboxListTile(
                title: Text("Closed"),
                value: closedCheck,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (newValue)
                {
                  setState(() {
                    if(newValue)
                    {
                      _openTime=null;
                      _closeTime=null;
                    }

                    closedCheck=newValue;

                  });
                }
            ),
            Visibility(
              child:   Row(
                children: [
                  RawMaterialButton(
                    fillColor: primaryLightColor,
                    onPressed: ()
                    {
                        _openTimePicker(context);
                    },
                    child: Text(_openTime==null?"Open Time":_openTime.format(context)),
                    padding: EdgeInsets.all(10.0),
                  ),
                  Expanded(
                    child: Text("TO",textAlign: TextAlign.center),
                  ),
                  RawMaterialButton(
                    fillColor: primaryLightColor,
                    onPressed: ()
                    {
                        _closeTimePicker(context);
                    },
                    child: Text(_closeTime==null?"Close Time":_closeTime.format(context)),
                    padding: EdgeInsets.all(10.0),
                  )


                ],
              ),
              visible: !closedCheck,
            )

          ],
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text("Cancel",style: TextStyleFactory.heading6(color: primaryColor)),
            onPressed: ()
            {
              Navigator.of(context).pop();
            },
          ),
          MaterialButton(
            elevation: 5.0,
            child: Text("Save",style: TextStyleFactory.heading6(color: primaryColor)),
            onPressed: ()
            {
              if(closedCheck)
              {
                OpenCloseTime openCloseTime=OpenCloseTime(closed: closedCheck);
                Navigator.of(context).pop(openCloseTime);
              }
              else{
                if(_closeTime==null||_openTime==null)
                {
                  fToast.showToast(
                      child: ToastWidget(status: 0, msg: "The time cannot be empty!"),
                      toastDuration: Duration(seconds: 2),
                      gravity: ToastGravity.BOTTOM);
                }
                else{
                  double openTime = _openTime.hour.toDouble() +
                      (_openTime.minute.toDouble() / 60);
                  double closeTime = _closeTime.hour.toDouble() +
                      (_closeTime.minute.toDouble() / 60);
                  if(openTime>=closeTime)
                  {
                    fToast.showToast(
                        child: ToastWidget(status: 0, msg: "The open time cannot late or equal than close time!"),
                        toastDuration: Duration(seconds: 2),
                        gravity: ToastGravity.BOTTOM);
                  }
                  else{
                    OpenCloseTime openCloseTime=OpenCloseTime(openTime: _openTime.format(context),closeTime: _closeTime.format(context),closed: closedCheck);
                    Navigator.of(context).pop(openCloseTime);
                  }
                }
              }
            },
          )
        ]
    );
  }
}

class TuesdayDialogState extends State<TuesdayDialog> {
  bool closedCheck=false;
  TimeOfDay _time = new TimeOfDay.now();
  TimeOfDay _openTime=null,_closeTime=null;
  String openTime="",closeTime="";
  FToast fToast;

  TuesdayDialogState(this.openTime, this.closeTime,this.closedCheck)
  {
    if(!closedCheck)
    {
      final format=DateFormat.jm();
      _openTime=TimeOfDay.fromDateTime(format.parse(openTime));
      _closeTime=TimeOfDay.fromDateTime(format.parse(closeTime));
    }

  }
  Future<Null> _openTimePicker(BuildContext context)async{
    final TimeOfDay picked=await showTimePicker(context: context, initialTime: _time);

    if(picked !=null)
    {
      setState(() {
        _openTime=picked;
      });
    }
  }

  Future<Null> _closeTimePicker(BuildContext context)async{
    final TimeOfDay picked=await showTimePicker(context: context, initialTime: _time);

    if(picked !=null)
    {
      setState(() {
        _closeTime=picked;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
        title: Text("Tuesday",style: TextStyleFactory.heading5(),textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CheckboxListTile(
                title: Text("Closed"),
                value: closedCheck,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (newValue)
                {
                  setState(() {
                    if(newValue)
                    {
                      _openTime=null;
                      _closeTime=null;
                    }

                    closedCheck=newValue;

                  });
                }
            ),
            Visibility(
              child:   Row(
                children: [
                  RawMaterialButton(
                    fillColor: primaryLightColor,
                    onPressed: ()
                    {
                      _openTimePicker(context);
                    },
                    child: Text(_openTime==null?"Open Time":_openTime.format(context)),
                    padding: EdgeInsets.all(10.0),
                  ),
                  Expanded(
                    child: Text("TO",textAlign: TextAlign.center),
                  ),
                  RawMaterialButton(
                    fillColor: primaryLightColor,
                    onPressed: ()
                    {
                      _closeTimePicker(context);
                    },
                    child: Text(_closeTime==null?"Close Time":_closeTime.format(context)),
                    padding: EdgeInsets.all(10.0),
                  )


                ],
              ),
              visible: !closedCheck,
            )

          ],
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text("Cancel",style: TextStyleFactory.heading6(color: primaryColor)),
            onPressed: ()
            {
              Navigator.of(context).pop();
            },
          ),
          MaterialButton(
            elevation: 5.0,
            child: Text("Save",style: TextStyleFactory.heading6(color: primaryColor)),
            onPressed: ()
            {
              if(closedCheck)
              {
                OpenCloseTime openCloseTime=OpenCloseTime(closed: closedCheck);
                Navigator.of(context).pop(openCloseTime);

              }
              else{
                if(_closeTime==null||_openTime==null)
                {
                  fToast.showToast(
                      child: ToastWidget(status: 0, msg: "The time cannot be empty!"),
                      toastDuration: Duration(seconds: 2),
                      gravity: ToastGravity.BOTTOM);
                }
                else{
                  double openTime = _openTime.hour.toDouble() +
                      (_openTime.minute.toDouble() / 60);
                  double closeTime = _closeTime.hour.toDouble() +
                      (_closeTime.minute.toDouble() / 60);
                  if(openTime>=closeTime)
                  {
                    fToast.showToast(
                        child: ToastWidget(status: 0, msg: "The open time cannot late or equal than close time!"),
                        toastDuration: Duration(seconds: 2),
                        gravity: ToastGravity.BOTTOM);
                  }
                  else{
                    OpenCloseTime openCloseTime=OpenCloseTime(openTime: _openTime.format(context),closeTime: _closeTime.format(context),closed: closedCheck);
                    Navigator.of(context).pop(openCloseTime);
                  }
                }
              }
            },
          )
        ]
    );
  }
}

class WednesdayDialogState extends State<WednesdayDialog> {
  bool closedCheck=false;
  TimeOfDay _time = new TimeOfDay.now();
  TimeOfDay _openTime=null,_closeTime=null;
  String openTime="",closeTime="";
  FToast fToast;

  WednesdayDialogState(this.openTime, this.closeTime,this.closedCheck)
  {
    if(!closedCheck)
    {
      final format=DateFormat.jm();
      _openTime=TimeOfDay.fromDateTime(format.parse(openTime));
      _closeTime=TimeOfDay.fromDateTime(format.parse(closeTime));
    }


  }
  Future<Null> _openTimePicker(BuildContext context)async{
    final TimeOfDay picked=await showTimePicker(context: context, initialTime: _time);

    if(picked !=null)
    {
      setState(() {
        _openTime=picked;
      });
    }
  }

  Future<Null> _closeTimePicker(BuildContext context)async{
    final TimeOfDay picked=await showTimePicker(context: context, initialTime: _time);

    if(picked !=null)
    {
      setState(() {
        _closeTime=picked;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
        title: Text("Wednesday",style: TextStyleFactory.heading5(),textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CheckboxListTile(
                title: Text("Closed"),
                value: closedCheck,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (newValue)
                {
                  setState(() {
                    if(newValue)
                    {
                      _openTime=null;
                      _closeTime=null;
                    }

                    closedCheck=newValue;

                  });
                }
            ),
            Visibility(
              child:   Row(
                children: [
                  RawMaterialButton(
                    fillColor: primaryLightColor,
                    onPressed: ()
                    {
                      _openTimePicker(context);
                    },
                    child: Text(_openTime==null?"Open Time":_openTime.format(context)),
                    padding: EdgeInsets.all(10.0),
                  ),
                  Expanded(
                    child: Text("TO",textAlign: TextAlign.center),
                  ),
                  RawMaterialButton(
                    fillColor: primaryLightColor,
                    onPressed: ()
                    {
                      _closeTimePicker(context);
                    },
                    child: Text(_closeTime==null?"Close Time":_closeTime.format(context)),
                    padding: EdgeInsets.all(10.0),
                  )


                ],
              ),
              visible: !closedCheck,
            )

          ],
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text("Cancel",style: TextStyleFactory.heading6(color: primaryColor)),
            onPressed: ()
            {
              Navigator.of(context).pop();
            },
          ),
          MaterialButton(
            elevation: 5.0,
            child: Text("Save",style: TextStyleFactory.heading6(color: primaryColor)),
            onPressed: ()
            {
              if(closedCheck)
              {
                OpenCloseTime openCloseTime=OpenCloseTime(closed: closedCheck);
                Navigator.of(context).pop(openCloseTime);

              }
              else{
                if(_closeTime==null||_openTime==null)
                {
                  fToast.showToast(
                      child: ToastWidget(status: 0, msg: "The time cannot be empty!"),
                      toastDuration: Duration(seconds: 2),
                      gravity: ToastGravity.BOTTOM);
                }
                else{
                  double openTime = _openTime.hour.toDouble() +
                      (_openTime.minute.toDouble() / 60);
                  double closeTime = _closeTime.hour.toDouble() +
                      (_closeTime.minute.toDouble() / 60);
                  if(openTime>=closeTime)
                  {
                    fToast.showToast(
                        child: ToastWidget(status: 0, msg: "The open time cannot late or equal than close time!"),
                        toastDuration: Duration(seconds: 2),
                        gravity: ToastGravity.BOTTOM);
                  }
                  else{
                    OpenCloseTime openCloseTime=OpenCloseTime(openTime: _openTime.format(context),closeTime: _closeTime.format(context),closed: closedCheck);
                    Navigator.of(context).pop(openCloseTime);
                  }
                }
              }
            },
          )
        ]
    );
  }
}

class ThursdayDialogState extends State<ThursdayDialog> {
  bool closedCheck=false;
  TimeOfDay _time = new TimeOfDay.now();
  TimeOfDay _openTime=null,_closeTime=null;
  String openTime="",closeTime="";
  FToast fToast;

  ThursdayDialogState(this.openTime, this.closeTime,this.closedCheck)
  {
    if(!closedCheck)
    {
      final format=DateFormat.jm();
      _openTime=TimeOfDay.fromDateTime(format.parse(openTime));
      _closeTime=TimeOfDay.fromDateTime(format.parse(closeTime));
    }


  }

  Future<Null> _openTimePicker(BuildContext context)async{
    final TimeOfDay picked=await showTimePicker(context: context, initialTime: _time);

    if(picked !=null)
    {
      setState(() {
        _openTime=picked;
      });
    }
  }

  Future<Null> _closeTimePicker(BuildContext context)async{
    final TimeOfDay picked=await showTimePicker(context: context, initialTime: _time);

    if(picked !=null)
    {
      setState(() {
        _closeTime=picked;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
        title: Text("Thursday",style: TextStyleFactory.heading5(),textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CheckboxListTile(
                title: Text("Closed"),
                value: closedCheck,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (newValue)
                {
                  setState(() {
                    if(newValue)
                    {
                      _openTime=null;
                      _closeTime=null;
                    }

                    closedCheck=newValue;

                  });
                }
            ),
            Visibility(
              child:   Row(
                children: [
                  RawMaterialButton(
                    fillColor: primaryLightColor,
                    onPressed: ()
                    {
                      _openTimePicker(context);
                    },
                    child: Text(_openTime==null?"Open Time":_openTime.format(context)),
                    padding: EdgeInsets.all(10.0),
                  ),
                  Expanded(
                    child: Text("TO",textAlign: TextAlign.center),
                  ),
                  RawMaterialButton(
                    fillColor: primaryLightColor,
                    onPressed: ()
                    {
                      _closeTimePicker(context);
                    },
                    child: Text(_closeTime==null?"Close Time":_closeTime.format(context)),
                    padding: EdgeInsets.all(10.0),
                  )


                ],
              ),
              visible: !closedCheck,
            )

          ],
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text("Cancel",style: TextStyleFactory.heading6(color: primaryColor)),
            onPressed: ()
            {
              Navigator.of(context).pop();
            },
          ),
          MaterialButton(
            elevation: 5.0,
            child: Text("Save",style: TextStyleFactory.heading6(color: primaryColor)),
            onPressed: ()
            {
              if(closedCheck)
              {
                OpenCloseTime openCloseTime=OpenCloseTime(closed: closedCheck);
                Navigator.of(context).pop(openCloseTime);

              }
              else{
                if(_closeTime==null||_openTime==null)
                {
                  fToast.showToast(
                      child: ToastWidget(status: 0, msg: "The time cannot be empty!"),
                      toastDuration: Duration(seconds: 2),
                      gravity: ToastGravity.BOTTOM);
                }
                else{
                  double openTime = _openTime.hour.toDouble() +
                      (_openTime.minute.toDouble() / 60);
                  double closeTime = _closeTime.hour.toDouble() +
                      (_closeTime.minute.toDouble() / 60);
                  if(openTime>=closeTime)
                  {
                    fToast.showToast(
                        child: ToastWidget(status: 0, msg: "The open time cannot late or equal than close time!"),
                        toastDuration: Duration(seconds: 2),
                        gravity: ToastGravity.BOTTOM);
                  }
                  else{
                    OpenCloseTime openCloseTime=OpenCloseTime(openTime: _openTime.format(context),closeTime: _closeTime.format(context),closed: closedCheck);
                    Navigator.of(context).pop(openCloseTime);
                  }
                }
              }
            },
          )
        ]
    );
  }
}

class FridayDialogState extends State<FridayDialog> {
  bool closedCheck=false;
  TimeOfDay _time = new TimeOfDay.now();
  TimeOfDay _openTime=null,_closeTime=null;
  String openTime="",closeTime="";
  FToast fToast;

  FridayDialogState(this.openTime, this.closeTime,this.closedCheck)
  {
    if(!closedCheck)
    {
      final format=DateFormat.jm();
      _openTime=TimeOfDay.fromDateTime(format.parse(openTime));
      _closeTime=TimeOfDay.fromDateTime(format.parse(closeTime));
    }


  }
  Future<Null> _openTimePicker(BuildContext context)async{
    final TimeOfDay picked=await showTimePicker(context: context, initialTime: _time);

    if(picked !=null)
    {
      setState(() {
        _openTime=picked;
      });
    }
  }

  Future<Null> _closeTimePicker(BuildContext context)async{
    final TimeOfDay picked=await showTimePicker(context: context, initialTime: _time);

    if(picked !=null)
    {
      setState(() {
        _closeTime=picked;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
        title: Text("Friday",style: TextStyleFactory.heading5(),textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CheckboxListTile(
                title: Text("Closed"),
                value: closedCheck,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (newValue)
                {
                  setState(() {
                    if(newValue)
                    {
                      _openTime=null;
                      _closeTime=null;
                    }

                    closedCheck=newValue;

                  });
                }
            ),
            Visibility(
              child:   Row(
                children: [
                  RawMaterialButton(
                    fillColor: primaryLightColor,
                    onPressed: ()
                    {
                      _openTimePicker(context);
                    },
                    child: Text(_openTime==null?"Open Time":_openTime.format(context)),
                    padding: EdgeInsets.all(10.0),
                  ),
                  Expanded(
                    child: Text("TO",textAlign: TextAlign.center),
                  ),
                  RawMaterialButton(
                    fillColor: primaryLightColor,
                    onPressed: ()
                    {
                      _closeTimePicker(context);
                    },
                    child: Text(_closeTime==null?"Close Time":_closeTime.format(context)),
                    padding: EdgeInsets.all(10.0),
                  )


                ],
              ),
              visible: !closedCheck,
            )

          ],
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text("Cancel",style: TextStyleFactory.heading6(color: primaryColor)),
            onPressed: ()
            {
              Navigator.of(context).pop();
            },
          ),
          MaterialButton(
            elevation: 5.0,
            child: Text("Save",style: TextStyleFactory.heading6(color: primaryColor)),
            onPressed: ()
            {
              if(closedCheck)
              {
                OpenCloseTime openCloseTime=OpenCloseTime(closed: closedCheck);
                Navigator.of(context).pop(openCloseTime);

              }
              else{
                if(_closeTime==null||_openTime==null)
                {
                  fToast.showToast(
                      child: ToastWidget(status: 0, msg: "The time cannot be empty!"),
                      toastDuration: Duration(seconds: 2),
                      gravity: ToastGravity.BOTTOM);
                }
                else{
                  double openTime = _openTime.hour.toDouble() +
                      (_openTime.minute.toDouble() / 60);
                  double closeTime = _closeTime.hour.toDouble() +
                      (_closeTime.minute.toDouble() / 60);
                  if(openTime>=closeTime)
                  {
                    fToast.showToast(
                        child: ToastWidget(status: 0, msg: "The open time cannot late or equal than close time!"),
                        toastDuration: Duration(seconds: 2),
                        gravity: ToastGravity.BOTTOM);
                  }
                  else{
                    OpenCloseTime openCloseTime=OpenCloseTime(openTime: _openTime.format(context),closeTime: _closeTime.format(context),closed: closedCheck);
                    Navigator.of(context).pop(openCloseTime);
                  }
                }
              }
            },
          )
        ]
    );
  }
}

class SaturdayDialogState extends State<SaturdayDialog> {
  bool closedCheck=false;
  TimeOfDay _time = new TimeOfDay.now();
  TimeOfDay _openTime=null,_closeTime=null;
  String openTime="",closeTime="";
  FToast fToast;

  SaturdayDialogState(this.openTime, this.closeTime,this.closedCheck)
  {
    if(!closedCheck)
    {
      final format=DateFormat.jm();
      _openTime=TimeOfDay.fromDateTime(format.parse(openTime));
      _closeTime=TimeOfDay.fromDateTime(format.parse(closeTime));
    }


  }

  Future<Null> _openTimePicker(BuildContext context)async{
    final TimeOfDay picked=await showTimePicker(context: context, initialTime: _time);

    if(picked !=null)
    {
      setState(() {
        _openTime=picked;
      });
    }
  }

  Future<Null> _closeTimePicker(BuildContext context)async{
    final TimeOfDay picked=await showTimePicker(context: context, initialTime: _time);

    if(picked !=null)
    {
      setState(() {
        _closeTime=picked;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
        title: Text("Saturday",style: TextStyleFactory.heading5(),textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CheckboxListTile(
                title: Text("Closed"),
                value: closedCheck,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (newValue)
                {
                  setState(() {
                    if(newValue)
                    {
                      _openTime=null;
                      _closeTime=null;
                    }

                    closedCheck=newValue;

                  });
                }
            ),
            Visibility(
              child:   Row(
                children: [
                  RawMaterialButton(
                    fillColor: primaryLightColor,
                    onPressed: ()
                    {
                      _openTimePicker(context);
                    },
                    child: Text(_openTime==null?"Open Time":_openTime.format(context)),
                    padding: EdgeInsets.all(10.0),
                  ),
                  Expanded(
                    child: Text("TO",textAlign: TextAlign.center),
                  ),
                  RawMaterialButton(
                    fillColor: primaryLightColor,
                    onPressed: ()
                    {
                      _closeTimePicker(context);
                    },
                    child: Text(_closeTime==null?"Close Time":_closeTime.format(context)),
                    padding: EdgeInsets.all(10.0),
                  )


                ],
              ),
              visible: !closedCheck,
            )

          ],
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text("Cancel",style: TextStyleFactory.heading6(color: primaryColor)),
            onPressed: ()
            {
              Navigator.of(context).pop();
            },
          ),
          MaterialButton(
            elevation: 5.0,
            child: Text("Save",style: TextStyleFactory.heading6(color: primaryColor)),
            onPressed: ()
            {
              if(closedCheck)
              {
                OpenCloseTime openCloseTime=OpenCloseTime(closed: closedCheck);
                Navigator.of(context).pop(openCloseTime);

              }
              else{
                if(_closeTime==null||_openTime==null)
                {
                  fToast.showToast(
                      child: ToastWidget(status: 0, msg: "The time cannot be empty!"),
                      toastDuration: Duration(seconds: 2),
                      gravity: ToastGravity.BOTTOM);
                }
                else{
                  double openTime = _openTime.hour.toDouble() +
                      (_openTime.minute.toDouble() / 60);
                  double closeTime = _closeTime.hour.toDouble() +
                      (_closeTime.minute.toDouble() / 60);
                  if(openTime>=closeTime)
                  {
                    fToast.showToast(
                        child: ToastWidget(status: 0, msg: "The open time cannot late or equal than close time!"),
                        toastDuration: Duration(seconds: 2),
                        gravity: ToastGravity.BOTTOM);
                  }
                  else{
                    OpenCloseTime openCloseTime=OpenCloseTime(openTime: _openTime.format(context),closeTime: _closeTime.format(context),closed: closedCheck);
                    Navigator.of(context).pop(openCloseTime);
                  }
                }
              }
            },
          )
        ]
    );
  }
}

class SundayDialogState extends State<SundayDialog> {
  bool closedCheck=false;
  TimeOfDay _time = new TimeOfDay.now();
  TimeOfDay _openTime=null,_closeTime=null;
  String openTime="",closeTime="";
  FToast fToast;

  SundayDialogState(this.openTime, this.closeTime,this.closedCheck)
  {
    if(!closedCheck)
      {
        final format=DateFormat.jm();
        _openTime=TimeOfDay.fromDateTime(format.parse(openTime));
        _closeTime=TimeOfDay.fromDateTime(format.parse(closeTime));
      }


  }
  Future<Null> _openTimePicker(BuildContext context)async{
    final TimeOfDay picked=await showTimePicker(context: context, initialTime: _time);

    if(picked !=null)
    {
      setState(() {
        _openTime=picked;
      });
    }
  }

  Future<Null> _closeTimePicker(BuildContext context)async{
    final TimeOfDay picked=await showTimePicker(context: context, initialTime: _time);

    if(picked !=null)
    {
      setState(() {
        _closeTime=picked;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
        title: Text("Sunday",style: TextStyleFactory.heading5(),textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CheckboxListTile(
                title: Text("Closed"),
                value: closedCheck,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (newValue)
                {
                  setState(() {
                    if(newValue)
                    {
                      _openTime=null;
                      _closeTime=null;
                    }

                    closedCheck=newValue;

                  });
                }
            ),
            Visibility(
              child:   Row(
                children: [
                  RawMaterialButton(
                    fillColor: primaryLightColor,
                    onPressed: ()
                    {
                      _openTimePicker(context);
                    },
                    child: Text(_openTime==null?"Open Time":_openTime.format(context)),
                    padding: EdgeInsets.all(10.0),
                  ),
                  Expanded(
                    child: Text("TO",textAlign: TextAlign.center),
                  ),
                  RawMaterialButton(
                    fillColor: primaryLightColor,
                    onPressed: ()
                    {
                      _closeTimePicker(context);
                    },
                    child: Text(_closeTime==null?"Close Time":_closeTime.format(context)),
                    padding: EdgeInsets.all(10.0),
                  )


                ],
              ),
              visible: !closedCheck,
            )

          ],
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text("Cancel",style: TextStyleFactory.heading6(color: primaryColor)),
            onPressed: ()
            {
              Navigator.of(context).pop();
            },
          ),
          MaterialButton(
            elevation: 5.0,
            child: Text("Save",style: TextStyleFactory.heading6(color: primaryColor)),
            onPressed: ()
            {
              if(closedCheck)
              {
                OpenCloseTime openCloseTime=OpenCloseTime(closed: closedCheck);
                Navigator.of(context).pop(openCloseTime);

              }
              else{
                if(_closeTime==null||_openTime==null)
                {
                  fToast.showToast(
                      child: ToastWidget(status: 0, msg: "The time cannot be empty!"),
                      toastDuration: Duration(seconds: 2),
                      gravity: ToastGravity.BOTTOM);
                }
                else{
                  double openTime = _openTime.hour.toDouble() +
                      (_openTime.minute.toDouble() / 60);
                  double closeTime = _closeTime.hour.toDouble() +
                      (_closeTime.minute.toDouble() / 60);
                  if(openTime>=closeTime)
                  {
                    fToast.showToast(
                        child: ToastWidget(status: 0, msg: "The open time cannot late or equal than close time!"),
                        toastDuration: Duration(seconds: 2),
                        gravity: ToastGravity.BOTTOM);
                  }
                  else{
                    OpenCloseTime openCloseTime=OpenCloseTime(openTime: _openTime.format(context),closeTime: _closeTime.format(context),closed: closedCheck);
                    Navigator.of(context).pop(openCloseTime);
                  }
                }
              }
            },
          )
        ]
    );
  }
}


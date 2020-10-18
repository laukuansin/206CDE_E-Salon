import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/appointment.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/admin_get_appointment_log.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TodayAppointmentScreen extends StatefulWidget{
  final Map<DateTime, List<Appointment>> appointmentList;

  @override
  State<StatefulWidget> createState()=>_TodayAppointmentScreenState(appointmentList);

  TodayAppointmentScreen(this.appointmentList);
}

class _TodayAppointmentScreenState extends State<TodayAppointmentScreen>{
  //Config
  static const _TIMELINE_LINE_XY = 0.27;
  static const _TIMELINE_INDICATOR_WIDTH = 35.0;
  static const _TIMELINE_INDICATOR_PADDING = 4.0;
  static const _TIMELINE_MARGIN_BETWEEN_BUBBLE = 12.0;
  static const _TIMELINE_THICKNESS = 2.0;

  final Map<DateTime, List<Appointment>> appointmentList;
  List<Log> logs = [];


  _TodayAppointmentScreenState(this.appointmentList);

  final DateFormat dateFormat = DateFormat('hh:mm a');

  @override
  void initState() {
    requestAppointmentLog();
    super.initState();
  }

  void requestAppointmentLog()async{
    AppointmentLogResponse result = await RestApi.admin.getUserAppointmentLog(DateFormat("yyyy-MM-dd").format(appointmentList.keys.elementAt(0)));
    setState(() {
      logs = result.log;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return RouteGenerator.buildScaffold(
      Container(
        color: primaryBgColor,
        width: screenSize.width,
        height: screenSize.height,
        child:Column(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: logs.length,
                  itemBuilder: (BuildContext context, int index)=> buildTimeLineTile(index)
                ),
              ),
              _buildCurrentAppointment(screenSize),
            ]
        )
      ),
      appbar: AppBar(
        title: Text(DateFormat("E, MMM dd").format(appointmentList.keys.elementAt(0)), style: TextStyleFactory.heading6(fontWeight: FontWeight.normal),),
      )
    );
  }

  Container _buildCurrentAppointment(Size screenSize){
    DateTime today = DateTime.now();
    DateTime selectedDate = appointmentList.keys.elementAt(0);
    if(!(selectedDate.year == today.year && selectedDate.month == today.month && selectedDate.day == today.day) ){
      return Container();
    }

    Appointment selectedAppointment;
    List<Appointment>currentAppointmentList =  appointmentList[selectedDate].where((element) => element.status != Status.CLOSE).toList();
    if(currentAppointmentList.isEmpty) return Container();

    for(Appointment appointment in currentAppointmentList){
      if(appointment.status == Status.SERVICING || appointment.status == Status.ONGOING)
        selectedAppointment = appointment;
    }

    selectedAppointment = selectedAppointment??currentAppointmentList[0];
    Color color = _getStatusColor(selectedAppointment.status);

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        width: screenSize.width,
        color: primaryLightColor,
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.symmetric(horizontal: 16),  child: Text("Current appointment", style: TextStyleFactory.heading4(color: color),),),
              ListTile(
                dense: true,
                leading: Icon(Icons.person, color: color,),
                title:Text(selectedAppointment.customerName, style: TextStyleFactory.heading5(color:color, fontWeight: FontWeight.normal),),
              ),
              ListTile(
                dense:true,
                leading: Icon(Icons.access_time, color: color,),
                title: Text(selectedAppointment.getAppointmentDateStringJM(), style: TextStyleFactory.heading5(color:color, fontWeight: FontWeight.normal),),
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.assignment, color: color),
                title: Text(selectedAppointment.getStatusName(), style: TextStyleFactory.heading5(color: color,fontWeight: FontWeight.normal),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                      child:FlatButton(
                        color: color,
                        textColor: primaryLightColor,
                        child: Text("View",style: TextStyleFactory.p(color: primaryLightColor),),
                        onPressed: (){
                          Navigator.of(context).pushNamed("/appointment_info",arguments: selectedAppointment).then((_) {setState(() {
                            requestAppointmentLog();
                          });});
                        },
                      )
                  ),
                ],
              ),
            ]
        )
    );
  }

  Color _getStatusColor(Status status){
    // ignore: missing_enum_constant_in_switch
    switch(status) {
      case Status.ACCEPTED:
        return Colors.greenAccent;
      case Status.CANCELLED:
        return  Colors.redAccent;
      case Status.CLOSE:
        return Colors.greenAccent;
      case Status.ONGOING:
        return primaryColor;
      case Status.SERVICING:
        return Colors.amber;
    }
    return null;
  }
  
  Color getLogColor(String activity){
    if(activity.startsWith("Arrived at")){
      return Colors.cyan;
    } else if(activity.startsWith("Service completed")){
      return Colors.greenAccent;
    } else if(activity.startsWith("Heading to")){
      return Colors.blueAccent;
    }
    return Colors.cyan;
  }

  IconData getLogIcon(String activity){
    if(activity.startsWith("Arrived at")){
      return Icons.done;
    } else if(activity.startsWith("Service completed")){
      return Icons.assignment_turned_in;
    } else if(activity.startsWith("Heading to")){
      return Icons.navigation;
    }

    return Icons.done;
  }

  Widget buildTimeLineTile(int index)=>
      TimelineTile(
        axis: TimelineAxis.vertical,
        alignment: TimelineAlign.manual,
        isFirst: index == 0,
        isLast: index == logs.length - 1,
        lineXY: _TIMELINE_LINE_XY,

        indicatorStyle: IndicatorStyle(
          width: _TIMELINE_INDICATOR_WIDTH,
          padding: EdgeInsets.only(
            left: _TIMELINE_INDICATOR_PADDING,
            right: _TIMELINE_INDICATOR_PADDING,
          ),
          color: getLogColor(logs[index].activity),
          iconStyle: IconStyle(
            color: Colors.white,
            iconData: getLogIcon(logs[index].activity),
          ),
        ),

        startChild: Container(
          height: 75,
            alignment: Alignment.centerRight,
            child:Text(
              dateFormat.format(logs[index].dateTime),
              style: TextStyleFactory.p()
            )
        ),

        endChild:Container(
          margin: EdgeInsets.symmetric(vertical: _TIMELINE_MARGIN_BETWEEN_BUBBLE),
          child:Row(
              children:[
                Expanded(
                    child:GestureDetector(
                      onTap: (){Navigator.of(context).pushNamed("/appointmentInfo");},
                      child: Text(logs[index].activity, style: TextStyleFactory.heading6(fontWeight: FontWeight.normal),)
                    )
                ),
              ]
          ),
        ),

        beforeLineStyle: LineStyle(
            color: getLogColor(logs[(index == 0)?index:index - 1].activity),
            thickness: _TIMELINE_THICKNESS
        ),

        afterLineStyle: LineStyle(
            color: getLogColor(logs[index].activity),
            thickness: _TIMELINE_THICKNESS
        ),
      );
}
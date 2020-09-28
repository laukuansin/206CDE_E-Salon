import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TodayAppointmentScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_TodayAppointmentScreenState();
}

enum TaskStatus{
  NAVIGATE,
  ARRIVE,
  SETTLE
}

class Task{
    DateTime time;
    String taskName;
    TaskStatus status;

    Task({this.time, this.taskName, this.status});

    IconData getIconData(){
      switch(status){
        case TaskStatus.NAVIGATE:
          return Icons.navigation;
        case TaskStatus.ARRIVE:
          return Icons.done;
        case TaskStatus.SETTLE:
          return Icons.assignment_turned_in;
      }
    }

    Color getColor(){
      switch(status){
        case TaskStatus.NAVIGATE:
          return Colors.blueAccent;
        case TaskStatus.ARRIVE:
          return Colors.cyan;
        case TaskStatus.SETTLE:
          return Colors.greenAccent;
      }
    }
}


class _TodayAppointmentScreenState extends State<TodayAppointmentScreen>{
  //Config
  static const _TIMELINE_LINE_XY = 0.27;
  static const _TIMELINE_INDICATOR_WIDTH = 35.0;
  static const _TIMELINE_INDICATOR_PADDING = 4.0;
  static const _TIMELINE_MARGIN_BETWEEN_BUBBLE = 12.0;
  static const _TIMELINE_THICKNESS = 2.0;

  final List<Color> colorList = [ primaryLightColor];
  final List<Task> taskList = [
    Task(taskName: "Navigate to Emilie Khor site.",time: DateTime.now(), status: TaskStatus.NAVIGATE),
    Task(taskName: "Arrive at Emilie Khor site.",time: DateTime.now(), status: TaskStatus.ARRIVE),
    Task(taskName: "Service completed.",time: DateTime.now(), status: TaskStatus.SETTLE),
    Task(taskName: "Navigate to Emilie Khor site.",time: DateTime.now(), status: TaskStatus.NAVIGATE),
    Task(taskName: "Arrive at Emilie Khor site.",time: DateTime.now(), status: TaskStatus.ARRIVE),
    Task(taskName: "Service completed.",time: DateTime.now(), status: TaskStatus.SETTLE),
    Task(taskName: "Navigate to Emilie Khor site.",time: DateTime.now(), status: TaskStatus.NAVIGATE),
    Task(taskName: "Arrive at Emilie Khor site.",time: DateTime.now(), status: TaskStatus.ARRIVE),
    Task(taskName: "Service completed.",time: DateTime.now(), status: TaskStatus.SETTLE),
  ];

  final DateFormat dateFormat = DateFormat('hh:mm a');

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
                  itemCount: taskList.length,
                  itemBuilder: (BuildContext context, int index)=> buildTimeLineTile(index)
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                width: screenSize.width,
                color: primaryLightColor,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Current appointment", style: TextStyleFactory.heading3(),),
                    Text("Jeffrey Tan", style: TextStyleFactory.p(fontSize: 16),),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child:FlatButton.icon(
                            color: primaryColor,
                            textColor: primaryLightColor,
                            label: Text("Start",),
                            icon: Icon(Icons.navigation),
                            onPressed: (){},
                          )
                        ),
                        SizedBox(width: 1,),
                        Expanded(
                          child :FlatButton.icon(
                            color: Colors.redAccent,
                            textColor: primaryLightColor,
                            label: Text("Skip",),
                            icon: Icon(Icons.clear),
                            onPressed: (){},
                          )
                        )
                      ],
                    ),

                  ]
                )
              )
            ]
        )
      ),
      appbar: AppBar(
        title: Text("Today, Wed 26 Sep", style: TextStyleFactory.heading6(fontWeight: FontWeight.normal),),
      )
    );
  }

  Widget buildTimeLineTile(int index)=>
      TimelineTile(
        axis: TimelineAxis.vertical,
        alignment: TimelineAlign.manual,
        isFirst: index == 0,
        isLast: index == taskList.length - 1,
        lineXY: _TIMELINE_LINE_XY,

        indicatorStyle: IndicatorStyle(
          width: _TIMELINE_INDICATOR_WIDTH,
          padding: EdgeInsets.only(
            left: _TIMELINE_INDICATOR_PADDING,
            right: _TIMELINE_INDICATOR_PADDING,
          ),
          color: taskList[index].getColor(),
          iconStyle: IconStyle(
            color: Colors.white,
            iconData: taskList[index].getIconData(),
          ),
        ),

        startChild: Container(
          height: 75,
            alignment: Alignment.centerRight,
            child:Text(
              dateFormat.format(taskList[index].time),
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
                      child: Text(taskList[index].taskName, style: TextStyleFactory.heading6(fontWeight: FontWeight.normal),)
                    )
                ),
              ]
          ),
        ),

        beforeLineStyle: LineStyle(
            color:taskList[(index == 0)?index:index - 1].getColor(),
            thickness: _TIMELINE_THICKNESS
        ),

        afterLineStyle: LineStyle(
            color: taskList[index].getColor(),
            thickness: _TIMELINE_THICKNESS
        ),
      );
}
import 'dart:math';
import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:gps_tracking_system/components/custom_table_calendar.dart';
import 'package:gps_tracking_system/overall_appointment.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AppointmentListScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_AppointmentListState();
}

class _AppointmentListState extends State<AppointmentListScreen>{
  //Config
  static const _TIMELINE_LINE_XY = 0.27;
  static const _TIMELINE_INDICATOR_WIDTH = 35.0;
  static const _TIMELINE_INDICATOR_PADDING = 4.0;
  static const _TIMELINE_MARGIN_BETWEEN_BUBBLE = 12.0;
  static const _TIMELINE_THICKNESS = 2.0;

  final List<Color> colorList = [ Color(0xFFB76D7C4), Color(0xFFB5DADE2), Color(0xFFBA9DFBF), Color(0xFFB7FB3D5), Color(0xFFBAED6F1)];
  final List<List<String>> steps = [
    ["9.00am", "Emilie khor", "1hour 40min (40km)", "done"],
    ["10.00am", "Jeffrey Tan", "40min (20km)", "miss"],
    ["11.00am", "Lau Kuan Sin", "1hour 30min (30km)", "done"],
    ["12.00pm", "Pey Xin Yi", "2hours (50km)", "done"],
    ["1.00pm", "Chuang Jing Yee", "2hour 10min (55km)", "done"],
    ["2.00pm", "Yuki Lim Qian Xing", "1hour 10min (28km)", "done"],
    ["3.00pm", "Kok Heng", "5min (3km)", "miss"],
    ["4.00pm", "Shahriman", "1hour (25km)", "miss"],
    ["5.00pm", "Tan Hoe Theng", "45min (22km)", "miss"],
    ["6.00pm", "Anonymous", "3hour 10min (70km)", "pending"],
    ["7.00pm", "Shou Jin", "4hour (80km)", "pending"],
    ["8.00pm", "Leong Yong peng", "1hour (20km)", "pending"],
    ["9.00pm", "Leow Jie Han", "1hour 15min (42km)", "pending"],
    ["10.00pm", "My brother", "1hour 55min (45km)", "pending"],
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
        color: primaryLightColor,
        width: screenSize.width,
        height: screenSize.height,
        // margin:EdgeInsets.only(top: statusBarHeight),
        child:Column(
          children: [
            Container(
              color: primaryLightColor,
              child: Column(
                children: <Widget>[
                  CustomTableCalendar(event: Map<DateTime, List>(), holiday: Map<DateTime, List>()),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05, vertical: screenSize.height * 0.02),
                    alignment: Alignment.centerRight,
                    child:Row(
                      children:[
                        Text(
                          "4 appointments today..",
                          style: TextStyle(
                            fontSize: 20,
                            color: primaryColor
                          ),
                        ),
                        Icon(Icons.assignment, color: primaryColor,),
                        SizedBox(width: screenSize.width * 0.10,),
                        Container(
                          height: 50.0,
                          width: 50.0,
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => OverallAppointment()),
                              );
                            },
                            child: Icon(Icons.chrome_reader_mode),
                            backgroundColor: Color(0XFFBFF7F50),
                          ),
                        )
                      ]
                    )
                  )
                ]
              )
            ),
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: steps.length,
                itemBuilder: (BuildContext context, int index){
                    final List<String> step = steps[index];
                    IconData icon = Icons.error;
                    Color iconColor = Colors.amber;

                    if(step[3] == "done") {
                      icon = Icons.check_circle;
                      iconColor = Color(0XFFB9ACD32);
                    }
                    else if (step[3] == "pending"){
                      icon = Icons.error;
                      iconColor = Colors.amber;
                    }
                    else if (step[3] == "miss"){
                      icon = Icons.cancel;
                      iconColor = Colors.red;
                    }

                    if(index == 0)
                      return buildTimeLineTile(index, icon, iconColor, time: step[0], text: step[1], duration: step[2], isFirst: true);
                    if(index == steps.length - 1)
                      return buildTimeLineTile(index, icon, iconColor, time: step[0], text: step[1], duration: step[2], isLast: true);
                    return buildTimeLineTile(index, icon, iconColor, time: step[0], text: step[1], duration: step[2]);
                },
              ),
            ),
          ]
        )
      );
  }

  Widget buildTimeLineTile(int index, IconData icon, var iconColor, {String time, String text, String duration, bool isFirst = false, bool isLast = false})=>
    TimelineTile(
      axis: TimelineAxis.vertical,
      alignment: TimelineAlign.manual,
      isFirst: isFirst,
      isLast: isLast,
      lineXY: _TIMELINE_LINE_XY,

      indicatorStyle: IndicatorStyle(
        width: _TIMELINE_INDICATOR_WIDTH,
        padding: EdgeInsets.only(
          left: _TIMELINE_INDICATOR_PADDING,
          right: _TIMELINE_INDICATOR_PADDING,
        ),
          color: iconColor,
          iconStyle: IconStyle(
            color: Colors.white,
            iconData: icon,
          ),
      ),

      startChild: Container(
        alignment: Alignment.centerRight,
        child:Text(
          time,
          style: TextStyle(
            color:Colors.black,
              fontFamily: 'Grandstander',
              fontSize: 15.5,
            fontWeight: FontWeight.w800
          ),
        )
      ),

      endChild:Container(
        margin: EdgeInsets.symmetric(vertical: _TIMELINE_MARGIN_BETWEEN_BUBBLE),
        child:Row(
          children:[
            Expanded(
              child:GestureDetector(
                onTap: (){Navigator.of(context).pushNamed("/appointmentInfo");},
                child: buildCard(index, text, duration, context),
              )
            ),
          ]
        ),
      ),

      beforeLineStyle: LineStyle(
        //color:colorList[max(0, index - 1) % colorList.length],
        color: iconColor,
        thickness: _TIMELINE_THICKNESS
      ),

      afterLineStyle: LineStyle(
        color: iconColor,
        thickness: _TIMELINE_THICKNESS
      ),
    );

  Widget buildCard(
      int index,
      String name,
      String duration,
      BuildContext context,
      ){
    return Card(
        elevation: 7,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)
        ),
        color: colorList[index % colorList.length],
        child: Slidable(
          delegate: new SlidableStrechDelegate(),
          actionExtentRatio: 0.30,
          actions: <Widget>[
            new IconSlideAction(
              caption: 'Done',
              color: Color(0XFFBFFD700),
              icon: Icons.event_available,
//              onTap: (){

//              },
            ),
          ],
          child: Container(
            height: 80.0,
            padding: EdgeInsets.only(left: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      ),
                      Text(
                        duration,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Baloo',
                          fontWeight: FontWeight.w800
                        ),
                      ),
                      SizedBox(height: 3.0),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 1.0),
                    child: Icon(Icons.arrow_forward_ios,color: Color(0xFFBBC8F8F)),
                  ),
                )
              ],
            ),
          ),
        )

    );
  }
}
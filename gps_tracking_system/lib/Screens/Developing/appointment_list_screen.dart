import 'dart:math';
import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:gps_tracking_system/components/custom_table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';

class AppointmentListScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_AppointmentListState();
}

class _AppointmentListState extends State<AppointmentListScreen>{
  //Config
  static const _TIMELINE_LINE_XY = 0.27;
  static const _TIMELINE_INDICATOR_WIDTH = 35.0;
  static const _TIMELINE_INDICATOR_PADDING = 4.0;
  static const _TIMELINE_MARGIN_BETWEEN_BUBBLE = 10.0;
  static const _TIMELINE_THICKNESS = 2.0;

  final List<Color> colorList = [Colors.cyan, Colors.orangeAccent, Colors.greenAccent, Colors.pinkAccent, Colors.green];
  final List<List<String>> steps = [
    ["9.00am", "Emilie khor"],
    ["10.00am", "Jeffrey Tan"],
    ["11.00am", "Lau Kuan Sin"],
    ["12.00pm", "Pey Xin Yi"],
    ["1.00pm", "Chuang Jing Yee"],
    ["2.00pm", "Yuki Lim Qian Xing"],
    ["3.00pm", "Kok Heng"],
    ["4.00pm", "Shahriman"],
    ["5.00pm", "Tan Hoe Theng"],
    ["6.00pm", "Anonymous"],
    ["7.00pm", "Shou Jin"],
    ["8.00pm", "Leong Yong peng"],
    ["9.00pm", "Leow Jie Han"],
    ["10.00pm", "My brother"],
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
        color: primaryBgColor,
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
                    if(index == 0)
                      return buildTimeLineTile(index, time: step[0], text: step[1], isFirst: true);
                    if(index == steps.length - 1)
                      return buildTimeLineTile(index, time: step[0], text: step[1], isLast: true);
                    return buildTimeLineTile(index, time: step[0], text: step[1]);
                },
              )
            )
          ]
        )
      );
  }

  Widget buildTimeLineTile(int index, {String time, String text, bool isFirst = false, bool isLast = false})=>
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

        indicator: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: colorList[index % colorList.length])
          ),

          child: Text(
            text[0].toUpperCase(),
            style: TextStyle(
              color: colorList[index % colorList.length],
            ),
          ),
        )
      ),

      startChild: Container(
        alignment: Alignment.centerRight,
        child:Text(
          time,
          style: TextStyle(
            color:primaryColor
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
                child:Bubble(
                  nip: BubbleNip.no,
                  child: Text(
                    text,
                    style: TextStyle(
                    color: Colors.white
                  ),
                ),
                color: colorList[index % colorList.length],
                ),
              )
            ),
          ]
        ),
      ),

      beforeLineStyle: LineStyle(
        color:colorList[max(0, index - 1) % colorList.length],
        thickness: _TIMELINE_THICKNESS
      ),

      afterLineStyle: LineStyle(
        color: colorList[index % colorList.length],
        thickness: _TIMELINE_THICKNESS
      ),
    );
}
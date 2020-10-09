import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Model/appointment.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:gps_tracking_system/Components/custom_table_calendar.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';


class AppointmentListScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_AppointmentListState();
}

class _AppointmentListState extends State<AppointmentListScreen>{

  final List<Color> colorList = [ Color(0xFFB76D7C4), Color(0xFFB5DADE2), Color(0xFFBA9DFBF), Color(0xFFB7FB3D5), Color(0xFFBAED6F1)];
  final Map<String, List<Appointment>> appointmentList = {
    "Wed Sep 26":[Appointment(null, null), Appointment(null, null)],
    "Wed Sep 27":[Appointment(null, null), Appointment(null, null)],
    "Wed Sep 28":[Appointment(null, null), Appointment(null, null), Appointment(null, null)],
  };

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
              _buildTopPanel(context),
              Expanded(
                child:_buildContentPanel()
              ),
            ]
          )
        )
      );
  }

  Card _buildCard(String customerName, String time, String timeTaken){
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 1),
      color: primaryLightColor,
      shape: RoundedRectangleBorder(),
      child:Column(
        children:<Widget>[
          ListTile(
            leading:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[Text(time)]
            ),
            title: Text(customerName, ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  Text(timeTaken),
                ]
            ),
            trailing:  Icon(Icons.done, color:Colors.green),
            onTap: (){
              Navigator.of(context).pushNamed("/appointmentInfo");
            },
          )
        ]
      )
    );
  }

  Container _buildContentDayPanel(String day, List<Appointment>appointmentList){
    return Container(
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child:Text("Today, Wed Sep 26", style: TextStyleFactory.p(color: primaryTextColor),)
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: appointmentList.length,
            itemBuilder: (BuildContext context, int index){
              return _buildCard("Emilie", "8:00am", "1hour 40min (40km)");
            },
          )
        ],
      )
    );
  }

  Container _buildContentPanel(){
    return Container(
      child:ListView.builder(
        scrollDirection: Axis.vertical,
          itemCount: appointmentList.length,
          itemBuilder: (BuildContext context, int index){
            String key = appointmentList.keys.elementAt(index);
            return _buildContentDayPanel(key, appointmentList[key]);
          }
      )
    );
  }

  Container _buildTopPanel(BuildContext context) {
    return Container(
      color:primaryLightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child:CustomTableCalendar(event: Map<DateTime, List>(), holiday: Map<DateTime, List>()),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child:Text("Appointments tracking", style: TextStyleFactory.heading6(),),
          ),
          Container(
            alignment: Alignment.centerRight,
            child:Row(
              children:[
                Expanded(
                  child:Container(
                    padding:EdgeInsets.symmetric(horizontal: 10),
                    child:LinearPercentIndicator(
                      animation: true,
                      lineHeight: 20.0,
                      animationDuration: 2500,
                      percent: 0.8,
                      center: Text("4 / 8", style: TextStyleFactory.p(color: primaryTextColor),),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.greenAccent,
                    )
                  )
                ),
                Container(
                  child:IconButton(
                    icon: Icon(Icons.chrome_reader_mode, color:Colors.green),
                    onPressed: () {Navigator.of(context).pushNamed("/today_appointment");},
                  )
                )
              ]
            )
          )
        ]
      )
    );
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:gps_tracking_system/components/custom_table_calendar.dart';

class UserAppointmentListScreen extends StatefulWidget {
  @override
  _UserAppointmentListScreenState createState() => _UserAppointmentListScreenState();
}

class _UserAppointmentListScreenState extends State<UserAppointmentListScreen> {

  final List<Color> colorList = [ Color(0xFFBFF7F50), Color(0xFFB808000), Color(0xFFB808000), Color(0xFFBFF7F50), Color(0xFFBFF7F50),
                                  Color(0xFFB808000)];
  final List<List<String>> meet = [
    ["2", "Tue", "9.00am", "2 Adults", "Done"],
    ["10", "Thu", "10.00am", "1 Child", "Done"],
    ["10", "Thu", "11.00am", "1 Adults 1 Child", "Reserved"],
    ["28", "Sun", "7.00pm", "2 Child", "Reserved"],
    ["28", "Sun", "2.00pm", "3 Adults", "Reserved"],
    ["30", "Tue", "3.00pm", "2 Adults 2 Child", "Reserved"],
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
        color: primaryLightColor,
        width: screenSize.width,
        height: screenSize.height,
        child:Column(
            children: [
              Container(
                  color: primaryLightColor,
                  child: Column(
                      children: <Widget>[
                        CustomTableCalendar(event: Map<DateTime, List>(), holiday: Map<DateTime, List>()),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05, vertical: screenSize.height * 0.01),
                            alignment: Alignment.centerRight,
                        )
                      ]
                  )
              ),
              Expanded(
                child: ClipPath(
                  clipper: OvalTopBorderClipper(),
                  child: Container(
                    color: Color(0XFFBAFEEEE),
                    padding: EdgeInsets.only(top: 50),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: meet.length,
                      itemBuilder: (BuildContext context, int index){
                        final List<String> step = meet[index];
                        IconData icon = Icons.watch_later;
                        Color iconColor = Colors.brown;

                        if(step[4] == "Done") {
                          icon = Icons.done_all;
                          iconColor = Colors.green;
                        }
                        else if (step[4] == "Reserved"){
                          icon = Icons.watch_later;
                          iconColor = Color(0XFFB6A5ACD);
                        }

                        return buildList(index, icon, iconColor, step[0], step[1], step[2], step[3], step[4], context);
                      },
                    ),
                  )
                )

              ),
            ]
        )
    );

  }

  Widget buildList(
      int index,
      IconData icon,
      Color iconColor,
      String date,
      String day,
      String time,
      String count,
      String progress,
      BuildContext context,
      ){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed("/userAppointmentInfo");
      },
      child: Card(
          elevation: 7,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          color: colorList[index % colorList.length],
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Slidable(
            delegate: new SlidableStrechDelegate(),
            actionExtentRatio: 0.26,
            actions: <Widget>[
              new IconSlideAction(
                caption: 'Cancel',
                color: Color(0XFFBFFD700),
                icon: Icons.cancel,
//              onTap: (){

//              },
              ),
            ],
            child: Container(
              height: 100.0,
              margin: EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    //height: 58,
                    width: MediaQuery.of(context).size.width * 0.22,
                    margin: EdgeInsets.only(top: 14,bottom: 14),
                    decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                            width: 2.0,
                          )
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          date,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0XFFBDC143C)
                          ),
                        ),
                        Text(
                          day,
                          style: TextStyle(
                              color: Colors.grey
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                              fontFamily: "Lato",
                              color: Color(0XFFB1E90FF)
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15.0),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 15.0),
                        Text(
                          count,
                          style: TextStyle(
                              fontFamily: 'Baloo',
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                          ),
                        ),
                        Row(
                            children:[
                              Icon(Icons.star, color: Colors.yellow,),
                              Icon(Icons.star, color: Colors.yellow,),
                              Icon(Icons.star, color: Colors.yellow,),
                              Icon(Icons.star, color: Colors.yellow,),
                              Icon(Icons.star, color: Colors.yellow,),
                            ]
                        ),
                        SizedBox(height: 15.0),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.only(top: 18, bottom: 15, right: 11),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:[
                                Icon(icon,color: iconColor),
                                Text(
                                    progress
                                ),
                              ]
                          )
                      )
                  ),
                ],
              ),
            ),
          )
      )


    );
  }

}

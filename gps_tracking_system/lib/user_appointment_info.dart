import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:gps_tracking_system/color.dart';

class UserAppointmentInfo extends StatefulWidget {
  @override
  _UserAppointmentInfoState createState() => _UserAppointmentInfoState();
}

class _UserAppointmentInfoState extends State<UserAppointmentInfo> {

  Widget buildDateDay(Size screenSize){
    return Expanded(
      flex: 1,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "10",
            style: TextStyle(
                color: Color(0XFFBDC143C),
                fontSize: 25
            ),
          ),
          Text(
            "THU",
            style: TextStyle(
                color: Colors.grey
            ),
          )
        ],
      ),
    );
  }

  Widget buildTopContainer(Size screenSize){
    return Container(
      width: screenSize.width,
      color: primaryLightColor,
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.021),
      child:Row(
          children: <Widget>[
            SizedBox(width: screenSize.width * 0.1,),
            buildDateDay(screenSize),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "1 Adults 1 Child",
                    style: TextStyle(
                        color: Color(0XFFB0000FF),
                        fontSize: 22
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
                  )
                ],
              )
            ),
          ]
      ),
    );
  }

  Widget buildAppointmentInfo(Size screenSize, IconData icon, String text){
    return Container(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.015),
        child:Row(
          children: [
            Expanded(
                flex: 1,
                child:Icon(
                  icon,
                  color: Color(0XFFB8A2BE2),
                )
            ),
            Flexible(
              flex: 4,
              child: Text(
                text,
                style: TextStyle(
                    color: dayColor
                ),
              ),
            )
          ],
        )
    );
  }

  Widget buildAppointmentInfoHeader(Size screenSize, String header){
    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(left: screenSize.width * 0.075, right: screenSize.width * 0.1, top: screenSize.height * 0.02),
        child: Text(
          header,
          style: TextStyle(
            color:Colors.black,
            fontSize: 18,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold
          ),
        )
    );
  }

  Widget buildAppointmentInformation(Size screenSize){
    return Container(
        color: primaryLightColor,
        child:Column(
            children:<Widget>[
              buildAppointmentInfoHeader(screenSize, "Appointment Information"),
              buildAppointmentInfo(screenSize, Icons.access_time, "11.00am"),
              buildAppointmentInfo(screenSize, Icons.location_on, "38, Lorong 7/ SS9, Bandar Tasek Mutiara, 14120, Simpang Ampat"),
              buildAppointmentInfo(screenSize, Icons.person, "E.V. Ramasamy a/l R. Karthik"),
              buildAppointmentInfo(screenSize, Icons.perm_phone_msg, "012-4727438"),
              SizedBox(height: screenSize.height * 0.015,)
            ]
        )
    );
  }

  Widget buildTimeArriveInformation(Size screenSize){
    return Container(
        color: primaryLightColor,
        child:Column(
            children:<Widget>[
              buildAppointmentInfoHeader(screenSize, "Time To Arrive"),
              buildAppointmentInfo(screenSize, Icons.time_to_leave, "1hour 10min (30km)"),
              SizedBox(height: screenSize.height * 0.015,)
            ]
        )
    );
  }

  Widget buildReview(Size screenSize){
    return Container(
        color: primaryLightColor,
        child:Column(
            children:<Widget>[
              buildAppointmentInfoHeader(screenSize, "Review"),
              Container(
                padding: EdgeInsets.only(top: screenSize.height * 0.015, bottom: screenSize.height * 0.015, left: 25,right: 25),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(15.0),
                      ),
                    ),
                    hintText: 'Your reviews (Optional)',
                    hintStyle: new TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.015,)
            ]
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.black12.withOpacity(.2),
                elevation: 0.0,
                leading: Icon(Icons.menu,color: Color(0XFFB707B7C),),
                centerTitle: true,
                title: Text("Coming",
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.menu,color: Color(0XFFB707B7C),),
                  )
                ],
              ),
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  width: double.infinity,
                  height: 300.0,
                  padding: EdgeInsets.only(bottom: 50.0),
                  decoration: BoxDecoration(
                    color: Color(0XFFBAFEEEE),
                    image: DecorationImage(
                      image: AssetImage("assets/images/Worker.png"),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    color: primaryBgColor,
                    child:Column(
                      children: [
                        buildTopContainer(screenSize),
                        SizedBox(height: screenSize.height * 0.01,),
                        buildAppointmentInformation(screenSize),
                        SizedBox(height: screenSize.height * 0.01,),
                        buildTimeArriveInformation(screenSize),
                        SizedBox(height: screenSize.height * 0.01,),
                        buildReview(screenSize),
                        SizedBox(height: screenSize.height * 0.01,),
                        Container(
                          width: screenSize.width,
                          height: screenSize.height * 0.3,
                          color: Color(0XFFBAFEEEE),
                          alignment: Alignment.center,
                          child: Text(
                            "Map",
                            style: TextStyle(
                              fontSize: 25
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],

              )

            ],
          ),
        ),
      ),
    );
  }


}

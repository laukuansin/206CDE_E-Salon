import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Screens/Admin/AppointmentList/appointment_list_response.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/map_helper.dart';
import 'package:gps_tracking_system/Utility/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:gps_tracking_system/Components/custom_table_calendar.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:skeleton_text/skeleton_text.dart';


class AppointmentListScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_AppointmentListState();
}

class _AppointmentListState extends State<AppointmentListScreen>{

  final Map<String, List<Appointment>> appointmentList = {};
  final Map<String, Map<String, int>> appointmentRouteTimeDistance = {};

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
              _buildAppointmentTracking(context),
              Expanded(
                child:_buildAppointmentList()
              ),
            ]
          )
        )
      );
  }
  
  @override
  void initState() {
    super.initState();
    requestAppointmentList();
  }

  void requestAppointmentList() async{
    AppointmentListResponse result = await RestApi.admin.getAppointmentList();

    if(result.response.status == 1) {
      for(Appointment appointment in result.appointments){
        if(!appointmentList.containsKey(appointment.appointmentDate))
          appointmentList[appointment.appointmentDate.toString()] = [];
        appointmentList[appointment.appointmentDate.toString()].add(appointment);
      }

      setState(() {});
      requestAppointmentTimeDistance();

    } else{
      Navigator.of(context).pushNamedAndRemoveUntil('/login',  ModalRoute.withName("/login"));
    }
  }

  void requestAppointmentTimeDistance() async{
    LatLng origin = MapHelper.positionToLatLng(await getCurrentPosition());
    appointmentList.forEach((date, list) async{
      for(Appointment appointment in list){
        LatLng desitnation = await MapHelper.addressToLatLng(appointment.address);
        Map<String, int> timeDistanceMap = await MapHelper.getRouteTimeDistance([origin, desitnation]);
        appointmentRouteTimeDistance[appointment.appointmentId] = timeDistanceMap;
        setState(() {});
      }
    });
  }


  Card _buildAppointmentCard(Appointment appointment){

    String timeTaken = appointmentRouteTimeDistance.containsKey(appointment.appointmentId)
        ? MapHelper.getTotalDistanceDurationString(appointmentRouteTimeDistance[appointment.appointmentId]['duration'], appointmentRouteTimeDistance[appointment.appointmentId]['distance']):"";

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
              children:<Widget>[Text(appointment.getAppointmentDateStringJM())]
            ),
            title: Text(appointment.customerName, ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  Text(appointment.address, overflow: TextOverflow.ellipsis,),
                  () {
                    return timeTaken.isEmpty
                        ? SkeletonAnimation(
                      child: Container(
                        height: 15,
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[300]),
                      ),
                    )
                        : Text(timeTaken);
                  }()
                ]
            ),
            trailing:  Icon(Icons.done, color:Colors.green),
            onTap: (){
              Navigator.of(context).pushNamed("/appointmentInfo", arguments: appointment);
            },
          )
        ]
      )
    );
  }

  Container _buildAppointmentListByDate(String day, List<Appointment>appointmentList){
    return Container(
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child:Text(day, style: TextStyleFactory.p(color: primaryTextColor),)
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: appointmentList.length,
            itemBuilder: (BuildContext context, int index){
              return _buildAppointmentCard(appointmentList[index]);
            },
          )
        ],
      )
    );
  }

  Container _buildAppointmentList(){
    return Container(
      child:ListView.builder(
        scrollDirection: Axis.vertical,
          itemCount: appointmentList.length,
          itemBuilder: (BuildContext context, int index){
            String key = appointmentList.keys.elementAt(index);
            return _buildAppointmentListByDate(appointmentList[key][0].getAppointmentDateStringEMMMDD(), appointmentList[key]);
          }
      )
    );
  }

  Container _buildAppointmentTracking(BuildContext context) {
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
                    onPressed: () {Navigator.of(context).pushNamed("/today_appointment",);},
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
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Model/Worker.dart';
import 'package:gps_tracking_system/Screens/GoogleMap/googlemap_screen.dart';
import 'package:gps_tracking_system/Screens/GoogleMap/googlemap_listener.dart';
import 'package:gps_tracking_system/Utility/app_launcher.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:gps_tracking_system/components/rounded_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AppointmentInfo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_AppointmentInfoState(Worker(workerId: "P18010220"));
}

class _AppointmentInfoState extends State<AppointmentInfo>{

  final String customerAddress = "Sunshine Farlim";
  bool _isWorkerReady;
  Worker _worker;
  GoogleMapListener _googleMapController;
  GlobalKey<GoogleMapScreenState> _key;

  _AppointmentInfoState(Worker worker)
  {
    _isWorkerReady = false;
    _worker = worker;
    _googleMapController = GoogleMapListener(worker: worker, workerLocationUpdated: onLocationReceived);
    _key = GlobalKey();
  }

  Widget buildDateDay(Size screenSize){
    return Expanded(
      flex: 1,
      // padding: EdgeInsets.all(screenSize.width * 0.05),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "31",
            style: TextStyle(
                color: dateColor,
                fontSize: 25
            ),
          ),
          Text(
            "THU",
            style: TextStyle(
                color: primaryColor
            ),
          )
        ],
      ),
    );
  }

  Widget buildTopPanel(Size screenSize){
    return Container(
      width: screenSize.width,
      color: primaryLightColor,
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
      child:Row(
        children: <Widget>[
          buildDateDay(screenSize),
          Expanded(
            flex: 2,
            child:Text(
              "Emilie Khor",
              style: TextStyle(
                  color: dayColor,
                  fontSize: 20
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.01),
            child: RoundedButton(
              icon: Icons.navigation,
              horizontalPadding: 6,
              text: "Navigate",
              fontSize: 15,
                press: (){
                  try {
                    AppLauncher.openMap(
                        srcLatLng: [_worker.latitude, _worker.longitude],
                        destAddress: customerAddress
                    );
                  }
                  catch(e){

                  }
                }
            )
          )
        ]
      ),
    );
  }

  Widget buildPanelInfo(Size screenSize, IconData icon, String text){
    return Container(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.015),
        child:Row(
          children: [
            Expanded(
                flex: 1,
                child:Icon(
                  icon,
                  color: primaryColor,
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

  Widget buildPanelInfoHeader(Size screenSize, String header){
    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(left: screenSize.width * 0.075, right: screenSize.width * 0.1, top: screenSize.height * 0.02),
        child: Text(
          header,
          style: TextStyle(
            color:Colors.black,
            fontSize: 18,
            // decoration: TextDecoration.underline
          ),
        )
    );
  }

  Widget buildPanelBasicInformation(Size screenSize){
    return Container(
      color: primaryLightColor,
      child:Column(
        children:<Widget>[
          buildPanelInfoHeader(screenSize, "Basic Information"),
          buildPanelInfo(screenSize, Icons.access_time, "9am to 10am"),
          buildPanelInfo(screenSize, Icons.location_on, "38, Lorong 7/ SS9, Bandar Tasek Mutiara, 14120, Simpang Ampat"),
          buildPanelInfo(screenSize, Icons.contacts, "012-4727438"),
          buildPanelInfo(screenSize, Icons.note_add, "Server down. Please solve it as fast as possible. Thank You very much. >3"),
          SizedBox(height: screenSize.height * 0.015,)
        ]
      )
    );
  }

  Widget buildPanelTravelInformation(Size screenSize){
    return Container(
        color: primaryLightColor,
        child:Column(
            children:<Widget>[
              buildPanelInfoHeader(screenSize, "Travel information"),
              buildPanelInfo(screenSize, Icons.time_to_leave, "1hour 40min (40km)"),
              SizedBox(height: screenSize.height * 0.015,)
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body:SlidingUpPanel(
        backdropEnabled: true,
        backdropTapClosesPanel: true,
        margin: EdgeInsets.only(top:statusBarHeight),
        body: SizedBox(
              height: screenSize.height,
              width: screenSize.width,
              child:GoogleMapScreen(
                key: _key,
                workerLatLng: LatLng(_worker.latitude, _worker.longitude),
                customerAddress: customerAddress,
              ),
            ),

        panel: Container(
          color: primaryBgColor,
          child:Column(
            children: [
              buildTopPanel(screenSize),
              SizedBox(height: screenSize.height * 0.01,),
              buildPanelBasicInformation(screenSize),
              SizedBox(height: screenSize.height * 0.01,),
              buildPanelTravelInformation(screenSize),
            ],
          ),
        ),

          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          maxHeight: screenSize.height,
          minHeight: screenSize.height * 0.12,
          defaultPanelState: PanelState.OPEN,
        )
      );
  }

  // Firebase will invoke the listener once even there is no changing. Hence, when the first value returned by firebase,
  // we need to animate the camera
  void onLocationReceived(double latitude, double longitude){
    _key.currentState.updateWorkerLocation(_isWorkerReady, LatLng(latitude, longitude));
    _isWorkerReady = true;
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Model/worker.dart';
import 'package:gps_tracking_system/Screens/Common/GoogleMap/googlemap_screen.dart';
import 'package:gps_tracking_system/Screens/Common/GoogleMap/googlemap_listener.dart';
import 'package:gps_tracking_system/Utility/app_launcher.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:gps_tracking_system/Components/rounded_button.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AppointmentInfo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_AppointmentInfoState(Worker("P18010220"));
}

class _AppointmentInfoState extends State<AppointmentInfo>{

  final String customerAddress = "Sunshine Farlim";
  final GlobalKey _keySlidingUpPanel = GlobalKey();
  double _minHeightOfSlidingUpPanel;
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


  @override
  void initState() {
    super.initState();
    _minHeightOfSlidingUpPanel = -1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _minHeightOfSlidingUpPanel = _keySlidingUpPanel.currentContext.size.height;
      setState(() {});
    });
  }

  Container _buildSlidingUpPanelIndicator(){
    Size screenSize = MediaQuery.of(context).size;
    if(_minHeightOfSlidingUpPanel == -1) _minHeightOfSlidingUpPanel = screenSize.height;
    return Container(
      color: primaryLightColor,
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Center(
            child: Container(
              height: 7,
              width: screenSize.width * 0.1,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildDateDay(Size screenSize){
    return Container(
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "31",
            style: TextStyleFactory.heading1(color:dateColor)
          ),
          Text(
            "THU",
            style: TextStyleFactory.p()
          )
        ],
      ),
    );
  }

  Widget _buildTopPanel(Size screenSize){
    return Container(
      key: _keySlidingUpPanel,
      width: screenSize.width,
      color: primaryLightColor,
      child:Column(
        children:<Widget>[
          _buildSlidingUpPanelIndicator(),
          ListTile(
            contentPadding: EdgeInsets.only(bottom: 16.0, left: 16.0, right:16.0),
            leading: buildDateDay(screenSize),
            title: Text("Emilie Khor"),
            trailing: RoundedButton(
              icon: Icons.navigation,
              horizontalPadding: 10,
              text: "Navigate",
              fontSize: 14,
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
            ),
          )
        ]
      )
    );
  }

  Widget buildPanelInfo(Size screenSize, IconData icon, String text){
    return Container(
        child:ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              Icon(
                icon,
                color: primaryColor,
              ),
            ]
          ),
          title: Text(text, style: TextStyleFactory.p(),),
        )
    );
  }

  Widget buildPanelInfoHeader(Size screenSize, String header){
    return ListTile(
        leading: Text(
          header,
          style: TextStyleFactory.heading5(),
        ),
        dense: true,
    );
  }

  Widget _buildPanelBasicInformation(Size screenSize){
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

  Widget _buildPanelTravelInformation(Size screenSize){
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
              _buildTopPanel(screenSize),
              SizedBox(height: screenSize.height * 0.01,),
              _buildPanelBasicInformation(screenSize),
              SizedBox(height: screenSize.height * 0.01,),
              _buildPanelTravelInformation(screenSize),
            ],
          ),
        ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          maxHeight: screenSize.height,
          minHeight: _minHeightOfSlidingUpPanel,
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


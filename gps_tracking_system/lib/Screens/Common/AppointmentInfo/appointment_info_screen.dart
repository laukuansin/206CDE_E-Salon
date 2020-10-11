import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Components/rounded_button.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/worker_location.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/appointment_list_response.dart';
import 'package:gps_tracking_system/Screens/Common/GoogleMap/googlemap_listener.dart';
import 'package:gps_tracking_system/Screens/Common/GoogleMap/googlemap_screen.dart';
import 'package:gps_tracking_system/Utility/app_launcher.dart';
import 'package:gps_tracking_system/Utility/map_helper.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AppointmentInfo extends StatefulWidget {
  final Appointment appointment;

  AppointmentInfo(Appointment arg): appointment= arg;

  @override
  State<StatefulWidget> createState() =>
      _AppointmentInfoState(appointment);
}

class _AppointmentInfoState extends State<AppointmentInfo> {
  final Appointment appointment;
  final GlobalKey _keySlidingUpPanel = GlobalKey();
  final GlobalKey<GoogleMapScreenState> _googleMapKey = GlobalKey();
  double _minHeightOfSlidingUpPanel;

  bool  _isWorkerReady;
  WorkerLocation _workerLocation;
  String _distanceDurationToDest;
  GoogleMapListener _googleMapListener;

  _AppointmentInfoState(this.appointment);

  @override
  void initState() {
    super.initState();
    _minHeightOfSlidingUpPanel = -1;
    _distanceDurationToDest    = "";
    _isWorkerReady             = false;
    _workerLocation            = WorkerLocation(workerId: appointment.workerId);
    _googleMapListener         = GoogleMapListener(workerId: appointment.workerId, workerLocationUpdated: onLocationReceived);

    if(appointment.status == Status.PENDING){
      _googleMapListener.startServices();
    }

    requestAppointmentTimeDistance();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _minHeightOfSlidingUpPanel = _keySlidingUpPanel.currentContext.size.height;
      });
    });
  }

  void requestAppointmentTimeDistance() async {
    LatLng origin = MapHelper.positionToLatLng(await getCurrentPosition());
    LatLng destination = await MapHelper.addressToLatLng(appointment.address);
    Map<String, int> timeDestinationMap = await MapHelper.getRouteTimeDistance([origin, destination]);
    setState(() {
      _distanceDurationToDest = MapHelper.getTotalDistanceDurationString(timeDestinationMap["duration"], timeDestinationMap["distance"]);
    });
  }

  Container _buildSlidingUpPanelIndicator() {
    Size screenSize = MediaQuery.of(context).size;
    if (_minHeightOfSlidingUpPanel == -1)
      _minHeightOfSlidingUpPanel = screenSize.height;
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

  Container buildDateDay(Size screenSize) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(appointment.getAppointmentDateStringDate(),
              style: TextStyleFactory.heading1(color: dateColor)),
          Text(appointment.getAppointmentDateStringDay(),
              style: TextStyleFactory.p())
        ],
      ),
    );
  }



  Widget _buildTopPanel(Size screenSize) {
    return Container(
        key: _keySlidingUpPanel,
        width: screenSize.width,
        color: primaryLightColor,
        child: Column(children: <Widget>[
          _buildSlidingUpPanelIndicator(),
          ListTile(
            contentPadding:
                EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
            leading: buildDateDay(screenSize),
            title: Text(appointment.customerName),
            trailing: RoundedButton(
                icon: Icons.navigation,
                horizontalPadding: 10,
                text: "Navigate",
                fontSize: 14,
                press: () async{
                  try {
                    AppLauncher.openMap(srcLatLng: [
                      _workerLocation.latitude,
                      _workerLocation.longitude
                    ], destAddress: appointment.address);
                  } catch (e) {}
                }),
          )
        ]));
  }

  Widget buildPanelInfo(Size screenSize, IconData icon, String text) {
    return Container(
        child: ListTile(
          leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  color: primaryColor,
                ),
              ]),
          title: text.isEmpty
              ? SkeletonAnimation(
                  child: Container(
                    height: 15,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[300]),
                  ),
                )
              : Text(
                  text,
                  style: TextStyleFactory.p(),
                ),
    ));
  }

  Widget buildPanelInfoHeader(Size screenSize, String header) {
    return ListTile(
      leading: Text(
        header,
        style: TextStyleFactory.heading5(),
      ),
      dense: true,
    );
  }

  Widget _buildPanelBasicInformation(Size screenSize) {
    return Container(
        color: primaryLightColor,
        child: Column(children: <Widget>[
          buildPanelInfoHeader(screenSize, "Basic Information"),
          buildPanelInfo(screenSize, Icons.access_time,
              appointment.getAppointmentDateStringJM()),
          buildPanelInfo(screenSize, Icons.location_on, appointment.address),
          buildPanelInfo(screenSize, Icons.contacts, appointment.telephone),
          SizedBox(
            height: screenSize.height * 0.015,
          )
        ]));
  }

  Widget _buildPanelTravelInformation(Size screenSize) {
    return Container(
        color: primaryLightColor,
        child: Column(children: <Widget>[
          buildPanelInfoHeader(screenSize, "Travel information"),
          buildPanelInfo(screenSize, Icons.time_to_leave, _distanceDurationToDest),
          SizedBox(
            height: screenSize.height * 0.015,
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return RouteGenerator.buildScaffold(
        SlidingUpPanel(
          backdropEnabled: true,
          backdropTapClosesPanel: true,
          margin: EdgeInsets.only(top: statusBarHeight),
          body: SizedBox(
            height: screenSize.height,
            width: screenSize.width,
            child: GoogleMapScreen(
              key: _googleMapKey,
              workerLatLng:
                  LatLng(_workerLocation.latitude, _workerLocation.longitude),
              customerAddress: appointment.address,
            ),
          ),
          panel: Container(
            color: primaryBgColor,
            child: Column(
              children: [
                _buildTopPanel(screenSize),
                SizedBox(
                  height: screenSize.height * 0.01,
                ),
                _buildPanelBasicInformation(screenSize),
                SizedBox(
                  height: screenSize.height * 0.01,
                ),
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
          defaultPanelState: PanelState.CLOSED,
    ));
  }

  // Firebase will invoke the listener once even there is no changing. Hence, when the first value returned by firebase,
  // we need to animate the camera
  void onLocationReceived(double latitude, double longitude) {
    _googleMapKey.currentState.updateWorkerLocation(_isWorkerReady, LatLng(latitude, longitude));
    _isWorkerReady = true;
  }
}

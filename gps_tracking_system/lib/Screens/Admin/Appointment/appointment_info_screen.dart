import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/appointment.dart';
import 'package:gps_tracking_system/Model/logged_user.dart';
import 'package:gps_tracking_system/Model/worker_location.dart';
import 'package:gps_tracking_system/Screens/Common/GoogleMap/googlemap_listener.dart';
import 'package:gps_tracking_system/Screens/Common/GoogleMap/googlemap_screen.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/common_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/get_services_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/Utility/app_launcher.dart';
import 'package:gps_tracking_system/Utility/map_helper.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sqflite/sqflite.dart';

class AppointmentInfo extends StatefulWidget {
  final Appointment appointment;

  AppointmentInfo(Appointment arg) : appointment = arg;

  @override
  State<StatefulWidget> createState() => _AppointmentInfoState(appointment);
}

class _AppointmentInfoState extends State<AppointmentInfo> {
  final Appointment appointment;
  final GlobalKey _keySlidingUpPanel = GlobalKey();
  final GlobalKey _sliverAppBar = GlobalKey();
  final GlobalKey<GoogleMapScreenState> _googleMapKey = GlobalKey();
  double _minHeightOfSlidingUpPanel;
  bool _isWorkerReady;
  WorkerLocation _workerLocation;
  String _distanceDurationToDest;
  GoogleMapListener _googleMapListener;
  List<Service> services = [];

  _AppointmentInfoState(this.appointment);

  @override
  void initState() {
    super.initState();
    _minHeightOfSlidingUpPanel = 0;
    _distanceDurationToDest = "";
    _isWorkerReady = false;
    _workerLocation = WorkerLocation(workerId: appointment.workerId);
    _googleMapListener = GoogleMapListener(
        appointmentId: appointment.appointmentId,
        workerId: appointment.workerId,
        workerLocationUpdated: onLocationReceived);

    requestAppointmentServices();
    requestAppointmentTimeDistance();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _minHeightOfSlidingUpPanel =
            _keySlidingUpPanel.currentContext.size.height;
      });
    });
  }


  void requestAppointmentServices() async {
    GetServicesResponse result = await RestApi.admin
        .getAppointmentServices(appointment.appointmentId);
    if (result.response.status == 1) {
      setState(() {
        services = result.services;
      });
    }
  }
  
  
  Future<void> requestUpdateAppointmentStatus(Status status) async {
    CommonResponse result = await RestApi.admin.updateAppointment(appointment.appointmentId, status);
    if (result.response.status == 1) {
      setState((){appointment.status = status;});
      if(status == Status.CANCELLED)
        Navigator.of(context).pop();
    }
  }

  Future<void> requestUpdateAppointmentStatusNLog(Status status) async {
    String activity = "";
    switch(status){
      case Status.ONGOING: activity = "Heading to ${appointment.customerName} site"; break;
      case Status.SERVICING: activity = "Arrived at ${appointment.customerName} site"; break;
      case Status.CLOSE: activity = "Service completed"; break;
      default: return;
    }
    CommonResponse result = await RestApi.admin.updateAppointmentStatusNLog(appointment.appointmentId, status, activity);
    if (result.response.status == 1) {
      setState((){appointment.status = status;});
      if(status == Status.CANCELLED)
        Navigator.of(context).pop();
    }
  }

  double _calcTotalPrice() {
    double totalPrice = 0.0;
    services.forEach((element) {
      totalPrice += element.servicePrice * element.quantity;
    });
    return totalPrice;
  }

  void requestAppointmentTimeDistance() async {
    LatLng origin = MapHelper.positionToLatLng(await getCurrentPosition());
    LatLng destination = await MapHelper.addressToLatLng(appointment.address);
    Map<String, int> timeDestinationMap =
    await MapHelper.getRouteTimeDistance([origin, destination]);
    setState(() {
      _distanceDurationToDest = MapHelper.getTotalDistanceDurationString(
          timeDestinationMap["duration"], timeDestinationMap["distance"]);
    });
  }

  Container _buildSlidingUpPanelIndicator() {
    Size screenSize = MediaQuery.of(context).size;
    if (_minHeightOfSlidingUpPanel == 0)
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
          Text(appointment.getAppointmentDateStringDD(),
              style: TextStyleFactory.heading2(color: dateColor)),
          Text(appointment.getAppointmentDateStringE(),
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
              contentPadding: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
              leading: buildDateDay(screenSize),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[ Text(appointment.customerName, style: TextStyleFactory.heading3(fontWeight: FontWeight.normal),),
                  Text("Salon: ${appointment.workerName}",style: TextStyleFactory.p(),)
                  ]),
            trailing:_buildAppointmentStatus()
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

  Widget _buildAppointmentStatus(){
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          _getStatusIcon(appointment.status),
          Text(appointment.getStatusName(), style: TextStyleFactory.p(color: _getStatusColor(appointment.status)),)
        ]
    );
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
          buildPanelInfoHeader(screenSize, "Customer's Information"),
          buildPanelInfo(screenSize, Icons.access_time,
              appointment.getAppointmentDateStringJM()),
          buildPanelInfo(
              screenSize, Icons.contacts, appointment.telephone),
          buildPanelInfo(
              screenSize, Icons.location_on, appointment.address),
          SizedBox(
            height: screenSize.height * 0.015,
          )
        ]));
  }

  Widget _buildWorkerInformation(Size screenSize) {
    return Container(
        color: primaryLightColor,
        child: Column(children: <Widget>[
          buildPanelInfoHeader(screenSize, "Salon's Information"),
          buildPanelInfo(
              screenSize, Icons.person, appointment.workerName),
          buildPanelInfo(
              screenSize, Icons.contacts, appointment.workerTelephone),
          SizedBox(
            height: screenSize.height * 0.015,
          )
        ]));
  }

  Widget _buildETAInformation(Size screenSize) {
    return appointment.status == Status.ONGOING
        ? Container(
        color: primaryLightColor,
        child: Column(children: <Widget>[
          buildPanelInfoHeader(screenSize, "Travel information"),
          buildPanelInfo(
              screenSize, Icons.time_to_leave, _distanceDurationToDest),
          SizedBox(
            height: screenSize.height * 0.015,
          )
        ]))
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return RouteGenerator.buildScaffold(SlidingUpPanel(
      backdropEnabled: true,
      backdropTapClosesPanel: true,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      body: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: Column(children: [
            AppBar(
              key: _sliverAppBar,
              title: Text("Appointment Info",
                  style: TextStyleFactory.p(color: primaryTextColor)),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.my_location,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      _googleMapKey.currentState.animateCameraToRouteBound();
                    })
              ],
            ),
            Expanded(
                child: GoogleMapScreen(
                  key: _googleMapKey,
                  size: Size(screenSize.width, screenSize.height - _minHeightOfSlidingUpPanel),
                  workerLatLng: (appointment.status == Status.ONGOING)
                      ? LatLng(_workerLocation.latitude, _workerLocation.longitude)
                      : null,
                  customerAddress: appointment.address,
                )),
          ])),
      panel: Container(
        height: screenSize.height,
        color: primaryBgColor,
        child: Column(
          children: [
            _buildTopPanel(screenSize),
            SizedBox(
              height: screenSize.height * 0.01,
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStatusActionButton(screenSize),
                          SizedBox(
                            height: screenSize.height * 0.01,
                          ),
                          _buildPanelBasicInformation(screenSize),
                          SizedBox(
                            height: screenSize.height * 0.01,
                          ),
                          _buildWorkerInformation(screenSize),
                          SizedBox(
                            height: screenSize.height * 0.01,
                          ),
                          _buildETAInformation(screenSize),
                          SizedBox(
                            height: screenSize.height * 0.01,
                          ),
                          _buildServiceInformation(screenSize),

                          _buildCancelAppointmentButton(screenSize),
                          SizedBox(height: _minHeightOfSlidingUpPanel,)
                        ])))
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

  Container _buildCancelAppointmentButton(Size screenSize) {
    if(LoggedUser.getRole() == Role.WORKER || appointment.status != Status.ACCEPTED) return Container();
    return Container(
      color: primaryLightColor,
      width: screenSize.width,
      child: Align(
        child: FlatButton.icon(
          icon: Icon(
            Icons.close,
            color: Colors.redAccent,
          ),
          label: Text(
            "Cancel appointment",
            style: TextStyleFactory.p(color: Colors.redAccent),
          ),
          onPressed: (){requestUpdateAppointmentStatus(Status.CANCELLED);},
        ),
      ),
    );
  }

  Icon _getStatusIcon(Status status){
    // ignore: missing_enum_constant_in_switch
    switch(status) {
      case Status.ACCEPTED:
        return Icon(Icons.access_alarm, color:_getStatusColor(status));
      case Status.CANCELLED:
        return Icon(Icons.cancel, color: _getStatusColor(status));
      case Status.CLOSE:
        return Icon(Icons.done, color: _getStatusColor(status));
      case Status.ONGOING:
        return Icon(Icons.directions_car, color: _getStatusColor(status),);
      case Status.SERVICING:
        return Icon(Icons.build, color: _getStatusColor(status),);
    }
    return null;
  }
  
  Color _getStatusColor(Status status){
    // ignore: missing_enum_constant_in_switch
    switch(status) {
      case Status.ACCEPTED:
        return Colors.greenAccent;
      case Status.CANCELLED:
        return  Colors.redAccent;
      case Status.CLOSE:
        return Colors.greenAccent;
      case Status.ONGOING:
        return primaryColor;
      case Status.SERVICING:
        return Colors.amber;
    }
    return null;
  }

  Container _buildStatusActionButton(Size screenSize) {
    if(LoggedUser.getRole() == Role.OWNER){
      return Container();
    }

    var createContainer = (IconData iconData, String text, Color color, Function() callback)=>Container(
      color: primaryLightColor,
      width: screenSize.width,
      child: Align(
        child: FlatButton.icon(
          icon: Icon(
            iconData,
            color: color,
          ),
          label: Text(
            text,
            style: TextStyleFactory.p(color: color),
          ),
          onPressed: callback
        ),
      ),
    );

    switch(appointment.status ){
      case Status.ACCEPTED:
        return createContainer(Icons.directions,"Start Navigation", primaryColor, ()async{
          await requestUpdateAppointmentStatusNLog(Status.ONGOING);
          try{
            _googleMapListener.startServices();
            AppLauncher.openMap(destAddress: appointment.address);
          }catch(e){}
        });
      case Status.ONGOING:
        return createContainer(Icons.build, "Start servicing", Colors.amber, ()async{
          _googleMapListener.stopServices();
          await requestUpdateAppointmentStatusNLog(Status.SERVICING);

          var db = await openDatabase("route.db");
          List<Map> routeCoord = await db.rawQuery("SELECT lat,lng FROM Route WHERE appointment_id = ${appointment.appointmentId} ORDER BY route_id");
          CommonResponse result = await RestApi.admin.sendRoute(appointment.appointmentId, routeCoord);
          db.rawDelete("DELETE FROM Route WHERE appointment_id = ?",[appointment.appointmentId]);
          await db.close();

        });
      case Status.SERVICING:
        return createContainer(Icons.attach_money, "Payment", Colors.greenAccent, ()async{
          await requestUpdateAppointmentStatusNLog(Status.CLOSE);
        });
      default:
        return Container();
    }
  }

  Container _buildServiceInformation(Size screenSize) {
    return Container(
        color: primaryLightColor,
        child: Column(children: <Widget>[
          buildPanelInfoHeader(screenSize, "Services"),
          _buildDataTable(),
          SizedBox(
            height: screenSize.height * 0.015,
          )
        ]));
  }

  DataTable _buildDataTable() {
    Size size = MediaQuery.of(context).size;
    const MARGIN = 16.0;
    List<DataRow> dataRow = [];

    if (services.isNotEmpty)
      services.forEach((element) {
        if (element.quantity > 0)
          dataRow.add(DataRow(cells: [
            DataCell(Container(
                width: (size.width - MARGIN * 2) * 0.4,
                child: Text(element.serviceName))),
            DataCell(Container(
              width: (size.width - MARGIN * 2) * 0.4,
              child: Align(
                alignment: Alignment.center,
                child: Text(element.quantity.toString()),
              ),
            )),
            DataCell(Container(
                width: (size.width - MARGIN * 2) * 0.2,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        (element.servicePrice * element.quantity).toString()))))
          ]));
      });

    dataRow.add(DataRow(cells: [
      DataCell(
        SizedBox(width: (size.width - MARGIN * 2) * 0.4),
      ),
      DataCell(Container(
          width: (size.width - MARGIN * 2) * 0.4,
          child: Align(
              alignment: Alignment.center,
              child: Text(
                "Total Price",
                style: TextStyleFactory.heading6(),
              )))),
      DataCell(Container(
          width: (size.width - MARGIN * 2) * 0.2,
          child: Align(
              alignment: Alignment.centerRight,
              child: Text(_calcTotalPrice().toString()))))
    ]));

    return DataTable(
        horizontalMargin: MARGIN,
        columnSpacing: 0,
        columns: [
          DataColumn(
              label: Container(
                  width: (size.width - MARGIN * 2) * 0.4,
                  child: Text(
                    "Service",
                    style: TextStyleFactory.p(),
                  ))),
          DataColumn(
              label: Container(
                  width: (size.width - MARGIN * 2) * 0.4,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Qty",
                        style: TextStyleFactory.p(),
                      )))),
          DataColumn(
              label: Container(
                  width: (size.width - MARGIN * 2) * 0.2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Sub(RM)",
                      style: TextStyleFactory.p(),
                    ),
                  ))),
        ],
        rows: dataRow);
  }

  // Firebase will invoke the listener once even there is no changing. Hence, when the first value returned by firebase,
  // we need to animate the camera
  void onLocationReceived(double latitude, double longitude) {
    if(_googleMapKey.currentState != null) {
      _googleMapKey.currentState.updateWorkerLocation(
          _isWorkerReady, LatLng(latitude, longitude));
      requestAppointmentTimeDistance();
      _isWorkerReady = true;
    }
  }


}

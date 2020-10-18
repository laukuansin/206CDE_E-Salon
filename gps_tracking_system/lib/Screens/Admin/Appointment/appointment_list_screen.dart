import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Components/custom_table_calendar.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/appointment.dart';
import 'package:gps_tracking_system/Model/logged_user.dart';
import 'package:gps_tracking_system/Utility/RestApi/appointment_list_response.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/Utility/map_helper.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentListScreen> {
  final Map<DateTime, List<Appointment>> appointmentList = {};
  final Map<String, Map<String, int>> appointmentRouteTimeDistance = {};

  String appBarTitle = "";
  Map<DateTime, List<Appointment>> appointmentSelected = {};

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return RouteGenerator.buildScaffold(
        Container(
          margin: EdgeInsets.only(top: 10),
            color: primaryBgColor,
            width: screenSize.width,
            height: screenSize.height,
            child: Column(children: [
              _buildAppointmentTracking(context),
              Expanded(child: _buildAppointmentListByDate()),
            ])),
        appbar: AppBar(
          backgroundColor: Color(0xFF65CBF2),
          elevation: 0,
          title: Text(
            appBarTitle,
            style: TextStyleFactory.heading5(color: primaryLightColor),
          ),
          iconTheme: IconThemeData(
              color: primaryLightColor
          ),
        ), drawer:RouteGenerator.buildDrawer(context)
    );
  }

  @override
  void initState() {
    super.initState();
    requestAppointmentList();
  }

  void requestAppointmentList() async {
    AppointmentListResponse result = await RestApi.admin.getAcceptedAppointmentList();

    if (result.response.status == 1) {
      for (Appointment appointment in result.appointments) {
        String dateString = appointment.getAppointmentDateStringYYYYMMDD();
        DateTime key = DateFormat("yyyy-MM-dd").parse(dateString);

        if (!appointmentList.containsKey(key)) appointmentList[key] = [];
        if(appointment.status != Status.REJECTED)
          appointmentList[key].add(appointment);
      }

      setState(() {});
      requestAppointmentTimeDistance();
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', ModalRoute.withName("/login"));
    }
  }

  void requestAppointmentTimeDistance() async {
    LatLng origin = MapHelper.positionToLatLng(await getCurrentPosition());
    appointmentList.forEach((date, list) async {
      for (Appointment appointment in list) {
        if(LoggedUser.getRole() == Role.OWNER && appointment.status != Status.ONGOING) continue;
        LatLng destination =
            await MapHelper.addressToLatLng(appointment.address);
        Map<String, int> timeDistanceMap =
            await MapHelper.getRouteTimeDistance([origin, destination]);
        appointmentRouteTimeDistance[appointment.appointmentId] =
            timeDistanceMap;
        setState(() {});
      }
    });
  }

  Card _buildAppointmentCard(Appointment appointment) {
    String timeTaken = appointmentRouteTimeDistance
            .containsKey(appointment.appointmentId)
        ? MapHelper.getTotalDistanceDurationString(
            appointmentRouteTimeDistance[appointment.appointmentId]['duration'],
            appointmentRouteTimeDistance[appointment.appointmentId]['distance'])
        : "";

    return Card(
        elevation: 0,
        margin: EdgeInsets.only(bottom: 1),
        color: primaryLightColor,
        shape: RoundedRectangleBorder(),
        child: Column(children: <Widget>[
          ListTile(
            leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(appointment.getAppointmentDateStringJM())
                ]),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            title: Text(
              appointment.customerName,
            ),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    appointment.address,
                    overflow: TextOverflow.ellipsis,
                  ),
                  () {
                    return timeTaken.isEmpty
                        ? (appointment.status == Status.ONGOING || LoggedUser.getRole() == Role.WORKER) ? SkeletonAnimation(
                            child: Container(
                              height: 15,
                              width: MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[300]),
                            ),
                          ) : Text("-")
                        : Text(timeTaken);
                  }()
                ]),
            trailing: _getStatusIcon(appointment.status),
            onTap: () {
              Navigator.of(context)
                  .pushNamed("/appointment_info", arguments: appointment).then((_){setState(() {

                  });} );
            },
          )
        ]));
  }

  Icon _getStatusIcon(Status status){
    switch(status) {
      case Status.ACCEPTED:
        return Icon(Icons.access_alarm, color: Colors.amber);
      case Status.CANCELLED:
        return Icon(Icons.cancel, color: Colors.redAccent);
      case Status.CLOSE:
        return Icon(Icons.done, color: Colors.greenAccent);
      case Status.ONGOING:
        return Icon(Icons.directions_car, color: primaryColor,);
    }
  }

  Container _buildAppointmentListByDate() {
    if (appointmentSelected.length == 0) return Container();

    DateTime selectedDay = appointmentSelected.keys.elementAt(0);
    if (appointmentSelected[selectedDay].length == 0)
      return Container(
          margin: EdgeInsets.only(top: 10),
          child: Text(
            "No appointment on selected day.",
            style: TextStyleFactory.p(),
          ));

    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  Appointment.convertAppointmentDateStringEMMMDD(selectedDay),
                  style: TextStyleFactory.p(color: primaryTextColor),
                )),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: appointmentSelected[selectedDay].length,
              itemBuilder: (BuildContext context, int index) {
                return _buildAppointmentCard(
                    appointmentSelected[selectedDay][index]);
              },
            )
          ],
    ));
  }

  Container _buildAppointmentTracking(BuildContext context) {
    double progress = -1;
    int totalDone = 0;
    int totalTask = 0;
    if(appointmentSelected.length > 0) {
      DateTime selectedDate = appointmentSelected.keys.elementAt(0);
      if (appointmentSelected[selectedDate].length > 0) {
        for (Appointment appointment in appointmentSelected[selectedDate]) {
          if (appointment.status == Status.CANCELLED ||
              appointment.status == Status.REJECTED) continue;
          if (appointment.status == Status.ONGOING ||
              appointment.status == Status.ACCEPTED) {
            totalTask += 1;
          }
          else if (appointment.status == Status.CLOSE) {
            totalDone += 1;
            totalTask += 1;
          }
          progress = totalDone / totalTask;
        }
      }
    }

    return Container(
        color: primaryLightColor,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: CustomTableCalendar(
                    onDaySelectedCallBack: onDaySelectedCallBack,
                    onCalendarCreatedCallBack: onCalendarCreated,
                    onVisibleDayChangedCallBack: onVisibleDayChanged,
                    event: appointmentList,
                    holiday: Map<DateTime, List>()),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Appointments tracking",
                  style: TextStyleFactory.heading6(),
                ),
              ),
              Container(
                  alignment: Alignment.centerRight,
                  child: Row(children: [
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: LinearPercentIndicator(
                              animation: true,
                              lineHeight: 20.0,
                              animationDuration: 2500,
                              percent: progress >= 0 ? progress : 1,
                              center: Text(
                                progress >= 0 ? "$totalDone / $totalTask" : "\u{221E} / \u{221E}",
                                style:
                                    TextStyleFactory.p(color: primaryTextColor),
                              ),
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              progressColor: Colors.greenAccent,
                            ))),
                    Container(
                        child: IconButton(
                          icon: Icon(Icons.chrome_reader_mode, color: Colors.green),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              "/today_appointment", arguments: appointmentSelected
                        );
                      },
                    ))
                  ]))
            ]));
  }

  void onDaySelectedCallBack(DateTime day, List events) {
    setState(() {
      appointmentSelected.clear();
      appBarTitle = Appointment.convertAppointmentDateStringMonthYear(day);
      DateTime selectedDay = Appointment.dateMonthYearFormatter
          .parse(Appointment.convertAppointmentDateStringDateMonthYear(day));
      (events.length > 0)
          ? appointmentSelected[selectedDay] = events
          : appointmentSelected[selectedDay] = [];
    });
  }

  void onCalendarCreated(
      DateTime first, DateTime last, CalendarController controller) {
    final DateFormat dateFormatter = DateFormat("MMMM yyyy");
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      appBarTitle = dateFormatter.format(first);
      setState(() {
        DateTime today = Appointment.dateMonthYearFormatter.parse(
            Appointment.convertAppointmentDateStringDateMonthYear(
                DateTime.now()));
        appointmentSelected[today] = appointmentList.containsKey(today) ? appointmentList[today] : [];
      });
    });
  }

  void onVisibleDayChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    final DateFormat dateFormatter = DateFormat("MMMM yyyy");
    setState(() {
      appBarTitle = dateFormatter.format(first);
    });
  }
}

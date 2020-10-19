import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/rating_dialog.dart';
import 'package:gps_tracking_system/Components/rounded_button.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/appointment.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/common_appointment_list_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/common_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/get_worker_detail_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/Utility/RestApi/user_get_customer_credit_response.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class HomePageScreen extends StatefulWidget {
  @override
  HomePageScreenState createState() => HomePageScreenState();
}

class HomePageScreenState extends State<HomePageScreen> {
  double creditAmount;
  FToast fToast;
  List<Appointment> _appointmentList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    creditAmount = 0.0;
    requestAppointmentList();
    requestCurrentCustomerCredit();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return RouteGenerator.buildScaffold(Container(
      key: _scaffoldKey,
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
            color: primaryDeepLightColor,
            image: DecorationImage(
                image: AssetImage("assets/images/home_background.png"),
                fit: BoxFit.fill)),
        child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Credit Balance",
                    style: TextStyleFactory.heading4(
                        color: primaryLightColor,
                        fontWeight: FontWeight.normal)),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Text("RM $creditAmount",
                              style: TextStyleFactory.heading1(
                                  fontSize: 30, color: primaryLightColor))),
                      RawMaterialButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed("/account_page");
                          },
                          fillColor: primaryLightColor,
                          child: Icon(
                            Icons.person_outline,
                            size: 30.0,
                            color: primaryColor,
                          ),
                          padding: EdgeInsets.all(10.0),
                          shape: CircleBorder())
                    ],
                  ),
                ),
                Padding(
                    child: _buildReloadCreditButton(context),
                    padding: EdgeInsets.only(top: 5)),
                Padding(
                    child: _buildPayAppointmentCard(context),
                    padding: EdgeInsets.only(top: 5)),
                Padding(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text("Appointment",
                            style: TextStyleFactory.heading3(
                                fontWeight: FontWeight.w600)),
                      ),
                      IconButton(
                        color: primaryLightColor,
                        icon: Icon(
                          Icons.notifications,
                          color: primaryColor,
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed("/my_appointments");
                        },
                      )
                    ],
                  ),
                  padding: EdgeInsets.only(top: 5),
                ),
                () {
                  return _appointmentList.length > 0
                      ? Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _appointmentList.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: _appointmentList[index].status ==
                                              Status.ONGOING
                                          ? BorderSide(
                                              color: Colors.amber, width: 3)
                                          : BorderSide(
                                              color: primaryDeepLightColor)),
                                  elevation: 0,
                                  child: Padding(
                                    child: ListTile(
                                      leading: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              _appointmentList[index]
                                                  .getAppointmentDateStringDD(),
                                              style: TextStyleFactory.heading1(
                                                  color: dateColor)),
                                          Text(
                                              _appointmentList[index]
                                                  .getAppointmentDateStringMMM(),
                                              style: TextStyleFactory.p())
                                        ],
                                      ),
                                      title: Text(
                                          _appointmentList[index].workerName),
                                      subtitle: Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: RatingBar(
                                            ignoreGestures: true,
                                            initialRating: 3,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemSize: 20,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 1.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (double value) {},
                                          )),
                                      trailing: CircleAvatar(
                                        radius: 30.0,
                                        backgroundImage: NetworkImage(
                                            _appointmentList[index]
                                                .workerImage),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed("/appointment_info",
                                                arguments:
                                                    _appointmentList[index])
                                            .then((_) {
                                          setState(() {
                                            requestAppointmentList();
                                          });
                                        });
                                      },
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                );
                              }),
                        )
                      : Text(
                          "No appointment",
                          style: TextStyleFactory.p(),
                        );
                }()
              ],
            ))));
  }

  RoundedButton _buildReloadCreditButton(BuildContext context) {
    return RoundedButton(
      press: () {
        Navigator.of(context).pushNamed("/top_up").then((_) {
          requestCurrentCustomerCredit();
        });
      },
      text: "+ Reload Credit",
      horizontalPadding: 25,
      verticalPadding: 15,
      fontSize: 12,
      color: primaryLightColor,
      textColor: primaryTextColor,
    );
  }

  Card _buildPayAppointmentCard(BuildContext context) {
    return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          child: Row(
            children: <Widget>[
              Expanded(
                  child: RaisedButton(
                elevation: 0,
                color: primaryLightColor,
                child: Column(
                  children: [
                    Icon(
                      MdiIcons.qrcode,
                      color: primaryColor,
                      size: 40,
                    ),
                    Text(
                      "Pay",
                      style: TextStyleFactory.p(),
                    )
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed("/qr_code").then((value) {
                    if(value is Worker) {
                      _showRatingDialog(value);
                      requestCurrentCustomerCredit();
                      requestAppointmentList();
                    }
                  });
                },
              )),
              Expanded(
                child: RaisedButton(
                  elevation: 0,
                  color: primaryLightColor,
                  child: Column(
                    children: [
                      Icon(
                        MdiIcons.calendarPlus,
                        color: primaryColor,
                        size: 40,
                      ),
                      Text(
                        "Appointment",
                        style: TextStyleFactory.p(),
                      )
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/choose_service");
                  },
                ),
              )
            ],
          ),
          padding: EdgeInsets.all(10),
        ));
  }

  Widget statusWidget(Status status) {
    Color color;
    IconData icon;
    if (status == Status.ACCEPTED) {
      color = Colors.greenAccent;
      icon = Icons.done;
    } else if (status == Status.REJECTED) {
      color = Colors.red;
      icon = Icons.close;
    } else if (status == Status.PENDING) {
      color = Colors.yellowAccent[700];
      icon = MdiIcons.loading;
    } else if (status == Status.CLOSE) {
      color = Colors.green;
      icon = Icons.done;
    } else if (status == Status.CANCELLED) {
      color = Colors.red;
      icon = Icons.close;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: color,
        ),
        Text(status.toString().split('.').last,
            style: TextStyleFactory.p(color: color))
      ],
    );
  }

  void requestCurrentCustomerCredit() async {
    CustomerCreditResponse result =
        await RestApi.customer.getCustomerCreditToken();

    if (result.response.status == 1) {
      setState(() {
        creditAmount = result.credit;
      });
    } else {
      creditAmount = 0.0;
      fToast.showToast(
          child: ToastWidget(
        status: result.response.status,
        msg: result.response.msg,
      ));
    }
  }

  void requestAppointmentList() async {
    AppointmentListResponse result =
        await RestApi.customer.getAcceptedAppointmentList();

    if (result.response.status == 1) {
      setState(() {
        _appointmentList = result.appointments;
      });
    } else {
      _appointmentList = null;
      fToast.showToast(
          child: ToastWidget(
        status: result.response.status,
        msg: result.response.msg,
      ));
    }
  }

  void _showRatingDialog(Worker worker) {
    // We use the built in showDialog function to show our Rating Dialog
    showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) {
          return RatingDialog(
            icon: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(
                  worker.profileImage),
              backgroundColor: Colors.transparent,
            ),
            // set your own image/icon widget
            title: worker.name,
            description: "Please rate my service",
            submitButton: "SUBMIT",
            // optional
            accentColor: primaryColor,
            // optional
            onSubmitPressed: (Rating rating) {
              requestSubmitRating(rating, worker.workerId);
            },
          );
        });
  }

  void requestSubmitRating(Rating rating, String workerId) async {
    CommonResponse result = await RestApi.customer.submitRating(workerId, rating);
    fToast.init(_scaffoldKey.currentContext);
    fToast.showToast(
        child: ToastWidget(
      status: result.response.status,
      msg: result.response.msg,
    ));
  }
}

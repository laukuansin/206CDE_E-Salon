import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Components/rating_dialog.dart';
import 'package:gps_tracking_system/Components/rounded_button.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/common_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/get_worker_detail_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/toast_widget';


class RatingPageScreen extends StatefulWidget {
  @override
  RatingPageScreenState createState() => RatingPageScreenState();
}

class RatingPageScreenState extends State<RatingPageScreen> {
  int workerID;
  String name,profileImg;
  FToast fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
    requestWorkerDetail();
  }

  void requestWorkerDetail()async
  {
    GetWorkerDetailResponse result = await RestApi.customer.getWorkerDetail("2");

    if (result.response.status == 1) {
      setState(() {
        name=result.worker.name;
        profileImg=result.worker.profileImage;
      });
    } else {
      fToast.showToast(
          child: ToastWidget(
            status: result.response.status,
            msg: result.response.msg,
          ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return RouteGenerator.buildScaffold(
      Container(
        child: RoundedButton(
          press: () {
            _showRatingDialog();
          },
          text: "show rating",
          horizontalPadding: 25,
          verticalPadding: 15,
          fontSize: 12,
          color: primaryLightColor,
          textColor: primaryTextColor,
        ),
      ),
      appbar: AppBar(
          elevation: 2,
          title: Text(
            "Rating",
            style: TextStyleFactory.p(color: primaryTextColor),
          )
      )
    );
  }
  void _showRatingDialog() {
    // We use the built in showDialog function to show our Rating Dialog
    showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) {
          return RatingDialog(
            icon: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(
                  "http://192.168.8.103/image/cache/catalog/profile-pic-250x250.png"),
              backgroundColor: Colors.transparent,
            ), // set your own image/icon widget
            title: name,
            description:
            "Please rate my service",
            submitButton: "SUBMIT", // optional
            accentColor: primaryColor, // optional
            onSubmitPressed: (Rating rating) {
                submitRating(rating);
              // TODO: open the app's page on Google Play / Apple App Store
            },
          );
        });
  }
  void submitRating(Rating rating)async
  {
    CommonResponse result=await RestApi.customer.submitRating("2",rating);

    fToast.showToast(
        child: ToastWidget(
          status: result.response.status,
          msg: result.response.msg,
        ));


  }



}

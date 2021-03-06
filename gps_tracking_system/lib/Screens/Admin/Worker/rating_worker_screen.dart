import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/admin.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/admin_get_worker_rating_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';

class RatingWorkerScreen extends StatefulWidget {
  final Admin user;

  @override
  State<StatefulWidget> createState() => RatingWorkerScreenState(user);

  RatingWorkerScreen(this.user);
}

class RatingWorkerScreenState extends State<RatingWorkerScreen> {
  Admin user;
  List<RatingList> _ratingReviewList = [];
  double averageRating = 0;
  FToast fToast;

  RatingWorkerScreenState(this.user);

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    requestWorkerRating();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RouteGenerator.buildScaffold(
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        side: BorderSide(color: primaryDeepLightColor)),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              child: Text(user.firstName + " " + user.lastName,
                                  style: TextStyleFactory.p(
                                    fontWeight: FontWeight.bold,
                                  )),
                              padding: EdgeInsets.only(bottom: 10)),
                          RatingBar(
                            ignoreGestures: true,
                            initialRating: averageRating,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20,
                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (double value) {},
                          )
                        ],
                      ),
                      leading: CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(user.image),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    // padding: EdgeInsets.all(10),
                  ),
                  padding: EdgeInsets.all(16)),
              Padding(
                child: Text(
                  "Ratings",
                  style: TextStyleFactory.p(),
                  textAlign: TextAlign.end,
                ),
                padding: EdgeInsets.only(left: 16),
              ),
              () {
                return _ratingReviewList.length > 0
                    ? Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _ratingReviewList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(_ratingReviewList[index]
                                            .customerName),
                                        RatingBar(
                                          ignoreGestures: true,
                                          initialRating:
                                              _ratingReviewList[index]
                                                  .rating
                                                  .toDouble(),
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
                                        ),
                                        Padding(
                                          child: Text("Review: " +
                                              _ratingReviewList[index].review),
                                          padding: EdgeInsets.only(top: 10),
                                        )
                                      ],
                                    ),
                                  ),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      side: BorderSide(
                                          color: primaryDeepLightColor)));
                            }),
                      )
                    :  Container(margin: EdgeInsets.symmetric(horizontal: 16), child:Text(
                        "No review available",
                        style: TextStyleFactory.p(),
                      ));
              }()
            ],
          ),
        ),
        appbar: AppBar(
          backgroundColor: Color(0xFF65CBF2),
          elevation: 0,
          title: Text(
            "Rating",
            style: TextStyleFactory.heading5(color: primaryLightColor),
          ),
          iconTheme: IconThemeData(color: primaryLightColor),
        ));
  }

  void requestWorkerRating() async {
    GetWorkerRatingResponse result =
        await RestApi.admin.getWorkerRating(user.id);

    if (result.response.status == 1) {
      setState(() {
        _ratingReviewList = result.ratingList;
        averageRating = result.averageRating;
      });
    } else {
      _ratingReviewList = [];
      averageRating = 0.0;
      fToast.showToast(
          child: ToastWidget(
        status: result.response.status,
        msg: result.response.msg,
      ));
    }
  }
}

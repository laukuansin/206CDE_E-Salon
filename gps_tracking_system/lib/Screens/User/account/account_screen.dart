import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/color.dart';


class AccountScreen extends StatefulWidget {
  @override
  AccountScreenState createState() => AccountScreenState();
}
class AccountScreenState extends State<AccountScreen> {
  FToast fToast;
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return RouteGenerator.buildScaffold(Container(

    ),appbar: AppBar(title: Text(
      "Account",
      style: TextStyleFactory.p(color: primaryTextColor),
    ),));
  }
}
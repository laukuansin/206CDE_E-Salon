import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/color.dart';

class HomePageScreen extends StatefulWidget {
  @override
  HomePageScreenState createState() => HomePageScreenState();
}

class HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return RouteGenerator.buildAdminScaffold(
      Container(
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

          ),
        ),
      ),true,
      context,
      appbar: AppBar(
        title: Text(
          "Home Page",
          style: TextStyleFactory.p(color: primaryTextColor),
        )
      )
    );
  }

}
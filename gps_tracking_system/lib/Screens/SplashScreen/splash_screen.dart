import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gps_tracking_system/color.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // Redirect to login after 1 second
    Timer(Duration(seconds: 1), (){
      Navigator.of(context).pushReplacementNamed("/addworker");
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color : primaryLightColor,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/ebox_logo.png",
            height: size.width * 0.2,
            width:  size.width * 0.2,
          ),

          Text(
            "eBox",
            style: TextStyle(
              color: primaryColor,
              fontSize: 30
            ),
          )
        ]
      ),
    );
  }
}

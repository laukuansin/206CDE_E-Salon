import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Model/User.dart';
import 'font.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User.authenticate("Whatever", "Whatever");
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      theme: ThemeData(
        fontFamily: mainFont
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/mapDebug",
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}


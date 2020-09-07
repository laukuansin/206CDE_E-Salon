import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gps_tracking_system/Screens/GoogleMap/googlemap_screen.dart';
import 'package:gps_tracking_system/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Position customerAddress = new Position(
      latitude: 5.341860,
      longitude: 100.281946
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: GoogleMapScreen(
          destination:customerAddress
        )
    );
  }
}

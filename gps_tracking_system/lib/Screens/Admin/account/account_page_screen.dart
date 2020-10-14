import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';

class AccountPageScreen extends StatefulWidget {
  @override
  AccountPageScreenState createState() => AccountPageScreenState();
}

class AccountPageScreenState extends State<AccountPageScreen> {
  @override
  Widget build(BuildContext context) {
   return RouteGenerator.buildAdminScaffold(widget,
       true,
       context,
       appbar: AppBar(

       ));
  }

}
import 'package:flutter/material.dart';
import 'package:gps_tracking_system/color.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key key,
    this.child
  }) : super();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding:EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width:size.width * 0.8,
      decoration: BoxDecoration(
        color:primaryLightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}

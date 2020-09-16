import 'package:flutter/material.dart';
import 'package:gps_tracking_system/color.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double fontSize;
  final double verticalPadding, horizontalPadding;
  const RoundedButton({
    Key key,
    this.text,
    this.press,
    this.color = primaryColor,
    this.textColor = Colors.white,
    this.fontSize = 20,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
        child: FlatButton(
            padding: EdgeInsets.symmetric(
                vertical: verticalPadding,
                horizontal: horizontalPadding
            ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19.0)
          ),
            color:color,
            onPressed: press,
            child:Text(
                text,
                style:TextStyle(
                    fontSize: fontSize,
                    color:textColor
                )
            )
        ),
    );
  }
}
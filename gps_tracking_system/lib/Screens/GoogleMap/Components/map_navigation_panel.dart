import 'package:flutter/material.dart';
import 'package:gps_tracking_system/components/rounded_button.dart';
import 'package:gps_tracking_system/color.dart';

class MapNavigationPanel extends StatelessWidget {
  const MapNavigationPanel({
    Key key,
    @required this.bottomBarSize,
    @required String totalDistance,
    @required String totalDuration,
    @required RoundedButton navigationButton,
  }) : totalDistance = totalDistance,
        totalDuration = totalDuration,
        navigationButton = navigationButton,
        super(key: key);

  final Size bottomBarSize;
  final String totalDistance;
  final String totalDuration;
  final RoundedButton navigationButton;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: bottomBarSize.width,
        height: bottomBarSize.height,
        decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            color:Colors.white.withOpacity(0.9),
            borderRadius:BorderRadius.circular(10)
        ),
        child:Stack(
          children: <Widget>[
            Positioned(
              left:bottomBarSize.width * 0.05,
              top:bottomBarSize.height * 0.2,
              child:Row(
                children: <Widget>[
                  Text(
                    totalDuration,
                    style: TextStyle(
                      fontSize: 20,
                      color: primaryColor,
                    ),
                  ),

                  Text(
                    "("+ totalDistance+")",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueGrey,
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                bottom:0,
                left:bottomBarSize.width * 0.05,
                child:navigationButton
            )
          ],
        )
    );
  }
}
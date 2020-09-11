import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Screens/Login/login_screen.dart';
import 'package:gps_tracking_system/Screens/Welcome/Components/background.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gps_tracking_system/components/rounded_button.dart';
import 'package:gps_tracking_system/constants.dart';

import 'background.dart';

class Body extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;// total width and height of screen
    return Background(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("WELCOME TO EDU",
                style: TextStyle(
                    fontWeight:FontWeight.bold
                )
            ),

            SizedBox(height: size.height * 0.03,),

            SvgPicture.asset(
                'assets/icons/chat.svg',
                height:size.height * 0.5
            ),
            SizedBox(height: size.height * 0.03,),
            RoundedButton(
              text: "LOGIN",
              press: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context){
                        return LoginScreen();
                      }
                    ),
                );
              },
            ),
            RoundedButton(
              text:"SIGN UP",
              color:kPrimaryLightColor,
              textColor: Colors.black,
              press:(){}
            )
          ],
      )
    );
  }

}

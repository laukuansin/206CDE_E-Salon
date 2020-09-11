import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gps_tracking_system/Screens/Login/Components/background.dart';
import 'package:gps_tracking_system/components/rounded_button.dart';
import 'package:gps_tracking_system/components/rounded_input_field.dart';
import 'package:gps_tracking_system/components/rounded_password_field.dart';


class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SvgPicture.asset("assets/icons/login.svg",
              height: size.height * 0.35,

            ),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value){},
            ),
            RoundedPasswordField(
              onChanged: (value){},
            ),
            RoundedButton(
              text:"LOGIN"
                  ,press: (){},
            )
          ],
        )
    );
  }
}

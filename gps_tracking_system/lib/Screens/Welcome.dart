import 'package:flutter/material.dart';
import 'package:gps_tracking_system/color.dart';
import 'Login.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color : primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(
                          top: 100
                      ),
                      child: Text(
                        "Welcome to",
                        style: TextStyle(
                            color: darkBlue,
                            fontSize: 18
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(28),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("GPS Live Tracking System!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color:  darkMagenta,
                            fontSize: 29
                        ),
                      ),
                    ),
                  ],
                )
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 32
              ),
              child: Center(
                child: Image.asset("assets/images/Welcome.jpg"),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage())
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(26),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: orangeRed,
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: Center(
                    child: Text(
                        "Login",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 20
                        )
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}
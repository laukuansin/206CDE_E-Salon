import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Nunito"
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: WelcomePage(),
        ),
      ),
    );
  }
}

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color : Colors.white,
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
                      color: Color(0xFFB40284A),
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
                        color:  Color(0xFFB8B008B),
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
                  color: Color(0xFFBFF4500),
                  borderRadius: BorderRadius.circular(50)
                ),
                child: Center(
                  child: Text(
                  "Login",
                    style: TextStyle(
                      color: Colors.white,
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

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            leading: BackButton(
                color: Colors.black
            ),
            backgroundColor: Colors.white,
            elevation: 0.0),
        body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                        top: 30
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Color(0xFFB00008B),
                          fontSize: 32
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Login to your account!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:  Color(0xFFBA9A9A9),
                          fontSize: 15
                      ),
                    ),
                  ),
                ],
              ),

            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 80
              ),
              child: Center(
                child: Image.asset("assets/images/Login.png"),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFBC7C7C7),
                  width: 2
                ),
                borderRadius: BorderRadius.circular(50)
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 80,
                    child: Icon(
                      Icons.email,
                      size: 20,
                      color: Color(0xFFBB9B9B9),
                    )
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 20),
                        border: InputBorder.none,
                        hintText: "Enter Email..."
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 5,
                left: 25,
                right: 25,
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color(0xFFBC7C7C7),
                      width: 2
                  ),
                  borderRadius: BorderRadius.circular(50)
              ),
              child: Row(
                children: <Widget>[
                  Container(
                      width: 80,
                      child: Icon(
                        Icons.lock,
                        size: 20,
                        color: Color(0xFFBB9B9B9),
                      )
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20),
                          border: InputBorder.none,
                          hintText: "Enter Password..."
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Container(
                margin: EdgeInsets.only(
                    top: 28,
                    left: 65,
                    right: 65),
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color(0xFFBFF4500),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Center(
                  child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      )
                  ),
                ),
              ),
            ),
          ],
        )
      )
    );
  }
}




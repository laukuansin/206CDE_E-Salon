import 'package:flutter/material.dart';
import '../color.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        appBar: AppBar(
            leading: BackButton(
                color: black
            ),
            backgroundColor: primaryColor,
            elevation: 0.0),
        body: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: bottom),
            reverse: true,
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
                              color: blue,
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
                              color:  lightGrey,
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
                          color: grey,
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
                            color: iconGrey,
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
                          color: grey,
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
                            color: iconGrey,
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
              ],
            )
        )
    );
  }
}
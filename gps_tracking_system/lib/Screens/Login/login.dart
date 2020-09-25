import 'package:flutter/material.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:gps_tracking_system/components/rounded_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _email;
  String _password;
  bool _isPasswordVisible;

  TextFormField _buildEmailTextFormField(){
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Email"
      ),
      validator: (email){
        return null;
        if(email.isEmpty){
          return "Email is required";
        }

        if(email == "a") {
          return null;
        }

        if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)){
          return "Invalid email";
        }

        return null;
      },
      onSaved: (email){
        _email = email;
      },
    );
  }

  TextFormField _buildPasswordTextFormField(){
    return TextFormField(
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
          labelText: "Password",
          suffixIcon: IconButton(
            icon: Icon(_isPasswordVisible?Icons.visibility: Icons.visibility_off),
            color:primaryColor,
            onPressed: (){
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          )
      ),
      validator: (password){
        return null;
        if(password.isEmpty){
          return "Password is required";
        }
        return null;
      },
      onSaved: (password){
        _password = password;
      },
    );
  }

  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryLightColor,
        body: SingleChildScrollView(
            reverse: true,
            child: Container(
              height:size.height,
              width:size.width,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/login_background_top.png",
                    width: size.width,
                  ),
                  SizedBox(height: size.height * 0.06),
                  Text(
                    "GPS Real Time Tracking System",
                    style: TextStyle(
                      fontSize: 18,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02,),
                  Container(
                      width: size.width,
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                      child:Form(
                          key:_formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _buildEmailTextFormField(),
                              _buildPasswordTextFormField(),
                              SizedBox(height: size.height * 0.05,),
                              RoundedButton(
                                text: "Login",
                                verticalPadding: 10,
                                horizontalPadding: 30,
                                press: (){
                                  if(!_formKey.currentState.validate()){
                                    return;
                                  }
                                  _formKey.currentState.save();
                                  Navigator.of(context).pushReplacementNamed("/appointmentList");
                                },
                              )
                            ],
                          )
                      )
                  )
                ],
              ),
            )
        )
    );
  }

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = false;
  }
}
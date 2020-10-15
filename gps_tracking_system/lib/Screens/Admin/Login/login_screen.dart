import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/logged_user.dart';
import 'package:gps_tracking_system/Utility/RestApi/admin_login_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:gps_tracking_system/Components/rounded_button.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FToast fToast;
  String _username;
  String _password;
  bool _isPasswordVisible;

  TextFormField _buildUsernameTextFormField(){
    return TextFormField(
      initialValue: 'admin',
      decoration: InputDecoration(
          labelText: "Username",
          labelStyle: TextStyleFactory.p()
      ),
      validator: (username) => username.isEmpty ? "Username is required" : null,
      onSaved: (username){_username = username;},
    );
  }

  TextFormField _buildPasswordTextFormField(){
    return TextFormField(
      initialValue: "123456",
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
          labelText: "Password",
          labelStyle: TextStyleFactory.p(),
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
      validator: (password) => password.isEmpty ? "Password is required" : null,
      onSaved: (password){_password = password;},
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
                    style: TextStyleFactory.heading4(color:primaryColor)
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
                              _buildUsernameTextFormField(),
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
                                  _login();
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

  void _login()async
  {
    final ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();

    LoginResponse result    = await RestApi.admin.login(_username, _password);
    progressDialog.hide();

    fToast.showToast(
        child: ToastWidget(status: result.response.status, msg: result.response.msg),
        toastDuration: Duration(seconds: 2),
        gravity: ToastGravity.BOTTOM);

    if(result.response.status == 1) {
      LoggedUser.createInstance(result.userToken,result.username, result.email, userImage: result.userImage ,userGroupId: result.userGroupId, );
      // Navigator.of(context).pushReplacementNamed("/appointment_list");
      Navigator.of(context).pushReplacementNamed("/home_page");
    }
  }

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = false;
    fToast = FToast();
    fToast.init(context);
  }
}
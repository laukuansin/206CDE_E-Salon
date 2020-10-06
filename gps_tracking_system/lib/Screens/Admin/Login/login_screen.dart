import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/user.dart';
import 'package:gps_tracking_system/Screens/Admin/Login/login_response.dart';
import 'package:gps_tracking_system/Utility/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:gps_tracking_system/Components/rounded_button.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FToast fToast;
  static const String APP_TOKEN="app-token";
  static const String USER_ID="user-id";


  String _username;
  String _password;
  bool _isPasswordVisible;

  TextFormField _buildUsernameTextFormField(){
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Username",
          labelStyle: TextStyleFactory.p()
      ),
      validator: (username){
        if(username.isEmpty){
          return "Username is required";
        }



        return null;
      },
      onSaved: (username){
        _username = username;
      },
    );
  }

  TextFormField _buildPasswordTextFormField(){
    return TextFormField(
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
      validator: (password){
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
                                  login(_username,_password);

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

  void login(String username,String password)async
  {
    final ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();

    LoginResponse result    = await RestApi.admin.login(username, password);
    progressDialog.hide();

    showToastMessage(result.response.status, result.response.msj);
    if(result.response.status == 1) {
      User.createInstance(result.userToken, Role.OWNER);
      Navigator.of(context).pushReplacementNamed("/appointmentList");
    }
  }

  void showToastMessage(int status, String msg) {
    Widget toast;
    if(status == 1) {
      toast = Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.greenAccent
          ),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check, color: Colors.white),
                SizedBox(width: 12.0),
                Expanded(
                    child: Text(msg,
                    style: TextStyleFactory.p(color: Colors.white)))
              ]
          )
      );
    }
    else {
       toast = Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0), color: Colors.red),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    msg,
                    style: TextStyleFactory.p(color: Colors.white))),
              ]
          )
       );
    }

    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        gravity: ToastGravity.BOTTOM);
  }

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = false;
    fToast = FToast();
    fToast.init(context);
  }
}
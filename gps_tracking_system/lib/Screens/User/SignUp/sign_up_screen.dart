import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/rounded_button.dart';
import 'package:gps_tracking_system/Factory/end_user_factory.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Utility/rest_api.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:gps_tracking_system/Model/end_user.dart';
import 'package:gps_tracking_system/Screens/User/SignUp/sign_up_response.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  EndUser _customer;
  String _errFirstname, _errLastname, _errEmail, _errTelephone, _errPassword, _errConfirm;
  FToast _fToast;


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return RouteGenerator.buildScaffold(
      Container(
        height: screenSize.height,
        width: screenSize.width,
        child:CustomPaint(
          painter: BackgroundSignUp(),
          child:SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    children: <Widget>[
                      _getHeader(),
                      _getForm(),
                      _getSignUp(),
                    ],
                  ),
                ),
              ],
            ),
          )
        )
      ),
      appbar: AppBar(
        backgroundColor: primaryLightColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: Navigator.of(context).pop,
        ),
      )
    );
  }

  _getSignUp() {
    return Align(
        alignment:Alignment.topLeft,
        child:RoundedButton(
          text: "Sign Up",
          verticalPadding: 10,
          horizontalPadding: 30,
          fontSize: 15,
          press: _register
        )
    );
  }

  InputDecoration getStandardInputDecoration(String label) =>
      InputDecoration(
        errorMaxLines: 2,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color:Colors.grey[300])),
          labelText: label,
          labelStyle: TextStyleFactory.p()
      );

  Form _getForm() {
    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 15,),
            TextFormField(decoration: getStandardInputDecoration("First Name"),initialValue: "Mr", onSaved: (value){_customer.firstName = value;}, validator: (_)=> _errFirstname.isEmpty? null : _errFirstname,),
            SizedBox(height: 15,),
            TextFormField(decoration: getStandardInputDecoration("Last name"), initialValue: "Nobody", onSaved: (value){_customer.lastName = value;}, validator: (_)=>_errLastname.isEmpty? null : _errLastname,),
            SizedBox(height: 15,),
            TextFormField(decoration: getStandardInputDecoration("Email"), initialValue: "mrnobody@gmail.com", onSaved: (value){_customer.email = value;}, validator: (_)=>_errEmail.isEmpty ? null : _errEmail),
            SizedBox(height: 15,),
            TextFormField(decoration: getStandardInputDecoration("Telephone"), initialValue: "0123456789", onSaved: (value){_customer.contactNo = value;}, validator: (_)=>_errTelephone.isEmpty? null: _errTelephone,),
            SizedBox(height: 15,),
            TextFormField(decoration: getStandardInputDecoration("Password"), initialValue: "123456", onSaved: (value){_customer.password = value;}, validator: (_)=>_errPassword.isEmpty? null : _errPassword,),
            SizedBox(height: 15,),
            TextFormField(decoration:getStandardInputDecoration("Password confirm"), initialValue: "123456", onSaved: (value){_customer.confirm = value;}, validator: (_)=>_errConfirm.isEmpty ? null: _errConfirm ),
            SizedBox(height: 25,)
          ],
        ),
      ),
    );
  }

  _getHeader() => Container(
      alignment: Alignment.bottomLeft,
      child: Text(
        'Create\nAccount',
        style: TextStyleFactory.heading1(fontSize: 30, color: primaryColor),
      ));

  @override
  void initState() {
    super.initState();
    _customer = EndUserFactory.createInstance(EndUserType.CUSTOMER);
    _fToast = FToast();
    _fToast.init(context);
    _clearErrorMessage();
  }

  void _clearErrorMessage(){
    _errFirstname =  _errLastname = _errEmail =  _errTelephone =  _errPassword = _errConfirm = "";
  }

  void _register() async {
    final ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();

    _formKey.currentState.save();
    SignUpResponse result = await RestApi.customer.signUp(_customer);
    progressDialog.hide();
    _clearErrorMessage();

    log(result.response.status.toString());
    if(result.response.status ==1)
    {
      _fToast.showToast(
          child: ToastWidget(status: result.response.status, msg: result.response.msg),
          toastDuration: Duration(seconds: 2),
          gravity: ToastGravity.BOTTOM);
      Navigator.of(context).pop();
    }
    else{
      _errEmail     = result.error.email;
      _errFirstname = result.error.firstname;
      _errLastname  = result.error.lastname;
      _errConfirm   = result.error.confirm;
      _errPassword  = result.error.password;
      _errTelephone = result.error.telephone;
      _formKey.currentState.validate();
    }
  }
}


class BackgroundSignUp extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var sw = size.width;
    var sh = size.height;
    var paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, sw, sh));
    paint.color = primaryColor;
    canvas.drawPath(mainBackground, paint);

    Path blueWave = Path();
    blueWave.lineTo(sw, 0);
    blueWave.lineTo(sw, sh * 0.65);
    blueWave.cubicTo(sw * 0.8, sh * 0.8, sw * 0.55, sh * 0.8, sw * 0.45, sh);
    blueWave.lineTo(0, sh);
    blueWave.close();
    paint.color = primaryLightColor;
    canvas.drawPath(blueWave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
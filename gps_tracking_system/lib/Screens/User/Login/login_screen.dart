import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/rounded_button.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/logged_user.dart';
import 'package:gps_tracking_system/Utility/RestApi/user_login_response.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FToast fToast;
  String _email;
  String _password;
  String _apiKey;
  bool _isPasswordVisible;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextFormField _buildEmailTextFormField() {
    return TextFormField(
      decoration:
          InputDecoration(labelText: "Email", labelStyle: TextStyleFactory.p()),
      validator: (email) => email.isEmpty ? "Email is required" : null,
      onSaved: (email) {
        _email = email;
      },
    );
  }

  TextFormField _buildPasswordTextFormField() {
    return TextFormField(
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
          labelText: "Password",
          labelStyle: TextStyleFactory.p(),
          suffixIcon: IconButton(
            icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off),
            color: primaryColor,
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          )),
      validator: (password) => password.isEmpty ? "Password is required" : null,
      onSaved: (password) {
        _password = password;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return RouteGenerator.buildScaffold(Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
            child: Container(
                height: size.height,
                width: size.width,
                child: Column(
                  children: [
                    Expanded(
                      flex: 9,
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/login_background_top.png",
                            width: size.width,
                          ),
                          SizedBox(height: size.height * 0.06),
                          Text("GPS Real Time Tracking System",
                              style: TextStyleFactory.heading4(
                                  color: primaryColor)),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Container(
                              width: size.width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.15),
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      _buildEmailTextFormField(),
                                      _buildPasswordTextFormField(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      RoundedButton(
                                        text: "Login",
                                        verticalPadding: 10,
                                        horizontalPadding: 30,
                                        fontSize: 17,
                                        press: () {
                                          if (!_formKey.currentState.validate())
                                            return;
                                          _formKey.currentState.save();
                                          _login();
                                        },
                                      ),
                                    ],
                                  ))),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: RichText(
                        text: TextSpan(style: TextStyleFactory.p(), children: <
                            TextSpan>[
                          TextSpan(text: "Don't have an account? "),
                          TextSpan(
                              text: "Sign up now.",
                              style: TextStyleFactory.p(color: primaryColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushNamed("/sign_up");
                                })
                        ]),
                      ),
                    )
                  ],
                )))
    ), key: _scaffoldKey
    );
  }

  void _login() async {
    final ProgressDialog progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();


    LoginResponse result;

    if(_apiKey.isNotEmpty)
      result = await RestApi.customer.loginByApiKey(_apiKey);
    else
      result = await RestApi.customer.login(_email, _password);
    await progressDialog.hide();

    fToast.init(_scaffoldKey.currentContext);
    fToast.showToast(
        child: ToastWidget(
            status: result.response.status, msg: result.response.msg),
        toastDuration: Duration(seconds: 2),
        gravity: ToastGravity.BOTTOM);

    if (result.response.status == 1) {
      await LoggedUser.createInstance(result.token,result.username, result.email);
      Navigator.of(context).pushReplacementNamed("/rating");
    } else {
      _apiKey = "";
    }
  }

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = false;
    fToast = FToast();
    fToast.init(_scaffoldKey.currentContext);
    autoLogin();
  }

  void autoLogin()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _apiKey =  prefs.getString("api_key") ?? "";
    if(_apiKey.isNotEmpty) _login();
  }
}

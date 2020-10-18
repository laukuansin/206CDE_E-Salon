import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/common_change_password_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ChangePasswordPageScreen extends StatefulWidget {
  @override
  ChangePasswordPageScreenState createState() => ChangePasswordPageScreenState();
}

class ChangePasswordPageScreenState extends State<ChangePasswordPageScreen> {
  FToast fToast;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String oldPassword="",newPassword="",confirmPassword="";
  String _errOldPassword, _errNewPassword, _errConfirmPassword;
  bool _hiddenNewPassword, _hiddenConfirmPassword,_hiddenOldPassword;

  @override
  Widget build(BuildContext context) {
    return RouteGenerator.buildScaffold(
        SingleChildScrollView(
            child: Container(
                color:primaryLightColor,
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      _buildInputRow(_buildOldPassword()),
                      _buildInputRow(_buildNewPassword()),
                      _buildInputRow(_buildConfirmPassword(), isLast: true)
                    ]
                    )
                )

            )
        )
        , appbar: AppBar(
            title: Text(
              "Change Password",
              style: TextStyleFactory.p(color: primaryTextColor),
            ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: changePassword,
                  child: Icon(
                    Icons.check,
                    color: primaryColor,
                  ),
                )
            )
          ]
        ));
  }
  void changePassword()async{
    final ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();

    _formKey.currentState.save();
    ChangePasswordResponse result = await RestApi.admin.changeUserPassword(oldPassword, newPassword, confirmPassword);
    progressDialog.hide();
    clearErrorMessage();

    if(result.response.status ==1)
    {
      Navigator.of(context).pop();
      fToast.showToast(
          child: ToastWidget(status: result.response.status, msg: result.response.msg),
          toastDuration: Duration(seconds: 2),
          gravity: ToastGravity.BOTTOM);
    }
    else{
      _errConfirmPassword   = result.error.confirm;
      _errOldPassword  = result.error.oldPassword;
      _errNewPassword  = result.error.newPassword;
      _formKey.currentState.validate();
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
    clearErrorMessage();
  }

  void clearErrorMessage(){_errNewPassword = _errConfirmPassword = _errOldPassword= "";_hiddenNewPassword = _hiddenOldPassword = _hiddenConfirmPassword = true;}

  Column _buildInputRow(Widget input, {isLast = false}){
    return Column(
      children: <Widget>[
        ListTile(
          title:input,
        ),
        SizedBox(height: 5,),
        (
                (){
              if(!isLast){
                return Divider(
                  color:primaryDeepLightColor,
                  thickness: 0.5,
                );
              }
              return SizedBox(height: 10,);
            }()
        ),
      ],
    );
  }

  TextFormField _buildNewPassword() {
    return TextFormField(
      validator: (_) => _errNewPassword.isEmpty ? null : _errNewPassword,
      obscureText: _hiddenNewPassword,
      style: TextStyleFactory.p(color: primaryTextColor),
      decoration: new InputDecoration(
        icon: Icon(Icons.lock, color: primaryColor,),
        labelText: "New Password",
        suffixIcon: IconButton(
          onPressed: (){setState(() {_hiddenNewPassword = !_hiddenNewPassword;});},
          icon: _hiddenNewPassword ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
        ),
        labelStyle: TextStyleFactory.p(),
      ),
      onSaved: (value) {newPassword = value;},
    );
  }

  TextFormField _buildOldPassword() {
    return TextFormField(
      validator: (_) => _errOldPassword.isEmpty ? null : _errOldPassword,
      obscureText: _hiddenOldPassword,
      style: TextStyleFactory.p(color: primaryTextColor),
      decoration: new InputDecoration(
        icon: Icon(Icons.lock, color: primaryColor,),
        labelText: "Old Password",
        suffixIcon: IconButton(
          onPressed: (){setState(() {_hiddenOldPassword = !_hiddenOldPassword;});},
          icon: _hiddenOldPassword ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
        ),
        labelStyle: TextStyleFactory.p(),
      ),
      onSaved: (value) {oldPassword = value;},
    );
  }

  TextFormField _buildConfirmPassword() {
    return TextFormField(
      onSaved: (value) {confirmPassword = value;},
      validator: (_) => _errConfirmPassword.isEmpty? null : _errConfirmPassword,
      obscureText: _hiddenConfirmPassword,
      style: TextStyleFactory.p(color: primaryTextColor),
      decoration: new InputDecoration(
          icon: Icon(Icons.lock, color: primaryColor,),
          suffixIcon: IconButton(
            onPressed: (){setState(() {_hiddenConfirmPassword = !_hiddenConfirmPassword;});},
            icon: _hiddenConfirmPassword ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
          ),
          labelText: "Confirm Password",
          labelStyle: TextStyleFactory.p()
      ),
    );
  }
}
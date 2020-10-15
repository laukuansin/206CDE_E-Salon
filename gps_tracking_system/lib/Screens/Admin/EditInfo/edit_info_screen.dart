import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/image_picker.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/edit_user_info_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/Utility/RestApi/user_detail_response.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EditInfoPageScreen extends StatefulWidget {
  @override
  EditInfoPageScreenState createState() => EditInfoPageScreenState();
}

class EditInfoPageScreenState extends State<EditInfoPageScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _username = "", _firstName = "", _lastName = "", _email ="";
  String _errUsername, _errFirstname, _errLastname, _errEmail;
  FToast _fToast;

  @override
  Widget build(BuildContext context) {
    return RouteGenerator.buildScaffold(
        SingleChildScrollView(
            child: Container(
                color: primaryLightColor,
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      _buildInputRow(_buildUserName()),
                      _buildInputRow(_buildFirstName()),
                      _buildInputRow(_buildLastName()),
                      _buildInputRow(_buildEmail(),isLast: true),
                    ]
                    )
                )
            )
        ),
        appbar: AppBar(
            title: Text(
              "Edit Information",
              style: TextStyleFactory.p(color: primaryTextColor),
            ),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: editUser,
                    child: Icon(
                      Icons.check,
                      color: primaryColor,
                    ),
                  ))
            ]));
  }

  void editUser() async {
    final ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();

    _formKey.currentState.save();
    EditUserInfoResponse result= await RestApi.admin.editUserInfo(_username, _firstName, _lastName, _email);
    progressDialog.hide();
    clearErrorMessage();

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
      _errUsername  = result.error.username;
      _formKey.currentState.validate();
    }
  }




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
  InputDecoration standardInputDecoration(String label, IconData iconData) => InputDecoration(
      icon: Icon(iconData, color: primaryColor,),
      labelText: label,
      labelStyle: TextStyleFactory.p()
  );

  TextFormField _buildUserName() {
    return TextFormField(
      key: Key(_username),
      initialValue: _username,
      validator: (_) => (_errUsername.isEmpty) ? null : _errUsername,
      onSaved: (value) {_username = value;},
      decoration: standardInputDecoration("Username", Icons.people),
    );
  }

  TextFormField _buildFirstName() {
    return TextFormField(
      key: Key(_firstName),
      initialValue: _firstName,
      validator: (_) => _errFirstname.isEmpty ? null : _errFirstname,
      decoration: standardInputDecoration("First Name", Icons.font_download),
      onSaved: (value) {_firstName = value;},
    );
  }

  TextFormField _buildLastName() {
    return TextFormField(
      key: Key(_lastName),
      initialValue: _lastName,
      validator: (_) => _errLastname.isEmpty ? null : _errLastname,
      decoration: standardInputDecoration("Last Name", Icons.font_download),
      onSaved: (value) {_lastName = value;},
    );
  }

  TextFormField _buildEmail() {
    return TextFormField(
      key: Key(_email),
      initialValue: _email,
      validator: (_) => _errEmail.isEmpty ? null : _errEmail,
      decoration: standardInputDecoration("Email", Icons.email),
      onSaved: (value) {_email = value;},
    );
  }

  void clearErrorMessage(){_errFirstname = _errLastname = _errUsername = _errEmail =  "";}

  @override
  void initState() {
    super.initState();

    _fToast = FToast();
    _fToast.init(context);
    getUserDetail();
    clearErrorMessage();
  }
  void getUserDetail()async{
    UserDetailResponse result = await RestApi.admin.getUserDetail();
    if (result.response.status == 1) {
      setState(() {
        _firstName = result.detail.firstName;
        _lastName = result.detail.lastName;
        _username = result.detail.userName;
        _email = result.detail.email;

      });
    } else {
      _fToast.showToast(
          child: ToastWidget(
            status: result.response.status,
            msg: result.response.msg,
          ));
    }
  }
}

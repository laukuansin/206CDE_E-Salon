import 'dart:developer';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/dropdown.dart';
import 'package:gps_tracking_system/Components/image_picker.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:gps_tracking_system/Factory/end_user_factory.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/admin.dart';
import 'package:gps_tracking_system/Response/user_group.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/admin_add_worker_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/admin_get_users_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EditWorkerScreen extends StatefulWidget {
  final Admin user;

  EditWorkerScreenState createState() => EditWorkerScreenState(user);
  EditWorkerScreen(this.user);
}

class EditWorkerScreenState extends State<EditWorkerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Admin user;
  List<UserGroup> _userGroupList = [];
  List<UserStatus> _userStatusList = [];

  String _errUsername,
      _errFirstname,
      _errLastname,
      _errEmail,
      _errPassword,
      _errConfirm;
  bool _hiddenPassword, _hiddenConfirmPassword;
  FToast _fToast;


  EditWorkerScreenState(this.user);

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
                    _buildInputRow(_buildUserGroup()),
                    _buildInputRow(_buildFirstName()),
                    _buildInputRow(_buildLastName()),
                    _buildInputRow(_buildEmail()),
                    _buildInputRow(_buildPassword()),
                    _buildInputRow(_buildConfirmPassword()),
                    _buildInputRow(_buildStatus(), isLast: true)
                  ])))),
      appbar: AppBar(
        backgroundColor: Color(0xFF65CBF2),
        elevation: 0,
        iconTheme: IconThemeData(color: primaryLightColor),
        title: Text(
          "Edit Worker",
          style: TextStyleFactory.heading5(color: primaryLightColor),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: requestSaveWorkerChanges,
          )
        ],
      ),
    );
  }

  Column _buildInputRow(Widget input, {isLast = false}) {
    return Column(
      children: <Widget>[
        ListTile(
          title: input,
        ),
        SizedBox(
          height: 5,
        ),
        (() {
          if (!isLast) {
            return Divider(
              color: primaryDeepLightColor,
              thickness: 0.5,
            );
          }
          return SizedBox(
            height: 10,
          );
        }()),
      ],
    );
  }


  InputDecoration standardInputDecoration(String label, IconData iconData) =>
      InputDecoration(
          icon: Icon(
            iconData,
            color: primaryColor,
          ),
          labelText: label,
          labelStyle: TextStyleFactory.p());

  TextFormField _buildUserName() {
    return TextFormField(
      initialValue: user.username,
      validator: (_) => (_errUsername.isEmpty) ? null : _errUsername,
      onSaved: (value) {
        user.username = value;
      },
      style: TextStyleFactory.p(color: primaryTextColor),
      decoration: standardInputDecoration("Username", Icons.people),
    );
  }

  TextFormField _buildFirstName() {
    return TextFormField(
      initialValue: user.firstName,
      validator: (_) => _errFirstname.isEmpty ? null : _errFirstname,
      decoration: standardInputDecoration("First Name", Icons.font_download),
      style: TextStyleFactory.p(color: primaryTextColor),
      onSaved: (value) {
        user.firstName = value;
      },
    );
  }

  TextFormField _buildLastName() {
    return TextFormField(
      initialValue: user.lastName,
      validator: (_) => _errLastname.isEmpty ? null : _errLastname,
      decoration: standardInputDecoration("Last Name", Icons.font_download),
      style: TextStyleFactory.p(color: primaryTextColor),
      onSaved: (value) {
        user.lastName = value;
      },
    );
  }

  TextFormField _buildEmail() {
    return TextFormField(
      initialValue: user.email,
      validator: (_) => _errEmail.isEmpty ? null : _errEmail,
      decoration: standardInputDecoration("Email", Icons.email),
      style: TextStyleFactory.p(color: primaryTextColor),
      onSaved: (value) {
        user.email = value;
      },
    );
  }

  TextFormField _buildPassword() {
    return TextFormField(
      initialValue: "",
      validator: (_) => _errPassword.isEmpty ? null : _errPassword,
      obscureText: _hiddenPassword,
      style: TextStyleFactory.p(color: primaryTextColor),
      decoration: new InputDecoration(
        icon: Icon(
          Icons.lock,
          color: primaryColor,
        ),
        labelText: "Password",
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _hiddenPassword = !_hiddenPassword;
            });
          },
          icon: _hiddenPassword
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
        ),
        labelStyle: TextStyleFactory.p(),
      ),
      onSaved: (value) {
        user.password = value;
      },
    );
  }

  TextFormField _buildConfirmPassword() {
    return TextFormField(
      onSaved: (value) {
        user.confirm = value;
      },
      initialValue: "",
      style: TextStyleFactory.p(color: primaryTextColor),
      validator: (_) => _errConfirm.isEmpty ? null : _errConfirm,
      obscureText: _hiddenConfirmPassword,
      decoration: new InputDecoration(
          icon: Icon(
            Icons.lock,
            color: primaryColor,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _hiddenConfirmPassword = !_hiddenConfirmPassword;
              });
            },
            icon: _hiddenConfirmPassword
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility),
          ),
          labelText: "Confirm Password",
          labelStyle: TextStyleFactory.p()),
    );
  }

  Widget _buildUserGroup() {
    return Dropdown(
      title: "User Group",
      data: user.userGroup.name.isEmpty ? _userGroupList.isNotEmpty ? _userGroupList.where((element) => element.userGroupId == user.userGroup.userGroupId).toList().first.name :  "" : user.userGroup.name,
      dropdownTitle: "Select User Group",
      dropdownSelection: getUserGroupNameList(),
      leadingIconData: Icons.people,
      trailingIconData: Icons.chevron_right,
      context: context,
      callback: (value) {
        setState(() {
          user.userGroup = (value == null || value.isEmpty )? user.userGroup : _userGroupList.where((e) => e.name == value).toList().first;
        });
      },
    );
  }

  Widget _buildStatus() {
    return Dropdown(
      title: "Status",
      data: user.status.name.isEmpty ? _userStatusList.isNotEmpty ? _userStatusList.where((element) => element.statusId == user.status.statusId).toList().first : "" : user.status.name,
      dropdownTitle: "Select status",
      dropdownSelection: _userStatusList.map((e) => e.name).toList(),
      leadingIconData: Icons.offline_pin,
      trailingIconData: Icons.chevron_right,
      context: context,
      callback: (value) {
        setState(() {
          user.status = (value == null || value.isEmpty )? user.status : _userStatusList.where((element) => element.name == value).toList().first;
        });
      },
    );
  }

  void clearErrorMessage() {
    _errFirstname = _errLastname =
        _errUsername = _errEmail = _errPassword = _errConfirm = "";
    _hiddenPassword = _hiddenConfirmPassword = true;
  }

  @override
  void initState() {
    super.initState();

    initDropdownList();
    _fToast = FToast();
    _fToast.init(context);

    clearErrorMessage();
  }

  void initDropdownList() async {
    final UserGroupResponse userGroupResponse =
    await RestApi.admin.getUserGroup();
    setState(() {
      _userStatusList = [
        UserStatus(statusId: 1, name: "Enabled"),
        UserStatus(statusId: 0, name: "Disabled")
      ];

      _userGroupList = userGroupResponse.userGroup;
    });
  }

  void requestSaveWorkerChanges() async {
    final ProgressDialog progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();

    _formKey.currentState.save();
    // AddWorkerResponse result = await RestApi.admin.addWorker(
    //     _username,
    //     getIdFromGroupName(_userGroup),
    //     _firstName,
    //     _lastName,
    //     _email,
    //     _password,
    //     getIdFromStatusName(_status),
    //     _confirm);
    // progressDialog.hide();
    // clearErrorMessage();
    //
    // if (result.response.status == 1) {
    //   _fToast.showToast(
    //       child: ToastWidget(
    //           status: result.response.status, msg: result.response.msg),
    //       toastDuration: Duration(seconds: 2),
    //       gravity: ToastGravity.BOTTOM);
    // } else {
    //   _errEmail = result.error.email;
    //   _errFirstname = result.error.firstname;
    //   _errLastname = result.error.lastname;
    //   _errConfirm = result.error.confirm;
    //   _errPassword = result.error.password;
    //   _errUsername = result.error.username;
    //   _formKey.currentState.validate();
    // }
  }

  List<String> getUserGroupNameList() {
    if (_userGroupList == null) return [];

    List<String> userGroupNameList = [];
    for (UserGroup userGroup in _userGroupList)
      userGroupNameList.add(userGroup.name);

    return userGroupNameList;
  }

  List<String> getStatusNameList() {
    if (_userStatusList == null) return [];

    List<String> userStatusList = [];
    for (UserStatus userStatus in _userStatusList)
      userStatusList.add(userStatus.name);
    return userStatusList;
  }

  String getIdFromGroupName(String name) {
    for (UserGroup userGroup in _userGroupList) {
      if (userGroup.name == name) return userGroup.userGroupId;
    }
    return '-1';
  }

  String getIdFromStatusName(String name) {
    for (UserStatus userStatus in _userStatusList) {
      if (userStatus.name == name) return userStatus.statusId.toString();
    }
    return '-1';
  }
}




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
import 'package:gps_tracking_system/Utility/RestApi/admin_modified_worker_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddWorkerState extends State<AddWorker> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<UserGroup> _userGroupList = [];
  List<UserStatus> _userStatusList = [];

  Admin user;
  String _errUsername,
      _errFirstname,
      _errLastname,
      _errEmail,
      _errPassword,
      _errConfirm;
  bool _hiddenPassword, _hiddenConfirmPassword;
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
                    _buildInputRow(_buildUserGroup()),
                    _buildInputRow(_buildFirstName()),
                    _buildInputRow(_buildLastName()),
                    _buildInputRow(_buildEmail()),
                    _buildInputRow(_buildImageFiled()),
                    _buildInputRow(_buildPassword()),
                    _buildInputRow(_buildConfirmPassword()),
                    _buildInputRow(_buildStatus(), isLast: true)
                  ])))),
      appbar: AppBar(
        backgroundColor: Color(0xFF65CBF2),
        elevation: 0,
        iconTheme: IconThemeData(color: primaryLightColor),
        title: Text(
          "Add Worker",
          style: TextStyleFactory.heading5(color: primaryLightColor),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: addUser,
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

  ImagePicker _buildImageFiled() {
    return ImagePicker(
      callback: (path) {
        setState(() {
          user.image = path;
        });
      },
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
      data: user.userGroup == null ? "" : user.userGroup.name,
      dropdownTitle: "Select User Group",
      dropdownSelection: _userGroupList.map((e) => e.name).toList(),
      leadingIconData: Icons.people,
      trailingIconData: Icons.chevron_right,
      context: context,
      callback: (value) {
        setState(() {
          user.userGroup = value == null || value.isEmpty ? user.userGroup : _userGroupList.where((element) => element.name == value).toList().first;
        });
      },
    );
  }

  Widget _buildStatus() {
    return Dropdown(
      title: "Status",
      data: user.status == null ? "" : user.status.name,
      dropdownTitle: "Select status",
      dropdownSelection: (_userStatusList.map((e) => e.name)).toList(),
      leadingIconData: Icons.offline_pin,
      trailingIconData: Icons.chevron_right,
      context: context,
      callback: (value) {
        setState(() {
          user.status = value == null || value.isEmpty ? user.status : _userStatusList.where((element) => element.name == value).toList().first;
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
    user = EndUserFactory.createInstance(EndUserType.ADMIN);

    initDropdownList();
    _fToast = FToast();
    _fToast.init(context);

    user.status = _userStatusList.isNotEmpty ? _userStatusList[0] : null;
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
      user.status =  _userStatusList[0];
      _userGroupList = userGroupResponse.userGroup;
      user.userGroup = _userGroupList[0];
    });
  }

  void addUser() async {
    final ProgressDialog progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();

    _formKey.currentState.save();
    ModifiedUserResponse result = await RestApi.admin.addWorker(user);
    progressDialog.hide();
    clearErrorMessage();

    if (result.response.status == 1) {
      _fToast.showToast(
          child: ToastWidget(
              status: result.response.status, msg: result.response.msg),
          toastDuration: Duration(seconds: 2),
          gravity: ToastGravity.BOTTOM);
      Navigator.of(context).pop();
    } else {
      _errEmail = result.error.email;
      _errFirstname = result.error.firstname;
      _errLastname = result.error.lastname;
      _errConfirm = result.error.confirm;
      _errPassword = result.error.password;
      _errUsername = result.error.username;
      _formKey.currentState.validate();
    }
  }
}

class AddWorker extends StatefulWidget {
  AddWorkerState createState() => AddWorkerState();
}

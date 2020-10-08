import 'dart:developer';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/dropdown.dart';
import 'package:gps_tracking_system/Components/image_picker.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Response/user_group.dart';
import 'package:gps_tracking_system/Screens/Admin/AddWorker/add_worker_response';
import 'package:gps_tracking_system/Utility/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:gps_tracking_system/Components/toast_widget';

class AddWorkerState extends State<AddWorker> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> _listStatus;
  List<UserGroup> _userGroupList;
  List<UserStatus> _userStatusList;

  String _username = "", _firstName = "", _lastName = "", _userGroup = "", _email ="", _password="", _confirm="", _status="", _imgPath = "";
  String _errUsername, _errFirstname, _errLastname, _errEmail, _errPassword, _errConfirm;
  bool _hiddenPassword, _hiddenConfirmPassword;
  FToast _fToast;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Add Worker",
          style: TextStyleFactory.p(color:primaryTextColor),),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: addUser,
                child: Icon(
                  Icons.check,
                  color: primaryColor,
                ),
              )
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
                color:primaryLightColor,
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
                      ]
                  )
              )
          )
        )
    );
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

  ImagePicker _buildImageFiled(){
    return ImagePicker(callback: (path){
      setState(() {_imgPath = path;});
    },);
  }

  InputDecoration standardInputDecoration(String label, IconData iconData) => InputDecoration(
      icon: Icon(iconData, color: primaryColor,),
      labelText: label,
      labelStyle: TextStyleFactory.p()
  );

  TextFormField _buildUserName() {
    return TextFormField(
        initialValue: "ah huat",
        validator: (_) => (_errUsername.isEmpty) ? null : _errUsername,
        onSaved: (value) {_username = value;},
        decoration: standardInputDecoration("Username", Icons.people),
    );
  }

  TextFormField _buildFirstName() {
    return TextFormField(
      initialValue: "Ah",
        validator: (_) => _errFirstname.isEmpty ? null : _errFirstname,
        decoration: standardInputDecoration("First Name", Icons.font_download),
        onSaved: (value) {_firstName = value;},
    );
  }

  TextFormField _buildLastName() {
    return TextFormField(
      initialValue: "Huat",
        validator: (_) => _errLastname.isEmpty ? null : _errLastname,
        decoration: standardInputDecoration("Last Name", Icons.font_download),
        onSaved: (value) {_lastName = value;},
    );
  }

  TextFormField _buildEmail() {
    return TextFormField(
      initialValue: "ahhuat@gmail.com",
      validator: (_) => _errEmail.isEmpty ? null : _errEmail,
      decoration: standardInputDecoration("Email", Icons.email),
      onSaved: (value) {_email = value;},
    );
  }

  TextFormField _buildPassword() {
    return TextFormField(
      initialValue: "123456",
      validator: (_) => _errPassword.isEmpty ? null : _errPassword,
      obscureText: _hiddenPassword,
      decoration: new InputDecoration(
        icon: Icon(Icons.lock, color: primaryColor,),
        labelText: "Password",
        suffixIcon: IconButton(
          onPressed: (){setState(() {_hiddenPassword = !_hiddenPassword;});},
          icon: _hiddenPassword ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
        ),
        labelStyle: TextStyleFactory.p(),
      ),
      onSaved: (value) {_password = value;},
    );
  }

  TextFormField _buildConfirmPassword() {
    return TextFormField(
      onSaved: (value) {_confirm = value;},
      initialValue: "123456",
      validator: (_) => _errConfirm.isEmpty? null : _errConfirm,
      obscureText: _hiddenConfirmPassword,
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


  Widget _buildUserGroup(){
    return Dropdown(
      title: "User Group",
      data: _userGroup == null? "": _userGroup,
      dropdownTitle: "Select User Group",
      dropdownSelection: getUserGroupNameList(),
      leadingIconData: Icons.people,
      trailingIconData: Icons.chevron_right,
      context: context,
      callback: (value){setState(() {
        _userGroup = value == null || value.isEmpty ? _userGroup : value;
      });},
    );
  }

  Widget _buildStatus(){
    return Dropdown(
      title: "Status",
      data: _status == null? "": _status,
      dropdownTitle: "Select status",
      dropdownSelection: _listStatus,
      leadingIconData: Icons.offline_pin,
      trailingIconData: Icons.chevron_right,
      context: context,
      callback: (value){setState(() {
        _status = value == null || value.isEmpty ? _status : value;
      });},
    );
  }

  void clearErrorMessage(){_errFirstname = _errLastname = _errUsername = _errEmail = _errPassword = _errConfirm = ""; _hiddenPassword = _hiddenConfirmPassword = true;}

  @override
  void initState() {
    super.initState();

    initDropdownList();
    _fToast = FToast();
    _fToast.init(context);

    _listStatus = List();
    _listStatus.add("Enabled");
    _listStatus.add("Disabled");

    _status    = _listStatus[0] != null ? _listStatus[0] : "";
    clearErrorMessage();
  }

  void initDropdownList()async{
    final UserGroupResponse userGroupResponse = await RestApi.admin.getUserGroup();
    setState(() {
      _userStatusList = [UserStatus(statusId: 1, name:"Enabled"), UserStatus(statusId: 0, name:"Disabled")];
      _status = _userStatusList[0].name;
      _userGroupList = userGroupResponse.userGroup;
      _userGroup = _userGroupList[0].name;
    });
  }

  void addUser()async{
    final ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();

    _formKey.currentState.save();
    AddWorkerResponse result = await RestApi.admin.addUser(_username, getIdFromGroupName(_userGroup), _firstName, _lastName, _email, _imgPath , _password, getIdFromStatusName(_status), _confirm);
    progressDialog.hide();
    clearErrorMessage();

    if(result.response.status ==1)
    {
      _fToast.showToast(
          child: ToastWidget(status: result.response.status, msg: result.response.msg),
          toastDuration: Duration(seconds: 2),
          gravity: ToastGravity.BOTTOM);
    }
    else{
      _errEmail     = result.error.email;
      _errFirstname = result.error.firstname;
      _errLastname  = result.error.lastname;
      _errConfirm   = result.error.confirm;
      _errPassword  = result.error.password;
      _errUsername  = result.error.username;
      _formKey.currentState.validate();
    }
  }

  List<String> getUserGroupNameList(){
    if(_userGroupList == null) return [];

    List<String> userGroupNameList = [];
    for(UserGroup userGroup in  _userGroupList)
      userGroupNameList.add(userGroup.name);

    return userGroupNameList;
  }

  List<String> getStatusNameList(){
    if(_userStatusList == null) return [];

    List<String> userStatusList = [];
    for(UserStatus userStatus in  _userStatusList)
      userStatusList.add(userStatus.name);
    return userStatusList;
  }

  String getIdFromGroupName(String name){
    for(UserGroup userGroup in  _userGroupList){
      if(userGroup.name == name)
        return userGroup.userGroupId;
    }
    return '-1';
  }

  String getIdFromStatusName(String name){
    for(UserStatus userStatus in _userStatusList){
      if(userStatus.name == name)
        return userStatus.statusId.toString();
    }
    return '-1';
  }
}

class UserStatus {
  UserStatus({
    this.statusId,
    this.name,
  });

  int statusId;
  String name;
}

class AddWorker extends StatefulWidget {
  AddWorkerState createState() => AddWorkerState();
}

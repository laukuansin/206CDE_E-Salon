import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/user_customer_detail_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/user_edit_user_info_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EditInfoScreen extends StatefulWidget {
  @override
  EditInfoScreenState createState() => EditInfoScreenState();
}

class EditInfoScreenState extends State<EditInfoScreen> {
  FToast _fToast;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String firstName="",lastName="",email="",contactNo="";
  String _errFirstname, _errLastname, _errEmail, _errContact;


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _fToast = FToast();
    _fToast.init(context);

    getCustomerDetail();
    clearErrorMessage();

  }

  @override
  Widget build(BuildContext context) {
    return RouteGenerator.buildScaffold(
      SingleChildScrollView(
        child: Container(
            color:primaryLightColor,
            child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  _buildInputRow(_buildFirstName()),
                  _buildInputRow(_buildLastName()),
                  _buildInputRow(_buildEmail()),
                  _buildInputRow(_buildContact(), isLast: true)
                ]
                )
            )
        ),
      ),appbar: AppBar(
        title: Text(
          "Edit information",
          style: TextStyleFactory.p(color: primaryTextColor)
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: editInfo,
                child: Icon(
                  Icons.check,
                  color: primaryColor,
                ),
              )
          )
        ]
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


  void getCustomerDetail()async
  {
    final ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();

    CustomerDetailResponse result = await RestApi.customer.getCustomerDetail();

    if (result.response.status == 1) {
      setState(() {
        firstName = result.customerDetail.firstName;
        lastName = result.customerDetail.lastName;
        contactNo = result.customerDetail.contactNo;
        email = result.customerDetail.email;
        print(firstName);
      });
    } else {
      firstName="";
      lastName = "";
      contactNo = "";
      email = "";
      _fToast.showToast(
          child: ToastWidget(
            status: result.response.status,
            msg: result.response.msg,
          ));
    }
    progressDialog.hide();


  }
  void clearErrorMessage(){_errFirstname = _errLastname = _errContact = _errEmail= "";}
  TextFormField _buildFirstName() {
    return TextFormField(
      key: Key(firstName),
      initialValue: firstName, // this is no need de hahaha
      validator: (_) => _errFirstname.isEmpty ? null : _errFirstname,
      decoration: standardInputDecoration("First Name", Icons.font_download),
      onSaved: (value) {firstName = value;},
    );
  }

  void editInfo()async{
    final ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();
    _formKey.currentState.save();
    EditInfoResponse result = await RestApi.customer.editInfo(firstName,lastName,contactNo,email);
    progressDialog.hide();
    clearErrorMessage();

    if(result.response.status ==1)
    {
      Navigator.of(context).pop();
      _fToast.showToast(
          child: ToastWidget(status: result.response.status, msg: result.response.msg),
          toastDuration: Duration(seconds: 2),
          gravity: ToastGravity.BOTTOM);
    }
    else{
      _errEmail     = result.error.email;
      _errFirstname = result.error.firstname;
      _errLastname  = result.error.lastname;
      _errContact  = result.error.contactNo;
      _formKey.currentState.validate();
    }
  }
  TextFormField _buildLastName() {
    return TextFormField(
      key: Key(lastName),
      initialValue: lastName.isEmpty?"":lastName,
      style: TextStyleFactory.p(color: primaryTextColor),
      validator: (_) => _errLastname.isEmpty ? null : _errLastname,
      decoration: standardInputDecoration("Last Name", Icons.font_download),
      onSaved: (value) {lastName = value;},
    );
  }

  TextFormField _buildEmail() {
    return TextFormField(
      key: Key(email),
      style: TextStyleFactory.p(color: primaryTextColor),
      initialValue: email.isEmpty?"":email,
      validator: (_) => _errEmail.isEmpty ? null : _errEmail,
      decoration: standardInputDecoration("Email", Icons.email),
      onSaved: (value) {email = value;},
    );
  }
  TextFormField _buildContact() {
    return TextFormField(
      key: Key(contactNo),
      initialValue: contactNo.isEmpty?"":contactNo,
      style: TextStyleFactory.p(color: primaryTextColor),
      validator: (_) => _errContact.isEmpty ? null : _errEmail,
      decoration: standardInputDecoration("Contact No", Icons.phone),
      onSaved: (value) {contactNo = value;},
    );
  }
  InputDecoration standardInputDecoration(String label, IconData iconData) => InputDecoration(
      icon: Icon(iconData, color: primaryColor,),
      labelText: label,
      labelStyle: TextStyleFactory.p()
  );
}
import 'dart:io';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Response/AddStaffResponse.dart';
import 'package:gps_tracking_system/Utility/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddWorker extends StatefulWidget {
  AddWorkerState createState() => AddWorkerState();
}

class AddWorkerState extends State<AddWorker> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File fileImg;
  List<String> _listGroup, _listStatus;
  String errorMsgOfEmail, errorMsgPassword, errorMsgConfirmPassword;
  String username, firstName, lastName, userGroup, email, password, confirmPassword, status;
  bool _hiddenPassword, _hiddenConfirmPassword;
  FToast fToast;

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
                  onTap: addWorker,
                  child: Icon(
                    Icons.check,
                    color: primaryColor,
                  ),
                ))
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
                        _buildInputRow(_buildImagePicker()),
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

  Container _buildImagePicker(){
    return Container(
        child:ListTile(
          contentPadding: EdgeInsets.zero,
          leading:Icon(
              Icons.image,
              color: primaryColor
          ),
          title:Align(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:<Widget>[
                Text(
                  "Image",
                  style: TextStyleFactory.p(),
                ),
                SizedBox(height: 5,),
                imagePick(),
                SizedBox(height: 5,),
                RaisedButton(
                  onPressed: pickImage,
                  child: Text(
                      "Upload",
                      style: TextStyleFactory.p(color:primaryLightColor)),
                  color: primaryColor,
                )
              ]
            ),
            alignment: Alignment(-1.2,0),
          ),
          trailing: SizedBox(),
        )
    );
  }

  Future<String> _showDropDown(String title, List<String>listData) async{
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            height: 100.0,
            width: 100.0,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: listData.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(listData[index]),
                  onTap: () {
                    setState(() {
                      Navigator.pop(context, listData[index]);
                    });
                  });
                },
            ),
          )
        );
      }
    );
  }

  TextFormField _buildUserName() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return "Username cannot be empty";
          }
          return null;
        },
        onSaved: (value) {
          username = value;
        },
        decoration: new InputDecoration(
            icon: Icon(
              Icons.person,
              color: primaryColor,
            ),
            labelText: "Username",
            labelStyle: TextStyleFactory.p()
        )
    );
  }

  TextFormField _buildFirstName() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return "First name cannot be empty";
          }
          return null;
        },
        decoration: new InputDecoration(
          icon: Icon(
            Icons.font_download,
            color: primaryColor,
          ),
          labelText: "First Name",
          labelStyle: TextStyleFactory.p(),
        ),
        onSaved: (value) {
          firstName = value;
        },
    );
  }

  TextFormField _buildLastName() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return "Last Name cannot be empty";
          }
          return null;
        },
        decoration: new InputDecoration(
            icon: Icon(
              Icons.font_download,
              color: primaryColor,
            ),
            labelText: "Last Name",
            labelStyle: TextStyleFactory.p()
        ),
        onSaved: (value) {
          lastName = value;
        },
    );
  }

  TextFormField _buildEmail() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return "Email cannot be empty";
        } else {
          if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(email)) {
            return "Please enter correct format of email";
          }
        }
        return null;
      },
      decoration: new InputDecoration(
        icon: Icon(
          Icons.email,
          color: primaryColor,
        ),
        labelText: "Email",
        labelStyle: TextStyleFactory.p(),
      ),
      onSaved: (value) {
        email = value;
      },
    );
  }

  TextFormField _buildPassword() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return "Password cannot be empty";
        } else {
          if (value.length < 8) {
            return "Use 8 characters or more for your password";
          }
        }
        return null;
      },
      obscureText: _hiddenPassword,
      decoration: new InputDecoration(
        icon: Icon(
          Icons.lock,
          color: primaryColor,
        ),
        labelText: "Password",
        suffixIcon: IconButton(
          onPressed: (){setState(() {
            _hiddenPassword = !_hiddenPassword;
          });},
          icon: _hiddenPassword
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
        ),
        labelStyle: TextStyleFactory.p(),
      ),
      onSaved: (value) {
        password = value;
      },
    );
  }

  TextFormField _buildConfirmPassword() {
    return TextFormField(
      onSaved: (value) {
        confirmPassword = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Confirm Password cannot be empty";
        } else {
          if (password != value) {
            return "Those passwords did not match. Try agin";
          }
        }
        return null;
      },
      obscureText: _hiddenConfirmPassword,
      decoration: new InputDecoration(
          icon: Icon(
            Icons.lock,
            color: primaryColor,
          ),
          suffixIcon: IconButton(
            onPressed: (){
              setState(() {
                _hiddenConfirmPassword = !_hiddenConfirmPassword;
              });
            },
            icon: _hiddenConfirmPassword
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility),
          ),
          labelText: "Confirm Password",
          labelStyle: TextStyleFactory.p()
      ),
    );
  }

  GestureDetector _buildUserGroup(){
    return GestureDetector(
        child: Container(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                  Icons.people,
                  color: primaryColor
              ),
              title: Align(
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget>[
                    Text("User Group", style: TextStyleFactory.p()),
                    Text(userGroup, style: TextStyleFactory.p(color: primaryTextColor),)
                  ]
                ),
                alignment: Alignment(-1.2, 0),
              ),
              trailing: Icon(Icons.chevron_right),
            )
        ),
        onTap: () async{
          String result = await _showDropDown("Select User Group", _listGroup);
          if(result == null) result = userGroup;
          setState(() {
            userGroup = result;
          });
        }
    );
  }

  GestureDetector _buildStatus(){
    return GestureDetector(
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  Icon(
                      Icons.offline_pin,
                      size: 24, color: primaryColor
                  ),
                  Padding(
                    child: Wrap(
                        direction: Axis.vertical,
                        children: <Widget>[
                          Text(
                            "Status",
                            style: TextStyleFactory.p(),
                          ),
                          Text(
                              status,
                              style: TextStyleFactory.p(color:primaryTextColor))
                        ]
                    ),
                    padding: EdgeInsets.only(left: 15),
                  )
                ]
              )
            ),
            Icon(Icons.chevron_right)
          ]
        )
      ),
      onTap: ()async{
        String result = await _showDropDown("Select status", _listStatus);
        if(result == null) result = status;
        setState(() {
          status = result;
        });
      }
    );
  }

  Widget imagePick() => (fileImg == null)? Text("No Image Selected", style: TextStyleFactory.p()):Image.file(fileImg, width: 150, height: 150);
  Future pickImage() async {
    PickedFile pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      fileImg = File(pickedImage.path);
    });
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);

    _listGroup = List();
    _listGroup.add("Owner");
    _listGroup.add("Worker");

    _listStatus = List();
    _listStatus.add("Enabled");
    _listStatus.add("Disabled");

    username        = "";
    firstName       = "";
    lastName        = "";
    email           = "";
    password        = "";
    confirmPassword = "";
    fileImg         = null;
    status    = _listStatus[0] != null ? _listStatus[0] : "";
    userGroup = _listGroup[0]  != null ?  _listGroup[0] : "";

    _hiddenConfirmPassword = true;
    _hiddenPassword = true;
  }

  void addWorker() {

    FocusScope.of(context).unfocus();
    _formKey.currentState.save();

    if (_formKey.currentState.validate()) {
      String imagePath;
      if(fileImg==null)
      {
        imagePath="";
      }
      else{
        imagePath=fileImg.path;

      }
      addStaff(username,firstName,lastName,email,password,imagePath,status,userGroup);
    return;
    }

  }

  void addStaff(String username,String firstname,String lastname,String email,String password,String imagePath,String status,String userGroup)async{
    final ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();
    AddStaffResponse result =await RestApi.addStaff(username, userGroup, firstName, lastName, email, imagePath, password, status);
    progressDialog.hide();

    if(result.errorCode.error==0)
    {
      successMessage(result.errorCode.msj);

    }
    else{
      errorMessage(result.errorCode.msj);
    }
  }
  void errorMessage(String errMsg) {
    Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0), color: Colors.red),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.error_outline, color: Colors.white),
          SizedBox(width: 12.0),
          Expanded(
              child: Text(errMsg,
                  style: TextStyle(color: Colors.white, fontSize: 12))),
        ]));
    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        gravity: ToastGravity.BOTTOM);
  }

  void successMessage(String scsMsg) {
    Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.greenAccent),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.check, color: Colors.white),
          SizedBox(width: 12.0),
          Expanded(
              child: Text(scsMsg,
                  style: TextStyle(color: Colors.white, fontSize: 12)))
        ]));
    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        gravity: ToastGravity.BOTTOM);
  }
}
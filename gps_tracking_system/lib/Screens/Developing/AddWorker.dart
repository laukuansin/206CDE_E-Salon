import 'dart:io';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';

import 'package:gps_tracking_system/color.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(AddWorker());
}

class AddWorker extends StatefulWidget {
  AddWorkerState createState() => AddWorkerState();
}

class AddWorkerState extends State<AddWorker> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File fileImg;
  List<String> _listGroup, _listStatus;
  String errorMsgOfEmail, errorMsgPassword, errorMsgConfirmPassword;
  String username,
      firstName,
      lastName,
      userGroup,
      email,
      password,
      confirmPassword,
      status;

  bool _hiddenPassword,
      _hiddenConfirmPassword;

  Widget _buildUserName() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return "Username cannot be empty";
          }
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
          errorStyle: TextStyle(fontSize: 15),
          labelStyle: TextStyle(color: Colors.black, fontSize: 20),
        ),
        style: TextStyle(fontSize: 18));
  }

  Widget _buildFirstName() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return "First Name cannot be empty";
        }
      },
      decoration: new InputDecoration(
        icon: Icon(
          Icons.font_download,
          color: primaryColor,
        ),
        labelText: "First Name",
        errorStyle: TextStyle(fontSize: 15),
        labelStyle: TextStyle(color: Colors.black, fontSize: 20),
      ),
      style: TextStyle(fontSize: 18),
      onSaved: (value) {
        firstName = value;
      },
    );
  }

  Widget _buildLastName() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return "Last Name cannot be empty";
        }
      },
      decoration: new InputDecoration(
        icon: Icon(
          Icons.font_download,
          color: primaryColor,
        ),
        labelText: "Last Name",
        errorStyle: TextStyle(fontSize: 15),
        labelStyle: TextStyle(color: Colors.black, fontSize: 20),
      ),
      style: TextStyle(fontSize: 18),
      onSaved: (value) {
        lastName = value;
      },
    );
  }

  Widget _buildEmail() {
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
      },
      decoration: new InputDecoration(
        icon: Icon(
          Icons.email,
          color: primaryColor,
        ),
        labelText: "Email",
        errorStyle: TextStyle(fontSize: 15),
        labelStyle: TextStyle(color: Colors.black, fontSize: 20),
      ),
      style: TextStyle(fontSize: 18),
      onSaved: (value) {
        email = value;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return "Password cannot be empty";
        } else {
          if (value.length < 8) {
            return "Use 8 characters or more for your password";
          }
        }
      },
      obscureText: _hiddenPassword,
      style: TextStyle(fontSize: 18),
      decoration: new InputDecoration(
        icon: Icon(
          Icons.lock,
          color: primaryColor,
        ),
        labelText: "Password",
        errorStyle: TextStyle(fontSize: 15),
        suffixIcon: IconButton(
          onPressed: _toggleVisibilityPassword,
          icon: _hiddenPassword
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
        ),
        labelStyle: TextStyle(color: Colors.black, fontSize: 20),
      ),
      onSaved: (value) {
        password = value;
      },
    );
  }

  Widget _buildConfirmPassword() {
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
      },
      obscureText: _hiddenConfirmPassword,
      decoration: new InputDecoration(
        icon: Icon(
          Icons.lock,
          color: primaryColor,
        ),
        suffixIcon: IconButton(
          onPressed: _toggleVisibilityConfirmPassword,
          icon: _hiddenConfirmPassword
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
        ),
        labelText: "Confirm Password",
        errorStyle: TextStyle(fontSize: 15),
        labelStyle: TextStyle(color: Colors.black, fontSize: 20),
      ),
      style: TextStyle(fontSize: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    //debugPaintSizeEnabled=true;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Add Worker"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: addWorker,
                  child: Icon(Icons.check),
                ))
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      Container(
                          color: Colors.white,
                          child: Padding(
                              child: _buildUserName(),
                              padding: EdgeInsets.only(
                                  left: 20, top: 10, right: 20, bottom: 20))),
                      Divider(
                        color: Colors.grey[500],
                        thickness: 0.5,
                        height: 0,
                      ),
                      new GestureDetector(
                          child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(20),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Row(children: [
                                  Icon(Icons.people,
                                      size: 24, color: primaryColor),
                                  Padding(
                                    child: Wrap(
                                        direction: Axis.vertical,
                                        children: <Widget>[
                                          Text(
                                            "User Group",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            userGroup,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey[500]),
                                          ),
                                        ]),
                                    padding: EdgeInsets.only(left: 15),
                                  )
                                ])),
                                Icon(Icons.chevron_right)
                              ])),
                          onTap: callUserGroupAlertDialog),
                      Divider(
                        color: Colors.grey[500],
                        thickness: 0.5,
                        height: 0,
                      ),
                      Container(
                          color: Colors.white,
                          child: Padding(
                              child: _buildFirstName(),
                              padding: EdgeInsets.only(
                                  left: 20, top: 10, right: 20, bottom: 20))),
                      Divider(
                        color: Colors.grey[500],
                        thickness: 0.5,
                        height: 0,
                      ),
                      Container(
                          color: Colors.white,
                          child: Padding(
                              child: _buildLastName(),
                              padding: EdgeInsets.only(
                                  left: 20, top: 10, right: 20, bottom: 20))),
                      Divider(
                        color: Colors.grey[500],
                        thickness: 0.5,
                        height: 0,
                      ),
                      Container(
                          color: Colors.white,
                          child: Padding(
                              child: _buildEmail(),
                              padding: EdgeInsets.only(
                                  left: 20, top: 10, right: 20, bottom: 20))),
                      Divider(
                        color: Colors.grey[500],
                        thickness: 0.5,
                        height: 0,
                      ),
                      Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20),
                          child: Row(children: <Widget>[
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.image,
                                      size: 24, color: primaryColor),
                                  Padding(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Image",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          Padding(
                                              child: imagePick(),
                                              padding: EdgeInsets.only(
                                                  top: 10, bottom: 10)),
                                          RaisedButton(
                                            onPressed: pickImage,
                                            child: Text(
                                              "Upload",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                            color: primaryColor,
                                          )
                                        ]),
                                    padding: EdgeInsets.only(left: 15),
                                  )
                                ]),
                          ])),
                      Divider(
                        color: Colors.grey[500],
                        thickness: 0.5,
                        height: 0,
                      ),
                      Container(
                          color: Colors.white,
                          child: Padding(
                              child: _buildPassword(),
                              padding: EdgeInsets.only(
                                  left: 20, top: 10, right: 20, bottom: 20))),
                      Divider(
                        color: Colors.grey[500],
                        thickness: 0.5,
                        height: 0,
                      ),
                      Container(
                          color: Colors.white,
                          child: Padding(
                              child: _buildConfirmPassword(),
                              padding: EdgeInsets.only(
                                  left: 20, top: 10, right: 20, bottom: 20))),
                      Divider(
                        color: Colors.grey[500],
                        thickness: 0.5,
                        height: 0,
                      ),
                      new GestureDetector(
                          child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(20),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Row(children: [
                                  Icon(Icons.offline_pin,
                                      size: 24, color: primaryColor),
                                  Padding(
                                    child: Wrap(
                                        direction: Axis.vertical,
                                        children: <Widget>[
                                          Text(
                                            "Status",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            status,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey[500]),
                                          ),
                                        ]),
                                    padding: EdgeInsets.only(left: 15),
                                  )
                                ])),
                                Icon(Icons.chevron_right)
                              ])),
                          onTap: callStatusAlertDialog)
                    ])))));
  }

  void callUserGroupAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Select the user group"), content: buildUserGroup());
        });
  }

  void _toggleVisibilityPassword() {
    setState(() {
      _hiddenPassword = !_hiddenPassword;
    });
  }

  void _toggleVisibilityConfirmPassword() {
    setState(() {
      _hiddenConfirmPassword = !_hiddenConfirmPassword;
    });
  }

  Widget buildUserGroup() {
    return Container(
      height: 100.0, // Change as per your requirement
      width: 100.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              title: Text(_listGroup[index]),
              onTap: () {
                setState(() {
                  Navigator.pop(context);

                  userGroup = _listGroup[index];
                });
              });
        },
      ),
    );
  }

  void callStatusAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Select the status"), content: buildStatus());
        });
  }

  Widget buildStatus() {
    return Container(
      height: 100.0, // Change as per your requirement
      width: 100.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              title: Text(_listStatus[index]),
              onTap: () {
                setState(() {
                  Navigator.pop(context);

                  status = _listStatus[index];
                });
              });
        },
      ),
    );
  }

  Widget imagePick() {
    if (fileImg == null) {
      return Text("No Image Selected", style: TextStyle(fontSize: 18));
    } else {
      return Image.file(fileImg, width: 150, height: 150);
    }
  }

  Future pickImage() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      fileImg = picture;
    });
  }

  @override
  void initState() {
    super.initState();
    username = "";
    firstName = "";
    lastName = "";
    userGroup = "Owner";
    email = "";
    password = "";
    confirmPassword = "";
    status = "Enabled";
    fileImg = null;

    _hiddenConfirmPassword = true;
    _hiddenPassword = true;

    _listGroup = new List();
    _listGroup.add("Owner");
    _listGroup.add("Worker");

    _listStatus = new List();
    _listStatus.add("Enabled");
    _listStatus.add("Disabled");
  }

  void addWorker() {
    FocusScope.of(context).unfocus();
    
    if (_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    print(username);
    print(firstName);
    print(lastName);
    print(email);
    print(userGroup);
    print(password);
    print(confirmPassword);
    print(fileImg);
    print(status);
  }
}

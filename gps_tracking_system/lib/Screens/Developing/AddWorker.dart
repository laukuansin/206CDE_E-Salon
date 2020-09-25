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

  bool _validUsername,
      _validFirstName,
      _validLastName,
      _validEmail,
      _validPassword,
      _validConfirmPassword,
      _hiddenPassword,
      _hiddenConfirmPassword;

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
                child: Column(children: <Widget>[
          Container(
              color: Colors.white,
              child: Padding(
                  child: TextField(
                      decoration: new InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: primaryColor,
                        ),
                        labelText: "Username",
                        errorText:
                            _validUsername ? "Username cannot be empty" : null,
                        errorStyle: TextStyle(fontSize: 15),
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      style: TextStyle(fontSize: 18),
                      onChanged: (text) {
                        username = text;
                      }),
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
                      Icon(Icons.people, size: 24, color: primaryColor),
                      Padding(
                        child:
                            Wrap(direction: Axis.vertical, children: <Widget>[
                          Text(
                            "User Group",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            userGroup,
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[500]),
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
                  child: TextField(
                      decoration: new InputDecoration(
                        icon: Icon(
                          Icons.font_download,
                          color: primaryColor,
                        ),
                        labelText: "First Name",
                        errorText: _validFirstName
                            ? "First Name cannot be empty"
                            : null,
                        errorStyle: TextStyle(fontSize: 15),
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      style: TextStyle(fontSize: 18),
                      onChanged: (text) {
                        firstName = text;
                      }),
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
                  child: TextField(
                      decoration: new InputDecoration(
                        icon: Icon(
                          Icons.font_download,
                          color: primaryColor,
                        ),
                        labelText: "Last Name",
                        errorText:
                            _validLastName ? "Last Name cannot be empty" : null,
                        errorStyle: TextStyle(fontSize: 15),
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      style: TextStyle(fontSize: 18),
                      onChanged: (text) {
                        lastName = text;
                      }),
                  padding: EdgeInsets.only(
                      left: 20, top: 10, right: 20, bottom: 20))),
          Divider(
            color: Colors.grey[500],
            thickness: 0.5,
            height: 0,
          ),
          Divider(
            color: Colors.grey[500],
            thickness: 0.5,
            height: 0,
          ),
          Container(
              color: Colors.white,
              child: Padding(
                  child: TextField(
                      decoration: new InputDecoration(
                        icon: Icon(
                          Icons.email,
                          color: primaryColor,
                        ),
                        labelText: "Email",
                        errorText: _validEmail ? errorMsgOfEmail : null,
                        errorStyle: TextStyle(fontSize: 15),
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      style: TextStyle(fontSize: 18),
                      onChanged: (text) {
                        email = text;
                      }),
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
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.image, size: 24, color: primaryColor),
                  Padding(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Image",
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(
                              child: imagePick(),
                              padding: EdgeInsets.only(top: 10, bottom: 10)),
                          RaisedButton(
                            onPressed: pickImage,
                            child: Text(
                              "Upload",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
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
                  child: TextField(
                      obscureText: _hiddenPassword,
                      style: TextStyle(fontSize: 18),
                      decoration: new InputDecoration(
                        icon: Icon(
                          Icons.lock,
                          color: primaryColor,
                        ),
                        labelText: "Password",
                        errorText: _validPassword ? errorMsgPassword : null,
                        errorStyle: TextStyle(fontSize: 15),
                        suffixIcon: IconButton(
                          onPressed: _toggleVisibilityPassword,
                          icon: _hiddenPassword
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        ),
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      onChanged: (text) {
                        password = text;
                      }),
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
                  child: TextField(
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
                        errorText: _validConfirmPassword
                            ? errorMsgConfirmPassword
                            : null,
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      style: TextStyle(fontSize: 18),
                      onChanged: (text) {
                        confirmPassword = text;
                      }),
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
                      Icon(Icons.offline_pin, size: 24, color: primaryColor),
                      Padding(
                        child:
                            Wrap(direction: Axis.vertical, children: <Widget>[
                          Text(
                            "Status",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            status,
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[500]),
                          ),
                        ]),
                        padding: EdgeInsets.only(left: 15),
                      )
                    ])),
                    Icon(Icons.chevron_right)
                  ])),
              onTap: callStatusAlertDialog)
        ]))));
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

    _validUsername = false;
    _validFirstName = false;
    _validLastName = false;
    _validEmail = false;
    _validPassword = false;
    _validConfirmPassword = false;
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
    bool check = true;
    FocusScope.of(context).unfocus();
    if (username.isEmpty) {
      check = false;
      setState(() {
        _validUsername = true;
      });
    } else {
      check = true;
      setState(() {
        _validUsername = false;
      });
    }

    if (firstName.isEmpty) {
      check = false;
      setState(() {
        _validFirstName = true;
      });
    } else {
      check = true;
      setState(() {
        _validFirstName = false;
      });
    }

    if (lastName.isEmpty) {
      check = false;
      setState(() {
        _validLastName = true;
      });
    } else {
      check = true;
      setState(() {
        _validLastName = false;
      });
    }
    if (email.isEmpty) {
      check = false;
      setState(() {
        errorMsgOfEmail = "Email cannot be empty";

        _validEmail = true;
      });
    } else {
      if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email)) {
        check = false;
        setState(() {
          errorMsgOfEmail = "Please enter correct format of email";
          _validEmail = true;
        });
      } else {
        check = true;
        setState(() {
          _validEmail = false;
        });
      }
    }
    if (password.isEmpty) {
      check = false;
      setState(() {
        errorMsgPassword = "Password cannot be empty";
        _validPassword = true;
      });
    } else {
      if (password.length < 8) {
        check = false;
        setState(() {
          errorMsgPassword = "Use 8 characters or more for your password";
          _validPassword = true;
        });
      } else {
        check = true;
        setState(() {
          _validPassword = false;
        });
      }
    }
    if (confirmPassword.isEmpty) {
      check = false;
      setState(() {
        _validConfirmPassword = true;
        errorMsgConfirmPassword = "Confirm Password cannot be empty";
      });
    } else {
      if (password != confirmPassword) {
        check = false;
        setState(() {
          _validConfirmPassword = true;
          errorMsgConfirmPassword = "Those passwords did not match. Try agin";
        });
      } else {
        check = true;
        setState(() {
          _validConfirmPassword = false;
        });
      }
    }

    if (check) {
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
}

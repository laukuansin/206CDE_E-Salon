import 'package:flutter/material.dart';
import 'package:gps_tracking_system/color.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();

  String dateString;
  SettingPage({Key key, @required this.dateString}) : super(key:key); // constructor

}

class _SettingPageState extends State<SettingPage> {
  bool showPassword = false;

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_printDateString);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _printDateString(){
    _controller.text = widget.dateString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 1.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryTextColor,
          ),
          onPressed: () {
            // to do navigation
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 20, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Settings",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 40, //15
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                "assets/images/salon.png",
                              )
                          )
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 60, //35
              ),
              buildTextField("Service Hour", "9am - 6pm"),
              buildTextField("Time Cancel Appointment", "1 day"),
              buildTextFieldForHoliday("Holiday", "24/7/2020"),
              SizedBox(
                height: 50, //35
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlineButton(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {},
                    child: Text("CANCEL",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    color: primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            labelStyle: new TextStyle(
              color: primaryColor,
              //fontWeight: FontWeight.bold,
              fontSize: 22
            ),
            enabledBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(
                    color: Colors.grey
                ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
              //fontWeight: FontWeight.bold,
            )
        ),
      ),
    );
  }

  Widget buildTextFieldForHoliday(
      String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        focusNode: AlwaysDisabledFocusNode(),
        controller: _controller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            labelStyle: new TextStyle(
                color: primaryColor,
                //fontWeight: FontWeight.bold,
                fontSize: 22
            ),
            enabledBorder: new UnderlineInputBorder(
              borderSide: new BorderSide(
                  color: Colors.grey
              ),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/calendar");
              },
              icon: Icon(Icons.calendar_today),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
              //fontWeight: FontWeight.bold,
            )
        ),
      ),
    );
  }

}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Response/CreditResponse.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class HomePageScreen extends StatefulWidget {
  @override
  HomePageScreenState createState() => HomePageScreenState();
}

class HomePageScreenState extends State<HomePageScreen> {
  double creditAmount;
  FToast fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
    getCurrentCredit();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return RouteGenerator.buildScaffold(Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/home_background.png"),
                fit: BoxFit.fill)),
        child: Padding(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Credit Balance",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Text("RM $creditAmount",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold))),
                      RawMaterialButton(
                          onPressed: () {},
                          fillColor: Colors.blue[50],
                          child: Icon(
                            Icons.person_outline,
                            size: 30.0,
                            color: Colors.blue[900],
                          ),
                          padding: EdgeInsets.all(10.0),
                          shape: CircleBorder())
                    ],
                  ),
                ),
                Padding(
                    child: Row(children: [
                      RawMaterialButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed("/topUp");
                          },
                          fillColor: Colors.white,
                          child: Text("+ Reload Credit"),
                          padding: EdgeInsets.only(
                              left: 25, right: 25, top: 15, bottom: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(color: Colors.white)))

                    ]),
                    padding: EdgeInsets.only(top: 20)),
                Padding(
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 20,
                                spreadRadius: 0.1,
                                offset: Offset(8, 10))
                          ],
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                                child: Column(
                                  children: <Widget>[
                                    RawMaterialButton(
                                      child: Icon(MdiIcons.qrcode,
                                          color: primaryColor, size: 50),
                                      onPressed: (){
                                        Navigator.of(context).pushReplacementNamed("/qr_code");

                                      },
                                    )
                                    ,
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text("Pay",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                    )
                                  ],
                                ),
                                padding: EdgeInsets.only(top: 10, bottom: 10)),
                            flex: 5,
                          ),
                          Expanded(
                            child: Padding(
                                child: Column(children: <Widget>[
                                  RawMaterialButton(
                                    child: Icon(MdiIcons.calendarPlus,
                                        color: primaryColor, size: 50),
                                    onPressed: (){
                                      Navigator.of(context).pushReplacementNamed("/add_appointment");

                                    },
                                  )
                                  ,
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Add Appointment",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  )
                                ]),
                                padding: EdgeInsets.only(top: 10, bottom: 10)),
                            flex: 5,
                          )
                        ],
                      ),
                    ),
                    padding: EdgeInsets.only(top: 20)),
                Padding(
                  child: Text("Appointment", style: TextStyle(fontSize: 20)),
                  padding: EdgeInsets.only(top: 30),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            child: Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("31",
                                        style: TextStyleFactory.heading1(
                                            color: dateColor)),
                                    Text("MARCH", style: TextStyleFactory.p())
                                  ],
                                ),
                                Expanded(
                                    child: Padding(
                                        child: Text("Tan Hoe Theng",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        padding: EdgeInsets.only(left: 15))),
                                Padding(
                                  child: Text("Completed",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.greenAccent[700])),
                                  padding: EdgeInsets.only(left: 15),
                                )
                              ],
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                        );
                      }),
                )
              ],
            )))));
  }
  void getCurrentCredit()async
  {
    final ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();
    CreditResponse result=await RestApi.getCredit(3);
    progressDialog.hide();
    if(result.errorCode.error==0)
    {
      setState(() {
        creditAmount=double.parse(result.credit);

      });
    }
    else{
      creditAmount=0.0;
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
}

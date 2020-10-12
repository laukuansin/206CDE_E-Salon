import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/rounded_button.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Utility/RestApi/user_get_customer_credit_response.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
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
    super.initState();
    fToast = FToast();
    fToast.init(context);
    creditAmount = 0.0;
    requestCurrentCustomerCredit();
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
                    Text("Credit Balance", style:TextStyleFactory.heading4(color: primaryLightColor, fontWeight: FontWeight.normal)) ,
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: Text("RM $creditAmount", style: TextStyleFactory.heading1(fontSize: 30, color:primaryLightColor))),
                          RawMaterialButton(
                              onPressed: () {},
                              fillColor: primaryLightColor,
                              child: Icon(
                                Icons.person_outline,
                                size: 30.0,
                                color: primaryColor,
                              ),
                              padding: EdgeInsets.all(10.0),
                              shape: CircleBorder())
                        ],
                      ),
                    ),
                    Padding(
                        child: Row(children: [
                          RoundedButton(
                            press: (){Navigator.of(context).pushNamed("/top_up").then((_) {
                              requestCurrentCustomerCredit();
                            });},
                            text: "+ Reload Credit",
                            horizontalPadding: 25,
                            verticalPadding: 15,
                            fontSize: 12,
                            color: primaryLightColor,
                            textColor: primaryTextColor,
                          )
                        ]),
                        padding: EdgeInsets.only(top: 20)),
                    Padding(
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding( 
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: RaisedButton(
                                    elevation: 0,
                                    color: primaryLightColor,
                                    child: Column(
                                      children: [
                                        Icon(MdiIcons.qrcode, color: primaryColor, size: 40,),
                                        Text("Pay", style: TextStyleFactory.p(),)
                                      ],
                                    ),
                                    onPressed: (){Navigator.of(context).pushNamed("/qr_code").then((_) {
                                      requestCurrentCustomerCredit();
                                    });},
                                  )
                                ),
                                Expanded(
                                  child: RaisedButton(
                                    elevation: 0,
                                    color: primaryLightColor,
                                    child: Column(
                                      children: [
                                        Icon(MdiIcons.calendarPlus, color: primaryColor, size: 40,),
                                        Text("Appointment", style: TextStyleFactory.p(),)
                                      ],
                                    ),
                                    onPressed: (){Navigator.of(context).pushNamed("/choose_service");},
                                  ),
                                )
                              ],
                            ),
                            padding: EdgeInsets.all(10),
                          )
                        ),
                        padding: EdgeInsets.only(top: 20)),
                    Padding(
                      child: Text("Appointment", style: TextStyleFactory.heading3(fontWeight: FontWeight.normal)),
                      padding: EdgeInsets.only(top: 20),
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
                                child: ListTile(
                                  leading: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("31",
                                              style: TextStyleFactory.heading1(
                                                  color: dateColor)),
                                          Text("MAR", style: TextStyleFactory.p())
                                        ],
                                    ),
                                    title: Text("Tan Hoe Theng"),
                                    trailing: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.done, color: Colors.greenAccent,),
                                        Text("Accepted",style: TextStyleFactory.p(color: Colors.greenAccent),)
                                      ],
                                    ),
                                ),
                                padding: EdgeInsets.all(10),
                              ),
                            );
                          }),
                    )
              ],
            )))));
  }

  void requestCurrentCustomerCredit()async
  {
    final ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();
    CustomerCreditResponse result=await RestApi.customer.getCustomerCredit();
    progressDialog.hide();

    if(result.response.status == 1)
    {
      setState(() {
        creditAmount = result.credit;
      });
    }
    else{
      creditAmount = 0.0;
      fToast.showToast(child: ToastWidget(
        status: result.response.status,
        msg: result.response.msg,
      ));
    }
  }

}

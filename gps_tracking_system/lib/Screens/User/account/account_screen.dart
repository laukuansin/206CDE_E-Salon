import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/customer_detail_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/logout_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:gps_tracking_system/Components/toast_widget';

class AccountScreen extends StatefulWidget {
  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  FToast fToast;
  String name, contactNo, email;

  @override
  void initState() {
    super.initState();
    getCustomerDetail();

    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return RouteGenerator.buildScaffold(
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/home_background.png"),
                  fit: BoxFit.fill)),
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  child: Container(
                      width: size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]),
                          color: Colors.white),
                      child: Padding(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(5),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  child: Text("Name: $name",
                                      style: TextStyleFactory.p(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  padding: EdgeInsets.only(bottom: 10)),
                              Padding(
                                  child: Text("Contact No: $contactNo",
                                      style: TextStyleFactory.p(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  padding: EdgeInsets.only(bottom: 10)),
                              Padding(
                                  child: Text("Email: $email",
                                      style: TextStyleFactory.p(
                                          fontWeight: FontWeight.bold)),
                                  padding: EdgeInsets.only(bottom: 10))
                            ],
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Icon(Icons.person,
                                size: 40, color: primaryColor),
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                      )),
                  padding: EdgeInsets.all(20)),
              Padding(
                  child: Container(
                      margin: EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]),
                          color: Colors.white),
                      width: size.width,
                      child: Padding(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                child: ListTile(
                                  onTap: (){
                                    Navigator.of(context).pushNamed("/edit_info").then((_){
                                      getCustomerDetail();
                                    });;
                                  },
                                  contentPadding: EdgeInsets.all(5),
                                  title: Text("Edit your account info",
                                      style: TextStyleFactory.p(
                                          fontWeight: FontWeight.normal)),
                                  leading: Icon(Icons.edit),
                                ),
                                padding: EdgeInsets.all(0)),
                            Padding(
                                child:
                                    Divider(color: Colors.grey[500], height: 0),
                                padding: EdgeInsets.only(top: 0, bottom: 0)),
                            Padding(
                                child: ListTile(
                                  onTap: ()
                                    {
                                      Navigator.of(context).pushNamed("/change_password");
                                    },
                                    contentPadding: EdgeInsets.all(5),
                                    title: Text("Change your password",
                                        style: TextStyleFactory.p(
                                          fontWeight: FontWeight.normal,
                                        )),
                                    leading: Icon(Icons.lock)),
                                padding: EdgeInsets.all(0)),
                          ],
                        ),
                        padding: EdgeInsets.only(left: 15, right: 15),
                      )),
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10)),
              GestureDetector(
                child:Padding(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]),
                          color: Colors.red),
                      width: size.width,
                      child: Padding(
                        child:  Text("Logout",
                            textAlign: TextAlign.center,
                            style: TextStyleFactory.p(
                                fontWeight: FontWeight.normal,
                                color: Colors.white)),
                        padding: EdgeInsets.all(15),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 20, right: 20)) ,
                onTap: logout,
              )
              ,
            ],
          ),
        ),
        appbar: AppBar(
          title: Text(
            "Account",
            style: TextStyleFactory.p(color: primaryTextColor),
          ),
        ));
  }

  void getCustomerDetail() async {
    final ProgressDialog progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();
    CustomerDetailResponse result = await RestApi.customer.getCustomerDetail();
    progressDialog.hide();

    if (result.response.status == 1) {
      setState(() {
        name = result.detail.name;
        contactNo = result.detail.contactNo;
        email = result.detail.email;
      });
    } else {
      name = "";
      contactNo = "";
      email = "";
      fToast.showToast(
          child: ToastWidget(
        status: result.response.status,
        msg: result.response.msg,
      ));
    }
  }

  void logout() async {
    LogoutResponse result = await RestApi.customer.logout();
    if (result.response.status == 1) {

      setState(() {
       Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      });
    } else {
      fToast.showToast(
          child: ToastWidget(
        status: result.response.status,
        msg: result.response.msg,
      ));
    }
  }
}

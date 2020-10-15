import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/Utility/RestApi/user_detail_response.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/toast_widget';


class AccountPageScreen extends StatefulWidget {
  @override
  AccountPageScreenState createState() => AccountPageScreenState();
}

class AccountPageScreenState extends State<AccountPageScreen> {
  String name,role,email;
  FToast fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
    getUserDetail();
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("My Account", style: TextStyleFactory.heading1(color: primaryLightColor, fontSize: 30),),
          Padding(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    side: BorderSide(color: primaryDeepLightColor)),
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
                          child: Text("Role: $role",
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
                  leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: 40, color: primaryColor)
                      ]),
                ),
                // padding: EdgeInsets.all(10),
              ),
              padding: EdgeInsets.all(20)),
          Padding(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    side: BorderSide(color: primaryDeepLightColor)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed("/edit_info")
                            .then((_) {
                          getUserDetail();
                        });
                      },
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      title: Text("Edit your account info",
                          style: TextStyleFactory.p()),
                      leading: Icon(Icons.edit),
                    ),
                    Divider(color: primaryDeepLightColor, height: 0),
                    ListTile(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed("/change_password");
                        },
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        title: Text("Change your password",
                            style: TextStyleFactory.p(
                              fontWeight: FontWeight.normal,
                            )),
                        leading: Icon(Icons.lock)),
                  ],
                ),
              ),
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10))
        ],
      ),
    ),
       appbar: AppBar(
         backgroundColor: Color(0xFF65CBF2),
         elevation: 0,
         iconTheme: IconThemeData(
             color: primaryLightColor
         ),
       ),
      drawer: RouteGenerator.buildDrawer(context)
    );
  }
  void getUserDetail()async
  {
    UserDetailResponse result = await RestApi.admin.getUserDetail();
    if (result.response.status == 1) {
      setState(() {
        name = result.detail.name;
        role = result.detail.role;
        email = result.detail.email;
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
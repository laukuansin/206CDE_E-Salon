import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/logged_user.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/user_get_customer_credit_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gps_tracking_system/Components/toast_widget';

class QRCodePaymentScreen extends StatefulWidget {
  QRCodePaymentScreenState createState() => QRCodePaymentScreenState();
}

class QRCodePaymentScreenState extends State<QRCodePaymentScreen> {
  double _creditAmount;
  FToast fToast;
  String userToken="";

  @override
  void initState() {
    super.initState();
    _creditAmount = 0.0;
    fToast = FToast();
    fToast.init(context);
    requestCustomerCreditToken();
  }

  @override
  Widget build(BuildContext context) {
    return RouteGenerator.buildScaffold(
     Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]),
              borderRadius: BorderRadius.circular(10.0)),
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                child: QrImage(
                  data:
                      userToken,
                  version: QrVersions.auto,
                  size: 250,
                  gapless: false,
                ),
                padding: EdgeInsets.all(10),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: Text("Scan the QR Code to Pay", style: TextStyleFactory.p(color: primaryTextColor),),
              ),
              Container(
                color: Colors.grey[200],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                          child: Text("Credit Balance",style:TextStyleFactory.p()),
                          padding: EdgeInsets.all(10)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("RM$_creditAmount", style: TextStyleFactory.p(color: primaryTextColor),),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      appbar: AppBar(
          elevation: 1,
          title: Text(
          "Pay", style: TextStyleFactory.p(color: primaryTextColor),
      )),
    );
  }

  void requestCustomerCreditToken()async
  {
    final ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();
    CustomerCreditResponse result=await RestApi.customer.getCustomerCreditToken();
    progressDialog.hide();
    if(result.response.status == 1)
    {
      setState(() {
        String token=result.token.customerToken;
        userToken='{"token":"$token"}';
        _creditAmount= result.credit;
      });
    }
    else{
      _creditAmount = 0.0;
      fToast.showToast(child: ToastWidget(
        status: result.response.status,
        msg: result.response.msg,
      ));
    }
  }

}

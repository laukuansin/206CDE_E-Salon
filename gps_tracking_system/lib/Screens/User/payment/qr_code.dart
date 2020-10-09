import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Response/CreditResponse.dart';
import 'package:gps_tracking_system/Utility/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeScreen extends StatefulWidget {
  QrCodeScreenState createState() => QrCodeScreenState();
}

class QrCodeScreenState extends State<QrCodeScreen> {
  double creditAmount;
  FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    callCreditAPI();
  }

  @override
  Widget build(BuildContext context) {
    // debugPaintSizeEnabled = true;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text(
            "Pay",
            style: TextStyleFactory.p(color: primaryTextColor),
          )),
      body: Align(
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
                      'KCBbdXNlcl9pZF0gPT4gMyBbZW1haWxdID0+IGxhdWt1YW5zaW5AZ21haWwuY29tIFtwYXNzd29yZF0gPT4gbGF1a3VhbnNpbiAp',
                  version: QrVersions.auto,
                  size: 250,
                  gapless: false,
                ),
                padding: EdgeInsets.all(10),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  "Scan the QR Code to Pay",
                ),
              ),
              Container(
                color: Colors.grey[200],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                          child: Text("Credit Balance",style: TextStyle(color: Colors.black54)),
                          padding: EdgeInsets.all(10)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("RM$creditAmount"),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void callCreditAPI()async
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

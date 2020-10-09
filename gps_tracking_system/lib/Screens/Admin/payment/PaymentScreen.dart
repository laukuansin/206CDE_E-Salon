import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class PaymentScreen extends StatefulWidget {
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  TextEditingController _controller = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double paymentAmount;
  String qrCodeData = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentAmount = 0;
    qrCodeData = "";
  }

  @override
  Widget build(BuildContext context) {
    return RouteGenerator.buildScaffold(
      Container(child:   Column(
        children: <Widget>[
          Expanded(
              child: Container(
                color: Colors.white,
                child: Form(
                  child: ListTile(
                    title: _buildAmountField(),
                  ),
                  key: _formKey,
                ),
              )),
          Text(qrCodeData),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              padding: EdgeInsets.all(10),
              onPressed: payment,
              color: primaryColor,
              child: Text(
                "PAY",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      )) ,
        appbar:AppBar(
        title: Text("Payment",
        style: TextStyleFactory.p(color: primaryTextColor)))

    );
  }

  TextFormField _buildAmountField() {
    return TextFormField(
      controller: _controller,
      validator: (value) {
        if (value.isEmpty) {
          return "Please do not leave blank";
        }
        return null;
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        WhitelistingTextInputFormatter(RegExp(r'^(\d+)?\.?\d{0,2}')),
      ],
      decoration: new InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 1.0)),
          suffix: IconButton(
            icon: Icon(Icons.close),
            onPressed: removeAmount,
            iconSize: 18,
            alignment: Alignment.center,
          ),
          errorMaxLines: 2,
          icon: Icon(
            Icons.attach_money,
            color: primaryColor,
          ),
          labelText: "Payment Amount",
          labelStyle: TextStyleFactory.p()),
      onChanged: (text) {
        setState(() {
          if (text.isEmpty) {
            paymentAmount = 0;
          } else {
            paymentAmount = double.parse(text);
          }
        });
      },
      onSaved: (value) {
        paymentAmount = double.parse(value);
      },
    );
  }

  void removeAmount() {
    setState(() {
      _controller.clear();
      FocusScope.of(context).unfocus();
      paymentAmount = 0;
    });
  }

  void payment() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState.validate()) {
      {
        _scan();
      }
      return;
    }
    _formKey.currentState.save();
  }

  Future _scan() async {
    final ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();
    String barcode = await scanner.scan();
    progressDialog.hide();

    setState(() {
      this.qrCodeData = barcode;
    });
  }
}

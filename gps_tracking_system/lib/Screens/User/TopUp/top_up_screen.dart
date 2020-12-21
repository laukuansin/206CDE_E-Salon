import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/common_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:progress_dialog/progress_dialog.dart';

class TopUpScreen extends StatefulWidget {
  TopUpScreenState createState() => TopUpScreenState();
}

class TopUpScreenState extends State<TopUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textCreditEditingController =
      new TextEditingController();
  double _creditAmount;
  FToast fToast;

  @override
  void initState() {
    super.initState();
    _creditAmount = 0;
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return RouteGenerator.buildScaffold(
      Container(
        color: primaryBgColor,
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            Container(
                decoration: BoxDecoration(color: primaryLightColor),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text("Top Up Amount(RM)",
                                style: TextStyleFactory.heading6()),
                          ),
                          Text("Minimum Amount: RM10",
                              style: TextStyleFactory.p())
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20,),
                        child: _buildAmountField(),
                      )
                    ],
                  ),
                )),
            Expanded(child: SizedBox()),
            Container(
              padding: EdgeInsets.zero,
              width: screenSize.width,
              height: 60,
              color: primaryLightColor,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child:Align(
                      child: Padding(
                          child: RichText(
                            text: TextSpan(
                                style: TextStyleFactory.heading5(),
                                children: <TextSpan>[
                                  TextSpan(text: "Top Up(RM): "),
                                  TextSpan(
                                      text: _creditAmount.toStringAsFixed(2),
                                      style: TextStyleFactory.heading5(
                                          color: primaryColor)),
                                ]),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10)),
                      alignment: Alignment.centerLeft,
                    )
                  ),
                  Expanded(
                    flex:1,
                    child: FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      color: primaryColor,
                      child: Text("Top Up",
                          style: TextStyleFactory.heading4(
                          color: primaryLightColor)),
                      onPressed: topUpCredit,
                    )
                  )
                ],
              ),
            )
          ]),
        ),
      ),
      appbar: AppBar(
          elevation: 2,
          title: Text(
            "Top Up",
            style: TextStyleFactory.p(color: primaryTextColor),
          )),
    );
  }

  void topUpCredit() {
    FocusScope.of(context).unfocus();

    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      requestTopUpCustomerCredit();
      return;
    }
  }

  TextFormField _buildAmountField() {
    return TextFormField(
      controller: _textCreditEditingController,
      validator: (_) => (_creditAmount < 10 || _creditAmount > 3000) ? "Please enter a number between RM 10.00 and RM3,000.00":null,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [WhitelistingTextInputFormatter(RegExp(r'^(\d+)?\.?\d{0,2}')),],
      decoration: new InputDecoration(
          contentPadding: EdgeInsets.all(8),
          suffix: IconButton(
            icon: Icon(Icons.close),
            onPressed: removeCreditAmount,
            iconSize: 18,
            alignment: Alignment.center,
          ),
          errorMaxLines: 2,
          hintText: "Enter top up amount",
          border: OutlineInputBorder(
            borderSide: BorderSide(),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 1.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          )),
      onChanged: (text) {
        setState(() {
          if (text.isEmpty) {
            _creditAmount = 0;
          } else {
            _creditAmount = double.parse(text);
          }
        });
      },
      onSaved: (value) {
        _creditAmount = double.parse(value);
      },
    );
  }

  void requestTopUpCustomerCredit() async {
    final ProgressDialog progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();
    CommonResponse result = await RestApi.customer.topUpCustomerCredit(_creditAmount);
    progressDialog.hide();

    fToast.showToast(
        child: ToastWidget(
      status: result.response.status,
      msg: result.response.msg,
    ));

    if(result.response.status == 1)
      Navigator.pop(context);
  }

  void removeCreditAmount() {
    setState(() {
      _textCreditEditingController.clear();
      FocusScope.of(context).unfocus();
      _creditAmount = 0;
    });
  }
}

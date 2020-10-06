import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Response/TopUpResponse.dart';
import 'package:gps_tracking_system/Utility/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:progress_dialog/progress_dialog.dart';

class TopUpScreen extends StatefulWidget {
  TopUpScreenState createState() => TopUpScreenState();
}

class TopUpScreenState extends State<TopUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controller=new TextEditingController();
  double amount;
  FToast fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amount = 0;
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: Text(
              "Top Up",
              style: TextStyleFactory.p(color: primaryTextColor),
            )),
        body: Container(
          color: Colors.grey[100],
          child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text("Top Up Amount(RM)",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)
                                ),
                              ),
                              Text("Minimum Amount: RM10",
                                  style: TextStyle(color: Colors.grey[500]))
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 40),
                            child: _buildAmountField(),
                          )
                        ],
                      ),
                    )
              ),
              Expanded(child: SizedBox()),
              Container(
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                      child: Row(
                        children: <Widget>[
                          Text("Top Up(RM): ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)
                          ),
                          Padding(
                            child: Text("$amount",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)
                            ),
                            padding: EdgeInsets.only(left: 10),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(20),
                    )),
                    SizedBox(
                      height: 65,
                      width: 150,
                        child: RaisedButton(
                        color: primaryColor,
                        child: Text("Top Up",
                            style: TextStyle(color: Colors.white, fontSize: 20)),
                        onPressed: topUp,
                    )
                    )
                  ],
                ),
              )
            ]
            ),
          ),
        )
    );
  }

  void topUp() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState.validate()) {
      topUpApiCall();
      return;
    }
    _formKey.currentState.save();
  }

  TextFormField _buildAmountField() {
    return TextFormField(

      controller: _controller,
      validator: (value) {
        double _amount=double.parse(value);
        if (value.isEmpty||_amount<10||_amount>3000) {
          return "Please enter a number between RM 10.00 and RM3,000.00";
        }
        return null;
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        WhitelistingTextInputFormatter(RegExp(r'^(\d+)?\.?\d{0,2}')),
      ],
      decoration: new InputDecoration(
          contentPadding: EdgeInsets.all(8),
          suffix:IconButton(icon: Icon(Icons.close),onPressed: removeAmount,iconSize: 18,alignment: Alignment.center,),
      errorMaxLines: 2,
          hintText: "Enter top up amount",
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[500]),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 1.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          )
      ),
      onChanged: (text)
      {
        setState(() {
          if(text.isEmpty)
            {
              amount=0;
            }
          else{
            amount= double.parse(text);
          }
        });
      },
      onSaved: (value) {
            amount = double.parse(value);
      },
    );
  }
  void topUpApiCall() async
  {
    final ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();
    TopUpResponse result=await RestApi.topUp(1, amount);
    progressDialog.hide();
    if(result.errorCode.error==0)
    {
      successMessage(result.errorCode.msj);
    }
    else{
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

  void successMessage(String scsMsg) {
    Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.greenAccent),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.check, color: Colors.white),
          SizedBox(width: 12.0),
          Expanded(
              child: Text(scsMsg,
                  style: TextStyle(color: Colors.white, fontSize: 12)))
        ]));
    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        gravity: ToastGravity.BOTTOM);
  }
  void removeAmount()
  {
    setState(() {
      _controller.clear();
      FocusScope.of(context).unfocus();
      amount=0;
    });
  }
}

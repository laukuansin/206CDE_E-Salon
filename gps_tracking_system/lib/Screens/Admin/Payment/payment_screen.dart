import 'dart:developer';

import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Components/toast_widget';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/appointment.dart';
import 'package:gps_tracking_system/Model/service.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/common_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/admin_payment_detail_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/admin_qr_code_data.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:skeleton_text/skeleton_text.dart';

class PaymentScreen extends StatefulWidget {
  final Appointment _appointment;
  final List<Service> _serviceList;

  PaymentScreen(Map<String,dynamic> argument):_appointment=argument["appointment"], _serviceList = argument["services"];
  PaymentScreenState createState() => PaymentScreenState(this._appointment, this._serviceList);
}

class PaymentScreenState extends State<PaymentScreen> {
  FToast _fToast;
  final Appointment appointment;
  final List<Service> _serviceList;
  Customer _customerDetail;


  PaymentScreenState(this.appointment, this._serviceList);

  @override
  void initState() {
    super.initState();
    _fToast = FToast();
    _fToast.init(context);
    requestGetAppointmentDetail();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return RouteGenerator.buildScaffold(
        Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                //height: size.height,
                color: Colors.grey[100],
                child: Column(
                  children: <Widget>[
                    _buildCustomerDetail(size),
                    _buildServiceSummary(size)
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text("Total",
                              style: TextStyleFactory.p(
                                  fontWeight: FontWeight.bold)),
                        ),
                        Text("RM  ${_calcTotalPrice().toStringAsFixed(2)}",
                            style: TextStyleFactory.p(
                                fontWeight: FontWeight.bold,
                                color: primaryColor))
                      ],
                    ),
                    Padding(
                      child: SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          padding: EdgeInsets.all(10),
                          onPressed: () {
                            _scan();
                          },
                          color: primaryColor,
                          child: Text(
                            "PAY",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      padding: EdgeInsets.only(top: 20),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        appbar: AppBar(
            title: Text("Payment",
                style: TextStyleFactory.p(color: primaryTextColor))));
  }

  Container _buildCustomerDetail(Size size) {
    Function() skeletonMaker = () => SkeletonAnimation(
          child: Container(
            height: 15,
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[300]),
          ),
        );

    return Container(
        color: primaryLightColor,
        padding: EdgeInsets.only(bottom: 16),
        child: Column(children: [
          ListTile(
            dense: true,
            title: Text("Customer  Detail",
                style: TextStyleFactory.p(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            dense: true,
            leading: Icon(
              Icons.person,
              color: primaryColor,
            ),
            title: _customerDetail == null
                ? skeletonMaker()
                : Text(_customerDetail.customerName),
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.contact_phone, color: primaryColor),
            title: _customerDetail == null
                ? skeletonMaker()
                : Text(_customerDetail.contactNo),
          ),
          ListTile(
            dense: true,
            leading: Icon(
              Icons.date_range,
              color: primaryColor,
            ),
            title: _customerDetail == null
                ? skeletonMaker()
                : Text(DateFormat("yyyy-MM-dd hh:mm a").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(_customerDetail.date))),
          ),
          ListTile(
            dense: true,
            leading: Icon(
              Icons.location_on,
              color: primaryColor,
            ),
            title: _customerDetail == null
                ? skeletonMaker()
                : Text(_customerDetail.location),
          )
        ]));
  }

  Container _buildServiceSummary(Size size) {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: Text("Service Summary",
                style: TextStyleFactory.p(fontWeight: FontWeight.bold)),
            trailing: RawMaterialButton(
              child: Text("Add Service",
                  style: TextStyleFactory.p(
                      fontWeight: FontWeight.bold, color: primaryColor)),
              onPressed: () {
                Navigator.of(context).pushNamed("/add_service", arguments: _serviceList).then((_) {setState(() {

                });});
              },
            ),
          ),
          Container(
              width: size.width,
              color: primaryLightColor,
              child: Padding(
                child: _buildDataTable(),
                padding: EdgeInsets.all(10),
              ))
        ],
      ),
    );
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    if(barcode == null) return;

    try {
      QrCodeData data = qrCodeDataFromJson(barcode) ?? null;
      requestPayment(data.token);
    } on Exception catch (_) {
      _fToast.showToast(
          child: ToastWidget(
        status: -1,
        msg: "Invalid QR Code",
      ));
    }
  }

  void requestPayment(String token) async {
    CommonResponse result = await RestApi.admin.scanQRCode(token, appointment.appointmentId, _serviceList);
    if(result.response.status==1)
    {
      Navigator.of(context).pop(1);
    }
    _fToast.showToast(
        child: ToastWidget(
          status: result.response.status,
          msg: result.response.msg,
        ));
  }

  void requestGetAppointmentDetail() async {
    final ProgressDialog progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    await progressDialog.show();
    PaymentDetailResponse result = await RestApi.admin.getPaymentDetail(appointment.appointmentId);
    progressDialog.hide();

    if (result.response.status == 1) {
      setState(() {
        _customerDetail = result.customer;
      });
    } else {
      _fToast.showToast(
          child: ToastWidget(
        status: result.response.status,
        msg: result.response.msg,
      ));
    }
  }

  DataTable _buildDataTable() {
    Size size = MediaQuery.of(context).size;
    const MARGIN = 16.0;
    List<DataRow> dataRow = [];

    if (_serviceList.isNotEmpty)
      _serviceList.forEach((element) {
        if (element.quantity > 0)
          dataRow.add(DataRow(cells: [
            DataCell(Container(
                width: (size.width - MARGIN * 2) * 0.4,
                child: Text(element.serviceName))),
            DataCell(Container(
              width: (size.width - MARGIN * 2) * 0.4,
              child: Align(
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.remove,
                            size: 14,
                          ),
                          onPressed: () {
                            setState(() {
                              if (element.quantity > 0) element.quantity--;
                            });
                          },
                        ),
                        Text(element.quantity.toString()),
                        IconButton(
                          icon: Icon(Icons.add, size: 14),
                          onPressed: () {
                            setState(() {
                              element.quantity++;
                            });
                          },
                        ),
                      ])),
            )),
            DataCell(Container(
                width: (size.width - MARGIN * 2) * 0.2,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        (element.servicePrice * element.quantity).toStringAsFixed(2)))))
          ]));
      });

    dataRow.add(DataRow(cells: [
      DataCell(
        SizedBox(width: (size.width - MARGIN * 2) * 0.4),
      ),
      DataCell(Container(
          width: (size.width - MARGIN * 2) * 0.4,
          child: Align(
              alignment: Alignment.center,
              child: Text(
                "Total Price",
                style: TextStyleFactory.heading6(),
              )))),
      DataCell(Container(
          width: (size.width - MARGIN * 2) * 0.2,
          child: Align(
              alignment: Alignment.centerRight, child: Text(_calcTotalPrice().toStringAsFixed(2)))))
    ]));

    return DataTable(
        horizontalMargin: MARGIN,
        columnSpacing: 0,
        columns: [
          DataColumn(
              label: Container(
                  width: (size.width - MARGIN * 2) * 0.4,
                  child: Text(
                    "Service",
                    style: TextStyleFactory.p(),
                  ))),
          DataColumn(
              label: Container(
                  width: (size.width - MARGIN * 2) * 0.4,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Qty",
                        style: TextStyleFactory.p(),
                      )))),
          DataColumn(
              label: Container(
                  width: (size.width - MARGIN * 2) * 0.2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Sub(RM)",
                      style: TextStyleFactory.p(),
                    ),
                  ))),
        ],
        rows: dataRow);
  }

  double _calcTotalPrice() {
    double totalPrice = 0.0;
    _serviceList.forEach((element) {
      totalPrice += element.servicePrice * element.quantity;
    });
    return totalPrice;
  }
}

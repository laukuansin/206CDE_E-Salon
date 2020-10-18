import 'dart:convert';

import 'package:gps_tracking_system/Model/service.dart';


PaymentDetailResponse paymentDetailResponseFromJson(String str) => PaymentDetailResponse.fromJson(json.decode(str));

String paymentDetailResponseToJson(PaymentDetailResponse data) => json.encode(data.toJson());

class PaymentDetailResponse {
  PaymentDetailResponse({
    this.customer,
    this.service,
    this.response,
  });

  Customer customer;
  List<Service> service;
  Response response;

  factory PaymentDetailResponse.fromJson(Map<String, dynamic> json) => PaymentDetailResponse(
    customer: Customer.fromJson(json["customer"]),
    service: List<Service>.from(json["service"].map((x) => Service.fromJson(x))),
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "customer": customer.toJson(),
    "service": List<dynamic>.from(service.map((x) => x.toJson())),
    "response": response.toJson(),
  };
}

class Customer {
  Customer({
    this.customerName,
    this.contactNo,
    this.date,
    this.location,
  });

  String customerName;
  String contactNo;
  String date;
  String location;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    customerName: json["customer_name"],
    contactNo: json["contact_no"],
    date: json["date"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "customer_name": customerName,
    "contact_no": contactNo,
    "date": date,
    "location": location,
  };
}

class Response {
  Response({
    this.status,
    this.msg,
  });

  int status;
  String msg;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    status: json["status"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
  };
}



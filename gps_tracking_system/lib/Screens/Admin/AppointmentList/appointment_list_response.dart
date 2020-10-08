import 'dart:convert';

import 'package:intl/intl.dart';

AppointmentListResponse appointmentListResponseFromJson(String str) => AppointmentListResponse.fromJson(json.decode(str));

String appointmentListResponseToJson(AppointmentListResponse data) => json.encode(data.toJson());

class AppointmentListResponse {
  AppointmentListResponse({
    this.response,
    this.appointments,
  });

  Response response;
  List<Appointment> appointments;

  factory AppointmentListResponse.fromJson(Map<String, dynamic> json) => AppointmentListResponse(
    response: Response.fromJson(json["response"]),
    appointments:json['appointments'] == null? null:  List<Appointment>.from(json["appointments"].map((x) => Appointment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "response": response.toJson(),
    "appointments": List<dynamic>.from(appointments.map((x) => x.toJson())),
  };
}

class Appointment {
  Appointment({
    this.appointmentId,
    this.customerName,
    this.workerName,
    this.telephone,
    this.address,
    this.status,
    this.appointmentDate,
    this.appointmentTime,
    this.services,
  });

  String appointmentId;
  String customerName;
  String workerName;
  String telephone;
  String address;
  String status;
  String appointmentDate;
  String appointmentTime;
  String services;

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    appointmentId: json["appointment_id"],
    customerName: json["customer_name"],
    workerName: json["worker_name"],
    telephone: json["telephone"],
    address: json["address"],
    status: json["status"],
    appointmentDate: json["appointment_date"],
    services: json["services"],
  );

  Map<String, dynamic> toJson() => {
    "appointment_id": appointmentId,
    "customer_name": customerName,
    "worker_name": workerName,
    "telephone": telephone,
    "address": address,
    "status": status,
    "appointment_date": appointmentDate,
    "services": services,
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

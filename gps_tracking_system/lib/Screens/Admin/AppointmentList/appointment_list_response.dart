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
  static final DateFormat dateParser     = DateFormat("yyyy-MM-dd hh:mmaa");
  static final DateFormat dayDateMonthFormatter  = DateFormat("E MMM dd");
  static final DateFormat dayFormatter  = DateFormat("E");
  static final DateFormat dateFormatter  = DateFormat("dd");
  static final DateFormat timeFormatter  = DateFormat().add_jm();

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
  DateTime appointmentDate;
  String appointmentTime;
  String services;

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    appointmentId: json["appointment_id"],
    customerName: json["customer_name"],
    workerName: json["worker_name"],
    telephone: json["telephone"],
    address: json["address"],
    status: json["status"],
    appointmentDate: dateParser.parse(json["appointment_date"].toString().toUpperCase()),
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

  String getAppointmentDateStringEMMMDD() => dayDateMonthFormatter.format(appointmentDate);
  String getAppointmentDateStringJM() => timeFormatter.format(appointmentDate);
  String getAppointmentDateStringDay() => dayFormatter.format(appointmentDate);
  String getAppointmentDateStringDate() => dateFormatter.format(appointmentDate);
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

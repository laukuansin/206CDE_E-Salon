import 'dart:convert';
import 'package:gps_tracking_system/Model/appointment.dart';


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

enum ServiceAttr{
  PRICE,
  QTY,
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

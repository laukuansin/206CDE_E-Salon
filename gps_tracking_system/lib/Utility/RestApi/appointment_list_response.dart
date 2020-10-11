import 'dart:convert';

AppointmentListResponse appointmentListResponseFromJson(String str) => AppointmentListResponse.fromJson(json.decode(str));

String appointmentListResponseToJson(AppointmentListResponse data) => json.encode(data.toJson());

class AppointmentListResponse {
  AppointmentListResponse({
    this.list,
    this.response,
  });

  List<Appointment> list;
  Response response;

  factory AppointmentListResponse.fromJson(Map<String, dynamic> json) => AppointmentListResponse(
    list: List<Appointment>.from(json["list"].map((x) => Appointment.fromJson(x))),
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
    "response": response.toJson(),
  };
}

class Appointment {
  Appointment({
    this.appointmentId,
    this.date,
    this.year,
    this.month,
    this.day,
    this.status,
    this.workerName,
  });

  int appointmentId;
  DateTime date;
  String year;
  String month;
  String day;
  String status;
  String workerName;

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    appointmentId: json["appointment_id"],
    date: DateTime.parse(json["date"]),
    year: json["year"],
    month: json["month"],
    day: json["day"],
    status: json["status"],
    workerName: json["worker_name"],
  );

  Map<String, dynamic> toJson() => {
    "appointment_id": appointmentId,
    "date": date.toIso8601String(),
    "year": year,
    "month": month,
    "day": day,
    "status": status,
    "worker_name": workerName,
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
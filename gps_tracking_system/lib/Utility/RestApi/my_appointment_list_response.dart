import 'dart:convert';

MyAppointmentListResponse myAppointmentListResponseFromJson(String str) => MyAppointmentListResponse.fromJson(json.decode(str));

String myAppointmentListResponseToJson(MyAppointmentListResponse data) => json.encode(data.toJson());

class MyAppointmentListResponse {
  MyAppointmentListResponse({
    this.list,
    this.response,
  });

  List<Appointment> list;
  Response response;

  factory MyAppointmentListResponse.fromJson(Map<String, dynamic> json) => MyAppointmentListResponse(
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
    this.time,
    this.day,
    this.status,
    this.serviceName,
  });

  int appointmentId;
  DateTime date;
  String year;
  String month;
  String time;
  String day;
  String status;
  String serviceName;

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    appointmentId: json["appointment_id"],
    date: DateTime.parse(json["date"]),
    year: json["year"],
    month: json["month"],
    time: json["time"],
    day: json["day"],
    status: json["status"],
    serviceName: json["service_name"],
  );

  Map<String, dynamic> toJson() => {
    "appointment_id": appointmentId,
    "date": date.toIso8601String(),
    "year": year,
    "month": month,
    "time": time,
    "day": day,
    "status": status,
    "service_name": serviceName,
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
import 'dart:convert';

ManageAppointmentResponse manageAppointmentResponseFromJson(String str) => ManageAppointmentResponse.fromJson(json.decode(str));

String manageAppointmentResponseToJson(ManageAppointmentResponse data) => json.encode(data.toJson());

class ManageAppointmentResponse {
  ManageAppointmentResponse({
    this.list,
    this.response,
  });

  List<Appointment> list;
  Response response;

  factory ManageAppointmentResponse.fromJson(Map<String, dynamic> json) => ManageAppointmentResponse(
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
    this.workerName,
    this.customerName,
    this.serviceName,
  });

  int appointmentId;
  DateTime date;
  String year;
  String month;
  String time;
  String day;
  String status;
  String workerName;
  String customerName;
  String serviceName;
  bool selected=false;

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    appointmentId: json["appointment_id"],
    date: DateTime.parse(json["date"]),
    year: json["year"],
    month: json["month"],
    time: json["time"],
    day: json["day"],
    status: json["status"],
    workerName: json["worker_name"],
    customerName: json["customer_name"],
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
    "worker_name": workerName,
    "customer_name": customerName,
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
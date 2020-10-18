import 'dart:convert';

AppointmentLogResponse appointmentLogResponseFromJson(String str) => AppointmentLogResponse.fromJson(json.decode(str));

String appointmentLogResponseToJson(AppointmentLogResponse data) => json.encode(data.toJson());

class AppointmentLogResponse {
  AppointmentLogResponse({
    this.log,
    this.response,
  });

  List<Log> log;
  Response response;

  factory AppointmentLogResponse.fromJson(Map<String, dynamic> json) => AppointmentLogResponse(
    log: json['log'] != null? List<Log>.from(json["log"].map((x) => Log.fromJson(x))) : [],
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "log": List<dynamic>.from(log.map((x) => x.toJson())),
    "response": response.toJson(),
  };
}

class Log {
  Log({
    this.dateTime,
    this.activity,
  });

  DateTime dateTime;
  String activity;

  factory Log.fromJson(Map<String, dynamic> json) => Log(
    dateTime: DateTime.parse(json["date_time"]),
    activity: json["activity"],
  );

  Map<String, dynamic> toJson() => {
    "date_time": dateTime.toIso8601String(),
    "activity": activity,
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
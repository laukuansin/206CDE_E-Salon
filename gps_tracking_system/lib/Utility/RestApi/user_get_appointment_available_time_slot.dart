import 'dart:convert';

GetAppointmentAvailableTimeslotResponse getAppointmentAvailableTimeslotResponseFromJson(String str) => GetAppointmentAvailableTimeslotResponse.fromJson(json.decode(str));

String getAppointmentAvailableTimeslotResponseToJson(GetAppointmentAvailableTimeslotResponse data) => json.encode(data.toJson());

class GetAppointmentAvailableTimeslotResponse {
  GetAppointmentAvailableTimeslotResponse({
    this.timeline,
    this.response,
  });

  List<String> timeline;
  Response response;

  factory GetAppointmentAvailableTimeslotResponse.fromJson(Map<String, dynamic> json) => GetAppointmentAvailableTimeslotResponse(
    timeline: json['timeline'] == null ? [] : List<String>.from(json["timeline"].map((x) => x)),
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "timeline": List<dynamic>.from(timeline.map((x) => x)),
    "response": response.toJson(),
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

import 'dart:convert';

MakeAppointmentResponse makeAppointmentResponseFromJson(String str) => MakeAppointmentResponse.fromJson(json.decode(str));

String makeAppointmentResponseToJson(MakeAppointmentResponse data) => json.encode(data.toJson());

class MakeAppointmentResponse {
  MakeAppointmentResponse({
    this.response,
  });

  Response response;

  factory MakeAppointmentResponse.fromJson(Map<String, dynamic> json) => MakeAppointmentResponse(
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
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

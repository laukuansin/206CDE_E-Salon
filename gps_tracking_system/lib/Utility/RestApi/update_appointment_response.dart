import 'dart:convert';

UpdateAppointmentResponse updateAppointmentResponseFromJson(String str) => UpdateAppointmentResponse.fromJson(json.decode(str));

String updateAppointmentResponseToJson(UpdateAppointmentResponse data) => json.encode(data.toJson());

class UpdateAppointmentResponse {
  UpdateAppointmentResponse({
    this.response,
  });

  Response response;

  factory UpdateAppointmentResponse.fromJson(Map<String, dynamic> json) => UpdateAppointmentResponse(
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
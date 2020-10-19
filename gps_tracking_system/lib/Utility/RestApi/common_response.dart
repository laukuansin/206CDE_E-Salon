import 'dart:convert';

CommonResponse commonResponseFromJson(String str) => CommonResponse.fromJson(json.decode(str));

String makeAppointmentResponseToJson(CommonResponse data) => json.encode(data.toJson());

class CommonResponse {
  CommonResponse({
    this.response,
  });

  Response response;

  factory CommonResponse.fromJson(Map<String, dynamic> json) => CommonResponse(
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

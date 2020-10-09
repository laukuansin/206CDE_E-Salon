import 'dart:convert';

TopUpResponse topUpResponseFromJson(String str) => TopUpResponse.fromJson(json.decode(str));

String topUpResponseToJson(TopUpResponse data) => json.encode(data.toJson());

class TopUpResponse {
  TopUpResponse({
    this.response,
  });

  Response response;

  factory TopUpResponse.fromJson(Map<String, dynamic> json) => TopUpResponse(
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

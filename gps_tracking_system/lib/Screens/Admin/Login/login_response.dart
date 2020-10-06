import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.userToken,
    this.response,
  });

  String userToken;
  Response response;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    userToken: json["user_token"],
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "user_token": userToken,
    "response": response.toJson(),
  };
}

class Response {
  Response({
    this.status,
    this.msj,
  });

  int status;
  String msj;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    status: json["status"],
    msj: json["msj"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msj": msj,
  };
}

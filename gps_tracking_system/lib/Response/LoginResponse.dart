import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.response,
    this.errorCode,
  });

  Response response;
  ErrorCode errorCode;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    response: Response.fromJson(json["response"]),
    errorCode: ErrorCode.fromJson(json["error_code"]),
  );

  Map<String, dynamic> toJson() => {
    "response": response.toJson(),
    "error_code": errorCode.toJson(),
  };
}

class ErrorCode {
  ErrorCode({
    this.error,
    this.msj,
  });

  int error;
  String msj;

  factory ErrorCode.fromJson(Map<String, dynamic> json) => ErrorCode(
    error: json["error"],
    msj: json["msj"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "msj": msj,
  };
}

class Response {
  Response({
    this.userId,
    this.key,
  });

  String userId;
  String key;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    userId: json["user_id"],
    key: json["key"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "key": key,
  };
}
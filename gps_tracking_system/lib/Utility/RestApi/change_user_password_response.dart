import 'dart:convert';

ChangeUserPasswordResponse changeUserPasswordResponseFromJson(String str) => ChangeUserPasswordResponse.fromJson(json.decode(str));

String changeUserPasswordResponseToJson(ChangeUserPasswordResponse data) => json.encode(data.toJson());

class ChangeUserPasswordResponse {
  ChangeUserPasswordResponse({
    this.response,
    this.error,
  });

  Response response;
  Error error;

  factory ChangeUserPasswordResponse.fromJson(Map<String, dynamic> json) => ChangeUserPasswordResponse(
    response: Response.fromJson(json["response"]),
    error: json["error"]== null? null : Error.fromJson(json["error"]),
  );

  Map<String, dynamic> toJson() => {
    "response": response.toJson(),
    "error": error.toJson(),
  };
}

class Error {
  Error({
    this.oldPassword,
    this.newPassword,
    this.confirmPassword,
  });

  String oldPassword;
  String newPassword;
  String confirmPassword;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    oldPassword:   json["oldPassword"] == null? "" : json['oldPassword'],
    newPassword:  json["newPassword"] == null ? "" : json['newPassword'],
    confirmPassword:   json["confirmPassword"] == null ? "": json["confirmPassword"],
  ) ;

  Map<String, dynamic> toJson() => {
    "oldPassword": oldPassword,
    "newPassword": newPassword,
    "confirmPassword": confirmPassword
  };
}

class Response {
  Response({
    this.msg,
    this.status,
  });

  String msg;
  int status;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
  };
}

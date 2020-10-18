import 'dart:convert';

ChangePasswordResponse changePasswordResponseFromJson(String str) => ChangePasswordResponse.fromJson(json.decode(str));

String changePasswordResponseToJson(ChangePasswordResponse data) => json.encode(data.toJson());

class ChangePasswordResponse {
  ChangePasswordResponse({
    this.response,
    this.error,
  });

  Response response;
  Error error;

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) => ChangePasswordResponse(
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
    this.confirm,
  });

  String oldPassword;
  String newPassword;
  String confirm;


  factory Error.fromJson(Map<String, dynamic> json) => Error(
    newPassword:   json["newPassword"] == null? "":json["newPassword"],
    oldPassword: json["oldPassword"] ==null? "":json["oldPassword"],
    confirm:    json["confirm"] == null? "":json["confirm"],
  ) ;

  Map<String, dynamic> toJson() => {
    "newPassword": newPassword,
    "oldPassword":oldPassword,
    "confirm": confirm,
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

import 'dart:convert';

EditUserInfoResponse editUserInfoResponseFromJson(String str) => EditUserInfoResponse.fromJson(json.decode(str));

String editUserInfoResponseToJson(EditUserInfoResponse data) => json.encode(data.toJson());

class EditUserInfoResponse {
  EditUserInfoResponse({
    this.response,
    this.error,
  });

  Response response;
  Error error;

  factory EditUserInfoResponse.fromJson(Map<String, dynamic> json) => EditUserInfoResponse(
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
    this.username,
    this.firstname,
    this.lastname,
    this.email
  });

  String username;
  String firstname;
  String lastname;
  String email;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    username:   json["username"] == null? "" : json['username'],
    firstname:  json["firstname"] == null ? "" : json['firstname'],
    lastname:   json["lastname"] == null ? "": json["lastname"],
    email:      json["email"] == null? "": json["email"],
  ) ;

  Map<String, dynamic> toJson() => {
    "username": username,
    "firstname": firstname,
    "lastname": lastname,
    "email":email,
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

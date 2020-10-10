import 'dart:convert';

SignUpResponse signUpResponseFromJson(String str) => SignUpResponse.fromJson(json.decode(str));

String signUpResponseToJson(SignUpResponse data) => json.encode(data.toJson());

class SignUpResponse {
  SignUpResponse({
    this.response,
    this.error,
  });

  Response response;
  Error error;

  factory SignUpResponse.fromJson(Map<String, dynamic> json) => SignUpResponse(
    response: Response.fromJson(json["response"]),
    error: json['error'] == null? null : Error.fromJson(json["error"]),
  );

  Map<String, dynamic> toJson() => {
    "response": response.toJson(),
    "error": error.toJson(),
  };
}

class Error {
  Error({
    this.firstname,
    this.lastname,
    this.email,
    this.telephone,
    this.password,
    this.confirm,
  });

  String firstname;
  String lastname;
  String email;
  String telephone;
  String password;
  String confirm;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    firstname: json["firstname"] == null? "" : json['firstname'],
    lastname: json["lastname"] == null? "" : json['lastname'],
    email: json["email"] == null? "":json['email'],
    telephone: json["telephone"] == null? "":json['telephone'],
    password: json["password"] == null? "": json['password'],
    confirm: json["confirm"] == null? "" : json['confirm'],
  );

  Map<String, dynamic> toJson() => {
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "telephone": telephone,
    "password": password,
    "confirm": confirm,
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
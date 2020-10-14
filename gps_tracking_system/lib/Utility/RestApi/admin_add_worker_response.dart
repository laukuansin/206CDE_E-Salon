import 'dart:convert';

AddWorkerResponse addWorkerResponseFromJson(String str) => AddWorkerResponse.fromJson(json.decode(str));

String addWorkerResponseToJson(AddWorkerResponse data) => json.encode(data.toJson());

class AddWorkerResponse {
  AddWorkerResponse({
    this.response,
    this.error,
  });

  Response response;
  Error error;

  factory AddWorkerResponse.fromJson(Map<String, dynamic> json) => AddWorkerResponse(
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
    this.password,
    this.confirm,
    this.email
  });

  String username;
  String firstname;
  String lastname;
  String password;
  String confirm;
  String email;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    username:   json["username"] == null? "" : json['username'],
    firstname:  json["firstname"] == null ? "" : json['firstname'],
    lastname:   json["lastname"] == null ? "": json["lastname"],
    password:   json["password"] == null? "":json["password"],
    confirm:    json["confirm"] == null? "":json["confirm"],
    email:      json["email"] == null? "": json["email"],
  ) ;

  Map<String, dynamic> toJson() => {
    "username": username,
    "firstname": firstname,
    "lastname": lastname,
    "password": password,
    "confirm": confirm,
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

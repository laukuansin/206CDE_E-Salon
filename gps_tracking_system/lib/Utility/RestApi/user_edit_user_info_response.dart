import 'dart:convert';

EditInfoResponse editInfoResponseFromJson(String str) => EditInfoResponse.fromJson(json.decode(str));

String editInfoResponseToJson(EditInfoResponse data) => json.encode(data.toJson());

class EditInfoResponse {
  EditInfoResponse({
    this.response,
    this.error,
  });

  Response response;
  Error error;

  factory EditInfoResponse.fromJson(Map<String, dynamic> json) => EditInfoResponse(
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
    this.firstname,
    this.lastname,
    this.contactNo,
    this.email
  });

  String firstname;
  String lastname;
  String contactNo;
  String email;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    firstname:  json["firstname"] == null ? "" : json['firstname'],
    lastname:   json["lastname"] == null ? "": json["lastname"],
    contactNo:   json["telephone"] == null? "":json["telephone"],
    email:      json["email"] == null? "": json["email"],
  ) ;

  Map<String, dynamic> toJson() => {
    "firstname": firstname,
    "lastname": lastname,
    "telephone": contactNo,
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

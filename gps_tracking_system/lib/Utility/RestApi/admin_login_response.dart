import 'dart:convert';

import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.userToken,
    this.response,
    this.userGroupId,
    this.username,
    this.userImage,
    this.email
  });

  String userToken;
  int userGroupId;
  String email;
  String username;
  String userImage;
  Response response;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    userToken: json["user_token"],
    response: Response.fromJson(json["response"]),
    userGroupId: json['user_group_id'] == null? -1 :json['user_group_id'],
    username: json['username'] == null? "": json["username"],
    userImage: json['image'] == null ? "" : json["image"],
    email: json['email'] == null ? "": json['email']
  );

  Map<String, dynamic> toJson() => {
    "user_token": userToken,
    "response": response.toJson(),
    "user_group_id": userGroupId
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

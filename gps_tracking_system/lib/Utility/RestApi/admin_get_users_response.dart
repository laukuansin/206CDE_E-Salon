import 'dart:convert';

import 'package:gps_tracking_system/Model/admin.dart';

GetUsersResponse getUsersResponseFromJson(String str) => GetUsersResponse.fromJson(json.decode(str));

class GetUsersResponse {
  GetUsersResponse({
    this.users,
    this.response,
  });

  List<Admin> users;
  Response response;

  factory GetUsersResponse.fromJson(Map<String, dynamic> json) => GetUsersResponse(
    users: List<Admin>.from(json["users"].map((x) => Admin.fromJson(x))),
    response: Response.fromJson(json["response"]),
  );

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

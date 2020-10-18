import 'dart:convert';

import 'package:gps_tracking_system/Model/service.dart';

GetServicesResponse getServicesResponseFromJson(String str) => GetServicesResponse.fromJson(json.decode(str));

String getServicesResponseToJson(GetServicesResponse data) => json.encode(data.toJson());

class GetServicesResponse {
  GetServicesResponse({
    this.services,
    this.response,
  });

  List<Service> services;
  Response response;

  factory GetServicesResponse.fromJson(Map<String, dynamic> json) => GetServicesResponse(
    services: json['services'] == null? null : List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
    "response": response.toJson(),
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

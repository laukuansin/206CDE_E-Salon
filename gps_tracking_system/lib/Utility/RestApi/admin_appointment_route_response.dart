import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

AppointmentRouteResponse appointmentRouteResponseFromJson(String str) => AppointmentRouteResponse.fromJson(json.decode(str));

String appointmentRouteResponseToJson(AppointmentRouteResponse data) => json.encode(data.toJson());

class AppointmentRouteResponse {
  AppointmentRouteResponse({
    this.response,
    this.appointmentId,
    this.route,
  });

  Response response;
  String appointmentId;
  List<LatLng> route;

  factory AppointmentRouteResponse.fromJson(Map<String, dynamic> json) => AppointmentRouteResponse(
    response: Response.fromJson(json["response"]),
    appointmentId: json["appointment_id"],
    route: List<LatLng>.from(json["route"].map((x) => LatLng(x['lat'].toDouble(), x['lng'].toDouble()))),
  );

  Map<String, dynamic> toJson() => {
    "response": response.toJson(),
    "appointment_id": appointmentId,
    "route": List<dynamic>.from(route.map((x) => x.toJson())),
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

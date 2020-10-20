import 'dart:convert';

AppointmentSalesResponse appointmentSalesResponseFromJson(String str) => AppointmentSalesResponse.fromJson(json.decode(str));

String appointmentSalesResponseToJson(AppointmentSalesResponse data) => json.encode(data.toJson());

class AppointmentSalesResponse {
  AppointmentSalesResponse({
    this.appointmentSales,
    this.response,
  });

  List<String> appointmentSales;
  Response response;

  factory AppointmentSalesResponse.fromJson(Map<String, dynamic> json) => AppointmentSalesResponse(
    appointmentSales: List<String>.from(json["appointment_sales"].map((x) => x)),
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "appointment_sales": List<dynamic>.from(appointmentSales.map((x) => x)),
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

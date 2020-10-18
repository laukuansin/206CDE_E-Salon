import 'dart:convert';

EditSettingResponse editSettingResponseFromJson(String str) =>
    EditSettingResponse.fromJson(json.decode(str));

String editSettingResponseToJson(EditSettingResponse data) =>
    json.encode(data.toJson());

class EditSettingResponse {
  EditSettingResponse({
    this.response,
    this.error,
  });

  Response response;
  Error error;

  factory EditSettingResponse.fromJson(Map<String, dynamic> json) =>
      EditSettingResponse(
        response: Response.fromJson(json["response"]),
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response.toJson(),
        "error": error.toJson(),
      };
}

class Error {
  Error(
      {this.cancellation_time,
      this.travel_time,
      this.appointment_interval});

  String cancellation_time;
  String travel_time;
  String appointment_interval;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        cancellation_time:
            json["cancellation_time"] == null ? "" : json["cancellation_time"],
        travel_time: json["travel_time"] == null ? "" : json["travel_time"],
        appointment_interval: json["appointment_interval"] == null
            ? ""
            : json["appointment_interval"],
      );

  Map<String, dynamic> toJson() => {
        "cancellation_time": cancellation_time,
        "travel_time": travel_time,
        "appointment_interval": appointment_interval,
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

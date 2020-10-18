import 'dart:convert';

GetHolidayResponse getHolidayResponseFromJson(String str) => GetHolidayResponse.fromJson(json.decode(str));

String getHolidayResponseToJson(GetHolidayResponse data) => json.encode(data.toJson());

class GetHolidayResponse {
  GetHolidayResponse({
    this.response,
    this.holiday,
  });

  Response response;
  List<Holiday> holiday;

  factory GetHolidayResponse.fromJson(Map<String, dynamic> json) => GetHolidayResponse(
    response: Response.fromJson(json["response"]),
    holiday: List<Holiday>.from(json["holiday"].map((x) => Holiday.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "response": response.toJson(),
    "holiday": List<dynamic>.from(holiday.map((x) => x.toJson())),
  };
}

class Holiday {
  Holiday({
    this.date,
  });

  String date;

  factory Holiday.fromJson(Map<String, dynamic> json) => Holiday(
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
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
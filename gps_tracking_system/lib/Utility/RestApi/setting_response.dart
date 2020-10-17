import 'dart:convert';

SettingResponse settingResponseFromJson(String str) => SettingResponse.fromJson(json.decode(str));

String settingResponseToJson(SettingResponse data) => json.encode(data.toJson());

class SettingResponse {
  SettingResponse({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
    this.appointmentInterval,
    this.travelTime,
    this.cancelTime,
    this.response,
  });

  Day monday;
  Day tuesday;
  Day wednesday;
  Day thursday;
  Day friday;
  Day saturday;
  Day sunday;
  int appointmentInterval;
  int travelTime;
  int cancelTime;
  Response response;

  factory SettingResponse.fromJson(Map<String, dynamic> json) => SettingResponse(
    monday: Day.fromJson(json["monday"]),
    tuesday: Day.fromJson(json["tuesday"]),
    wednesday: Day.fromJson(json["wednesday"]),
    thursday: Day.fromJson(json["thursday"]),
    friday: Day.fromJson(json["friday"]),
    saturday: Day.fromJson(json["saturday"]),
    sunday: Day.fromJson(json["sunday"]),
    appointmentInterval: json["appointment_interval"],
    travelTime: json["travel_time"],
    cancelTime: json["cancel_time"],
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "monday": monday.toJson(),
    "tuesday": tuesday.toJson(),
    "wednesday": wednesday.toJson(),
    "thursday": thursday.toJson(),
    "friday": friday.toJson(),
    "saturday": saturday.toJson(),
    "sunday": sunday.toJson(),
    "appointment_interval": appointmentInterval,
    "travel_time": travelTime,
    "cancel_time": cancelTime,
    "response": response.toJson(),
  };
}

class Day {
  Day({
    this.openTime,
    this.closeTime,
    this.isOpen,
  });

  String openTime;
  String closeTime;
  bool isOpen;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    openTime: json["open_time"],
    closeTime: json["close_time"],
    isOpen: json["is_open"],
  );

  Map<String, dynamic> toJson() => {
    "open_time": openTime,
    "close_time": closeTime,
    "is_open": isOpen,
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

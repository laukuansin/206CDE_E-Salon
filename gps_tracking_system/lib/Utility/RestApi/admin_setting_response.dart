import 'dart:convert';

ServiceSettingResponse serviceSettingResponseFromJson(String str) => ServiceSettingResponse.fromJson(json.decode(str));

String serviceSettingResponseToJson(ServiceSettingResponse data) => json.encode(data.toJson());

class ServiceSettingResponse {
  ServiceSettingResponse({
    this.setting,
    this.response,
  });

  Setting setting;
  Response response;

  factory ServiceSettingResponse.fromJson(Map<String, dynamic> json) => ServiceSettingResponse(
    setting: Setting.fromJson(json["setting"]),
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "setting": setting.toJson(),
    "response": response.toJson(),
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

class Setting {
  Setting({
    this.cancellationTime,
    this.businessHour,
    this.travelTime,
    this.appointmentInterval,
  });

  int cancellationTime;
  BusinessHour businessHour;
  int travelTime;
  int appointmentInterval;

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
    cancellationTime: int.parse(json["cancellation_time"].toString()),
    businessHour: BusinessHour.fromJson(json["business_hour"]),
    travelTime: int.parse(json["travel_time"].toString()),
    appointmentInterval: int.parse(json["appointment_interval"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "cancellation_time": cancellationTime,
    "business_hour": businessHour.toJson(),
    "travel_time": travelTime,
    "appointment_interval": appointmentInterval,
  };
}

class BusinessHour {
  BusinessHour({
    Day monday,
    Day tuesday,
    Day wednesday,
    Day thursday,
    Day friday,
    Day saturday,
    Day sunday,
  }){
    days.clear();
    days["Monday"] = monday;
    days["Tuesday"] = tuesday;
    days["Wednesday"] = wednesday;
    days["Thursday"] = thursday;
    days["Friday"] = friday;
    days["Saturday"] = saturday;
    days["Sunday"] = sunday;
  }

  Map<String, Day> days = {};

  factory BusinessHour.fromJson(Map<String, dynamic> json) => BusinessHour(
    monday: Day.fromJson(json["Monday"]),
    tuesday: Day.fromJson(json["Tuesday"]),
    wednesday: Day.fromJson(json["Wednesday"]),
    thursday: Day.fromJson(json["Thursday"]),
    friday: Day.fromJson(json["Friday"]),
    saturday: Day.fromJson(json["Saturday"]),
    sunday: Day.fromJson(json["Sunday"]),
  );

  Map<String, dynamic> toJson() => {
    "Monday": days["Monday"].toJson(),
    "Tuesday": days["Tuesday"].toJson(),
    "Wednesday": days["Wednesday"].toJson(),
    "Thursday": days["Thursday"].toJson(),
    "Friday": days["Friday"].toJson(),
    "Saturday": days["Saturday"].toJson(),
    "Sunday": days["Sunday"].toJson(),
  };
}

class Day {
  Day({
    this.isOpen,
    this.startTime,
    this.startMeridiem,
    this.endTime,
    this.endMeridiem,
  });

  bool isOpen;
  String startTime;
  String startMeridiem;
  String endTime;
  String endMeridiem;

  String getStartTime() => startTime + " " + startMeridiem;
  String getEndTime()=> endTime + " " + endMeridiem;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    isOpen: json["is_open"],
    startTime: json["start_time"],
    startMeridiem: json["start_meridiem"],
    endTime: json["end_time"],
    endMeridiem: json["end_meridiem"],
  );

  Map<String, dynamic> toJson() => {
    "is_open": isOpen,
    "start_time": startTime,
    "start_meridiem": startMeridiem,
    "end_time": endTime,
    "end_meridiem": endMeridiem,
  };
}
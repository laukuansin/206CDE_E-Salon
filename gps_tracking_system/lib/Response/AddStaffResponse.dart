
import 'dart:convert';

AddStaffResponse addStaffResponseFromJson(String str) => AddStaffResponse.fromJson(json.decode(str));

String addStaffResponseToJson(AddStaffResponse data) => json.encode(data.toJson());

class AddStaffResponse {
  AddStaffResponse({
    this.errorCode,
  });

  ErrorCode errorCode;

  factory AddStaffResponse.fromJson(Map<String, dynamic> json) => AddStaffResponse(
    errorCode: ErrorCode.fromJson(json["error_code"]),
  );

  Map<String, dynamic> toJson() => {
    "error_code": errorCode.toJson(),
  };
}

class ErrorCode {
  ErrorCode({
    this.error,
    this.msj,
  });

  int error;
  String msj;

  factory ErrorCode.fromJson(Map<String, dynamic> json) => ErrorCode(
    error: json["error"],
    msj: json["msj"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "msj": msj,
  };
}
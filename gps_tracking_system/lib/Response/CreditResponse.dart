import 'dart:convert';

CreditResponse creditResponseFromJson(String str) => CreditResponse.fromJson(json.decode(str));

String creditResponseToJson(CreditResponse data) => json.encode(data.toJson());

class CreditResponse {
  CreditResponse({
    this.credit,
    this.errorCode,
  });

  String credit;
  ErrorCode errorCode;

  factory CreditResponse.fromJson(Map<String, dynamic> json) => CreditResponse(
    credit: json["credit"],
    errorCode: ErrorCode.fromJson(json["error_code"]),
  );

  Map<String, dynamic> toJson() => {
    "credit": credit,
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
import 'dart:convert';

TopUpResponse topUpResponseFromJson(String str) => TopUpResponse.fromJson(json.decode(str));

String topUpResponseToJson(TopUpResponse data) => json.encode(data.toJson());

class TopUpResponse {
  TopUpResponse({
    this.errorCode,
  });

  ErrorCode errorCode;

  factory TopUpResponse.fromJson(Map<String, dynamic> json) => TopUpResponse(
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
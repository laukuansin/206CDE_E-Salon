import 'dart:convert';

CustomerCreditResponse customerCreditResponseFromJson(String str) => CustomerCreditResponse.fromJson(json.decode(str));

String customerCreditResponseToJson(CustomerCreditResponse data) => json.encode(data.toJson());

class CustomerCreditResponse {
  CustomerCreditResponse({
    this.credit,
    this.response,
  });

  double credit;
  Response response;

  factory CustomerCreditResponse.fromJson(Map<String, dynamic> json) => CustomerCreditResponse(
    credit: json["credit"] == null? 0.0 : double.parse(json["credit"]),
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "credit": credit,
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

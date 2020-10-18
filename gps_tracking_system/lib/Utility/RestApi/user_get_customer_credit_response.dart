import 'dart:convert';

CustomerCreditResponse customerCreditResponseFromJson(String str) => CustomerCreditResponse.fromJson(json.decode(str));

String customerCreditResponseToJson(CustomerCreditResponse data) => json.encode(data.toJson());

class CustomerCreditResponse {
  CustomerCreditResponse({
    this.credit,
    this.token,
    this.response,
  });

  double credit;
  Token token;
  Response response;

  factory CustomerCreditResponse.fromJson(Map<String, dynamic> json) => CustomerCreditResponse(
    credit: json["credit"].toDouble()??0.0,
    token: Token.fromJson(json["token"]),
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "credit": credit,
    "token": token.toJson(),
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

class Token {
  Token({
    this.customerId,
    this.customerToken,
  });

  String customerId;
  String customerToken;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    customerId: json["customer_id"],
    customerToken: json["customer_token"],
  );

  Map<String, dynamic> toJson() => {
    "customer_id": customerId,
    "customer_token": customerToken,
  };
}
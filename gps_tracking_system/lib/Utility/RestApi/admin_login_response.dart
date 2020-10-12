import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.userToken,
    this.response,
    this.userGroupId
  });

  String userToken;
  int userGroupId;
  Response response;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    userToken: json["user_token"],
    response: Response.fromJson(json["response"]),
    userGroupId: json['user_group_id'] == null? -1 :json['user_group_id']
  );

  Map<String, dynamic> toJson() => {
    "user_token": userToken,
    "response": response.toJson(),
    "user_group_id": userGroupId
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

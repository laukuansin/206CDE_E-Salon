import 'dart:convert';

UserDetailResponse userDetailResponseFromJson(String str) => UserDetailResponse.fromJson(json.decode(str));

String userDetailResponseToJson(UserDetailResponse data) => json.encode(data.toJson());

class UserDetailResponse {
  UserDetailResponse({
    this.response,
    this.detail,
  });

  Response response;
  Detail detail;

  factory UserDetailResponse.fromJson(Map<String, dynamic> json) => UserDetailResponse(
    response: Response.fromJson(json["response"]),
    detail: Detail.fromJson(json["detail"]),
  );

  Map<String, dynamic> toJson() => {
    "response": response.toJson(),
    "detail": detail.toJson(),
  };
}

class Detail {
  Detail({
    this.name,
    this.role,
    this.email,
    this.image,
    this.firstName,
    this.lastName,
    this.userName,
  });

  String name;
  String role;
  String email;
  String image;
  String firstName;
  String lastName;
  String userName;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    name: json["name"],
    role: json["role"],
    email: json["email"],
    image: json["image"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    userName: json["user_name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "role": role,
    "email": email,
    "image": image,
    "first_name": firstName,
    "last_name": lastName,
    "user_name": userName,
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
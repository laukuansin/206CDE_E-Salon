import 'dart:convert';

CustomerDetailResponse customerDetailResponseFromJson(String str) => CustomerDetailResponse.fromJson(json.decode(str));

String customerDetailResponseToJson(CustomerDetailResponse data) => json.encode(data.toJson());

class CustomerDetailResponse {
  CustomerDetailResponse({
    this.customerDetail,
    this.response,
  });

  CustomerDetail customerDetail;
  Response response;

  factory CustomerDetailResponse.fromJson(Map<String, dynamic> json) => CustomerDetailResponse(
    customerDetail: CustomerDetail.fromJson(json["detail"]),
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "detail": customerDetail.toJson(),
    "response": response.toJson(),
  };
}

class CustomerDetail {
  CustomerDetail({
    this.customerId,
    this.name,
    this.firstName,
    this.lastName,
    this.contactNo,
    this.email,
  });

  String customerId;
  String name;
  String firstName;
  String lastName;
  String contactNo;
  String email;

  factory CustomerDetail.fromJson(Map<String, dynamic> json) => CustomerDetail(
    customerId: json["customer_id"],
    name: json["name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    contactNo: json["contact_no"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "customer_id": customerId,
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "contact_no": contactNo,
    "email": email,
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

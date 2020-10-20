import 'dart:convert';

GetWorkerRatingResponse getWorkerRatingResponseFromJson(String str) => GetWorkerRatingResponse.fromJson(json.decode(str));

String getWorkerRatingResponseToJson(GetWorkerRatingResponse data) => json.encode(data.toJson());

class GetWorkerRatingResponse {
  GetWorkerRatingResponse({
    this.ratingList,
    this.averageRating,
    this.response,
  });

  List<RatingList> ratingList;
  double averageRating;
  Response response;

  factory GetWorkerRatingResponse.fromJson(Map<String, dynamic> json) => GetWorkerRatingResponse(
    ratingList: List<RatingList>.from(json["rating_list"].map((x) => RatingList.fromJson(x))),
    averageRating: json["average_rating"].toDouble(),
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "rating_list": List<dynamic>.from(ratingList.map((x) => x.toJson())),
    "average_rating": averageRating,
    "response": response.toJson(),
  };
}

class RatingList {
  RatingList({
    this.customerName,
    this.rating,
    this.review,
  });

  String customerName;
  int rating;
  String review;

  factory RatingList.fromJson(Map<String, dynamic> json) => RatingList(
    customerName: json["customer_name"],
    rating: json["rating"],
    review: json["review"]??"",
  );

  Map<String, dynamic> toJson() => {
    "customer_name": customerName,
    "rating": rating,
    "review": review,
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
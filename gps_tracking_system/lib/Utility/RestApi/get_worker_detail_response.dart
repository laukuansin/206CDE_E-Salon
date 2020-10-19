import 'dart:convert';

GetWorkerDetailResponse getWorkerDetailResponseFromJson(String str) => GetWorkerDetailResponse.fromJson(json.decode(str));

String getWorkerDetailResponseToJson(GetWorkerDetailResponse data) => json.encode(data.toJson());

class GetWorkerDetailResponse {
  GetWorkerDetailResponse({
    this.worker,
    this.response,
  });

  Worker worker;
  Response response;

  factory GetWorkerDetailResponse.fromJson(Map<String, dynamic> json) => GetWorkerDetailResponse(
    worker: Worker.fromJson(json["worker"]),
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "worker": worker.toJson(),
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

class Worker {
  Worker({
    this.workerId,
    this.profileImage,
    this.name,
  });

  String workerId;
  String profileImage;
  String name;

  factory Worker.fromJson(Map<String, dynamic> json) => Worker(
    profileImage: json["profile_image"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "profile_image": profileImage,
    "name": name,
  };
}
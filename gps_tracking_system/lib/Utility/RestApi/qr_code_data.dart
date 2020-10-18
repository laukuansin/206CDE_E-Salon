import 'dart:convert';

QrCodeData qrCodeDataFromJson(String str) => QrCodeData.fromJson(json.decode(str));

String qrCodeDataToJson(QrCodeData data) => json.encode(data.toJson());

class QrCodeData {
  QrCodeData({
    this.token,
  });

  String token;

  factory QrCodeData.fromJson(Map<String, dynamic> json) => QrCodeData(
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
  };
}

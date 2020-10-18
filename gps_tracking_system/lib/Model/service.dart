class Service {
  Service({
    this.serviceId,
    this.serviceName,
    this.servicePrice,
    this.quantity
  });

  int serviceId;
  String serviceName;
  double servicePrice;
  int quantity;

  double calcTotalPrice(){

  }

  factory Service.fromJson(Map<String, dynamic> json) => Service(
      serviceId: json["service_id"],
      serviceName: json["service_name"],
      servicePrice: json["service_price"].toDouble(),
      quantity: json['quantity'] == null? 0 : json['quantity']
  );

  Map<String, dynamic> toJson() => {
    "service_id": serviceId,
    "service_name": serviceName,
    "service_price": servicePrice,
    "qty":quantity
  };
}
class Service{
  final String serviceId;
  String name;
  String description;
  double price;
  int duration;

  Service(String serviceId,
      {
        this.name = "",
        this.description = '',
        this.price = 0.0,
        this.duration = 0
      }):
      serviceId = serviceId;


}
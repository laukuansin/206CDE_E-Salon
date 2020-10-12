import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/appointment_list_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/get_services_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';

class ChooseServiceScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ChooseServiceScreenState();

}



class ChooseServiceScreenState extends State<ChooseServiceScreen>{

  List<Service>services = [];
  Appointment appointment;
  Map<int, Map<ServiceAttr, double>>serviceQtyMap = {};
  final GlobalKey<ScaffoldState>_scaffoldStateKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    requestServices();
    appointment = Appointment();
  }



  void requestServices() async{
     GetServicesResponse getServicesResponse = await RestApi.customer.getAllServices();

     if(getServicesResponse.response.status == 1){
       setState(() {
          services = getServicesResponse.services;
          for(var service in services){
            serviceQtyMap[service.serviceId] = {};
            serviceQtyMap[service.serviceId][ServiceAttr.QTY] = 0;
            serviceQtyMap[service.serviceId][ServiceAttr.PRICE] = service.servicePrice;
          }
       });
     }
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _scaffoldStateKey.currentState.hideCurrentSnackBar();
      if(_calcSumOfServices() > 0)
        _scaffoldStateKey.currentState.showSnackBar(buildSnackBar());
    });
    Scaffold scaffold = RouteGenerator.buildScaffold(
      Container(
        child: ListView.builder(
          itemCount: services.length,
          itemBuilder: (context, index){
            var serviceId =  services[index].serviceId;
            var serviceQty = serviceQtyMap.containsKey(serviceId) ? serviceQtyMap[serviceId][ServiceAttr.QTY].toInt() : 0;
            return Container(
              color: primaryLightColor,
              margin: EdgeInsets.only(bottom: 2),
                child:ListTile(
                  trailing: Text("RM ${services[index].servicePrice}"),
                  title: Text(services[index].serviceName),
                  leading: serviceQty > 0
                      ? Text(serviceQty.toString(), style: TextStyleFactory.heading4(color: primaryColor),)
                      : null,
                  onTap: (){
                    setState(() {
                      serviceQtyMap[serviceId][ServiceAttr.QTY]++;});
                },
              )
            );
          },
        ),
      ),
      key: _scaffoldStateKey,
      appbar: AppBar(
        title: Text("Select services", style: TextStyleFactory.p(color: primaryTextColor),),
      )
    );
    return scaffold;
  }

  SnackBar buildSnackBar(){
    return SnackBar(
      backgroundColor: primaryColor,

      content: Row(
        children:[
          Text(_calcSumOfServices().toString()),
          SizedBox(width: 10,),
          Text("RM ${_calcSumOfPrice()}")
        ],
      ),
      action:SnackBarAction(
        label: "View your selected services",
        textColor: primaryLightColor,
        onPressed: (){
          Navigator.of(context).pushNamed("/add_appointment", arguments: {"appointment": appointment, "serviceQtyMap" : serviceQtyMap}).then((value) {setState(() {});});}
      ),
      duration: Duration(days: 1),
    );
  }

  int _calcSumOfServices(){
    int sum = 0;
    serviceQtyMap.forEach((key, value) => sum += value[ServiceAttr.QTY].toInt());
    return sum;
  }

  double _calcSumOfPrice(){
    double price = 0;
    serviceQtyMap.forEach((key, value) {price += value[ServiceAttr.PRICE] * value[ServiceAttr.QTY];});
    return price;
  }

}
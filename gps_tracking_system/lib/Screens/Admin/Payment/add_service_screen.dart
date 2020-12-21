import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/service.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/common_get_services_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';


class AddServiceScreen extends StatefulWidget{
  final List<Service>_serviceList;

  AddServiceScreen(List<Service> args):_serviceList=args;

  @override
  State<StatefulWidget> createState() => AddServiceScreenState(_serviceList);

}

class AddServiceScreenState extends State<AddServiceScreen>{

  final List<Service>_serviceList;
  List<Service> _serviceSelection = [];

  final GlobalKey<ScaffoldState>_scaffoldStateKey = GlobalKey<ScaffoldState>();

  AddServiceScreenState(this._serviceList);

  @override
  void initState() {
    super.initState();
    requestServices();
  }

  void requestServices() async{
    GetServicesResponse getServicesResponse = await RestApi.admin.getAllServices();

    if(getServicesResponse.response.status == 1){
      setState(() {
        _serviceSelection = getServicesResponse.services;
        _serviceList.forEach((service) {
            for(Service s in _serviceSelection){
              if(s.serviceId == service.serviceId)
                s.quantity = service.quantity;
            }
        });
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
            itemCount: _serviceSelection.length,
            itemBuilder: (context, index){
              var serviceQty = _serviceSelection[index].quantity;
              return Container(
                  color: primaryLightColor,
                  margin: EdgeInsets.only(bottom: 2),
                  child:ListTile(
                    trailing: Text("RM ${_serviceSelection[index].servicePrice.toStringAsFixed(2)}"),
                    title: Text(_serviceSelection[index].serviceName),
                    leading: serviceQty > 0
                        ? Text(serviceQty.toString(), style: TextStyleFactory.heading4(color: primaryColor),)
                        : null,
                    onTap: (){
                      setState(() {
                        _serviceSelection[index].quantity++;
                        _updateData();
                      });
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
          Text("RM ${_calcSumOfPrice().toStringAsFixed(2)}")
        ],
      ),
      duration: Duration(days: 1),
    );
  }

  int _calcSumOfServices(){
    int sum = 0;
    _serviceSelection.forEach((element) {sum += element.quantity;});
    return sum;
  }

  double _calcSumOfPrice(){
    double price = 0;
    _serviceSelection.forEach((element) {price += (element.quantity * element.servicePrice);});
    return price;
  }

  // Bad practice but i sipek lazy
  void _updateData(){
    _serviceList.clear();
    _serviceList.addAll(_serviceSelection.where((element) => element.quantity > 0));
  }
}
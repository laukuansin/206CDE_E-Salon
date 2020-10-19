import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:gps_tracking_system/Screens/Common/GoogleMap/view_model.dart';

class GoogleMapScreen extends StatefulWidget{
  final String customerAddress;
  final LatLng workerLatLng;
  final Size size;
  List<LatLng> latLngPolylineList = [];

  @override
  State<StatefulWidget> createState() => GoogleMapScreenState();
  GoogleMapScreen({Key key, this.size, @required this.customerAddress, @required this.workerLatLng, this.latLngPolylineList}): super(key:key);
}

class GoogleMapScreenState extends State<GoogleMapScreen>{
  ViewModel viewModel;
  Size size;

  @override
  void initState() {
    super.initState();
    size = widget.size;
    viewModel = ViewModel(
      latLngPolylineList: widget.latLngPolylineList,
      customerAddress:widget.customerAddress,
      workerLatLng: widget.workerLatLng,
      notifyChanges: (){setState(() {});},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        width :size.width,
        height:size.height,
        child:Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox(
              child:viewModel.buildMap()
            ),
          ]
        )
      )
    );
  }


  // Call this function using key to update worker location
  void updateWorkerLocation(bool isWorkerReady, LatLng workerLocation){
    viewModel.updateWorkerLocation(isWorkerReady, workerLocation);
    setState(() {});
  }

  void animateCameraToRouteBound(){
    viewModel.animateCameraToRouteBound();
  }

  @override
  void dispose() {
    viewModel.workerLatLng = null;
    super.dispose();
  }

  void setMapSize(Size size){
    setState(() {
      this.size = size;
    });
  }

  void setPolylineList(List<LatLng> list){
    setState(() {
      viewModel.latLngPolylineList = list;
      viewModel.animateCameraToRouteBound();
    });
  }
}

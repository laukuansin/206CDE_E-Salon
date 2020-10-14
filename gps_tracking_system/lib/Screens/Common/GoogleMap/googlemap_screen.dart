import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:gps_tracking_system/Screens/Common/GoogleMap/view_model.dart';

class GoogleMapScreen extends StatefulWidget{
  final String customerAddress;
  final LatLng workerLatLng;

  @override
  State<StatefulWidget> createState() => GoogleMapScreenState();
  GoogleMapScreen({Key key, @required this.customerAddress, @required this.workerLatLng}): super(key:key);
}

class GoogleMapScreenState extends State<GoogleMapScreen>{
  ViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = ViewModel(
      customerAddress:widget.customerAddress,
      workerLatLng: widget.workerLatLng,
      notifyChanges: (){setState(() {});},
      showAlertDialog: showAlertDialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body:Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        width :screenSize.width,
        height:screenSize.height,
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

  void showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            FlatButton(
              child: Text("Ok"),
              onPressed: (){Navigator.pop(context);},
            )
          ]
        );
      }
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
}

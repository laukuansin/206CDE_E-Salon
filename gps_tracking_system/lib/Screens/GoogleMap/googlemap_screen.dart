import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'file:///C:/Users/Jeffrey%20Tan/Desktop/GPSTracker/RealWorldProject/gps_tracking_system/lib/Screens/GoogleMap/viewModel.dart';

class GoogleMapScreen extends StatefulWidget{
  final Position destination;

  @override
  State<StatefulWidget> createState() => _GoogleMapScreenState();
  GoogleMapScreen({Key key, @required this.destination}): super(key:key);
}

class _GoogleMapScreenState extends State<GoogleMapScreen>{

  ViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ViewModel(
      destination:LatLng(widget.destination.latitude, widget.destination.longitude),
      notifyChanges: (){setState(() {});},
      showAlertDialog: showAlertDialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:Container(
        width :size.width,
        height:size.height,
        child:Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox(
              child:_viewModel.getMap()
            ),

            Positioned(
              bottom: 0,
              child: _viewModel.getNavigationButton()
            )
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
}
import 'package:flutter/material.dart';
import 'Components/map_navigation_panel.dart';
import 'package:gps_tracking_system/Screens/GoogleMap/view_model.dart';

class GoogleMapScreen extends StatefulWidget{
  final String destAddr;

  @override
  State<StatefulWidget> createState() => _GoogleMapScreenState();
  GoogleMapScreen({Key key, @required this.destAddr}): super(key:key);
}

class _GoogleMapScreenState extends State<GoogleMapScreen>{

  ViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ViewModel(
      destAddress:widget.destAddr,
      notifyChanges: (){setState(() {});},
      showAlertDialog: showAlertDialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Size bottomBarSize = Size(screenSize.width, screenSize.height * 0.18);

    return Scaffold(
      body:Container(
        width :screenSize.width,
        height:screenSize.height,
        child:Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox(
              child:viewModel.buildMap()
            ),

            Positioned(
              bottom:0,
              child: MapNavigationPanel(
                bottomBarSize: bottomBarSize,
                navigationButton: viewModel.buildNavigationButton(),
                totalDistance: viewModel.getTotalDistance(),
                totalDuration: viewModel.getTotalDurations(),)
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
}

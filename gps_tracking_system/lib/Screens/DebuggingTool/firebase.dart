import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Model/Worker.dart';
import 'package:geolocator/geolocator.dart';

class Firebase extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _FirebaseState();
}

class _FirebaseState extends State<Firebase>{
  final workerIdController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final customerIdController = TextEditingController();
  final Worker worker = Worker(workerId: "P18010220", syncDB: true);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase debugging tool"),
      ),
      body: Container(
        width: size.width,
        height:size.height,
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: workerIdController,
                decoration: InputDecoration(
                  labelText: "Worker ID",
                ),
              ),
              SizedBox(height: size.height * 0.03,),
              TextFormField(
                controller: latitudeController,
                decoration: InputDecoration(
                    labelText: "Lat"
                ),
              ),
              SizedBox(height: size.height * 0.03,),
              TextFormField(
                controller: longitudeController,
                decoration: InputDecoration(
                    labelText: "Long"
                ),
              ),
              SizedBox(height: size.height * 0.03,),
              TextFormField(
                controller: customerIdController,
                decoration: InputDecoration(
                    labelText: "Customer id"
                ),
              ),
              SizedBox(height: size.height * 0.06,),
              FlatButton(
                  child: Text(
                    "Insert",
                  ),
                  onPressed: saveDataChanges
              ),
              FlatButton(
                  child: Text(
                    "Remove",
                  ),
                  onPressed: removeData
              ),
              FlatButton(
                  child: Text(
                      "Edit"
                  ),
                  onPressed: saveDataChanges
              ),
              FlatButton(
                  child: Text(
                      "Search"
                  ),
                  onPressed:saveDataChanges
              )
            ],
          ),
        ),
      ),
    );
  }

  void saveDataChanges() {
    worker.latitude = double.parse(latitudeController.text);
    worker.longitude = double.parse(longitudeController.text);
    worker.customerId = customerIdController.text;
    try {
      worker.save();
    } catch (error) {
      showDialog(
        context:context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Data save changes error"),
            content: Text(error.toString()),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      );
    }
  }

  void removeData(){
    worker.latitude = double.parse(latitudeController.text);
    worker.longitude = double.parse(longitudeController.text);
    worker.customerId = customerIdController.text;
    try {
      worker.remove();
    } catch (error) {
      showDialog(
          context:context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Data save changes error"),
              content: Text(error.toString()),
              actions: [
                FlatButton(
                  child: Text("Ok"),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            );
          }
      );
    }
  }

  void requestLocationUpdate()
  {

  }

}
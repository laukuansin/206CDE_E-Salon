import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Model/admin.dart';

import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/admin_get_users_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';

class ManageWorkerScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ManageWorkerScreenState();

}


class _ManageWorkerScreenState extends State<ManageWorkerScreen>{

  List<Admin>_userList = [];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return RouteGenerator.buildScaffold(
      Container(
        height: screenSize.height,
        width:screenSize.width,
        child: SingleChildScrollView(
          child:FittedBox(
            child:_buildWorkerDataTable(),
          )
        )
      ),
      appbar:AppBar(
        backgroundColor: Color(0xFF65CBF2),
        elevation: 0,
        title: Text(
          "Worker", style: TextStyleFactory.heading5(color: primaryLightColor),
        ),
        iconTheme: IconThemeData(
            color: primaryLightColor
        ),
        actions: [
          IconButton(icon:Icon(Icons.add),
            onPressed: (){Navigator.of(context).pushNamed("/add_worker").then((_){setState(() {

            });} );},
          )
        ],
      ),
      drawer: RouteGenerator.buildDrawer(context)
    );
  }

  DataTable _buildWorkerDataTable(){
    return DataTable(
      columns: [
        DataColumn(
          label: Text(
            'Username',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Status',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Date Added',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Action',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: List<DataRow>.generate(_userList.length, (index) => DataRow(
        cells: [
          DataCell(
            Text(_userList[index].username)
          ),
          DataCell(
              Text(_userList[index].status.name)
          ),
          DataCell(
              Text(_userList[index].dateAdded)
          ),
          DataCell(
              IconButton(
                icon: Icon(Icons.edit, color: secondaryTextColor,),
                onPressed: (){
                  Navigator.of(context).pushNamed("/edit_worker",  arguments:_userList[index]);
                },
              )
          ),
        ]
      ))
    );
  }

  @override
  void initState() {
    requestUsersList();
    super.initState();
  }

  void requestUsersList()async{
    GetUsersResponse usersResponse = await RestApi.admin.getWorkers();
    setState(() {
      _userList = usersResponse.users;
    });
  }

}
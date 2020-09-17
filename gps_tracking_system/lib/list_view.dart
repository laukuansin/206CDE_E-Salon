import 'package:flutter/material.dart';
import 'package:gps_tracking_system/color.dart';

class ListViewContainer extends StatelessWidget {

  final List<String> entries = <String>['A', 'B', 'C', 'D'];
  final List<String> time = <String>["9.30 am","9.30 am","9.30 am","9.30 am"];
  final List<String> duration = <String>["60 min","60 min","60 min","60 min"];
  final List<int> colorCodes = <int>[600, 500, 100];
  final List<Icon> icon = <Icon>[Icon(Icons.check_circle, color: Colors.lightGreenAccent,),
    Icon(Icons.error, color: Colors.amber),
    Icon(Icons.watch_later, color: Colors.blueGrey,),
    Icon(Icons.cancel, color: Colors.red),
  ];


  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      //padding: const EdgeInsets.all(8),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.only(left: 4.0, right: 4.0),
          decoration: new BoxDecoration(
              border: new Border(
                bottom: new BorderSide(width: 2.0),
                left: new BorderSide(
                    width: 2.0,
                    color: Colors.orange,
                    style: BorderStyle.solid),
                right: new BorderSide(
                    width: 2.0,
                    color: Colors.orange,
                    style: BorderStyle.solid),
              ),
            color: Colors.white,
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right:12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0),
                  )
              ),
              child: icon[index],
            ),
            title: Row(
              children: [
                Column(
                  children: [
                    Text('${time[index]}'),
                    Text('${duration[index]}',
                    style: TextStyle(
                      color: Colors.grey
                    ),
                    )
                  ],
                ),
                SizedBox(width: 20.0),
                Column(
                  children:[
                    Text('Tan Fen Nee ${entries[index]}',
                    style: TextStyle(
                      color: Colors.indigo
                    ),
                    ),
                    Text('Repair Light',
                      style: TextStyle(
                          color: Colors.grey
                      ),),
                  ],
                ),
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios,color: Color(0xFFBBC8F8F)),
            onTap: (){
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => AppointmentDetails()));
            },
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
      Container(
        height: 30,
        //thickness: 28,
        padding: EdgeInsets.only(left: 10.0, right: 10.0,top: 5.0),
        color: Color(0xFFBDCDCDC),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Today, Wed Sep 04',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFBA52A2A)
                  ),
                  //textAlign: TextAlign.left,
                ),
              ]
            ),
            Column(
              children: [
                Icon(Icons.add, color: primaryColor)
              ],
            )
          ],
        ),
      ),
    );
  }
}

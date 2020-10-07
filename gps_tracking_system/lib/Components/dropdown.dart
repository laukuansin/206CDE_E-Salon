import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';

class Dropdown extends StatelessWidget{

  final String title;
  final String data;
  final String dropdownTitle;
  final List<String>dropdownSelection;
  final BuildContext context;
  final IconData leadingIconData;
  final IconData trailingIconData;
  final Function(String) callback;

  Dropdown({
    this.title,
    this.data,
    this.dropdownTitle,
    this.dropdownSelection,
    this.context,
    this.leadingIconData,
    this.trailingIconData,
    this.callback,
  });

  GestureDetector _buildDropdown() {
    return GestureDetector(
        child: Container(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(leadingIconData, color: primaryColor),
              title: Align(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title, style: TextStyleFactory.p()),
                      Text(data, style: TextStyleFactory.p(color: primaryTextColor),)
                    ]
                ),
                alignment: Alignment(-1.2, 0),
              ),
              trailing: Icon(trailingIconData),
            )
        ),
        onTap: () async {
          String result = await _showDropDown();
          callback(result == null ? "" : result);
        }
    );
  }


  Future<String> _showDropDown() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(title),
              content: Container(
                height: 100.0,
                width: 100.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: dropdownSelection.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        title: Text(dropdownSelection[index]),
                        onTap: () {
                            Navigator.pop(context, dropdownSelection[index]);
                        });
                  },
                ),
              )
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDropdown();
  }

}

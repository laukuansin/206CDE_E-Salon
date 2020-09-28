import 'package:flutter/material.dart';
import 'package:gps_tracking_system/components/text_field_container.dart';
import 'package:gps_tracking_system/color.dart';


class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String>onChanged;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child:TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            icon: Icon(
              icon,
              color: primaryColor,
            ),
          ),
        )
    );
  }
}


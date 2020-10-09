import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Components/text_field_container.dart';
import 'package:gps_tracking_system/color.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child:TextField(
          obscureText: true,
          decoration: InputDecoration(
              hintText:"Password",
              icon: Icon(
                Icons.lock,
                color:primaryColor,
              ),
              suffixIcon: Icon(
                  Icons.visibility,
                  color:primaryColor
              ),
              border:InputBorder.none
          ),
        )
    );
  }
}

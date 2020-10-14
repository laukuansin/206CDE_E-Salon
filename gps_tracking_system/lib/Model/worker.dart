import 'package:flutter/cupertino.dart';
import 'package:gps_tracking_system/Model/end_user.dart';

class Worker extends EndUser{



  Worker({
    String workerId  = "",
    String contactNo = "",
    String firstname = "",
    String lastname  = "",
    String email     = "",
  }):
    super(
      id: workerId,
      firstName: firstname,
      lastName: lastname,
      contactNo: contactNo,
      email:email,
    );

}
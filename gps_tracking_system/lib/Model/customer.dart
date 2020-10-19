import 'package:gps_tracking_system/Model/end_user.dart';

class Customer extends EndUser{


  Customer({
    String customerId  = "",
    String contactNo = "",
    String firstname = "",
    String lastname  = "",
    String email     = "",
  }) : super(
    id: customerId,
    firstName: firstname,
    lastName: lastname,
    contactNo: contactNo,
    email:email,
  );
}
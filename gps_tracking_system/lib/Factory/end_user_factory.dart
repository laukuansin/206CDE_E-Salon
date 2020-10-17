import 'package:gps_tracking_system/Model/admin.dart';
import 'package:gps_tracking_system/Model/customer.dart';
import 'package:gps_tracking_system/Model/end_user.dart';

enum EndUserType{
  CUSTOMER,
  ADMIN,
}

class EndUserFactory{
  EndUserFactory._();

  static EndUser createInstance(EndUserType type){
    switch(type){
      case EndUserType.CUSTOMER:
        return Customer();
      case EndUserType.ADMIN:
        return Admin();
    }
    return null;
  }
}
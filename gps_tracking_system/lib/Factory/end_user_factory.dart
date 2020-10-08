import 'package:gps_tracking_system/Model/worker.dart';
import 'package:gps_tracking_system/Model/customer.dart';
import 'package:gps_tracking_system/Model/end_user.dart';

enum EndUserType{
  CUSTOMER,
  WORKER,
  OWNER
}

class EndUserFactory{
  EndUserFactory._();

  static EndUser createInstance(EndUserType type){
    switch(type){
      case EndUserType.CUSTOMER:
        return Customer();
      case EndUserType.WORKER:
        return Worker();
      case EndUserType.OWNER:
        return null;
    }
    return null;
  }
}
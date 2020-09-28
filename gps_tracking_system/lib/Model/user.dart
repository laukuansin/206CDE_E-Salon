
import 'package:gps_tracking_system/Factory/end_user_factory.dart';
import 'package:gps_tracking_system/Model/end_user.dart';

enum Role{
  OWNER,
  WORKER,
  CUSTOMER
}

class User{
  static User _user;
  String token;
  EndUser endUserProfile;
  Role role;

  User._(final Role role): role = role;

  static bool isAuthenticated(){
    return _user != null;
  }

  static bool authenticate(String email, String password){
    if(_user == null) {
      String id = "P18010220";
      _user = User._(Role.CUSTOMER);
      _user.endUserProfile = EndUserFactory.createInstance(EndUserType.CUSTOMER, id);
    }
    return true;
  }

  static Role getRole()=> _user.role;
  static EndUser getEndUserProfile()=>_user.endUserProfile;
}
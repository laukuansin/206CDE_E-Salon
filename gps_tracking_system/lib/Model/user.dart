
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

  User._(final String token, final Role role):token = token, role = role;


  static void createInstance(String token, Role role){
    if(_user == null)
      _user = User._(token, role);
  }

  static bool isAuthenticated() => _user != null;
  static Role getRole()=> _user.role;
  static EndUser getEndUserProfile()=>_user.endUserProfile;
}
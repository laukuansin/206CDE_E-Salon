
import 'dart:developer';

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
  String username;
  String email;
  String userImage;
  Role role;

  User._(final this.token,final this.username, final this.email, final this.userImage, final this.role);


  static void createInstance(String token, String username, String email, {String userImage , int userGroupId = -1} ){
    if(_user == null) {
      Role role;
      switch(userGroupId){
        case 1:
          role = Role.OWNER;
          break;
        case 10:
          role = Role.WORKER;
          break;
        default:
          role = Role.CUSTOMER;
          break;
      }
      _user = User._(token, username, email, userImage, role);
    }
  }

  static void logout(){
    _user = null;
  }

  static bool isAuthenticated() => _user != null;
  static String getToken() => _user.token;
  static Role getRole()=> _user.role;
  static String getEmail() => _user.email;
  static String getUsername() => _user.username;
  static String getUserImage() => _user.userImage;
}
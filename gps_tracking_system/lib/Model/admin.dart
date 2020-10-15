import 'package:flutter/cupertino.dart';
import 'package:gps_tracking_system/Model/end_user.dart';


class UserGroup {
  UserGroup({
    this.userGroupId,
    this.name,
  });

  String userGroupId;
  String name;

  factory UserGroup.fromJson(Map<String, dynamic> json) => UserGroup(
    userGroupId: json["user_group_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "user_group_id": userGroupId,
    "name": name,
  };
}


class UserStatus {
  UserStatus({
    this.statusId,
    this.name,
  });

  int statusId;
  String name;
}


class Admin extends EndUser{
  String username;
  UserGroup userGroup;
  UserStatus status;
  String dateAdded;
  String image;


  Admin({
    String userId  = "",
    String contactNo = "",
    String firstname = "",
    String lastname  = "",
    String email     = "",
    String password = "",
    String confirm = "",
    this.username = "",
    this.userGroup,
    this.status,
    this.dateAdded = "",
    this.image = ""
  }):
    super(
      id: userId,
      firstName: firstname,
      lastName: lastname,
      contactNo: contactNo,
      email:email,
      password:password,
      confirm:confirm
    );


  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    userId: json["user_id"],
    username: json["username"],
    status: UserStatus(statusId: int.parse(json["status_id"]), name: json['status_name'] == null ? "" : json['status_name']),
    dateAdded: json["date_added"],
    firstname: json['firstname'],
    lastname:json['lastname'],
    email: json['email'],
    image: json['image'],
    contactNo: json['telephone'] == null ? "" : json['telephone'],
    userGroup: UserGroup(userGroupId: json['user_group_id'], name: json['user_group_name'] == null ? "": json['user_group_name'] ),
  );

}

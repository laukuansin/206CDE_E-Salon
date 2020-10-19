import 'dart:convert';

import 'package:gps_tracking_system/Model/admin.dart';

UserGroupResponse userGroupResponseFromJson(String str) => UserGroupResponse.fromJson(json.decode(str));

String userGroupResponseToJson(UserGroupResponse data) => json.encode(data.toJson());

class UserGroupResponse {
  UserGroupResponse({
    this.userGroup,
  });

  List<UserGroup> userGroup;

  factory UserGroupResponse.fromJson(Map<String, dynamic> json) => UserGroupResponse(
    userGroup: List<UserGroup>.from(json["user_group"].map((x) => UserGroup.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user_group": List<dynamic>.from(userGroup.map((x) => x.toJson())),
  };
}



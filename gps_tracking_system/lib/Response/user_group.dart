// To parse this JSON data, do
//
//     final userGroupResponse = userGroupResponseFromJson(jsonString);

import 'dart:convert';

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

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);


import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String id;
  final String username;
  final String email;
  final String role;
  final String password;
  final String roleId;
  final String? fcmToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.password,
    required this.roleId,
    required this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    username: json["username"],
    email: json["email"],
    role: json["role"],
    password: json["password"],
    roleId: json["roleId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]), 
    fcmToken: null,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "email": email,
    "role": role,
    "password": password,
    "roleId": roleId,
    "fcmToken":fcmToken,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

// To parse this JSON data, do
//
//     final admin = adminFromJson(jsonString);


import 'dart:convert';

Admin adminFromJson(String str) => Admin.fromJson(json.decode(str));

String adminToJson(Admin data) => json.encode(data.toJson());

class Admin {
    final String id;
    final String adminId;
    final String adminName;
    final String email;
    final String phoneNumber;
    final DateTime createdAt;
    final DateTime updatedAt;

    Admin({
        required this.id,
        required this.adminId,
        required this.adminName,
        required this.email,
        required this.phoneNumber,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        id: json["_id"],
        adminId: json["adminId"],
        adminName: json["adminName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "adminId": adminId,
        "adminName": adminName,
        "email": email,
        "phoneNumber": phoneNumber,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}

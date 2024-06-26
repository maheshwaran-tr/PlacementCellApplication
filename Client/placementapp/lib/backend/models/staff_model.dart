// To parse this JSON data, do
//
//     final staffModel = staffModelFromJson(jsonString);


import 'dart:convert';

Staff staffModelFromJson(String str) => Staff.fromJson(json.decode(str));

String staffModelToJson(Staff data) => json.encode(data.toJson());

class Staff {
  String? id;
  final String staffId;
  final String staffName;
  final String department;
  final String email;
  final String phoneNumber;
  DateTime? createdAt;
  DateTime? updatedAt;

  Staff({
    this.id,
    required this.staffId,
    required this.staffName,
    required this.department,
    required this.email,
    required this.phoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
    id: json["_id"],
    staffId: json["staffId"],
    staffName: json["staffName"],
    department: json["department"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "staffId": staffId,
    "staffName": staffName,
    "department": department,
    "email": email,
    "phoneNumber": phoneNumber,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

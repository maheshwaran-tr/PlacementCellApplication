// To parse this JSON data, do
//
//     final jobApplicationModel = jobApplicationModelFromJson(jsonString);


import 'dart:convert';

JobApplicationModel jobApplicationModelFromJson(String str) => JobApplicationModel.fromJson(json.decode(str));

String jobApplicationModelToJson(JobApplicationModel data) => json.encode(data.toJson());

class JobApplicationModel {
  final String id;
  final String student;
  final String job;
  String status;
  bool isStaffApproved;
  final DateTime createdAt;
  final DateTime updatedAt;

  JobApplicationModel({
    required this.id,
    required this.student,
    required this.job,
    required this.status,
    required this.isStaffApproved,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobApplicationModel.fromJson(Map<String, dynamic> json) => JobApplicationModel(
    id: json["_id"],
    student: json["student"],
    job: json["job"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    isStaffApproved: json["isStaffApproved"]
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "student": student,
    "job": job,
    "status": status,
    "isStaffApproved":isStaffApproved,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String()
  };
}
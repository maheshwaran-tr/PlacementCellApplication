import 'dart:convert';

JobPostModel jobPostModelFromJson(String str) => JobPostModel.fromJson(json.decode(str));

String jobPostModelToJson(JobPostModel data) => json.encode(data.toJson());

class JobPostModel {
  final String id;
  final String companyName;
  final String companyLocation;
  final String venue;
  final String jobName;
  final String description;
  final String campusMode;
  final double eligible10ThMark;
  final double eligible12ThMark;
  final double eligibleCgpa;
  final String interviewDate;
  final String interviewTime;
  final int historyOfArrears;
  final List<String> skills;
  final List<String> jobApplications;
  final DateTime createdAt;
  final DateTime updatedAt;

  JobPostModel({
    required this.id,
    required this.companyName,
    required this.companyLocation,
    required this.venue,
    required this.jobName,
    required this.description,
    required this.campusMode,
    required this.eligible10ThMark,
    required this.eligible12ThMark,
    required this.eligibleCgpa,
    required this.interviewDate,
    required this.interviewTime,
    required this.historyOfArrears,
    required this.skills,
    required this.jobApplications,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobPostModel.fromJson(Map<String, dynamic> json) => JobPostModel(
    id: json["_id"] as String,
    companyName: json["companyName"] as String,
    companyLocation: json["company_location"] ?? "N/A",
    venue: json["venue"] as String,
    jobName: json["jobName"] as String,
    description: json["description"] as String,
    campusMode: json["campusMode"] as String,
    eligible10ThMark: (json["eligible10thMark"] as num).toDouble(),
    eligible12ThMark: (json["eligible12thMark"] as num).toDouble(),
    eligibleCgpa: (json["eligibleCGPA"] as num).toDouble(),
    interviewDate: json["interviewDate"] as String,
    interviewTime: json["interviewTime"] as String,
    historyOfArrears: json["historyOfArrears"] as int,
    skills: List<String>.from(json["skills"].map((x) => x as String)),
    jobApplications: List<String>.from(json["jobApplications"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"] as String),
    updatedAt: DateTime.parse(json["updatedAt"] as String),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "companyName": companyName,
    "company_location": companyLocation,
    "venue": venue,
    "jobName": jobName,
    "description": description,
    "campusMode": campusMode,
    "eligible10thMark": eligible10ThMark,
    "eligible12thMark": eligible12ThMark,
    "eligibleCGPA": eligibleCgpa,
    "interviewDate": interviewDate,
    "interviewTime": interviewTime,
    "historyOfArrears": historyOfArrears,
    "skills": List<dynamic>.from(skills.map((x) => x)),
    "jobApplications": List<dynamic>.from(jobApplications.map((x) => x)),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

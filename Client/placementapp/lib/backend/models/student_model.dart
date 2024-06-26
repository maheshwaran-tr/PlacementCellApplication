// To parse this JSON data, do
//
//     final student = studentFromJson(jsonString);





import 'dart:convert';

Student studentFromJson(String str) => Student.fromJson(json.decode(str));

String studentToJson(Student data) => json.encode(data.toJson());

class Student {
  final String id;
  final String rollNo;
  final String regNo;
  final String studentName;
  final String community;
  final String gender;
  final String department;
  final String section;
  final String fatherName;
  final String fatherOccupation;
  final String motherName;
  final String motherOccupation;
  final String placeOfBirth;
  final String dateOfBirth;
  final double score10Th;
  final String board10Th;
  final String yearOfPassing10Th;
  final double score12Th;
  final String board12Th;
  final String yearOfPassing12Th;
  final String scoreDiploma;
  final String branchDiploma;
  final String yearOfPassingDiploma;
  final String presentAddress;
  final String phoneNumber;
  final String parentPhoneNumber;
  final String email;
  final String aadhar;
  bool? placementWilling;
  final int batch;
  final int currentSem;
  final double cgpa;
  final int standingArrears;
  final int historyOfArrears;
  final String permanentAddress;
  final List<String> jobApplications;
  final String? updatedAt;

  Student({
    required this.id,
    required this.rollNo,
    required this.regNo,
    required this.studentName,
    required this.community,
    required this.gender,
    required this.department,
    required this.section,
    required this.fatherName,
    required this.fatherOccupation,
    required this.motherName,
    required this.motherOccupation,
    required this.placeOfBirth,
    required this.dateOfBirth,
    required this.score10Th,
    required this.board10Th,
    required this.yearOfPassing10Th,
    required this.score12Th,
    required this.board12Th,
    required this.yearOfPassing12Th,
    required this.scoreDiploma,
    required this.branchDiploma,
    required this.yearOfPassingDiploma,
    required this.presentAddress,
    required this.phoneNumber,
    required this.parentPhoneNumber,
    required this.email,
    required this.aadhar,
    required this.placementWilling,
    required this.batch,
    required this.currentSem,
    required this.cgpa,
    required this.standingArrears,
    required this.historyOfArrears,
    required this.permanentAddress,
    required this.jobApplications,
    this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json["_id"],
    rollNo: json["rollNo"],
    regNo: json["regNo"],
    studentName: json["studentName"],
    community: json["community"],
    gender: json["gender"],
    department: json["department"],
    section: json["section"],
    fatherName: json["fatherName"],
    fatherOccupation: json["fatherOccupation"],
    motherName: json["motherName"],
    motherOccupation: json["motherOccupation"],
    placeOfBirth: json["placeOfBirth"],
    dateOfBirth: json["dateOfBirth"],
    score10Th: json["score10th"].toDouble(),
    board10Th: json["board10th"],
    yearOfPassing10Th: json["yearOfPassing10th"],
    score12Th: json["score12th"].toDouble(),
    board12Th: json["board12th"],
    yearOfPassing12Th: json["yearOfPassing12th"],
    scoreDiploma: json["scoreDiploma"],
    branchDiploma: json["branchDiploma"],
    yearOfPassingDiploma: json["yearOfPassingDiploma"],
    presentAddress: json["presentAddress"],
    phoneNumber: json["phoneNumber"],
    parentPhoneNumber: json["parentPhoneNumber"],
    email: json["email"],
    aadhar: json["aadhar"],
    placementWilling: json["placementWilling"],
    batch: json["batch"],
    currentSem: json["currentSem"],
    cgpa: json["cgpa"].toDouble(),
    standingArrears: json["standingArrears"],
    historyOfArrears: json["historyOfArrears"],
    permanentAddress: json["permanentAddress"],
    jobApplications: List<String>.from(json["jobApplications"].map((x) => x)),
    updatedAt: json["updatedAt"]
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "rollNo": rollNo,
    "regNo": regNo,
    "studentName": studentName,
    "community": community,
    "gender": gender,
    "department": department,
    "section": section,
    "fatherName": fatherName,
    "fatherOccupation": fatherOccupation,
    "motherName": motherName,
    "motherOccupation": motherOccupation,
    "placeOfBirth": placeOfBirth,
    "dateOfBirth": dateOfBirth,
    "score10th": score10Th,
    "board10th": board10Th,
    "yearOfPassing10th": yearOfPassing10Th,
    "score12th": score12Th,
    "board12th": board12Th,
    "yearOfPassing12th": yearOfPassing12Th,
    "scoreDiploma": scoreDiploma,
    "branchDiploma": branchDiploma,
    "yearOfPassingDiploma": yearOfPassingDiploma,
    "presentAddress": presentAddress,
    "phoneNumber": phoneNumber,
    "parentPhoneNumber": parentPhoneNumber,
    "email": email,
    "aadhar": aadhar,
    "placementWilling": placementWilling,
    "batch": batch,
    "currentSem": currentSem,
    "cgpa": cgpa,
    "standingArrears": standingArrears,
    "historyOfArrears": historyOfArrears,
    "permanentAddress": permanentAddress,
    "jobApplications": List<dynamic>.from(jobApplications.map((x) => x)),
    // "updatedAt": updatedAt.toIso8601String()
  };
}

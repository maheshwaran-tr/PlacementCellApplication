import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:placementapp/api_requests/student_requests.dart';

import '../../../backend/models/applied_job_model.dart';
import '../../../backend/models/student_model.dart';
import '../student_details.dart';

class StudentListByAppliedJobs extends StatefulWidget {
  final List<JobApplicationModel> jobApplications;

  const StudentListByAppliedJobs({super.key, required this.jobApplications});

  @override
  State<StudentListByAppliedJobs> createState() =>
      _StudentListByAppliedJobsState();
}

class _StudentListByAppliedJobsState extends State<StudentListByAppliedJobs> {
  String searchText = '';
  List<JobApplicationModel> filteredJobApplications = [];
  Map<String, Student> studentMap = {};

  @override
  void initState() {
    super.initState();
    print(widget.jobApplications);
    filteredJobApplications = List.from(widget.jobApplications);
  }

  Future<void> filterStudents() async {
    List<Student> studentList = [];
    for (var application in filteredJobApplications) {
      studentList
          .add(await StudentRequests.getStudentById(application.student));
    }

    setState(() {
      studentMap = {for (var student in studentList) student.id: student};

      filteredJobApplications = List.from(widget.jobApplications);

      if (searchText.isNotEmpty) {
        filteredJobApplications = filteredJobApplications.where((app) {
          return app.student.toLowerCase().contains(searchText.toLowerCase());
        }).toList();
      }
    });
  }

  void downloadData() async {
    // List<Student> studenList = [];
    // for(var obj in widget.jobApplications){
    //   studenList.add(obj.student);
    // }
    // await StudentExcelService.createExcelFile(studenList,widget.jobApplications[0].jobPost.companyName);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
          title: Text(
            'Student Details',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              onPressed: downloadData,
              icon: Icon(
                Icons.download,
                size: 24,
                color: Colors.black,
              ),
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Column(children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            margin: EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                  filterStudents();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by Student name',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            searchText = '';
                            filterStudents();
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredJobApplications.length,
              itemBuilder: (context, index) {
                final studentId = filteredJobApplications[index].student;
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'Name: ${studentMap[studentId]!.studentName}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    // Handle edit action
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    // Handle delete action
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.visibility),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StudentDetailsPage(
                                          student: studentMap[studentId]!,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text('Roll Number: ${studentMap[studentId]!.rollNo}',
                            style: TextStyle(fontSize: 14)),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ]));
  }
}

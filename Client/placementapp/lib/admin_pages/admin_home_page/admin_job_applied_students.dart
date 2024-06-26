import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:placementapp/api_requests/job_application_requests.dart';
import 'package:placementapp/api_requests/student_requests.dart';
import '../../../backend/models/applied_job_model.dart';
import '../../../backend/models/student_model.dart';
import '../../staff_pages/staff_home_page/student_details.dart';

class AdminStudentListByAppliedJobs extends StatefulWidget {
  final List<String>? jobApplicationId;

  const AdminStudentListByAppliedJobs({super.key, required this.jobApplicationId});

  @override
  State<AdminStudentListByAppliedJobs> createState() =>
      _AdminStudentListByAppliedJobsState();
}

class _AdminStudentListByAppliedJobsState
    extends State<AdminStudentListByAppliedJobs> {
  String searchText = '';
  List<JobApplicationModel?> filteredJobApplications = [];
  Map<String, Student> studentMap = {};

  @override
  void initState() {
    super.initState();
    if (widget.jobApplicationId != null && widget.jobApplicationId!.isNotEmpty) {
      initApplications();
    }
  }

  Future<void> initApplications() async {
    List<JobApplicationModel?> theApplications = [];
    List<Student> allStudents = [];
    for (var appId in widget.jobApplicationId!) {
      JobApplicationModel? theApp =
          await JobApplicationRequests.findById(appId);
      if (theApp!.isStaffApproved == true) {
        theApplications.add(theApp);
        allStudents.add(await StudentRequests.getStudentById(theApp.student));
      }
    }

    setState(() {
      filteredJobApplications = theApplications;
      studentMap = {for (var student in allStudents) student.id: student};
    });
  }

  Future<void> filterStudents() async {
    setState(() {
      if (searchText.isNotEmpty) {
        filteredJobApplications = filteredJobApplications.where((app) {
          return app!.student.toLowerCase().contains(searchText.toLowerCase());
        }).toList();
      }
    });
  }

  void downloadData() async {
    // Implementation for downloading data
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
      body: widget.jobApplicationId == null || widget.jobApplicationId!.isEmpty
          ? Center(
              child: Text(
                'No students applied for this job',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : Column(
              children: [
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
                      final studentId = filteredJobApplications[index]!.student;
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
              ],
            ),
    );
  }
}

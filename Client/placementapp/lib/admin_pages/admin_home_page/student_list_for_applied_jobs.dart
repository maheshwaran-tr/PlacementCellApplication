import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:placementapp/api_requests/student_requests.dart';

import '../../ExcelService/student_excel_service/student_details_excel.dart';
import '../../api_requests/job_requests.dart';
import '../../backend/models/applied_job_model.dart';
import '../../backend/models/student_model.dart';
import '../../backend/models/job_post_model.dart';
import '../../staff_pages/staff_home_page/student_details.dart';

class StudentListByAppliedJobs extends StatefulWidget {
  final List<JobApplicationModel?> jobApplications;

  const StudentListByAppliedJobs({super.key, required this.jobApplications});

  @override
  State<StudentListByAppliedJobs> createState() =>
      _StudentListByAppliedJobsState();
}

class _StudentListByAppliedJobsState extends State<StudentListByAppliedJobs> {
  String searchText = '';
  List<JobApplicationModel?> filteredJobApplications = [];
  List<Student> students = [];
  List<JobPostModel> jobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    try {
      List<Student> fetchedStudents = [];
      List<JobPostModel> fetchedJobs = [];
      for (var application in widget.jobApplications) {
        Student student = await StudentRequests.getStudentById(application!.student);
        JobPostModel? job = await JobRequests.findById(application.job);

        fetchedStudents.add(student);
        fetchedJobs.add(job!);
      }
      setState(() {
        students = fetchedStudents;
        jobs = fetchedJobs;
        filteredJobApplications = widget.jobApplications.where((element) => element!.status == "Selected").toList();
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data: $e')),
      );
    }
  }

  void filterStudents() {
    setState(() {
      filteredJobApplications = List.from(widget.jobApplications);
      if (searchText.isNotEmpty) {
        filteredJobApplications = filteredJobApplications.where((app) {
          var student = students.firstWhere((s) => s.id == app?.student);
          return student.studentName
              .toLowerCase()
              .contains(searchText.toLowerCase());
        }).toList();
      }
    });
  }

  void downloadData() async {
    await StudentExcelService.createExcelFile(students, jobs[0].companyName);
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
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
                      final app = filteredJobApplications[index];
                      final student =
                          students.firstWhere((s) => s.id == app?.student);
                      return Card(
                        elevation: 3,
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Name: ${student.studentName}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
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
                                                      student: student),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text('Roll Number: ${student.rollNo}',
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

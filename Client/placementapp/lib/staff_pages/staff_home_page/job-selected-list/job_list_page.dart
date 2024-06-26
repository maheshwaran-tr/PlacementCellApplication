import 'package:flutter/material.dart';
import 'package:placementapp/api_requests/job_application_requests.dart';
import 'package:placementapp/api_requests/student_requests.dart';

import '../../../admin_pages/admin_home_page/student_list_for_applied_jobs.dart';
import '../../../api_requests/job_requests.dart';
import '../../../backend/models/applied_job_model.dart';
import '../../../backend/models/job_post_model.dart';
import '../../../backend/models/student_model.dart';

class JobSelectedListPage extends StatefulWidget {
  final List<Student> studentList;
  final String dept;

  const JobSelectedListPage(
      {super.key, required this.studentList, required this.dept});

  @override
  State<JobSelectedListPage> createState() => _JobSelectedListPageState();
}

class _JobSelectedListPageState extends State<JobSelectedListPage> {
  late Future<void> loadDataFuture;
  List<JobApplicationModel?> filteredApplications = [];
  Map<String, JobPostModel> jobMap = {};

  String searchText = '';

  @override
  void initState() {
    super.initState();
    loadDataFuture = loadData();
  }

  Future<void> loadData() async {
    String queryParam = "department=${widget.dept}&sort=-jobApplications";
    List<Student> studentList =
        await StudentRequests.studentsCustomFilter(queryParam);

    print(studentList.length);
    List<JobApplicationModel?> applications = [];

    for (var student in studentList) {
      for (var applicationId in student.jobApplications) {
        JobApplicationModel? theApplication =
            await JobApplicationRequests.findById(applicationId);
        applications.add(theApplication);
      }
    }
    print(applications);
    List<JobPostModel> allJobs = await JobRequests.getAllJobs();
    print(allJobs);
    setState(() {
      filteredApplications = applications;
      jobMap = {for (var job in allJobs) job.id: job};
    });
  }

  void filterStudentsByJobs(String jobId) {
    print("Iam here");
    List<JobApplicationModel?> filteredList = filteredApplications
        .where((jobApplied) => jobApplied?.job == jobId)
        .toList();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              StudentListByAppliedJobs(jobApplications: filteredList)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF536DFE), Color(0xFF1E88E5)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(24, 60, 24, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jobs',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: Colors.grey[600]),
                                SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        searchText = value;
                                      });
                                    },
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: 'Search Jobs...',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[600]),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<void>(
                future: loadDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return buildJobList();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildJobList() {
    final filteredJobs = filteredApplications.where((application) {
      final job = jobMap[application!.job];
      return job != null &&
          job.companyName.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredJobs.length,
      itemBuilder: (context, index) {
        final jobApplication = filteredJobs[index];
        final job = jobMap[jobApplication!.job]!;

        return GestureDetector(
          onTap: () {
            filterStudentsByJobs(job.id);
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    job.companyName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 18),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

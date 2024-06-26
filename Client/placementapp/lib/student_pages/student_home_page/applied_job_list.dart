import 'package:flutter/material.dart';
import 'package:placementapp/backend/models/job_post_model.dart';

import '../../api_requests/job_application_requests.dart';
import '../../api_requests/job_requests.dart';
import '../../backend/models/applied_job_model.dart';
import '../../backend/models/student_model.dart';

import 'new_upload_status.dart';

class StudentJobApplicationList extends StatefulWidget {
  final Student student;

  const StudentJobApplicationList({super.key, required this.student});

  @override
  State<StudentJobApplicationList> createState() =>
      _StudentJobApplicationListState();
}

class _StudentJobApplicationListState extends State<StudentJobApplicationList> {
  List<JobApplicationModel?>? jobApplications = [];
  Map<String, JobPostModel> jobdatas = {};
  String searchText = '';
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    initdata();
  }

  void initdata() async {
    for (String appId in widget.student.jobApplications) {
      JobApplicationModel? jam = await JobApplicationRequests.findById(appId);
      if (jam != null) {
        JobPostModel? job = await JobRequests.findById(jam.job);
        if (job != null) {
          jobApplications?.add(jam);
          jobdatas[jam.job] = job;
        }
      }
    }
    setState(() {
      isLoaded = true;
    });
  }

  void filterStudentsByJobs(JobApplicationModel? selectedJob) {
    if (selectedJob == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadJobStatus(
          theJob: selectedJob,
          jobpost: jobdatas[selectedJob.job]!,

        ),
      ),
    );
  }

  List<JobApplicationModel?> getFilteredJobs() {
    if (searchText.isEmpty) {
      return jobApplications!;
    } else {
      return jobApplications!
          .where((jobApplication) =>
      jobApplication != null &&
          jobdatas[jobApplication.job]!.companyName
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    }
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
              child: isLoaded
                  ? SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: getFilteredJobs().length,
                        itemBuilder: (context, index) {
                          final jobApplication = getFilteredJobs()[index];
                          if (jobApplication == null) return SizedBox();

                          return GestureDetector(
                            onTap: () {
                              filterStudentsByJobs(jobApplication);
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      jobdatas[jobApplication.job]!
                                          .companyName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward_ios,
                                        size: 18),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
                  : Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}

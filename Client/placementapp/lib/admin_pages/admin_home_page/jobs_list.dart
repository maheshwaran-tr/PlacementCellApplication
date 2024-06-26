import 'package:flutter/material.dart';
import 'package:placementapp/api_requests/job_application_requests.dart';
import 'package:placementapp/api_requests/job_requests.dart';

import '../../backend/models/applied_job_model.dart';
import '../../backend/models/job_post_model.dart';
import '../../staff_pages/staff_home_page/job-selected-list/student_application_list.dart';

class SelectedJobApplicationList extends StatefulWidget {
  const SelectedJobApplicationList({super.key});

  @override
  State<SelectedJobApplicationList> createState() => _SelectedJobApplicationListState();
}

class _SelectedJobApplicationListState extends State<SelectedJobApplicationList> {
  List<JobApplicationModel> jobApplications = [];
  List<JobPostModel> jobPosts = [];
  String searchText = '';
  var isLoaded = true;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    List<JobPostModel> jobsPosts = await JobRequests.getAllJobs();
    List<JobApplicationModel>? applicationList = await JobApplicationRequests.getAllApplications();

    setState(() {
      jobPosts = jobsPosts;
      jobApplications = applicationList!;
    });
  }

  void filterStudentsByJobs(String jobId) {
    print("Iam here");
    List<JobApplicationModel> filteredList = jobApplications.where((jobApplied) => jobApplied.job == jobId).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => StudentListByAppliedJobs(jobApplications: filteredList)
      ),
    );
  }

  List<JobPostModel> getFilteredJobs() {
    if (searchText.isEmpty) {
      return jobPosts;
    } else {
      return jobPosts
          .where(
              (tempJob) => tempJob.companyName.toLowerCase().contains(searchText.toLowerCase()))
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
                    SizedBox(height: 30,),
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
                                      hintStyle: TextStyle(color: Colors.grey[600]),
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
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: getFilteredJobs().length,
                        itemBuilder: (context, index) {
                          final filteredJob = getFilteredJobs()[index];
                          return GestureDetector(
                            onTap: () {
                              filterStudentsByJobs(filteredJob.id);
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
                                      filteredJob.companyName,
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

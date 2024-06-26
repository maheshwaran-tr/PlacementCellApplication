import 'package:flutter/material.dart';
import '../../api_requests/job_requests.dart';
import '../../backend/models/student_model.dart';
import '../../backend/models/job_post_model.dart';
import 'apply_job_page.dart';

class JobListPage extends StatefulWidget {
  final Student? studentProfile;
  const JobListPage({super.key, required this.studentProfile});

  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  late Future<List<JobPostModel>> jobListFuture;

  @override
  void initState() {
    super.initState();
    jobListFuture = initializeJobList();
  }

  Future<List<JobPostModel>> initializeJobList() async {
    return JobRequests.getAllJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job List"),
        backgroundColor: Colors.indigo, // Use a vibrant color
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            jobListFuture = initializeJobList();
          });
        },
        child: FutureBuilder<List<JobPostModel>>(
          future: jobListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: Colors.white70, // Use a light background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      title: Text(
                        snapshot.data![index].companyName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ApplyJobPage(
                              job: snapshot.data![index],
                              studentprofile: widget.studentProfile,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:placementapp/api_requests/job_application_requests.dart';

import '../../backend/models/job_post_model.dart';
import '../../backend/models/student_model.dart';

class ApplyJobPage extends StatefulWidget {
  final JobPostModel job;
  final Student? studentprofile;

  ApplyJobPage({required this.job, required this.studentprofile});

  @override
  State<ApplyJobPage> createState() => _ApplyJobPageState();
}

class _ApplyJobPageState extends State<ApplyJobPage> {
  bool hasApplied = false;
  late Student studentData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    studentData = widget.studentprofile!;
    print(widget.job.companyName);
  }

  @override
  Widget build(BuildContext context) {
    bool isEligible = checkEligibility(studentData, widget.job);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
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
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          widget.job.companyName,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Job ID: ${widget.job.id}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Company Name : ${widget.job.companyName}",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Job Name : ${widget.job.jobName}",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Job Description:",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      ),
                      Text(
                        "${widget.job.description}",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Eligibility Criteria:",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      ),
                      Text(
                        "10th Mark: ${widget.job.eligible10ThMark}",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      Text(
                        "12th Mark: ${widget.job.eligible12ThMark}",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      Text(
                        "CGPA Mark: ${widget.job.eligibleCgpa}",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Interview Details:",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      ),
                      Text(
                        "Venue: ${widget.job.venue}",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      Text(
                        "Date: ${widget.job.interviewDate}",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      Text(
                        "Time: ${widget.job.interviewTime}",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: isEligible ? applyJob : null,
                  icon: Icon(Icons.send, size: 24),
                  label: Text(
                    "Apply Now",
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        isEligible ? Colors.deepPurple : Colors.grey,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: isEligible ? 5 : 0,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: hasApplied
                      ? () {
                          // Add your upload logic here
                        }
                      : null,
                  icon: Icon(Icons.cloud_upload, size: 24),
                  label: Text(
                    "Upload",
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueGrey,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool checkEligibility(Student student, JobPostModel job) {
    if (studentData.score10Th >= job.eligible10ThMark) {
      if (studentData.score12Th >= job.eligible12ThMark) {
        if (studentData.cgpa >= job.eligibleCgpa) {
          return true;
        }
      }
    }
    return false;
  }

  void applyJob() async {
    setState(() {
      isLoading = true;
    });

    int stsCode = await JobApplicationRequests.createApplication(
      studentData.id,
      widget.job.id,
    );

    setState(() {
      isLoading = false;
    });

    if (stsCode == 409) {
      // already applied
      showResultBox("Already Applied", "You have already applied to this job.");
    } else if (stsCode == 201) {
      // applied
      showResultBox(
          "Applied Successfully", "You have successfully applied to this job.");
    } else if (stsCode == 404) {
      showResultBox("Not Found", "Job or Student Not found");
    } else {
      showResultBox(
          "Applied Successfully", "You have successfully applied to this job.");
    }
  }

  void showResultBox(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

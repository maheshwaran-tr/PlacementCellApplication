import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:placementapp/api_requests/job_application_requests.dart';
import 'package:placementapp/api_requests/job_requests.dart';
import 'package:placementapp/api_requests/student_requests.dart';
import 'package:placementapp/backend/models/job_post_model.dart';
import 'package:placementapp/backend/models/student_model.dart';
import '../../backend/models/applied_job_model.dart';

class JobAppliedListPage extends StatefulWidget {
  final String dept;

  const JobAppliedListPage({Key? key, required this.dept}) : super(key: key);

  @override
  _JobAppliedListPageState createState() => _JobAppliedListPageState();
}

class _JobAppliedListPageState extends State<JobAppliedListPage> {
  Map<String, List<JobApplicationModel?>> applicationIdData = {};
  Map<String, JobPostModel> jobData = {};
  List<JobApplicationModel?> allApplicationsOfDept = [];
  Map<String, Student> studentMap = {};

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    await initData();
  }

  Future<void> initData() async {
    // Mapping students
    String queryParam = "department=${widget.dept}&sort=-jobApplications";
    List<Student> allStudents =
        await StudentRequests.studentsCustomFilter(queryParam);
    

    // Fetch all job applications concurrently
    List<Future<void>> fetchApplicationsFutures = [];

    for (var student in allStudents) {
      fetchApplicationsFutures.add(_fetchApplicationsForStudent(student));
    }
    await Future.wait(fetchApplicationsFutures);

    // Fetch all jobs
    List<JobPostModel> allJobs = await JobRequests.getAllJobs();
    

    setState(() {
      studentMap = {for (var student in allStudents) student.id: student};
      jobData = {for (var job in allJobs) job.id: job};
    });
    print("allApplicationsOfDept : ${allApplicationsOfDept}");
  }

  Future<void> _fetchApplicationsForStudent(Student student) async {
    List<JobApplicationModel?> dupAllApplicationsOfDept = [];
    List<JobApplicationModel?> tempApplicationList = [];

    for (var applicationId in student.jobApplications) {
      JobApplicationModel? theApplication =
          await JobApplicationRequests.findById(applicationId);
      if (theApplication != null) {
        tempApplicationList.add(theApplication);
        dupAllApplicationsOfDept.add(theApplication);
      }
    }
    setState(() {
      allApplicationsOfDept = dupAllApplicationsOfDept;
      applicationIdData[student.id] = tempApplicationList;
    });

    print(allApplicationsOfDept);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text(
          'Job Applied List',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    var application = allApplicationsOfDept[index];
                    if (application == null) {
                      return SizedBox.shrink();
                    }
                    var student = studentMap[application.student];
                    var job = jobData[application.job];
                    if (student == null || job == null) {
                      return SizedBox.shrink();
                    }
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Icon(
                            Icons.work,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          student.studentName,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            'Applied to: ${job.companyName}\nStatus: ${application.status}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        trailing: Checkbox(
                          value: application.isStaffApproved,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            setState(() {
                              application.isStaffApproved = value!;
                            });
                          },
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 5),
                  itemCount: allApplicationsOfDept.length,
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: ElevatedButton.icon(
                  onPressed: isAnyStudentSelected()
                      ? () => showApprovalMessage(context)
                      : null,
                  icon: Icon(
                    Icons.check,
                    size: 24,
                  ),
                  label: Text(
                    'Approve Selected',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isAnyStudentSelected() {
    return allApplicationsOfDept
        .any((application) => application?.isStaffApproved ?? false);
  }

  void showApprovalMessage(BuildContext context) async {
    String msg = 'Selected students approved successfully!';
    IconData iconToSet = Icons.check_circle;
    MaterialColor clr = Colors.green;

    List<JobApplicationModel?> approvedApplications = allApplicationsOfDept
        .where((application) => application!.isStaffApproved)
        .toList();

    List<String> failedUpdates = [];

    for (var application in approvedApplications) {
      try {
        application?.status = "Applied";
        bool approvalResult =
            await JobApplicationRequests.updateApplication(application!);
        if (!approvalResult) {
          failedUpdates.add(application.id);
        }
      } catch (e) {
        failedUpdates.add(application!.id);
        // Optionally, log the exception or handle it as needed
        print('Failed to update application ${application.id}: $e');
      }
    }

    if (failedUpdates.isNotEmpty) {
      msg =
          'Some approvals failed for applications: ${failedUpdates.join(", ")}';
      iconToSet = Icons.cancel;
      clr = Colors.red;
    } else {
      msg = 'All approvals successful';
      iconToSet = Icons.check_circle;
      clr = Colors.green;
    }

// You can then show a message to the user using a Snackbar, AlertDialog, etc.

    // Create a GlobalKey for the overlay
    // GlobalKey<State> overlayKey = GlobalKey<State>();

    // Show overlay
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,
        bottom: 0.0,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Delay for 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      // Remove overlay after delay
      overlayEntry.remove();

      // Show success message
      showDialog(
        context: context,
        builder: (context) => Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    iconToSet,
                    color: clr,
                    size: 50,
                  ),
                  SizedBox(height: 16),
                  Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Done"))
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

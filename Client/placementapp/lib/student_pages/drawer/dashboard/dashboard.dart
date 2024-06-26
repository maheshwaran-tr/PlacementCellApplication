import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:placementapp/backend/models/job_post_model.dart';
import 'package:placementapp/student_pages/StudentNotification/StudentNotification.dart';

import '../../../api_requests/image_requests.dart';
import '../../../api_requests/job_application_requests.dart';
import '../../../api_requests/job_requests.dart';
import '../../../backend/models/applied_job_model.dart';
import '../../../backend/models/student_model.dart';
import '../../student_home_page/applied_job_list.dart';
import '../../student_home_page/job_list_page.dart';
import '../menu_page/menu_page.dart';

class DashBoard extends StatefulWidget {
  final Student student;

  const DashBoard({Key? key, required this.student}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final _drawerController = ZoomDrawerController();

  List<JobApplicationModel?> jobAppliedList = [];
  Map<String, JobPostModel?> jobData = {};
  List<String> attendedCompanies = [];
  List<String> companyStatus = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    print(widget.student.jobApplications);
    List<JobApplicationModel?> dupjobAppliedList = [];
    for (var appId in widget.student.jobApplications) {
      JobApplicationModel? jam = await JobApplicationRequests.findById(appId);
      jobData[jam!.job] = await JobRequests.findById(jam.job);
      dupjobAppliedList.add(jam);
    }

    print(jobAppliedList);

    setState(() {
      jobAppliedList = dupjobAppliedList;
      attendedCompanies = jobAppliedList.map((jam) => jobData[jam!.job]!.companyName).toList();
      companyStatus = jobAppliedList.map((jam) => jam!.status).toList();
    });
    print(attendedCompanies);
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else if (hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  IconData _getIconForGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 6) {
      return Icons.nightlight_round;
    } else if (hour < 12) {
      return Icons.wb_sunny;
    } else if (hour < 17) {
      return Icons.brightness_5;
    } else if (hour < 21) {
      return Icons.brightness_4;
    } else {
      return Icons.nightlight_round;
    }
  }

  List<Icon> catIcon = [
    Icon(Icons.assignment, color: Colors.white, size: 25),
    Icon(Icons.assessment, color: Colors.white, size: 25),
    Icon(Icons.plagiarism_sharp, color: Colors.white, size: 25),
  ];

  List<Color> catColor = [
    Colors.amberAccent,
    Colors.redAccent,
    Colors.deepPurpleAccent,
  ];

  List catName = [
    "Co-Ord",
    "Upload Status",
    "Apply Job",
  ];

  static const Map<String, IconData> companyStatusIcons = {
    "Selected": Icons.check_circle,
    "Not Selected": Icons.cancel,
    "Waiting for Result": Icons.access_time,
    "Not Attended": Icons.not_interested
  };

  static const Map<String, Color> companyStatusColors = {
    "Selected": Colors.green,
    "Not Selected": Colors.red,
    "Waiting for Result": Colors.grey,
    "Not Attended": Colors.amber
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ZoomDrawer(
          controller: _drawerController,
          style: DrawerStyle.defaultStyle,
          menuScreen: MenuPage(student: widget.student, selectedIndex: 0),
          mainScreen: buildMainScreen(),
          borderRadius: 25.0,
          angle: 0,
          mainScreenScale: 0.2,
          slideWidth: MediaQuery.of(context).size.width * 0.8,
        ),
      ),
    );
  }

  Widget buildMainScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _drawerController.toggle!();
                      },
                      child: Icon(Icons.dashboard_customize_rounded,
                          size: 30, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToNotifi();
                      },
                      child: Icon(Icons.notification_add_rounded,
                          size: 30, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15), // Adjust horizontal padding
                  child: ListTile(
                    contentPadding: EdgeInsets.zero, // Remove horizontal padding inside ListTile
                    title: Text(
                      'Hello!',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          _getGreeting(),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white54),
                        ),
                        SizedBox(width: 5), // Add spacing between text and icon
                        Icon(
                          _getIconForGreeting(),
                          color: Colors.white,
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 60, // Adjust the width of the trailing widget
                      height: 60, // Set a fixed height for the trailing widget
                      child: ClipOval(
                        child: FutureBuilder(
                          future: ImageRequests.fetchImageByStudentId(widget.student.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (!snapshot.hasData) {
                              return CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage('assets/images/user.jpg'),
                              );
                            } else {
                              // Image fetched successfully
                              return CircleAvatar(
                                radius: 30,
                                backgroundImage: MemoryImage(snapshot.data!),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 15, right: 15),
            child: GridView.builder(
              itemCount: catName.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (catName[index] == "Co-Ord") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CoOrdPage()),
                      );
                    } else if (catName[index] == "Upload Status") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentJobApplicationList(
                                student: widget.student)),
                      );
                    } else if (catName[index] == "Apply Job") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                JobListPage(studentProfile: widget.student)),
                      );
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: catColor[index],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: catIcon[index],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        catName[index],
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.7)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Attended Companies",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 21)),
                    Text("Count: ${attendedCompanies.length}",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.blue)),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: attendedCompanies.isEmpty
                      ? Center(
                          child: Text(
                            "No attended companies yet.",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: attendedCompanies.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(attendedCompanies[index],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Row(
                                  children: [
                                    Icon(
                                      companyStatusIcons[
                                              companyStatus[index]] ??
                                          Icons.info,
                                      color: companyStatusColors[
                                              companyStatus[index]] ??
                                          Colors.black,
                                    ),
                                    SizedBox(width: 8),
                                    Text("Status: ${companyStatus[index]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Full Details"),
                                              content: Text(
                                                "Details for ${attendedCompanies[index]}",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Close"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(Icons.remove_red_eye,
                                          color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToNotifi() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentNotificationsPage(),
      ),
    );
  }
}

class CoOrdPage extends StatelessWidget {
  const CoOrdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

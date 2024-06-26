import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:placementapp/api_requests/admin_requests.dart';
import '../../../backend/models/admin_model.dart';
import '../../AdminNotification/AdminNotification.dart';
import '../../admin_home_page/add_staff.dart';
import '../../admin_home_page/department_staff_list.dart';
import '../../admin_home_page/department_student_list.dart';
import '../../admin_home_page/job_applications.dart';
import '../../admin_home_page/jobs_list.dart';
import '../../admin_home_page/post_job.dart';
import '../../admin_home_page/posted_jobs.dart';
import '../menu_page/menu_page.dart';

class AdminDash extends StatefulWidget {
  final Admin admin;

  const AdminDash({Key? key, required this.admin}) : super(key: key);

  @override
  State<AdminDash> createState() => _AdminDashState();
}

class _AdminDashState extends State<AdminDash> {
  final _drawerController = ZoomDrawerController();

  @override
  void initState() {
    super.initState();
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
    Icon(
      Icons.assignment,
      color: Colors.white,
      size: 25,
    ),
    Icon(
      Icons.assessment,
      color: Colors.white,
      size: 25,
    ),
    Icon(
      Icons.plagiarism_sharp,
      color: Colors.white,
      size: 25,
    ),
    Icon(
      Icons.assignment,
      color: Colors.white,
      size: 25,
    ),
    Icon(
      Icons.assessment,
      color: Colors.white,
      size: 25,
    ),
  ];

  List<Color> catColor = [
    Colors.tealAccent,
    Colors.amberAccent,
    Colors.redAccent,
    Colors.deepPurpleAccent,
    Colors.cyan,
  ];

  List catName = [
    "Dept Student List",
    "Post Job",
    "Add Staff",
    "Posted Job",
    "Staff List",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: ZoomDrawer(
        controller: _drawerController,
        style: DrawerStyle.defaultStyle,
        menuScreen: AdminMenuPage(
          selectedIndex: 0,
          admin: widget.admin,
        ),
        mainScreen: buildMainScreen(),
        borderRadius: 25.0,
        angle: 0,
        // Adjust the angle for a more dynamic appearance
        mainScreenScale: 0.2,
        // Adjust the scale for the main screen
        slideWidth: MediaQuery.of(context).size.width * 0.8,
      )),
    );
  }

  Widget buildMainScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color(0xFFF2DF74),
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
                          size: 30, color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToNotifi();

                        print("Notification Icon Pressed");
                      },
                      child: Icon(Icons.notification_add_rounded,
                          size: 30, color: Colors.blue),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3, right: 15),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                    title: Text('Hello  !',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                            fontSize: 26)),
                    subtitle: Row(
                      children: [
                        Text(_getGreeting(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.blueGrey)),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          _getIconForGreeting(),
                          // Get dynamic icon based on time
                          color: Colors.black,
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 60, // Adjust the width of the trailing widget
                      height: 60, // Set a fixed height for the trailing widget
                      child: ClipOval(
                        child: FutureBuilder(
                          future: AdminRequests.fetchImageByAdminId(
                              widget.admin.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                                backgroundImage:
                                    AssetImage('assets/images/user.jpg'),
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
                )
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
                    if (catName[index] == "Add Staff") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddStaffPage()),
                      );
                    } else if (catName[index] == "Dept Student List") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DepartmentStudentListPage()),
                      );
                    } else if (catName[index] == "Post Job") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JobPostingScreen()),
                      );
                    } else if (catName[index] == "Staff List") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DepartmentStaffListPage()),
                      );
                    } else if (catName[index] == "Posted Job") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostedJobsListPage()),
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
                      SizedBox(
                        height: 10,
                      ),
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
          SizedBox(
            height: 20,
          ),
          Text(
            "STUDENT STATUS ",
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 40,
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 50,
                mainAxisSpacing: 10,
                children: [
                  itemDashboard(
                      'Job Applied List',
                      CupertinoIcons.rectangle_stack_person_crop_fill,
                      Colors.blueGrey),
                  itemDashboard('Job Selected List',
                      CupertinoIcons.briefcase_fill, Colors.cyanAccent),
                  // Add more items as needed
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget itemDashboard(String title, IconData iconData, Color background) =>
      GestureDetector(
        onTap: () {
          print(title);
          _navigateToPage(title, context);
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 5),
                    color: Theme.of(context).primaryColor.withOpacity(.1),
                    spreadRadius: 3,
                    blurRadius: 5)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(iconData, color: Colors.white)),
              const SizedBox(height: 8),
              Text(title.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium)
            ],
          ),
        ),
      );

  void _navigateToNotifi() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminNotificationsPage(),
      ),
    );
  }
}

Future<void> _navigateToPage(String pageTitle, BuildContext context) async {
  switch (pageTitle) {
    case 'Job Applied List':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobApplicationList(),
        ),
      );
      break;
    case 'Job Selected List':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectedJobApplicationList(),
        ),
      );
      break;
  }
}

// Future<List<JobApplicationModel>?> getApprovedStudentsForAdmin(
//     String token, int statusId) async {
//   List<JobApplicationModel>? applications =
//       await StudentRequest.getApprovedStudents(statusId);
//   return applications;
// }

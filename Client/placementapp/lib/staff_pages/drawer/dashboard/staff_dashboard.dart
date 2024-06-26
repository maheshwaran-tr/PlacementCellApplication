import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:placementapp/api_requests/staff_requests.dart';
import '../../../api_requests/student_requests.dart';
import '../../../backend/models/student_model.dart';
import '../../StaffNotification/StaffNotification.dart';
import '../../staff_home_page/add_student.dart';
import '../../staff_home_page/job-selected-list/job_list_page.dart';
import '../../staff_home_page/job_applied_list.dart';
import '../../staff_home_page/staff_approval_page.dart';
import '../../staff_home_page/staff_posted_job.dart';
import '../../staff_home_page/staff_student_list.dart';
import '../menu_page/menu_page.dart';
import '../../../backend/models/staff_model.dart';

class StaffDash extends StatefulWidget {
  final Staff staff;

  const StaffDash({Key? key, required this.staff}) : super(key: key);

  @override
  State<StaffDash> createState() => _StaffDashState();
}

class _StaffDashState extends State<StaffDash> {
  String department = "";
  List<Student> students = [];
  final _drawerController = ZoomDrawerController();

  @override
  void initState() {
    super.initState();
    intitData();
  }

  Future<void> intitData() async {
    String dept = widget.staff.department;
    List<Student>? allStudents = await StudentRequests.getStudentsByDept(dept);

    if (allStudents != null) {
      List<Student> willingStudents = allStudents
          .where((student) => student.placementWilling == true)
          .toList();

      setState(() {
        students = willingStudents;
        department = dept;
      });
    }
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
    Icon(Icons.assignment, color: Colors.white, size: 25),
    Icon(Icons.assessment, color: Colors.white, size: 25),
  ];

  List<Color> catColor = [
    Colors.tealAccent,
    Colors.amberAccent,
    Colors.redAccent,
    Colors.deepPurpleAccent,
    Colors.cyan,
  ];

  List catName = [
    "Placement Willing",
    "Student List",
    "Posted Job",
    "Add Student",
    "Job Applied List"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshData,
          child: ZoomDrawer(
            controller: _drawerController,
            style: DrawerStyle.defaultStyle,
            menuScreen: StaffMenuPage(
              selectedIndex: 0,
              staffProfile: widget.staff,
            ),
            mainScreen: buildMainScreen(),
            borderRadius: 25.0,
            angle: 0,
            mainScreenScale: 0.2,
            slideWidth: MediaQuery.of(context).size.width * 0.8,
          ),
        ),
      ),
    );
  }

  Future<void> refreshData() async {
    await intitData();
  }

  Widget buildMainScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color(0xFFF9F8F4),
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
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 3, right: 15),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                    title: Text('Hello  !',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 26)),
                    subtitle: Row(
                      children: [
                        Text(_getGreeting(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.black87)),
                        SizedBox(width: 10),
                        Icon(
                          _getIconForGreeting(),
                          color: Colors.yellow,
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 60, // Adjust the width of the trailing widget
                      height: 60, // Set a fixed height for the trailing widget
                      child: ClipOval(
                        child: FutureBuilder(
                          future: StaffRequests.fetchImageByStaffId(
                              widget.staff.id!),
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
                    if (catName[index] == "Student List") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StaffStudentListPage(
                                  department: widget.staff.department,
                                )),
                      );
                    } else if (catName[index] == "Add Student") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddStudentPage()));
                    } else if (catName[index] == "Job Applied List") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JobAppliedListPage(
                                    dept: widget.staff.department,
                                  )));
                    } else if (catName[index] == "Placement Willing") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ApprovalPage(
                                    department: widget.staff.department,
                                  )));
                    } else if (catName[index] == "Posted Job") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StaffPostedJobsListPage()));
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
          Text(
            "STUDENT STATUS ",
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
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
                      '  Approved \nJobApply List',
                      CupertinoIcons.rectangle_stack_person_crop_fill,
                      Colors.blueGrey),
                  itemDashboard('Job Selected List',
                      CupertinoIcons.briefcase_fill, Colors.cyanAccent),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget itemDashboard(String title, IconData iconData, Color background) =>
      GestureDetector(
        onTap: () {
          print(title);
          _navigateToPage(title);
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
        builder: (context) => StaffNotificationsPage(),
      ),
    );
  }

  void _navigateToPage(String pageTitle) {
    switch (pageTitle) {
      case "Job Selected List":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobSelectedListPage(
              studentList: students, dept: widget.staff.department,
            ),
          ),
        );
        break;
      // Add other cases as needed
    }
  }
}

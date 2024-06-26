import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../api_requests/image_requests.dart';
import '../../backend/models/student_model.dart';
import '../drawer/menu_page/menu_page.dart';

class StudentProfilePage extends StatefulWidget {
  final Student student;

  const StudentProfilePage({Key? key, required this.student}) : super(key: key);

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final _drawerController = ZoomDrawerController();
  bool isContactExpanded = false;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.lightBlueAccent,
        leading: IconButton(
          onPressed: () {
            _drawerController.toggle!();
          },
          icon: Icon(
            Icons.dashboard_customize_rounded,
            size: 30,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Center(child: Text('Student Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),)),
      ),
      extendBodyBehindAppBar: true,

      body: SafeArea(

        child: ZoomDrawer(
          controller: _drawerController,
          style: DrawerStyle.defaultStyle,
          menuScreen: MenuPage(student: widget.student, selectedIndex: 1,),
          mainScreen: buildMainScreen(),
          borderRadius: 25.0,
          angle: 0,
          // Adjust the angle for a more dynamic appearance
          mainScreenScale: 0.2,
          // Adjust the scale for the main screen
          slideWidth: MediaQuery
              .of(context)
              .size
              .width * 0.8,
        ),
      ),
    );
  }

  Widget buildMainScreen() {
    return SingleChildScrollView(
      child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlueAccent, Colors.white],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 45),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: FutureBuilder(
                            future: ImageRequests.fetchImageByStudentId(
                                widget.student.id),
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
                                return Center(
                                  child: Text('No data available'),
                                );
                              } else {
                                // Image fetched successfully
                                return Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                Center(
                  child: Text(
                    widget.student.studentName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    widget.student.rollNo,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    widget.student.regNo,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 2),
                Center(
                  child: Text(
                    widget.student.department,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 2),
                Center(
                  child: Text(
                    widget.student.email,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                buildExpansionTile(
                  title: 'Contact Information',
                  isExpanded: isContactExpanded,
                  onPressed: () {
                    setState(() {
                      isContactExpanded = !isContactExpanded;
                    });
                  },
                  children: [
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Phone Number'),
                      subtitle: Text(widget.student.phoneNumber),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text('Address'),
                      subtitle: Text(widget.student.presentAddress),
                    ),
                  ],
                ),
                // ... your existing code
              ],
            ),
          )
      ),

    );
  }


  Widget buildExpansionTile({
    required String title,
    required bool isExpanded,
    required Function onPressed,
    required List<Widget> children,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ExpansionTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          onExpansionChanged: (value) {
            onPressed();
          },
          initiallyExpanded: isExpanded,
          children: children,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:placementapp/api_requests/staff_requests.dart';

import '../../backend/models/staff_model.dart';
import '../drawer/menu_page/menu_page.dart';

class StaffProfilePage extends StatefulWidget {
  final Staff staff;

  const StaffProfilePage({super.key, required this.staff});

  @override
  State<StaffProfilePage> createState() => _StaffProfilePageState();
}

class _StaffProfilePageState extends State<StaffProfilePage> {
  final _drawerController = ZoomDrawerController();

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
        backgroundColor: Colors.white,
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
        title: Center(
            child: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: ZoomDrawer(
        controller: _drawerController,
        style: DrawerStyle.defaultStyle,
        menuScreen: StaffMenuPage(
          selectedIndex: 1,
          staffProfile: widget.staff,
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
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
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(
                            widget.staff.staffName,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.staff.department,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProfileField('Staff ID', widget.staff.staffId, Icons.work),
              buildProfileField('Email', widget.staff.email, Icons.email),
              buildProfileField(
                  'Phone Number', widget.staff.phoneNumber, Icons.phone),
            ],
          ),
        ),
      ],
    ));
  }

  Widget buildProfileField(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.blueAccent,
            size: 24,
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

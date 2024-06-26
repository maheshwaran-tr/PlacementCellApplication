import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../../backend/models/student_model.dart';
import 'dashboard/dashboard.dart';
import 'menu_page/menu_page.dart';

class StudentDrawerHome extends StatefulWidget {
  final Student student;

  const StudentDrawerHome({Key? key, required this.student}) : super(key: key);

  @override
  State<StudentDrawerHome> createState() => _StudentDrawerHomeState();
}

class _StudentDrawerHomeState extends State<StudentDrawerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZoomDrawer(
        angle: 0.0,
        mainScreen: DashBoard(
          student: widget.student,
        ),
        menuScreen: MenuPage(
          selectedIndex: 0,
          student: widget.student,
        ),
      ),
    );
  }
}

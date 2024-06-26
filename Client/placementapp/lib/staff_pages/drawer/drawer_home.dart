import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../backend/models/staff_model.dart';
import 'dashboard/staff_dashboard.dart';
import 'menu_page/menu_page.dart';

class StaffDrawerHome extends StatefulWidget {
  final Staff staff;

  const StaffDrawerHome({Key? key, required this.staff}) : super(key: key);

  @override
  State<StaffDrawerHome> createState() => _StaffDrawerHomeState();
}

class _StaffDrawerHomeState extends State<StaffDrawerHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ZoomDrawer(
      angle: 0.0,
      mainScreen: StaffDash(
        staff: widget.staff,
      ),
      menuScreen: StaffMenuPage(
        selectedIndex: 0,
        staffProfile: widget.staff,
      ),
    ));
  }
}

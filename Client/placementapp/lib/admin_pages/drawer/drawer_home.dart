import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../backend/models/admin_model.dart';
import 'dashboard/dashboard.dart';
import 'menu_page/menu_page.dart';

class AdminDrawerHome extends StatefulWidget {
  final Admin admin;
  const AdminDrawerHome({Key? key, required this.admin}) : super(key: key);

  @override
  State<AdminDrawerHome> createState() => _AdminDrawerHomeState();
}

class _AdminDrawerHomeState extends State<AdminDrawerHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ZoomDrawer(
      angle: 0.0,
      mainScreen: AdminDash(admin: widget.admin,),
      menuScreen: AdminMenuPage(
        selectedIndex: 0,
        admin: widget.admin,
      ),
    ));
  }
}

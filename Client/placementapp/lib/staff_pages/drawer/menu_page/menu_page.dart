import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:placementapp/backend/token/token_storage.dart';

import '../../../backend/models/staff_model.dart';
import '../../../homepage/home_page.dart';
import '../../StaffChangePassword/StaffChangePassword.dart';
import '../../staff_profile_page/staff_profile.dart';
import '../drawer_home.dart';


class StaffMenuPage extends StatefulWidget {
  final int selectedIndex;
  final Staff staffProfile;
  const StaffMenuPage({Key? key, required this.selectedIndex,required this.staffProfile}) : super(key: key);

  @override
  State<StaffMenuPage> createState() => _StaffMenuPageState();
}

class MenuOption {
  final IconData icon;
  final String title;

  MenuOption(this.icon, this.title);
}

class MenuOptions {

  static final home = MenuOption(Icons.home, "Home");
  static final profile = MenuOption(Icons.person, "Profile");
  static final changePass = MenuOption(Icons.lock_person, "Change Password");

  static final logout = MenuOption(Icons.logout, "Logout");

  static final allOptions = [home, profile, changePass, logout];
}

class _StaffMenuPageState extends State<StaffMenuPage> {
  int selectedIndex = 0; // Default to the Home page// Default to the Home page

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedIndex = widget.selectedIndex;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xE3FFFFE1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
              onTap: () {
                ZoomDrawer.of(context)!.close();
              },
              child: const Icon(
                Icons.close,
                color: Colors.black54,
                size: 30,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Text(
                      "Hello,",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.staffProfile.staffName,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: MenuOptions.allOptions.length,
                itemBuilder: (BuildContext context, int index) {
                  final option = MenuOptions.allOptions[index];
                  return ListTile(
                    tileColor: index == selectedIndex ? Colors.lightBlueAccent.shade100 : null,
                    leading: Icon(
                      option.icon,
                      color: index == selectedIndex ? Colors.lightBlueAccent.shade100 : Colors.black,
                    ),
                    title: Text(
                      option.title,
                      style: TextStyle(
                        fontSize: 18,
                        color: index == selectedIndex ? Colors.lightBlueAccent.shade100 : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      handleMenuOptionTap(option, index);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> handleMenuOptionTap(MenuOption option, int index) async {
    setState(() {
      selectedIndex = index; // Update the selected index
    });

    if (option == MenuOptions.home) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StaffDrawerHome(staff: widget.staffProfile,),
        ),
      );
      // Add your logic for Home here
    } else if (option == MenuOptions.profile) {
      print('Tapped on Profile');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StaffProfilePage(staff: widget.staffProfile,),
        ),
      );// Add your logic for Profile here
    } else if (option == MenuOptions.changePass) {
      print('Tapped on ChangePassword');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StaffChangePasswordPage(staff: widget.staffProfile,),
        ),
      );
      // Add your logic for Setting here
    } else if (option == MenuOptions.logout) {
      TokenStorage.deleteTokens();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
      print('Logout pressed');
      // Add your logic for Logout here
    }

    // Close the drawer after handling the tap
    ZoomDrawer.of(context)!.close();
  }
}
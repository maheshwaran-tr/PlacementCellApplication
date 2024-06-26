import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../backend/models/admin_model.dart';
import '../drawer/menu_page/menu_page.dart';

class AdminChangePasswordPage extends StatefulWidget {
  final Admin admin;
  const AdminChangePasswordPage({super.key, required this.admin});

  @override
  _AdminChangePasswordPageState createState() =>
      _AdminChangePasswordPageState();
}

class _AdminChangePasswordPageState extends State<AdminChangePasswordPage> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _drawerController = ZoomDrawerController();
  String errorText = '';
  bool isLoading = false;

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
          'Change Password',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        )),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: ZoomDrawer(
        controller: _drawerController,
        style: DrawerStyle.defaultStyle,
        menuScreen: AdminMenuPage(
          selectedIndex: 2,
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.lock_outline,
              size: 100,
              color: Colors.greenAccent,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              errorText,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                // Reset error message
                setState(() {
                  errorText = '';
                });

                // Add your password change logic here
                String currentPassword = currentPasswordController.text;
                String newPassword = newPasswordController.text;
                String confirmPassword = confirmPasswordController.text;

                // Example validation - Add your own validation logic
                if (currentPassword.isEmpty ||
                    newPassword.isEmpty ||
                    confirmPassword.isEmpty) {
                  // Show error message
                  setState(() {
                    errorText = 'Please fill in all fields';
                  });
                } else if (newPassword.length < 8) {
                  // Show error message for minimum length
                  setState(() {
                    errorText = 'New Password must be at least 8 characters';
                  });
                } else if (newPassword != confirmPassword) {
                  // Show error message
                  setState(() {
                    errorText =
                        'New Password and Confirm Password do not match';
                  });
                } else {
                  // Start loading process
                  setState(() {
                    isLoading = true;
                  });

                  // Simulate password change process
                  await Future.delayed(Duration(seconds: 2));

                  // Password change logic goes here
                  // For demonstration, we print a success message
                  print('Password changed successfully');

                  // Stop loading process
                  setState(() {
                    isLoading = false;
                  });

                  // Clear text fields
                  currentPasswordController.clear();
                  newPasswordController.clear();
                  confirmPasswordController.clear();

                  // Display success message with an innovative design
                  showInnovativePopup(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show an innovative success popup
  void showInnovativePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 60,
                  color: Colors.green,
                ),
                SizedBox(height: 20),
                Text(
                  'Password Changed Successfully!',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

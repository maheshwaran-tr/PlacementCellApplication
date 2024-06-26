import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lottie/lottie.dart';
import 'package:placementapp/api_requests/admin_requests.dart';
import 'package:placementapp/api_requests/staff_requests.dart';
import 'package:placementapp/backend/models/admin_model.dart';
import 'package:placementapp/backend/models/user_model.dart';

import '../admin_pages/drawer/drawer_home.dart';
import '../api_requests/student_requests.dart';
import '../api_requests/user_requests.dart';
import '../backend/models/staff_model.dart';
import '../backend/models/student_model.dart';
import '../backend/token/token_storage.dart';
import '../homepage/home_page.dart';
import '../staff_pages/drawer/drawer_home.dart';
import '../student_pages/drawer/drawer_home.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkTokenAndNavigate();
      }
    });
    _controller.forward();
  }

  _checkTokenAndNavigate() async {

    // getting saved token from TokenStorage
    String? savedToken = await TokenStorage.getAccessToken();
    print(savedToken);
    // if token is null
    if (savedToken == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // decoding token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(savedToken);

      // getting userid from token
      String userID = decodedToken['id'];
      User theUser = await UserRequest.getUserDataById(userID);
      String role = theUser.role;

      // checking if expired
      if (JwtDecoder.isExpired(savedToken)) {
        // AuthRequest.logout(savedToken);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),  // navigating to home page
        );
      } else {
        // if not expired
        if (role == "Student") {
          Student theStudent = await StudentRequests.getStudentById(theUser.roleId);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => StudentDrawerHome(student: theStudent,)),
          );
        } else if (role == "Staff") {
           Staff staff = await StaffRequests.getStaffById(theUser.roleId);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => StaffDrawerHome(staff: staff,)),
          );
        } else if (role == "Admin") {
          Admin admin = await AdminRequests.getAdminById(theUser.roleId);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AdminDrawerHome(admin: admin,)),
          );
        } else {
          print("Unknown error from splash screen");
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Lottie.asset(
              'assets/lottie/flow1.json',
              fit: BoxFit.fitWidth,
              controller: _controller,
              onLoaded: (composition) {
                _controller
                  ..duration = composition.duration
                  ..forward();
              },
            ),
          ),
          Positioned(
            bottom: 140,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

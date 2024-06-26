import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:placementapp/api_requests/auth_request.dart';
import 'package:placementapp/api_requests/user_requests.dart';
import 'package:placementapp/backend/models/student_model.dart';
import 'package:placementapp/backend/token/token_storage.dart';

import '../student_pages/drawer/drawer_home.dart';
import 'forgot_password_page.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({Key? key}) : super(key: key);

  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isNotValidate = false;
  bool isPasswordVisible = false; // Added variable for password visibility

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text('Student Login'),
      ),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: Transform.translate(
              offset: Offset(0.0, 30 * (1 - _animation.value)),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Hero(
                          tag: 'student_icon',
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 40 * _animation.value,
                            child: Icon(
                              Icons.school,
                              size: 50,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Text(
                          "Student Login",
                          style: TextStyle(
                            fontSize: 30 * _animation.value,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Opacity(
                          opacity: 0.6,
                          child: Text(
                            "Login to your account",
                            style: TextStyle(
                              fontSize: 15 * _animation.value,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Column(
                                children: <Widget>[
                                  makeInput(label: "Username"),
                                  makeInput(
                                      label: "Password", obscureText: true),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (usernameController.text.isEmpty ||
                                      passwordController.text.isEmpty) {
                                    setState(() {
                                      isNotValidate = true;
                                    });
                                  } else {
                                    setState(() {
                                      isNotValidate = false;
                                    });
                                    Map<String, dynamic>? loginData =
                                        await AuthRequests.loginUser(
                                      usernameController.text,
                                      passwordController.text,
                                    );

                                    print(loginData);
                                    var accessToken =
                                        loginData!['access_token'];
                                    if (accessToken != null &&
                                        accessToken.isNotEmpty) {
                                      // Map<String, dynamic> decodedToken =
                                      //     JwtDecoder.decode(accessToken);
                                      String role = loginData['role'];
                                      if (role == "Student") {
                                        Student student = Student.fromJson(
                                            loginData["user_data"]);

                                        bool res =
                                            await UserRequest.updateFcmToken(
                                                loginData["user_id"],
                                                await TokenStorage
                                                    .getFCMToken());
                                        if (res) {
                                          print("FCM UPDATED");
                                        } else {
                                          print("FCM NOT UPDATED");
                                        }

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StudentDrawerHome(
                                              student: student,
                                            ),
                                          ),
                                        );
                                      } else if (role == "Staff") {
                                        print("STAFF NOT ALLOWED");
                                      } else if (role == "Admin") {
                                        print("ADMIN NOT ALLOWED");
                                      } else {
                                        print("STRANGER NOT ALLOWED");
                                      }
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: EdgeInsets.all(0),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.greenAccent,
                                        Colors.lightGreenAccent
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(minHeight: 60),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgottenPassword(),
                                  ),
                                );
                              },
                              child: Text(
                                "Forgotten Password",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            if (isNotValidate)
                              Text(
                                "Please fill in both username and password.",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 4,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/ill.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget makeInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          obscureText: label == "Password" ? !isPasswordVisible : obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            suffixIcon: label == "Password"
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  )
                : null,
          ),
          controller:
              label == "Username" ? usernameController : passwordController,
        ),
        SizedBox(height: 30),
      ],
    );
  }
}

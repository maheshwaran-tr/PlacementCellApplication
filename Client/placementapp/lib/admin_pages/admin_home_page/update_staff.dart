import 'package:flutter/material.dart';
import 'package:placementapp/api_requests/staff_requests.dart';

import '../../backend/models/staff_model.dart';

class UpdateStaffPage extends StatefulWidget {
  final Staff staff;
  
  const UpdateStaffPage({Key? key, required this.staff});

  @override
  _UpdateStaffPageState createState() => _UpdateStaffPageState();
}

class _UpdateStaffPageState extends State<UpdateStaffPage> {
  TextEditingController staffIdController = TextEditingController();
  TextEditingController staffNameController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  String errorMessage = '';
  bool isProcessing = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    staffIdController.text = widget.staff.staffId;
    staffNameController.text = widget.staff.staffName;
    departmentController.text = widget.staff.department;
    emailController.text = widget.staff.email;
    phoneNumberController.text=widget.staff.phoneNumber;
  }

  void validateAndSubmit() {
    if (staffIdController.text.isEmpty ||
        staffNameController.text.isEmpty ||
        departmentController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneNumberController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all fields';
      });
    } else {
      setState(() {
        errorMessage = '';
        isProcessing = true;
      });

      Staff staff = Staff(
        id: widget.staff.id,
        staffId: staffIdController.text,
        staffName: staffNameController.text,
        department: departmentController.text,
        email: emailController.text,
        phoneNumber: phoneNumberController.text,
      );

      Future.delayed(Duration(seconds: 2), () async {
        setState(() {
          isProcessing = false;
        });

        bool response = await StaffRequests.updateStaff(staff);

        if (response) {
          showSuccessDialog("Success","Staff details submitted successfully!");
          // staffIdController.clear();
          // staffNameController.clear();
          // departmentController.clear();
          // emailController.clear();
          // phoneNumberController.clear();
        }else{
          showSuccessDialog("Failed","Failed to add staff!");
        }
      });
    }
  }

  void showSuccessDialog(String title,String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Staff details submitted successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Staff'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextField(
                "Staff ID",
                Icons.badge,
                staffIdController,
              ),
              SizedBox(height: 16.0),
              buildTextField(
                "Staff Name",
                Icons.person,
                staffNameController,
              ),
              SizedBox(height: 16.0),
              buildTextField(
                "Department",
                Icons.work,
                departmentController,
              ),
              SizedBox(height: 16.0),
              buildTextField(
                "Email",
                Icons.email,
                emailController,
              ),
              SizedBox(height: 16.0),
              buildTextField(
                "Phone Number",
                Icons.phone,
                phoneNumberController,
              ),
              SizedBox(height: 16.0),
              Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: isProcessing ? null : validateAndSubmit,
                child: isProcessing
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    IconData icon,
    TextEditingController controller,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }
}

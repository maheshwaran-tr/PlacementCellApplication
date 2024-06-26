import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:placementapp/api_requests/job_requests.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:placementapp/api_requests/notification_requests.dart';

import '../../backend/models/job_post_model.dart';

class JobPostingScreen extends StatefulWidget {
  const JobPostingScreen({Key? key}) : super(key: key);

  @override
  _JobPostingScreenState createState() => _JobPostingScreenState();
}

class _JobPostingScreenState extends State<JobPostingScreen> {
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyLocationController = TextEditingController();
  TextEditingController jobNameController = TextEditingController();
  TextEditingController jobDetailsController = TextEditingController();
  TextEditingController skillsController = TextEditingController();
  TextEditingController arrearsHistoryController = TextEditingController();
  TextEditingController tenthMarkController = TextEditingController();
  TextEditingController twelveController = TextEditingController();
  TextEditingController cgpaController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController venueController = TextEditingController();

  String? filePath;
  String? logoPath;
  String? campusMode;
  List<String> selectedDepartments = [];
  List<String> campusModes = ['On-campus', 'Off-campus'];
  final List<String> departments = ['CSD', 'CSE', 'AIDS', 'MECH'];

  @override
  void initState() {
    super.initState();
    // Initialize with all departments selected
    selectedDepartments = List.from(departments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
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
        title: Text(
          "Job Posting",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCompanySection(),
              SizedBox(height: 15),
              _buildJobDetailsSection(),
              SizedBox(height: 15),
              _buildEligibilitySection(),
              SizedBox(height: 15),
              _buildInterviewSection(),
              SizedBox(height: 15),
              _buildDepartmentSelectionSection(),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _postJob,
                  child: Text('Post Job'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanySection() {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Company Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: companyNameController,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Company Name',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: companyLocationController,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Company Location',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobDetailsSection() {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Job Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: jobNameController,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Job Name',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: jobDetailsController,
              maxLines: 3,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Job Details',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: skillsController,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Required Skills (comma separated)',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEligibilitySection() {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Eligibility Criteria',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: arrearsHistoryController,
              style: TextStyle(fontSize: 16),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              decoration: InputDecoration(
                hintText: 'History of Arrears',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: campusMode,
              onChanged: (newValue) {
                setState(() {
                  campusMode = newValue;
                });
              },
              items: campusModes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                hintText: 'Select Campus Mode',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: tenthMarkController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: '10th Mark',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: twelveController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: '12th Mark',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: cgpaController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'CGPA',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterviewSection() {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interview Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              readOnly: true,
              controller: dateController,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Select Interview Date',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (selectedDate != null) {
                  dateController.text =
                      "${selectedDate.toLocal()}".split(' ')[0];
                }
              },
            ),
            SizedBox(height: 10),
            TextField(
              readOnly: true,
              controller: timeController,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Select Interview Time',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onTap: () async {
                TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  timeController.text = selectedTime.format(context);
                }
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: venueController,
              style: TextStyle(fontSize: 16),
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Interview Address',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentSelectionSection() {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Eligible Departments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            MultiSelectDialogField(
              items: departments
                  .map((department) => MultiSelectItem(department, department))
                  .toList(),
              initialValue: selectedDepartments,
              title: Text("Departments"),
              selectedColor: Colors.blue,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
              buttonIcon: Icon(
                Icons.arrow_drop_down,
                color: Colors.blue,
              ),
              buttonText: Text(
                "Select Eligible Departments",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
              onConfirm: (results) {
                setState(() {
                  selectedDepartments = results.cast<String>();
                });
              },
              chipDisplay: MultiSelectChipDisplay(
                onTap: (value) {
                  setState(() {
                    selectedDepartments.remove(value);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        logoPath = pickedFile.path;
      });
    }
  }

  void _postJob() async {
    try {
      JobPostModel newJobPost = JobPostModel(
        id: '1', // Placeholder ID; should be generated by the backend.
        companyName: companyNameController.text,
        companyLocation: companyLocationController.text,
        venue: venueController.text,
        jobName: jobNameController.text,
        description: jobDetailsController.text,
        campusMode: campusMode ?? '',
        eligible10ThMark: double.tryParse(tenthMarkController.text) ?? 0,
        eligible12ThMark: double.tryParse(twelveController.text) ?? 0,
        eligibleCgpa: double.tryParse(cgpaController.text) ?? 0.0,
        interviewDate: dateController.text,
        interviewTime: timeController.text,
        historyOfArrears: int.tryParse(arrearsHistoryController.text) ?? 0,
        skills: skillsController.text.split(',').map((e) => e.trim()).toList(),
        jobApplications: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool isPosted = await JobRequests.postJob(newJobPost);

      if (isPosted) {
        showSuccessDialog("Success", "Job posted Successfully",
            Icons.check_circle, Colors.green);
        sendNotificationsToDept(selectedDepartments);
      } else {
        showSuccessDialog(
            "Failed", "Failed to post job", Icons.check_circle, Colors.red);
      }

      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post job: $e')),
      );
    }
  }

  void sendNotificationsToDept(List<String> departments) async {
    // Implement notification sending logic here
    // Example: send a request to the backend to notify selected departments
    String title = "New Job Posted";
    String body = "New Job From ${companyNameController.text}";
    bool isSent = await NotificationRequests.sendNotificationsToDept(title,body,departments);
    if(isSent){
      print("Notification Sent");
    }else{
      print("Notification not sent");
    }
    print(departments);
  }

  void showSuccessDialog(
      String status, String msg, IconData symbol, MaterialColor clr) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(symbol, color: clr),
              SizedBox(width: 8),
              Text(status),
            ],
          ),
          content: Text(msg),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    // companyNameController.clear();
    // companyLocationController.clear();
    // jobNameController.clear();
    // jobDetailsController.clear();
    // skillsController.clear();
    // arrearsHistoryController.clear();
    // tenthMarkController.clear();
    // twelveController.clear();
    // cgpaController.clear();
    // dateController.clear();
    // timeController.clear();
    // venueController.clear();
    setState(() {
      filePath = null;
      logoPath = null;
      // campusMode = null;
      // selectedDepartments = List.from(departments); // Reset to all departments
    });
  }
}

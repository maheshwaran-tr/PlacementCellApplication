import 'package:flutter/material.dart';

import '../../api_requests/student_requests.dart';
import '../../backend/models/student_model.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({Key? key}) : super(key: key);

  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final Map<String, TextEditingController> _controllers = {};
  bool? placementWilling;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllers['studentName'] = TextEditingController();
    _controllers['rollNo'] = TextEditingController();
    _controllers['regNo'] = TextEditingController();
    _controllers['cgpa'] = TextEditingController();
    _controllers['standingArrears'] = TextEditingController();
    _controllers['historyOfArrears'] = TextEditingController();
    _controllers['department'] = TextEditingController();
    _controllers['section'] = TextEditingController();
    _controllers['dob'] = TextEditingController();
    _controllers['gender'] = TextEditingController();
    _controllers['placeOfBirth'] = TextEditingController();
    _controllers['email'] = TextEditingController();
    _controllers['phoneNumber'] = TextEditingController();
    _controllers['permanentAddress'] = TextEditingController();
    _controllers['presentAddress'] = TextEditingController();
    _controllers['community'] = TextEditingController();
    _controllers['fatherName'] = TextEditingController();
    _controllers['fatherOccupation'] = TextEditingController();
    _controllers['motherName'] = TextEditingController();
    _controllers['motherOccupation'] = TextEditingController();
    _controllers['score10th'] = TextEditingController();
    _controllers['board10th'] = TextEditingController();
    _controllers['yearOfPassing10th'] = TextEditingController();
    _controllers['score12th'] = TextEditingController();
    _controllers['board12th'] = TextEditingController();
    _controllers['yearOfPassing12th'] = TextEditingController();
    _controllers['scoreDiploma'] = TextEditingController();
    _controllers['branchDiploma'] = TextEditingController();
    _controllers['yearOfPassingDiploma'] = TextEditingController();
    _controllers['parentPhoneNumber'] = TextEditingController();
    _controllers['aadhar'] = TextEditingController();
    _controllers['batch'] = TextEditingController();
    _controllers['currentSem'] = TextEditingController();
    placementWilling = true;
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  String errorMessage = "";
  bool isProcessing = false;

  Future<void> validateAndSubmit() async {
    setState(() {
      errorMessage = "";
      isProcessing = true;
    });

    final createdStudent = Student(
        id: '1',
        studentName: _controllers['studentName']!.text,
        department: _controllers['department']!.text,
        section: _controllers['section']!.text,
        dateOfBirth: _controllers['dob']!.text,
        gender: _controllers['gender']!.text,
        placeOfBirth: _controllers['placeOfBirth']!.text,
        email: _controllers['email']!.text,
        phoneNumber: _controllers['phoneNumber']!.text,
        permanentAddress: _controllers['permanentAddress']!.text,
        presentAddress: _controllers['presentAddress']!.text,
        currentSem: int.tryParse(_controllers['currentSem']!.text)!,
        community: _controllers['community']!.text,
        fatherName: _controllers['fatherName']!.text,
        fatherOccupation: _controllers['fatherOccupation']!.text,
        motherName: _controllers['motherName']!.text,
        motherOccupation: _controllers['motherOccupation']!.text,
        score10Th: double.tryParse(_controllers['score10th']!.text)!,
        board10Th: _controllers['board10th']!.text,
        yearOfPassing10Th: _controllers['yearOfPassing10th']!.text,
        score12Th: double.tryParse(_controllers['score12th']!.text)!,
        board12Th: _controllers['board12th']!.text,
        yearOfPassing12Th: _controllers['yearOfPassing12th']!.text,
        scoreDiploma: _controllers['scoreDiploma']!.text,
        branchDiploma: _controllers['branchDiploma']!.text,
        yearOfPassingDiploma: _controllers['yearOfPassingDiploma']!.text,
        parentPhoneNumber: _controllers['parentPhoneNumber']!.text,
        aadhar: _controllers['aadhar']!.text,
        placementWilling: placementWilling,
        batch: int.tryParse(_controllers['batch']!.text) ?? 0,
        rollNo: _controllers['rollNo']!.text,
        regNo: _controllers['regNo']!.text,
        cgpa: double.tryParse(_controllers['cgpa']!.text)!,
        standingArrears: int.tryParse(_controllers['standingArrears']!.text)!,
        historyOfArrears: int.tryParse(_controllers['historyOfArrears']!.text)!,
        jobApplications: []
        // updatedAt: DateTime.now(),
        );

    bool isUpdated = await StudentRequests.addStudent(createdStudent);

    setState(() {
      isProcessing = false;
    });

    if (isUpdated) {
      showSuccessDialog("Success", "Student Added Successfully",
          Icons.check_circle, Colors.green);
      _controllers.values.forEach((controller) => controller.clear());
      setState(() {
        placementWilling = null;
      });
    } else {
      showSuccessDialog(
          "Failure", "Student Not Added", Icons.close_rounded, Colors.red);
    }
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

  Widget buildTextField(String labelText, String key,
      {bool readOnly = false, bool isNumeric = false, void Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controllers[key],
        readOnly: readOnly,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget buildPlacementWillingField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Placement Willing',
            style: TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: placementWilling,
                onChanged: (bool? value) {
                  setState(() {
                    placementWilling = value;
                  });
                },
              ),
              Text('Yes'),
              Radio<bool>(
                value: false,
                groupValue: placementWilling,
                onChanged: (bool? value) {
                  setState(() {
                    placementWilling = value;
                  });
                },
              ),
              Text('No'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildTextField('Student Name', 'studentName'),
            buildTextField('Roll No', 'rollNo'),
            buildTextField('Reg No', 'regNo'),
            buildTextField('CGPA', 'cgpa', isNumeric: true),
            buildTextField('Standing Arrear', 'standingArrears',
                isNumeric: true),
            buildTextField('History of Arrear', 'historyOfArrears',
                isNumeric: true),
            buildTextField('Department', 'department'),
            buildTextField('Section', 'section'),
            buildTextField('Date of Birth', 'dob',
                readOnly: true, onTap: () => _selectDate(context)),
            buildTextField('Gender', 'gender'),
            buildTextField('Place of Birth', 'placeOfBirth'),
            buildTextField('Email', 'email'),
            buildTextField('Phone Number', 'phoneNumber'),
            buildTextField('Permanent Address', 'permanentAddress'),
            buildTextField('Present Address', 'presentAddress'),
            buildTextField('Community', 'community'),
            buildTextField('Father Name', 'fatherName'),
            buildTextField('Father Occupation', 'fatherOccupation'),
            buildTextField('Mother Name', 'motherName'),
            buildTextField('Mother Occupation', 'motherOccupation'),
            buildTextField('10th Score', 'score10th', isNumeric: true),
            buildTextField('10th Board', 'board10th'),
            buildTextField('Year of Passing 10th', 'yearOfPassing10th'),
            buildTextField('12th Score', 'score12th', isNumeric: true),
            buildTextField('12th Board', 'board12th'),
            buildTextField('Year of Passing 12th', 'yearOfPassing12th'),
            buildTextField('Diploma Score', 'scoreDiploma'),
            buildTextField('Diploma Branch', 'branchDiploma'),
            buildTextField('Year of Passing Diploma', 'yearOfPassingDiploma'),
            buildTextField('Parent Phone Number', 'parentPhoneNumber'),
            buildTextField('Aadhar', 'aadhar'),
            buildPlacementWillingField(),
            buildTextField('Batch', 'batch', isNumeric: true),
            buildTextField('Current Sem', 'currentSem', isNumeric: true),
            SizedBox(height: 20),
            isProcessing
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: validateAndSubmit,
                    child: Text('Add Student'),
                  ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _controllers['dob']!.text = pickedDate
            .toLocal()
            .toString()
            .split(' ')[0]; // Format the date as yyyy-MM-dd
      });
    }
  }
}

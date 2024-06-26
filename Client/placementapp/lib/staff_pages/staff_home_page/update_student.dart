import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api_requests/student_requests.dart';
import '../../backend/models/student_model.dart';

class UpdateStudentPage extends StatefulWidget {
  final Student student;

  const UpdateStudentPage({Key? key, required this.student}) : super(key: key);

  @override
  _UpdateStudentPageState createState() => _UpdateStudentPageState();
}

class _UpdateStudentPageState extends State<UpdateStudentPage> {
  final Map<String, TextEditingController> _controllers = {};
  bool? placementWilling;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final student = widget.student;
    _controllers['studentName'] =
        TextEditingController(text: student.studentName);
    _controllers['rollNo'] = TextEditingController(text: student.rollNo);
    _controllers['regNo'] = TextEditingController(text: student.regNo);
    _controllers['cgpa'] = TextEditingController(text: student.cgpa.toString());
    _controllers['standingArrears'] =
        TextEditingController(text: student.standingArrears.toString());
    _controllers['historyOfArrears'] =
        TextEditingController(text: student.historyOfArrears.toString());
    _controllers['department'] =
        TextEditingController(text: student.department);
    _controllers['section'] = TextEditingController(text: student.section);
    _controllers['dob'] = TextEditingController(text: student.dateOfBirth);
    _selectedDate = DateFormat('yyyy-MM-dd').parse(student.dateOfBirth);
    _controllers['gender'] = TextEditingController(text: student.gender);
    _controllers['placeOfBirth'] =
        TextEditingController(text: student.placeOfBirth);
    _controllers['email'] = TextEditingController(text: student.email);
    _controllers['phoneNumber'] =
        TextEditingController(text: student.phoneNumber);
    _controllers['permanentAddress'] =
        TextEditingController(text: student.permanentAddress);
    _controllers['presentAddress'] =
        TextEditingController(text: student.presentAddress);
    _controllers['community'] = TextEditingController(text: student.community);
    _controllers['fatherName'] =
        TextEditingController(text: student.fatherName);
    _controllers['fatherOccupation'] =
        TextEditingController(text: student.fatherOccupation);
    _controllers['motherName'] =
        TextEditingController(text: student.motherName);
    _controllers['motherOccupation'] =
        TextEditingController(text: student.motherOccupation);
    _controllers['score10th'] =
        TextEditingController(text: student.score10Th.toString());
    _controllers['board10th'] = TextEditingController(text: student.board10Th);
    _controllers['yearOfPassing10th'] =
        TextEditingController(text: student.yearOfPassing10Th);
    _controllers['score12th'] =
        TextEditingController(text: student.score12Th.toString());
    _controllers['board12th'] = TextEditingController(text: student.board12Th);
    _controllers['yearOfPassing12th'] =
        TextEditingController(text: student.yearOfPassing12Th);
    _controllers['scoreDiploma'] =
        TextEditingController(text: student.scoreDiploma);
    _controllers['branchDiploma'] =
        TextEditingController(text: student.branchDiploma);
    _controllers['yearOfPassingDiploma'] =
        TextEditingController(text: student.yearOfPassingDiploma);
    _controllers['parentPhoneNumber'] =
        TextEditingController(text: student.parentPhoneNumber);
    _controllers['aadhar'] = TextEditingController(text: student.aadhar);
    _controllers['batch'] =
        TextEditingController(text: student.batch.toString());
    _controllers['currentSem'] =
        TextEditingController(text: student.currentSem.toString());
    placementWilling = student.placementWilling;
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  String errorMessage = "";
  bool isProcessing = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controllers['dob']!.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> validateAndSubmit() async {
    setState(() {
      errorMessage = "";
      isProcessing = true;
    });

    final updatedStudent = Student(
      id: widget.student.id,
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
      jobApplications: widget.student.jobApplications,
      // updatedAt: DateTime.now(),
    );

    bool isUpdated = await StudentRequests.updateStudent(updatedStudent);
    print(isUpdated);
    setState(() {
      isProcessing = false;
    });

    if (isUpdated) {
      showSuccessDialog(
          "Success", "Student Updated Successfully", Icons.check_circle, Colors.green);
      _controllers.values.forEach((controller) => controller.clear());
      setState(() {
        placementWilling = null;
      });
    } else {
      showSuccessDialog("Failure", "Student Not updated", Icons.close_rounded, Colors.red);
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
      {bool readOnly = false, bool isNumeric = false}) {
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
      ),
    );
  }

  Widget buildDatePickerField(String labelText, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _selectDate(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _controllers[key]!.text.isNotEmpty
                    ? _controllers[key]!.text
                    : 'Select Date',
              ),
              Icon(Icons.calendar_today),
            ],
          ),
        ),
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
        title: Text('Update Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildTextField('Student Name', 'studentName'),
            buildTextField('Roll No', 'rollNo', readOnly: true),
            buildTextField('Reg No', 'regNo', readOnly: true),
            buildTextField('CGPA', 'cgpa', isNumeric: true),
            buildTextField('Standing Arrear', 'standingArrears',
                isNumeric: true),
            buildTextField('History of Arrear', 'historyOfArrears',
                isNumeric: true),
            buildTextField('Department', 'department'),
            buildTextField('Section', 'section'),
            buildDatePickerField('Date of Birth', 'dob'),
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
              child: Text('Update Student'),
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
}

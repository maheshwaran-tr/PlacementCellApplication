import 'dart:io';

import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;
import '../../backend/models/student_model.dart';

class StudentExcelService {
  static Future<void> createExcelFile(List<Student> students,String sheetName) async {
    final xcel.Workbook workbook = xcel.Workbook();
    final xcel.Worksheet sheet = workbook.worksheets[0];
    sheet.name = sheetName;
    List<String> columnNames = [
      'ID',
      'Roll No',
      'Reg No',
      'Student Name',
      'Community',
      'Gender',
      'Department',
      'Section',
      'Father Name',
      'Father Occupation',
      'Mother Name',
      'Mother Occupation',
      'Place of Birth',
      'Date of Birth',
      '10th Score',
      '10th Board',
      '10th Year of Passing',
      '12th Score',
      '12th Board',
      '12th Year of Passing',
      'Diploma Score',
      'Diploma Branch',
      'Diploma Year of Passing',
      'Permanent Address',
      'Present Address',
      'Phone Number',
      'Parent Phone Number',
      'Email',
      'Aadhar',
      'Placement Willing',
      'Batch',
      'Current Sem',
      'CGPA',
      'Standing Arrears',
      'History of Arrears',
    ];
    int len = columnNames.length;

    // ADD HEADERS
    for (var i = 0; i < len; i++) {
      sheet.getRangeByIndex(1, i + 1).setText(columnNames[i]);
    }

    // ADD DATA
    int rowNumber = 2; // Starting from row 2 to insert data
    for (var student in students) {
      sheet.getRangeByIndex(rowNumber, 1).setValue(student.id);
      sheet.getRangeByIndex(rowNumber, 2).setText(student.rollNo);
      sheet.getRangeByIndex(rowNumber, 3).setText(student.regNo);
      sheet.getRangeByIndex(rowNumber, 4).setText(student.studentName);
      sheet.getRangeByIndex(rowNumber, 5).setText(student.community);
      sheet.getRangeByIndex(rowNumber, 6).setText(student.gender);
      sheet.getRangeByIndex(rowNumber, 7).setText(student.department);
      sheet.getRangeByIndex(rowNumber, 8).setText(student.section);
      sheet.getRangeByIndex(rowNumber, 9).setText(student.fatherName);
      sheet.getRangeByIndex(rowNumber, 10).setText(student.fatherOccupation);
      sheet.getRangeByIndex(rowNumber, 11).setText(student.motherName);
      sheet.getRangeByIndex(rowNumber, 12).setText(student.motherOccupation);
      sheet.getRangeByIndex(rowNumber, 13).setText(student.placeOfBirth);
      sheet.getRangeByIndex(rowNumber, 14).setText(student.dateOfBirth);

      sheet.getRangeByIndex(rowNumber, 15).setText(student.score10Th as String?);
      sheet.getRangeByIndex(rowNumber, 16).setText(student.board10Th);
      sheet.getRangeByIndex(rowNumber, 17).setText(student.yearOfPassing10Th);

      sheet.getRangeByIndex(rowNumber, 18).setText(student.score12Th as String?);
      sheet.getRangeByIndex(rowNumber, 19).setText(student.board12Th);
      sheet.getRangeByIndex(rowNumber, 20).setText(student.yearOfPassing12Th);

      sheet.getRangeByIndex(rowNumber, 21).setText(student.scoreDiploma as String?);
      sheet.getRangeByIndex(rowNumber, 22).setText(student.branchDiploma);
      sheet.getRangeByIndex(rowNumber, 23).setText(student.yearOfPassingDiploma);

      sheet.getRangeByIndex(rowNumber, 24).setText(student.permanentAddress);
      sheet.getRangeByIndex(rowNumber, 25).setText(student.presentAddress);
      sheet.getRangeByIndex(rowNumber, 26).setText(student.phoneNumber);

      sheet.getRangeByIndex(rowNumber, 27).setText(student.parentPhoneNumber);
      sheet.getRangeByIndex(rowNumber, 28).setText(student.email);
      sheet.getRangeByIndex(rowNumber, 29).setText(student.aadhar);
      sheet.getRangeByIndex(rowNumber, 30).setText(student.placementWilling == true ? "Yes" : "NO");

      sheet.getRangeByIndex(rowNumber, 31).setText(student.batch as String?);
      sheet.getRangeByIndex(rowNumber, 32).setText(student.currentSem as String?);
      sheet.getRangeByIndex(rowNumber, 33).setText(student.cgpa as String?);
      sheet.getRangeByIndex(rowNumber, 34).setText(student.standingArrears as String?);
      sheet.getRangeByIndex(rowNumber, 35).setText(student.historyOfArrears as String?);




      // Increment row number for the next student
      rowNumber++;
    }

    // Save Excel file
    final List<int> bytes = workbook.saveAsStream();
    // Save the file to a desired location (e.g., device storage)
    // In this example, the file is saved to the app's documents directory
    final String path = '/storage/emulated/0/Documents/test.xlsx';
    await File(path).writeAsBytes(bytes, flush: true);

    workbook.dispose();
  }
}
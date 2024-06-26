import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:placementapp/api_requests/urls.dart';

import '../backend/models/student_model.dart';
import '../backend/token/token_storage.dart';

class StudentRequests {
  static Future<List<Student>?> getStudentsByDept(String dept) async {
    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }
    String url = "${Urls.studentUrl}/?department=$dept";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body)["data"];

      List<Student> studentsList = [];
      for (var obj in jsonData) {
        final pobj = Student.fromJson(obj);
        studentsList.add(pobj);
      }
      return studentsList;
    } else {
      return null;
    }
  }

  static Future<Student> getStudentById(String id) async {
    String? token = await TokenStorage.getAccessToken();
    if (token == null) {
      throw Exception('Token is null');
    }
    String url = "${Urls.studentUrl}/${id}";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Student.fromJson(jsonData);
    } else {
      throw Exception('Cannot get student by this id');
    }
  }

  static Future<bool> deleteStudent(String id) async {
    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }

    String url = "${Urls.studentUrl}/$id";
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateStudent(Student student) async {
    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }

    String url = "${Urls.studentUrl}/${student.id}";

    final response = await http.put(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(student.toJson()));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> addStudent(Student student) async {
    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }

    final response = await http.post(Uri.parse(Urls.studentUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(student.toJson()));
    print(response.statusCode);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Student>?> studentsByPlacementWilling(
      bool isWilling) async {
    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }
    String url = "${Urls.studentUrl}/?placementWilling = $isWilling";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body) as List<dynamic>;

      List<Student> studentsList = [];
      for (var obj in jsonData) {
        final pobj = Student.fromJson(obj["data"]);
        studentsList.add(pobj);
      }
      return studentsList;
    } else {
      return null;
    }
  }

  static Future<List<Student>> studentsCustomFilter(String queryParams) async {
    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }
    String url = "${Urls.studentUrl}/?$queryParams";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body)["data"];
      List<Student> studentsList = [];
      for (var obj in jsonData) {
        final pobj = Student.fromJson(obj);
        print(pobj);
        studentsList.add(pobj);
      }
      return studentsList;
    } else {
      return [];
    }
  }
}

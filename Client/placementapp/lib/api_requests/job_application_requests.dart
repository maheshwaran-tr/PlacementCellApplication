import 'package:placementapp/api_requests/urls.dart';

import '../backend/models/applied_job_model.dart';
import '../backend/token/token_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobApplicationRequests {
  
  static Future<JobApplicationModel?> findById(String id) async {
    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }


    String url = "${Urls.jobApplicationUrl}/${id}";
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return JobApplicationModel.fromJson(jsonData);
    } else {
      return null;
    }
  }

  static Future<int> updateApplicationStatus(
      JobApplicationModel application, String status) async {
    String? token = await TokenStorage.getAccessToken();
    if (token == null) {
      throw Exception('Token is null');
    }

    String url = "${Urls.jobApplicationUrl}/${application.id}";
    application.status = status;
    final response = await http.put(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(application.toJson()));

    return response.statusCode;
  }

  static Future<int> createApplication(
      String studentId, String jobId) async {
    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }
    
    String url = "${Urls.jobApplicationUrl}";
    var regBody = {"student": studentId, "job": jobId, "status": "Applied"};
    
    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        },
        body: jsonEncode(regBody));
    print(response.statusCode);
    return response.statusCode;
  }

  static Future<bool> updateApplication(JobApplicationModel application) async {
    String? token = await TokenStorage.getAccessToken();
    if (token == null) {
      throw Exception('Token is null');
    }

    String url = "${Urls.jobApplicationUrl}/${application.id}";

    final response = await http.put(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(application.toJson()));

    return response.statusCode == 200 ? true : false;
  }

  static Future<List<JobApplicationModel>?> getAllApplications() async {
    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }
    String url = "${Urls.jobApplicationUrl}";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body)["data"];

      List<JobApplicationModel> applicationList = [];
      for (var obj in jsonData) {
        final pobj = JobApplicationModel.fromJson(obj);
        applicationList.add(pobj);
      }
      return applicationList;
    } else {
      return null;
    }
  }
}

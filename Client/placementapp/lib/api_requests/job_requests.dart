import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:placementapp/api_requests/urls.dart';

import '../backend/models/job_post_model.dart';
import '../backend/token/token_storage.dart';

class JobRequests {
  static Future<List<JobPostModel>> getAllJobs() async {
    String? token = await TokenStorage.getAccessToken();
    if (token == null) {
      throw Exception('Token is null');
    }

    String url = "${Urls.jobUrl}";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body)["data"];
      List<JobPostModel> joblist = [];
      for (var obj in jsonData) {
        if (obj is Map<String, dynamic>) {
          final pobj = JobPostModel.fromJson(obj);
          joblist.add(pobj);
        }
      }
      return joblist;
    }
    throw Exception('Failed to load jobs');
  }

  static Future<JobPostModel?> findById(String id) async {
    String? token = await TokenStorage.getAccessToken();
    if (token == null) {
      throw Exception('Token is null');
    }

    String url = "${Urls.jobUrl}/${id}";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return JobPostModel.fromJson(jsonData);
    } else {
      return null;
    }
  }

  static Future<bool> postJob(JobPostModel job) async {
    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }

    final response = await http.post(Uri.parse(Urls.jobUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(job.toJson()));
    
    print(response.body);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteJob(String id) async {
    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }

    String deleteJobUrl = "${Urls.jobUrl}/$id";
    print(deleteJobUrl);
    final response = await http.delete(
      Uri.parse(deleteJobUrl),
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

  static Future<bool> updateTheJob(JobPostModel job) async {
    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }

    String url = "${Urls.jobUrl}/${job.id}";

    var regBody = job.toJson();
    final response = await http.put(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(regBody));
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.statusCode);
      return false;
    }
  }
}

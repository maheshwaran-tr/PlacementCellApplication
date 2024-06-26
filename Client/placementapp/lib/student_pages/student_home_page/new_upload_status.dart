import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:placementapp/api_requests/image_requests.dart';
import 'package:placementapp/api_requests/job_application_requests.dart';
import 'package:placementapp/backend/models/job_post_model.dart';

import '../../backend/models/applied_job_model.dart';

class UploadJobStatus extends StatefulWidget {
  final JobApplicationModel theJob;
  final JobPostModel jobpost;

  const UploadJobStatus({Key? key, required this.theJob, required this.jobpost})
      : super(key: key);

  @override
  State<UploadJobStatus> createState() => _UploadJobStatusState();
}

class _UploadJobStatusState extends State<UploadJobStatus> {
  String? interviewStatus;
  String proof = '';
  String? imageName;
  final List<String> interviewStatusOptions = [
    'Selected',
    'Not Selected',
    'Waiting for Result'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Upload Status for ${widget.jobpost.companyName}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Company Name:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              widget.jobpost.companyName,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Company Details:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              widget.jobpost.description,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Job Name:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              widget.jobpost.jobName,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 30),
            DropdownButtonFormField<String>(
              value: interviewStatus,
              items: interviewStatusOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline),
                      SizedBox(width: 8),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  interviewStatus = value;
                });
              },
              decoration: InputDecoration(labelText: 'Interview Status'),
            ),
            SizedBox(height: 10),
            Visibility(
              visible: interviewStatus == 'Selected',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

                      if (image != null) {
                        setState(() {
                          proof = image.path;
                          imageName = image.name;
                        });
                      }
                    },
                    icon: Icon(Icons.image),
                    label: Text('Pick an Image'),
                  ),
                  SizedBox(height: 10),
                  if (imageName != null)
                    Text(
                      'Selected Image: $imageName',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Fill in the details and share your interview experience!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_areAllFieldsFilled()) {
                  _handleSubmit();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill all fields before submitting.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.upload_rounded,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _areAllFieldsFilled() {
    return interviewStatus != null &&
        (interviewStatus != 'Selected' || proof.isNotEmpty);
  }

  void _handleSubmit() async {
    print(interviewStatus);
    if (interviewStatus == "Selected") {
      if (proof.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an image.'),
          ),
        );
        return;
      }
      uploadProof();
    }
    updateStatus(interviewStatus!);
  }

  void uploadProof() async {
    try {
      var responseStatusCode =
      await ImageRequests.uploadProof(widget.theJob.id, proof);
      if (responseStatusCode == 200) {
        showResultBox("Success", "Proof Uploaded Successfully");
      } else if (responseStatusCode == 409) {
        showResultBox("Proof Updated", "Proof Updated Successfully");
      } else {
        showResultBox("Failed", "Proof Uploading Failed");
      }
    } catch (e) {
      showResultBox("Error", "Error Uploading Proof");
    }
  }

  void updateStatus(String status) async {
    try {
      var responseStatusCode =
      await JobApplicationRequests.updateApplicationStatus(
          widget.theJob, status);
      if (responseStatusCode == 200) {
        showResultBox("Status Updated", "Status Updated Successfully");
      } else {
        showResultBox("Failed", "Failed to Update status");
      }
    } catch (e) {
      showResultBox("Error", "Error uploading status");
    }
  }

  void showResultBox(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
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
}

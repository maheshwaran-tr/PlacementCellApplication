import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../backend/models/staff_model.dart';

class StaffDetailsPage extends StatelessWidget {
  final Staff staff;

  StaffDetailsPage({required this.staff});

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
          (staff.staffName) + " Details",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.download,
              color: Colors.black,
            ),
            onPressed: () {
              // Add your download functionality here
            },
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.black,
            ),
            onPressed: () {
              // Add your share functionality here
            },
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(
              'Name',
              staff.staffName,
              icon: Icons.person,
              iconColor: Colors.blue,
            ),
            SizedBox(height: 12.0),
            _buildDetailCard(
              'Department',
              staff.department,
              icon: Icons.business,
              iconColor: Colors.orange,
            ),
            SizedBox(height: 12.0),
            _buildDetailCard(
              'Staff Id',
              staff.staffId.toString(),
              icon: Icons.confirmation_number,
              iconColor: Colors.green,
            ),
            SizedBox(height: 12.0),
            _buildDetailCard(
              'Email Id',
              staff.email.toString(),
              icon: Icons.confirmation_number,
              iconColor: Colors.green,
            ),
            SizedBox(height: 12.0),
            _buildDetailCard(
              'Phone Number',
              staff.phoneNumber.toString(),
              icon: Icons.confirmation_number,
              iconColor: Colors.green,
            ),
            // Add more sections or details here...
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String value,
      {required IconData icon, required Color iconColor}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.blue.withOpacity(0.1)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            icon,
            color: iconColor,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            value,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  List<dynamic>? convertStringToList(String? input) {
    if (input == null) {
      // Handle the case where input is null
      return ["Null"];
    }

    try {
      // Attempt to decode the JSON string
      List<dynamic> list = json.decode(input);
      return list;
    } catch (e) {
      // Handle the case where decoding fails
      print("Error decoding JSON: $e");
      return null;
    }
  }
}
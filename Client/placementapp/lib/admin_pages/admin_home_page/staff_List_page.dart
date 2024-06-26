import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:placementapp/api_requests/staff_requests.dart';
import '../../backend/models/staff_model.dart';
import 'staff_details.dart';
import 'update_staff.dart';

class StaffListPage extends StatefulWidget {
  final List<Staff> staffs;

  StaffListPage({required this.staffs});

  @override
  _StaffListPageState createState() => _StaffListPageState();
}

class _StaffListPageState extends State<StaffListPage> {
  List<Staff> filteredStaffs = [];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    filteredStaffs = List.from(widget.staffs);
  }

  void filterStudents() {
    setState(() {
      filteredStaffs = List.from(widget.staffs);
      if (searchText.isNotEmpty) {
        filteredStaffs = filteredStaffs.where((student) {
          return student.staffName
              .toLowerCase()
              .contains(searchText.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _refreshStaffList() async {
    // Simulate fetching data from an external source
    await Future.delayed(Duration(seconds: 1));
    // Reset the filtered staff list and the search text
    setState(() {
      searchText = '';
      filteredStaffs = List.from(widget.staffs);
    });
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
          'Staff Details',
          style: TextStyle(color: Colors.black),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            margin: EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                  filterStudents();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by Staff name',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            searchText = '';
                            filterStudents();
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshStaffList,
              child: ListView.builder(
                itemCount: filteredStaffs.length,
                itemBuilder: (context, index) {
                  final staff = filteredStaffs[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Name: ${staff.staffName}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdateStaffPage(
                                            staff: staff,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      // Handle delete action
                                      bool isDeleted =
                                          await StaffRequests.deleteStaff(
                                              staff.id!);
                                      if (isDeleted) {
                                        print("DELETED");
                                        widget.staffs.remove(staff);
                                      } else {
                                        print("ERROR DELETING");
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.visibility),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              StaffDetailsPage(
                                            staff: staff,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text('Staff Id: ${staff.staffId}',
                              style: TextStyle(fontSize: 14)),
                          SizedBox(height: 4),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

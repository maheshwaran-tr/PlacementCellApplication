import 'package:flutter/material.dart';
import 'package:placementapp/api_requests/student_requests.dart';
import '../../../backend/models/student_model.dart';

class ApprovalPage extends StatefulWidget {
  final String department;

  const ApprovalPage({super.key, required this.department});

  @override
  _ApprovalPageState createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> {
  List<Student> students = [];
  ScrollController _scrollController = ScrollController();
  String selectedSection = 'All';
  int selectedBatch = 0;
  String searchQuery = '';
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMoreData = true; // Flag to indicate if more data is available
  List<Student> filteredStudents = [];
  List<Student> changedStudents = [];

  @override
  void initState() {
    super.initState();
    _loadStudentsData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && hasMoreData) {
        _loadMoreStudents();
      }
    });
  }

  Future<void> _loadStudentsData() async {
    String queryParams = "page=$currentPage&limit=10&department=${widget.department}";

    try {
      List<Student>? allStudents = await StudentRequests.studentsCustomFilter(queryParams);
      if (allStudents.isEmpty) {
        setState(() {
          hasMoreData = false; // No more data to load
        });
      } else {
        setState(() {
          students.addAll(allStudents);
        });
      }
    } catch (e) {
      print("Error loading students data: $e");
    }
  }

  void assign(){
    setState(() {
      students = filteredStudents;
    });
  }

  Future<void> _loadMoreStudents() async {
    if (isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    currentPage++;
    await _loadStudentsData();

    setState(() {
      isLoadingMore = false;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      currentPage = 1;
      students.clear();
      hasMoreData = true; // Reset the flag for fresh data load
    });
    await _loadStudentsData();
  }

  Future<void> _searchStudentsData(String query) async {
    setState(() {
      searchQuery = query;
      currentPage = 1;
      students.clear();
      hasMoreData = true;
    });

    while (hasMoreData) {
      await _loadStudentsData();

      // Check if any student matches the search query
      bool studentFound = students.any((student) =>
          student.studentName.toLowerCase().contains(searchQuery.toLowerCase()));

      if (studentFound) {
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    filteredStudents = students
        .where((student) =>
    (selectedSection == 'All' || student.section == selectedSection) &&
        (selectedBatch == 0 || student.batch == selectedBatch) &&
        (searchQuery.isEmpty ||
            student.studentName
                .toLowerCase()
                .contains(searchQuery.toLowerCase())))
        .toList();

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
        hintColor: Colors.amberAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Student List',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: Column(
            children: [
              _buildEnhancedContainer(),
              _buildSearchBar(),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: filteredStudents.length + (hasMoreData ? 1 : 0), // Add one for the loading indicator if more data is available
                  itemBuilder: (context, index) {
                    if (index == filteredStudents.length) {
                      return _buildLoadingIndicator();
                    }
                    bool isChanged = false;
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          value: filteredStudents[index].placementWilling,
                          onChanged: (value) {
                            isChanged = isChanged == true ? false : true;
                            setState(() {
                              if(isChanged){
                                changedStudents.add(filteredStudents[index]);
                              }else{
                                changedStudents.remove(filteredStudents[index]);
                              }
                              filteredStudents[index].placementWilling = value!;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                        title: Text(filteredStudents[index].studentName),
                        subtitle: Text(
                            'Section: ${filteredStudents[index].section} - Batch: ${filteredStudents[index].batch}'
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Theme.of(context).hintColor),
                              onPressed: () {
                                _editStudentDetails(filteredStudents[index]);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.visibility, color: Theme.of(context).hintColor),
                              onPressed: () {
                                _viewStudentDetails(filteredStudents[index]);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEnhancedContainer() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDropdownButton(selectedSection, ['All', 'A', 'B', 'C'],
                  (String? newValue) {
                setState(() {
                  selectedSection = newValue!;
                });
              }),
          _buildDropdownButton<int>(selectedBatch, [0, 2023, 2024, 2025, 2026],
                  (int? newValue) {
                setState(() {
                  selectedBatch = newValue!;
                });
              }),
          ElevatedButton(
            onPressed: () {
              _showApprovalDialog(context);
            },
            child: Text(
              'Approve',
              style: TextStyle(fontSize: 16.0),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).hintColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownButton<T>(
      T value, List<T> items, ValueChanged<T?> onChanged) {
    return DropdownButton<T>(
      value: value,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            item.toString(),
            style: TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      style: TextStyle(color: Colors.white),
      dropdownColor: Theme.of(context).primaryColor,
      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
      color: Colors.transparent,
      child: TextField(
        onChanged: (value) {
          _searchStudentsData(value);
        },
        style: TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Search by name...',
          hintStyle: TextStyle(color: Colors.blueGrey),
          prefixIcon: Icon(Icons.search, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _showApprovalDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Processing...',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10.0),
              Text(
                'Approving students',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          backgroundColor: Colors.white,
        );
      },
    );

    // Simulate a 2-second delay for processing (replace with your actual approval logic)
    await Future.delayed(Duration(seconds: 2), () async {
      // Extract students with placementWilling = true

      print(changedStudents.length);
      List<String> failedUpdates = [];
      for (var student in changedStudents) {
        print(student.studentName);
        try {
          bool isUpdated = await StudentRequests.updateStudent(student);
          if (!isUpdated) {
            failedUpdates.add(student.id);
          }
          changedStudents = [];
        } catch (e) {
          failedUpdates.add(student.id);
          print('Failed to update application ${student.id}: $e');
        }
      }


      if (failedUpdates.isEmpty) {
        Navigator.of(context).pop(); // Close the dialog after 2 seconds
        _showSuccessDialog(context, "Approval Successful","Students have been approved successfully!");
      } else {
        _showSuccessDialog(context, "Some Approval Failed ", "Students Approval Failed");
      }
      // Optionally, show a success dialog after approval
    });
  }

  void _showSuccessDialog(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50.0,
              ),
              SizedBox(height: 10.0),
              Text(
                msg,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.lightBlue,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          backgroundColor: Colors.white,
        );
      },
    );
  }

  void _editStudentDetails(Student student) {
    print('Editing details for ${student.studentName}');
  }

  void _viewStudentDetails(Student student) {
    print('Viewing details for ${student.studentName}');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

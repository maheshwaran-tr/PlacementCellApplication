import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ExcelService/student_excel_service/student_details_excel.dart';
import '../../api_requests/student_requests.dart';
import '../../backend/models/student_model.dart';
import 'student_details.dart';
import 'update_student.dart';

class StaffStudentListPage extends StatefulWidget {
  final String department;

  const StaffStudentListPage({super.key, required this.department});

  @override
  _StaffStudentListPageState createState() => _StaffStudentListPageState();
}

class _StaffStudentListPageState extends State<StaffStudentListPage> {
  List<Student> filteredStudents = [];
  List<int> selectedBatchList = [];
  List<String> selectedSkillsList = [];
  List<Student> students = [];
  String searchText = '';

  List<int> batchYears = [2023, 2022, 2021]; // List of available batch years
  List<String> skillsList = ['Java', 'Python', 'Flutter']; // List of available skills

  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initializeData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && hasMoreData) {
        loadMoreStudents();
      }
    });
  }

  initializeData() async {
    String queryParams = "page=1&limit=10&placementWilling=true&department=${widget.department}";
    students = await StudentRequests.studentsCustomFilter(queryParams);
    setState(() {
      filteredStudents = students;
    });
  }

  void filterStudents() {
    setState(() {
      filteredStudents = students.where((student) {
        bool matchesBatch = selectedBatchList.isEmpty || selectedBatchList.contains(student.batch);
        bool matchesSearch = searchText.isEmpty || student.studentName.toLowerCase().contains(searchText.toLowerCase());
        return matchesBatch && matchesSearch;
      }).toList();
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      currentPage = 1;
      hasMoreData = true;
      students.clear();
    });
    await initializeData();
  }

  void downloadData() async {
    await StudentExcelService.createExcelFile(students, "STUDENT-LIST");
  }

  void showBatchFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Batch Filter',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: batchYears.length,
                  itemBuilder: (context, index) {
                    final year = batchYears[index];
                    return ListTile(
                      title: Text(
                        year.toString(),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      tileColor: selectedBatchList.contains(year)
                          ? Colors.blue.withOpacity(0.2)
                          : null,
                      onTap: () {
                        setState(() {
                          if (selectedBatchList.contains(year)) {
                            selectedBatchList.remove(year);
                          } else {
                            selectedBatchList.add(year);
                          }
                          filterStudents();
                        });
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedBatchList.clear();
                    filterStudents();
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showSkillsFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Skills Filter',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: skillsList.length,
                  itemBuilder: (context, index) {
                    final skill = skillsList[index];
                    return ListTile(
                      title: Text(
                        skill,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      tileColor: selectedSkillsList.contains(skill)
                          ? Colors.blue.withOpacity(0.2)
                          : null,
                      onTap: () {
                        setState(() {
                          if (selectedSkillsList.contains(skill)) {
                            selectedSkillsList.remove(skill);
                          } else {
                            selectedSkillsList.add(skill);
                          }
                          filterStudents();
                        });
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedSkillsList.clear();
                    filterStudents();
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> loadMoreStudents() async {
    if (isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    currentPage++;
    String queryParams = "page=$currentPage&limit=10&placementWilling=true&department=${widget.department}";
    List<Student> moreStudents = await StudentRequests.studentsCustomFilter(queryParams);

    setState(() {
      isLoadingMore = false;
      if (moreStudents.isEmpty) {
        hasMoreData = false;
      } else {
        students.addAll(moreStudents);
        filterStudents();
      }
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
          'Student Details',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: showBatchFilterDialog,
            icon: Icon(
              Icons.calendar_today,
              size: 24,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: showSkillsFilterDialog,
            icon: Icon(
              Icons.filter_alt,
              size: 24,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: downloadData,
            icon: Icon(
              Icons.download,
              size: 24,
              color: Colors.black,
            ),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            if (selectedBatchList.isNotEmpty || selectedSkillsList.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    if (selectedBatchList.isNotEmpty)
                      ...selectedBatchList.map((batchYear) {
                        return Chip(
                          label: Text(
                            'Batch $batchYear',
                            style: TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Colors.blueAccent.withOpacity(0.5),
                          deleteIconColor: Colors.white,
                          onDeleted: () {
                            setState(() {
                              selectedBatchList.remove(batchYear);
                              filterStudents();
                            });
                          },
                        );
                      }).toList(),
                    if (selectedSkillsList.isNotEmpty)
                      ...selectedSkillsList.map((skill) {
                        return Chip(
                          label: Text(
                            'Skill: $skill',
                            style: TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Colors.orangeAccent.withOpacity(0.5),
                          deleteIconColor: Colors.white,
                          onDeleted: () {
                            setState(() {
                              selectedSkillsList.remove(skill);
                              filterStudents();
                            });
                          },
                        );
                      }).toList(),
                  ],
                ),
              ),
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
                  hintText: 'Search by student name',
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
              child: ListView.builder(
                controller: _scrollController,
                itemCount: filteredStudents.length + (hasMoreData ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == filteredStudents.length) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final student = filteredStudents[index];
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
                                  'Name: ${student.studentName}',
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
                                      // Handle edit action
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => UpdateStudentPage(student: student)));
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      // Handle delete action
                                      bool isDeleted = await StudentRequests.deleteStudent(student.id);
                                      if (isDeleted) {
                                        setState(() {
                                          students.remove(student);
                                          filterStudents();
                                        });
                                        showResultBox("Success", "Student deleted");
                                      } else {
                                        showResultBox("Failure", "Failed to delete student");
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.visibility),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StudentDetailsPage(student: student),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text('Reg No: ${student.regNo}', style: TextStyle(fontSize: 14)),
                          SizedBox(height: 4),
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
    );
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

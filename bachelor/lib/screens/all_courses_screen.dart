import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './course_screen_student.dart';

class AllCoursesScreen extends StatefulWidget {
  static const routeName = '/allCourses-student';

  @override
  State<AllCoursesScreen> createState() => _AllCoursesScreenState();
}

class _AllCoursesScreenState extends State<AllCoursesScreen> {
  final currentUserID = FirebaseAuth.instance.currentUser.uid;
  var allCourses = [];
  var filteredCourses = [];
  var myCourses = [];
  TextEditingController searchController = new TextEditingController();
  getMyCourses() {
    Firestore.instance.collection('courses').getDocuments().then((value) {
      value.documents.forEach((element) {
        var data = element.data();
        var course = {
          'courseName': data['courseName'],
          'courseCode': data['courseCode'],
          'major': data['major'],
          'semester': data['semester'],
          'creditHours': data['creditHours'],
          'numberOfGroups': data['numberOfGroups'],
          'lecturesFrequency': data['lecturesFrequency'],
          'timings': data['timings'],
          'assessments': data['assessments'],
          'courseOwnerId': data['courseOwnerId'],
          'documentID': data['documentID'],
          'enrolledStudents': data['enrolledStudents'],
        };
        if (data['enrolledStudents'].contains(currentUserID)) {
          setState(() {
            myCourses.add(course);
          });
        }
      });
    });
  }

  void _runFilter(String enteredKeyword) {
    var results = [];
    if (enteredKeyword.isEmpty) {
      results = allCourses;
    } else {
      for (var course in allCourses) {
        if (course['courseName']
            .toString()
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase())) {
          results.add(course);
        }
      }
    }
    setState(() {
      filteredCourses.clear();
    });
    for (var course in results) {
      setState(() {
        filteredCourses.add(course);
      });
    }
  }

  void search(String query) {
    final results = allCourses.where((course) {
      final titleLower = course['courseName'].toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      // this.query = query;
      filteredCourses = results;
    });
    print(filteredCourses);
  }

  getAllCourses() {
    Firestore.instance.collection('courses').getDocuments().then((value) {
      value.documents.forEach((element) {
        var data = element.data();
        var course = {
          'courseName': data['courseName'],
          'courseCode': data['courseCode'],
          'major': data['major'],
          'semester': data['semester'],
          'creditHours': data['creditHours'],
          'numberOfGroups': data['numberOfGroups'],
          'lecturesFrequency': data['lecturesFrequency'],
          'timings': data['timings'],
          'assessments': data['assessments'],
          'courseOwnerId': data['courseOwnerId'],
          'documentID': data['documentID'],
          'enrolledStudents': data['enrolledStudents'],
        };
        if (!data['enrolledStudents'].contains(currentUserID)) {
          setState(() {
            allCourses.add(course);
          });
        }
      });
    });
    setState(() {
      filteredCourses = allCourses;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllCourses();
    getMyCourses();
  }

  Icon customIcon = Icon(Icons.search);
  Widget customSearchBar = Text('All Courses');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
        title: customSearchBar,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (customIcon.icon == Icons.search) {
                  customIcon = Icon(Icons.cancel);
                  customSearchBar = ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                        hintText: 'type in course name...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      onChanged: (value) => search(value),
                    ),
                  );
                } else {
                  customIcon = Icon(Icons.search);
                  customSearchBar = Text('All Courses');
                }
              });
            },
            icon: customIcon,
          )
        ],
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: ListView.builder(
            itemCount: filteredCourses.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CourseScreenStudent(
                                filteredCourses.elementAt(index)['courseName'],
                                filteredCourses.elementAt(index)['courseCode'],
                                filteredCourses.elementAt(index)['creditHours'],
                                filteredCourses
                                    .elementAt(index)['numberOfGroups'],
                                filteredCourses
                                    .elementAt(index)['lecturesFrequency'],
                                filteredCourses.elementAt(index)['timings'],
                                filteredCourses.elementAt(index)['assessments'],
                                filteredCourses
                                    .elementAt(index)['courseOwnerId'],
                                filteredCourses.elementAt(index)['documentID'],
                                filteredCourses
                                    .elementAt(index)['enrolledStudents'],
                                filteredCourses.elementAt(index)['major'],
                                filteredCourses.elementAt(index)['semester'],
                                myCourses,
                              )));
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            filteredCourses.elementAt(index)['courseName'],
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            filteredCourses.elementAt(index)['courseCode'],
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          )),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

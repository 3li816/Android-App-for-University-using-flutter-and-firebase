import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_complete_guide/screens/all_courses_screen.dart';
import 'package:flutter_complete_guide/screens/course_screen_student.dart';

class StudentCoursesScreen extends StatefulWidget {
  @override
  State<StudentCoursesScreen> createState() => _StudentCoursesScreenState();
}

class _StudentCoursesScreenState extends State<StudentCoursesScreen> {
  final usersRef = Firestore.instance.collection('users');
  final currentUserID = FirebaseAuth.instance.currentUser.uid;
  var email = '';
  var firstName = '';
  var lastName = '';
  var major = '';
  var semester = '';
  var gucID = '';
  var lectureGroup = '';
  var role = "";
  var userID = "";
  var flagUserData = false;
  var allCourses = [];
  var myCourses = [];
  getStudentData() async {
    var majorCourse = '';
    var semesterCourse = '';
    var user = await usersRef.getDocuments().then((value) {
      value.documents.forEach((element) {
        var data = element.data();
        if (data['userID'] == FirebaseAuth.instance.currentUser.uid) {
          setState(() {
            email = data['email'];
            firstName = data['firstName'];
            lastName = data['lastName'];
            role = data['role'];
            userID = data['userID'];
            major = data['major'];
            semester = data['semester'];
            gucID = data['gucID'];
            lectureGroup = data['lectureGroup'];
          });
        }
        semesterCourse = data['semester'];
        majorCourse = data['major'];
      });
    });
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
        if (data['major'] == majorCourse &&
            data['semester'] == semesterCourse &&
            !data['enrolledStudents'].contains(currentUserID)) {
          setState(() {
            allCourses.add(course);
          });
          String courseName = data['courseName'];
          FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
          // firebaseMessaging.subscribeToTopic(courseName);
        }
        if (data['enrolledStudents'].contains(currentUserID)) {
          setState(() {
            myCourses.add(course);
          });
        }
      });
    });
    setState(() {
      flagUserData = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return !flagUserData
        ? Center(
            child: CircularProgressIndicator(color: Colors.blue.shade900 ,),
          )
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                var newCourses;
                newCourses = await Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => AllCoursesScreen()));
                print("new Courses");
                print(newCourses);
                if (newCourses != null) {
                  setState(() {
                    myCourses = newCourses;
                  });
                }
              },
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBar: AppBar(
              title: Text('My Courses'),
            ),
            body: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView.builder(
                      itemCount: myCourses.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            var newCourses = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CourseScreenStudent(
                                          myCourses
                                              .elementAt(index)['courseName'],
                                          myCourses
                                              .elementAt(index)['courseCode'],
                                          myCourses
                                              .elementAt(index)['creditHours'],
                                          myCourses.elementAt(
                                              index)['numberOfGroups'],
                                          myCourses.elementAt(
                                              index)['lecturesFrequency'],
                                          myCourses.elementAt(index)['timings'],
                                          myCourses
                                              .elementAt(index)['assessments'],
                                          myCourses.elementAt(
                                              index)['courseOwnerId'],
                                          myCourses
                                              .elementAt(index)['documentID'],
                                          myCourses.elementAt(
                                              index)['enrolledStudents'],
                                          myCourses.elementAt(index)['major'],
                                          myCourses
                                              .elementAt(index)['semester'],
                                          myCourses,
                                        )));
                            if (newCourses != null) {
                            //  print("t")
                              print(newCourses);
                              setState(() {
                                myCourses = newCourses;
                              });
                            }
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      myCourses.elementAt(index)['courseName'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      myCourses.elementAt(index)['courseCode'],
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey),
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
              ],
            ),
          );
  }
}

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EnrolledCourseScreen extends StatefulWidget {
  var courseName;
  var courseCode;
  var creditHours;
  var numberOfGroups;
  var lecturesFrequency;
  var timings;
  var assessments;
  var courseOwnerID;
  var documentID;
  var enrolledStudents;
  var userID;
  var role;
  EnrolledCourseScreen(
      this.courseName,
      this.courseCode,
      this.creditHours,
      this.numberOfGroups,
      this.lecturesFrequency,
      this.timings,
      this.assessments,
      this.courseOwnerID,
      this.documentID,
      this.enrolledStudents,
      this.userID,
      this.role);
  @override
  State<EnrolledCourseScreen> createState() => _EnrolledCourseScreenState();
}

class _EnrolledCourseScreenState extends State<EnrolledCourseScreen> {
  final usersRef = Firestore.instance.collection('users');
  var lectureFrequency;
  var group;
  var day1;
  var slot1;
  var location1;
  var day2;
  var slot2;
  var location2;

  void getUserCourseData() {
    usersRef.getDocuments().then((value) {
      value.documents.forEach((element) {
        var data = element.data();
        if (data['userID'] == FirebaseAuth.instance.currentUser.uid) {
          setState(() {
            group = data['group'];
          });
          print(group);
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserCourseData();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Course with ChangeNotifier {
  String name;
  String code;
  String creditHours;
  String numberOfGroups;
  String createdCourseID;
  // String courseOwner; // stores user id (uid) of Instructor who created Course
  // List<String> enrolledStudents; // stores uid of all enrolled students
  //List<String> otherInstructors; // stores uid of other imstructors
  //Map<String, Object>
  //  assessment; // name of assessment, weight and maybe deadline

  Course(
    this.name,
    this.code,
    this.creditHours,
    this.numberOfGroups,
    // this.courseOwner,
    //this.enrolledStudents,
    //this.otherInstructors,
    //this.assessment,
  );

  createCourse(
      String name,
      String code,
      String major, 
      String semester,
      String creditHours,
      String numberOfGroups,
      String lectureFrequency,
      var timings,
      String ownerID, 
      String documentID) async {
    var newDoc = await FirebaseFirestore.instance.collection('courses').doc();
    var newDocRef = await newDoc.get();
    List<Map<dynamic, dynamic>> assessments = [{}];

    await FirebaseFirestore.instance
        .collection('courses')
        .doc(documentID)
        .set({
      'courseName': name,
      'courseCode': code,
      'major': major,
      'semester': semester,
      'creditHours': creditHours,
      'numberOfGroups': numberOfGroups,
      'lecturesFrequency': lectureFrequency,
      'timings': timings,
      'assessments': [],
      'courseOwnerId': ownerID,
      'documentID': documentID,
      'enrolledStudents': [],
    });
    notifyListeners();
  }
}

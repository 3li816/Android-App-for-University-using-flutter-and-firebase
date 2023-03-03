import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/screens/course_media_screen.dart';
import 'package:flutter_complete_guide/screens/create_question_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter_complete_guide/screens/questions_answers_screen.dart';

class CourseScreenStudent extends StatefulWidget {
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
  var major;
  var semester;
  var myCourses;
  CourseScreenStudent(
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
      this.major,
      this.semester,
      this.myCourses);

  @override
  State<CourseScreenStudent> createState() => _CourseScreenStudentState();
}

class _CourseScreenStudentState extends State<CourseScreenStudent> {
  final currentUserID = FirebaseAuth.instance.currentUser.uid;
  var flagErrorEnrolled = false;
  var group;
  var textEnrolled = "Enrolled Successfully";
  var courseMedia = [];
  var questions = [];
  var flagUserEnrolled = false;
  var flagErrorUnenroll = false;
  var announcements = [];
  final userRef = Firestore.instance.collection('users');
  var flagMedia = false;
  var upcomingAssessmentTimings = [];
  void getUserGroup()async {
    await userRef.getDocuments().then((value) {
      value.documents.forEach((element) {
        var data = element.data();
        if (data['userID'] == FirebaseAuth.instance.currentUser.uid) {
          print(data['lectureGroup']);
          setState(() {
            group = data['lectureGroup'];
          });
          print(group + "group");
        }
      });
    });
    getAnnouncements();
  }

  getAssesments() async {
    await Firestore.instance.collection('courses').getDocuments().then((value) {
      value.documents.forEach((element) {
        var data = element.data();
        if (data['enrolledStudents'].contains(currentUserID) &&
            data['courseName'] == widget.courseName) {
          FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
          for (var assessment in data['assessments']) {
            var splittedDate = assessment['day'].split('-');
            var date = new DateTime(int.parse(splittedDate[2]),
                int.parse(splittedDate[1]), int.parse(splittedDate[0]));
            var splittedTime = assessment['time'].split(' ');
            var hoursMinutes = splittedTime[0];
            var hoursMinutesSplit = hoursMinutes.split(':');
            var hours = int.parse(hoursMinutesSplit[0]);
            var minutes = int.parse(hoursMinutesSplit[1]);
            var amPm = splittedTime[1];
            if (amPm == 'PM') {
              hours += 12;
            }
            var dateTimeAssessment = new DateTime(
                int.parse(splittedDate[2]),
                int.parse(splittedDate[1]),
                int.parse(splittedDate[0]),
                hours,
                minutes);
            var flag = "";
            var remainingTime = dateTimeAssessment.difference(DateTime.now());
            var remainingTimeDays = remainingTime.inDays;
            var remainingTimeHours = remainingTime.inHours;
            var remainingHours = remainingTimeHours - (24 * remainingTimeDays);
            var remainingTimeMinutes = remainingTime.inMinutes;
            var remainingMinutes =
                remainingTimeMinutes - (60 * remainingTimeHours);
            if (DateTime.now().isBefore(dateTimeAssessment)) {
              setState(() {
                upcomingAssessmentTimings.add({
                  'courseName': data['courseName'],
                  'courseCode': data['courseCode'],
                  'assessment': assessment,
                  'dateTimeAssessment': dateTimeAssessment,
                  'remainingTime': remainingTime,
                  'remainingDays': remainingTimeDays,
                  'remainingHours': remainingHours,
                  'remainingMinutes': remainingMinutes,
                });
              });
            }
          }
        }
      });
    });
    for (int i = 0; i < upcomingAssessmentTimings.length - 1; i++) {
      for (int j = 0; j < upcomingAssessmentTimings.length - i - 1; j++) {
        if (upcomingAssessmentTimings.elementAt(j)['remainingTime'] >
            upcomingAssessmentTimings.elementAt(j + 1)['remainingTime']) {
          setState(() {
            var temp = upcomingAssessmentTimings[j];
            upcomingAssessmentTimings[j] =
                upcomingAssessmentTimings.elementAt(j + 1);
            upcomingAssessmentTimings[j + 1] = temp;
          });
        }
      }
    }
  }

  getAnnouncements() {
    Firestore.instance.collection('announcements').getDocuments().then((value) {
      value.documents.forEach((element) {
        var announcement = element.data();
        if (announcement['courseName'] == widget.courseName &&
            (announcement['group'] == group.toString() ||
                announcement['group'] == 'All Groups')) {
          print("my group");
          print(group);
          var expiryDay = announcement['expiryDate'];
          var splitted = expiryDay.toString().split("-");
          var expiryDate = new DateTime(int.parse(splitted[2]),
              int.parse(splitted[1]), int.parse(splitted[0]), 23, 59);
          if (expiryDate.isAfter(DateTime.now())) {
            setState(() {
              announcements.add(announcement);
            });
          }
        }
      });
    });
  }

  void checkUserEnrolled() {
    if (widget.enrolledStudents != null &&
        widget.enrolledStudents.contains(currentUserID)) {
      setState(() {
        flagUserEnrolled = true;
      });
    } else {
      setState(() {
        flagUserEnrolled = false;
      });
    }
  }

  getCourseMedia() {
    if (widget.enrolledStudents != null &&
        widget.enrolledStudents.contains(currentUserID)) {
      Firestore.instance
          .collection('coursesMedia')
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          var data = element.data();
          if (data['courseName'] == widget.courseName) {
            setState(() {
              courseMedia.add(data);
            });
          }
        });
      });
    } else {
      setState(() {
        flagMedia = true;
      });
      return;
    }
    setState(() {
      flagMedia = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserEnrolled();
    getCourseMedia();
    getUserGroup();
    //  getAnnouncements();
    getAssesments();
  }

  enrollInCourse() async {
    if (widget.enrolledStudents == []) {
      widget.enrolledStudents = [currentUserID];
    } else {
      if (widget.enrolledStudents.contains(currentUserID)) {
        setState(() {
          textEnrolled = 'Already Enrolled';
        });

        return;
      }
      setState(() {
        widget.enrolledStudents.add(currentUserID);
      });
    }

    try {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.documentID)
          .set({
        'courseName': widget.courseName,
        'courseCode': widget.courseCode,
        'creditHours': widget.creditHours,
        'numberOfGroups': widget.numberOfGroups,
        'lecturesFrequency': widget.lecturesFrequency,
        'timings': widget.timings,
        'assessments': widget.assessments,
        'courseOwnerId': widget.courseOwnerID,
        'documentID': widget.documentID,
        'enrolledStudents': widget.enrolledStudents
      });
    } catch (error) {
      print(error);
      setState(() {
        flagErrorEnrolled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        if (flagUserEnrolled)
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async{
                              await Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => CourseMediaScreen(
                                            courseMedia, widget.courseName)));

                            },
                            child: Text(
                              "View Course Media",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () async {
                                await Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => CourseMediaScreen(
                                            courseMedia, widget.courseName)));
                              },
                              icon: Icon(
                                Icons.image,
                                color: Colors.blue.shade900,
                              )),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            QuestionsAnswersScreen(
                                                widget.courseName, widget.documentID)));
                              },
                              child: Text(
                                "View Course Questions",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade900),
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () async {
                                await Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            QuestionsAnswersScreen(
                                                widget.courseName, widget.documentID)));
                              },
                              icon: Icon(
                                Icons.question_answer,
                                color: Colors.blue.shade900,
                              )),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                var course = {
                                  'courseName': widget.courseName,
                                  'courseCode': widget.courseCode,
                                  'major': widget.major,
                                  'semester': widget.semester,
                                  'creditHours': widget.creditHours,
                                  'numberOfGroups': widget.numberOfGroups,
                                  'lecturesFrequency': widget.lecturesFrequency,
                                  'timings': widget.timings,
                                  'assessments': widget.assessments,
                                  'courseOwnerId': widget.courseOwnerID,
                                  'documentID': widget.documentID,
                                  'enrolledStudents': widget.enrolledStudents,
                                };
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          content: Text(
                                              'Are you sure you want to unenroll from this course?',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('No', style:TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold, ))),
                                            FlatButton(
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                  try {
                                                    setState(() {
                                                      widget.enrolledStudents
                                                          .remove(
                                                              currentUserID);
                                                    });
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('courses')
                                                        .doc(widget.documentID)
                                                        .set({
                                                      'courseName':
                                                          widget.courseName,
                                                      'courseCode':
                                                          widget.courseCode,
                                                      'major': widget.major,
                                                      'semester':
                                                          widget.semester,
                                                      'creditHours':
                                                          widget.creditHours,
                                                      'numberOfGroups':
                                                          widget.numberOfGroups,
                                                      'lecturesFrequency': widget
                                                          .lecturesFrequency,
                                                      'timings': widget.timings,
                                                      'assessments':
                                                          widget.assessments,
                                                      'courseOwnerId':
                                                          widget.courseOwnerID,
                                                      'documentID':
                                                          widget.documentID,
                                                      'enrolledStudents': widget
                                                          .enrolledStudents,
                                                    });
                                                  } catch (error) {
                                                    print(error);
                                                    setState(() {
                                                      flagErrorUnenroll = true;
                                                    });
                                                  }
                                                  if (!flagErrorUnenroll) {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (_) => AlertDialog(
                                                                  content: Text(
                                                                      'Unenrolled from Course Successfuly'),
                                                                  actions: [
                                                                    FlatButton(
                                                                        onPressed:
                                                                            () {
                                                                          for (var course
                                                                              in widget.myCourses) {
                                                                            if (course['courseName'] ==
                                                                                widget.courseName) {
                                                                              setState(() {
                                                                                widget.myCourses.remove(course);
                                                                              });
                                                                            }
                                                                          }
                                                                          print(
                                                                              "myCourses");
                                                                          print(widget
                                                                              .myCourses
                                                                              .toString());
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Navigator.of(context)
                                                                              .pop(widget.myCourses);
                                                                        },
                                                                        child: Text(
                                                                            'Dimiss',style:TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold,fontSize: 16 )))
                                                                  ],
                                                                ));
                                                  }
                                                },
                                                child: Text('Yes',style:TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold, )),)
                                          ],
                                        ));
                              },
                              child: Text(
                                "Un-enroll from Course",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () async {
                                var course = {
                                  'courseName': widget.courseName,
                                  'courseCode': widget.courseCode,
                                  'major': widget.major,
                                  'semester': widget.semester,
                                  'creditHours': widget.creditHours,
                                  'numberOfGroups': widget.numberOfGroups,
                                  'lecturesFrequency': widget.lecturesFrequency,
                                  'timings': widget.timings,
                                  'assessments': widget.assessments,
                                  'courseOwnerId': widget.courseOwnerID,
                                  'documentID': widget.documentID,
                                  'enrolledStudents': widget.enrolledStudents,
                                };
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          content: Text(
                                              'Are you sure you want to unenroll from this course?',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('No', style: TextStyle(color: Colors.red),)),
                                            FlatButton(
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                  try {
                                                    setState(() {
                                                      widget.enrolledStudents
                                                          .remove(
                                                              currentUserID);
                                                    });
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('courses')
                                                        .doc(widget.documentID)
                                                        .set({
                                                      'courseName':
                                                          widget.courseName,
                                                      'courseCode':
                                                          widget.courseCode,
                                                      'major': widget.major,
                                                      'semester':
                                                          widget.semester,
                                                      'creditHours':
                                                          widget.creditHours,
                                                      'numberOfGroups':
                                                          widget.numberOfGroups,
                                                      'lecturesFrequency': widget
                                                          .lecturesFrequency,
                                                      'timings': widget.timings,
                                                      'assessments':
                                                          widget.assessments,
                                                      'courseOwnerId':
                                                          widget.courseOwnerID,
                                                      'documentID':
                                                          widget.documentID,
                                                      'enrolledStudents': widget
                                                          .enrolledStudents,
                                                    });
                                                  } catch (error) {
                                                    print(error);
                                                    setState(() {
                                                      flagErrorUnenroll = true;
                                                    });
                                                  }
                                                  if (!flagErrorUnenroll) {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (_) => AlertDialog(
                                                                  content: Text(
                                                                      'Unenrolled from Course Successfuly'),
                                                                  actions: [
                                                                    FlatButton(
                                                                        onPressed:
                                                                            () {
                                                                          for (var course
                                                                              in widget.myCourses) {
                                                                            if (course['courseName'] ==
                                                                                widget.courseName) {
                                                                              setState(() {
                                                                                widget.myCourses.remove(course);
                                                                              });
                                                                            }
                                                                          }
                                                                          print(
                                                                              "myCourses");
                                                                          print(widget
                                                                              .myCourses
                                                                              .toString());
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Navigator.of(context)
                                                                              .pop(widget.myCourses);
                                                                        },
                                                                        child: Text(
                                                                            'Dimiss'))
                                                                  ],
                                                                ));
                                                  }
                                                },
                                                child: Text('Yes')),
                                          ],
                                        ));
                              },
                              icon: Icon(
                                Icons.remove,
                                color: Colors.red,
                              )),
                        ],
                      ),
                    )
                  ])
      ], title: Text(widget.courseName)),
      // floatingActionButton: TextButton(
      //   onPressed: () async {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) =>
      //                 CreateQuestionScreen(widget.courseName,widget.documentID  )));
      //   },
      //   child: Text("Ask a question"),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: !flagMedia
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                if (!flagUserEnrolled)
                  Container(
                    alignment: Alignment.center,
                    child: EmptyWidget(
                      image: null,
                      packageImage: PackageImage.Image_3,
                      title: 'You are not enrolled in this course',
                      //  subTitle: 'No  questions available yet',
                      titleTextStyle: TextStyle(
                        fontSize: 22,
                        color: Color(0xff9da9c7),
                        fontWeight: FontWeight.w500,
                      ),
                      subtitleTextStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xffabb8d6),
                      ),
                    ),
                  ),
                  if(!flagUserEnrolled)
                  SizedBox(height: 20,),
                 if (!widget.enrolledStudents.contains(currentUserID))
                  ElevatedButton(
                      onPressed: () {
                        enrollInCourse();
                        setState(() {
                          widget.myCourses.add({
                            'courseName': widget.courseName,
                            'courseCode': widget.courseCode,
                            'major': widget.major,
                            'semester': widget.semester,
                            'creditHours': widget.creditHours,
                            'numberOfGroups': widget.numberOfGroups,
                            'lecturesFrequency': widget.lecturesFrequency,
                            'timings': widget.timings,
                            'assessments': widget.assessments,
                            'courseOwnerId': widget.courseOwnerID,
                            'documentID': widget.documentID,
                            'enrolledStudents': widget.enrolledStudents,
                          });
                        });
                        if (!flagErrorEnrolled) {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    content: Text(textEnrolled),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            setState(() {});
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context)
                                                .pop(widget.myCourses);
                                          },
                                          child: Text('Dimiss'))
                                    ],
                                  ));
                        }
                      },
                      child: Text('Enroll in Course')),
                if (flagUserEnrolled)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView.builder(
                        itemCount: upcomingAssessmentTimings.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {},
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Align(
                                          // alignment: Alignment.centerLeft,
                                          child: Icon(
                                        Icons.label_important_outlined,
                                        size: 30,
                                        color: Colors.red.shade900,
                                      )),
                                      SizedBox(width: 10),
                                      Text(
                                        'Important Events',
                                        style:  TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900),
                                      ),
                                      // Spacer(),
                                      // IconButton(
                                      //     onPressed: () {
                                      //       notificationDefaultSound();
                                      //     },
                                      //     icon: Icon(Icons.add_alarm)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  if (upcomingAssessmentTimings.elementAt(
                                                  index)['assessment']
                                              ['assessmentType'] ==
                                          'Project' ||
                                      upcomingAssessmentTimings.elementAt(
                                                  index)['assessment']
                                              ['assessmentType'] ==
                                          'Assignment')
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            upcomingAssessmentTimings.elementAt(
                                                    index)['assessment']
                                                ['assessmentName'],
                                            style: TextStyle(
                                                color: Colors.blue.shade900,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold))),
                                  if (upcomingAssessmentTimings.elementAt(index)['assessment']
                                              ['assessmentType'] ==
                                          'Project' ||
                                      upcomingAssessmentTimings
                                                  .elementAt(index)['assessment']
                                              ['assessmentType'] ==
                                          'Assignment')
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            'DueDate: ' +
                                                upcomingAssessmentTimings
                                                        .elementAt(index)['assessment']
                                                    ['day'] +
                                                ' @ ' +
                                                upcomingAssessmentTimings
                                                        .elementAt(index)['assessment']
                                                    ['time'],
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold))),
                                  if (upcomingAssessmentTimings.elementAt(
                                                  index)['assessment']
                                              ['assessmentType'] ==
                                          'Midterm' ||
                                      upcomingAssessmentTimings.elementAt(
                                                  index)['assessment']
                                              ['assessmentType'] ==
                                          'Final')
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            upcomingAssessmentTimings.elementAt(
                                                    index)['assessment']
                                                ['assessmentType'],
                                            style:
                                                TextStyle(color: Colors.grey))),
                                  if (upcomingAssessmentTimings.elementAt(
                                                  index)['assessment']
                                              ['assessmentType'] ==
                                          'Midterm' ||
                                      upcomingAssessmentTimings.elementAt(
                                                  index)['assessment']
                                              ['assessmentType'] ==
                                          'Final')
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          'Exam Date: ' +
                                              upcomingAssessmentTimings
                                                      .elementAt(
                                                          index)['assessment']
                                                  ['day'] +
                                              ' @ ' +
                                              upcomingAssessmentTimings
                                                      .elementAt(
                                                          index)['assessment']
                                                  ['time'],
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  if (upcomingAssessmentTimings
                                              .elementAt(index)['assessment']
                                          ['assessmentType'] ==
                                      'Quiz')
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        upcomingAssessmentTimings
                                                .elementAt(index)['assessment']
                                            ['assessmentName'],
                                        style: TextStyle(color: Colors.blue.shade900),
                                      ),
                                    ),
                                  if (upcomingAssessmentTimings
                                              .elementAt(index)['assessment']
                                          ['assessmentType'] ==
                                      'Quiz')
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          'Quiz Date: ' +
                                              upcomingAssessmentTimings
                                                      .elementAt(
                                                          index)['assessment']
                                                  ['day'] +
                                              ' @ ' +
                                              upcomingAssessmentTimings
                                                      .elementAt(
                                                          index)['assessment']
                                                  ['time'],
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  Divider(
                                    color: Colors.blue.shade900,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  if(flagUserEnrolled)
                Row(
                  children: [
                    Align(
                        // alignment: Alignment.centerLeft,
                        child: Icon(
                      Icons.announcement_rounded,
                      size: 30,
                      color: Colors.red.shade900
                    )),
                    SizedBox(width: 10),
                    Text(
                      'Announcements',
                      style:  TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: ListView.builder(
                      itemCount: announcements.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SingleChildScrollView(
                          child: Dismissible(
                            onDismissed: (direction) {
                              setState(() {
                                announcements.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Announcement ' +
                                          (index + 1).toString() +
                                          ' dismissed')));
                            },
                            key: UniqueKey(),
                            background: Container(color: Colors.red),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 5),
                                Center(
                                  child: Text(
                                    announcements.elementAt(index)['title'],
                                    style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(announcements
                                        .elementAt(index)['body'], style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 15, color: Colors.blue.shade900),)),
                                Divider(color: Colors.blue.shade900 ),
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

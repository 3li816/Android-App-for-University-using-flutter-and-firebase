import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_complete_guide/screens/calender_screen.dart';
import 'package:flutter_complete_guide/screens/edit_instructor_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/services.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

class InstructorHomeScreen extends StatefulWidget {
  static const routeName = '/instructor-home';

  @override
  State<InstructorHomeScreen> createState() => _InstructorHomeScreenState();
}

class _InstructorHomeScreenState extends State<InstructorHomeScreen> {
  //var currentUserID = FirebaseAuth.instance.currentUser.updatePassword(newPassword);
  // final coursesRef = Firestore.instance.collection('courses');
  int _selectedIndex = 0;
  final usersRef = Firestore.instance.collection('users');
  var myCourses = [];
  var flagViewCourse = false;
  var email = '';
  var firstName = '';
  var lastName = '';
  var role;
  var userID;
  var myUser = [];
  var myAssessment = [];
  var upcomingAssessmentTimings = [];
  var myLectureTimings = [];
  var saturdayArray = [];
  var sundayArray = [];
  var mondayArray = [];
  var tuesdayArray = [];
  var wednesdayArray = [];
  var thursdayArray = [];
  //var _pages = [InstructorHomeScreen(),EditInstructorScreen("", "lastName", "email", "role", "userID") ];

  logOut() async {
    //FirebaseAuth.instance.currentUser.;
    await FirebaseAuth.instance.signOut();
    //print(FirebaseAuth.instance.currentUser.email);
  }

  Function getInstructorData() {
    usersRef.getDocuments().then((value) {
      value.documents.forEach((element) {
        var data = element.data();
        if (data['userID'] == FirebaseAuth.instance.currentUser.uid) {
          setState(() {
            email = data['email'];
            firstName = data['firstName'];
            lastName = data['lastName'];
            role = data['role'];
            userID = data['userID'];
          });
        }
      });
    });
    setState(() {
      flagViewCourse = true;
    });
  }

  // Function viewmyAssessments() {
  //   for (var course in myAssessment) {
  //     for (var assessment in course['assessments']) {
  //       var assessmentTime =
  //           new DateTime.fromMillisecondsSinceEpoch(assessment['date'] / 1000);
  //       setState(() {
  //         assessmentTimings.add(assessment['date']);
  //       });
  //     }
  //   }
  // }

  Function viewMyCourses() {
    var item = {};
    Firestore.instance.collection('courses').getDocuments().then((value) {
      value.documents.forEach((element) {
        var data = element.data();
        if (data['courseOwnerId'] == FirebaseAuth.instance.currentUser.uid) {
          print(data['courseName']);
          setState(() {
            myCourses.add({
              'courseName': data['courseName'],
              'courseCode': data['courseCode'],
              'creditHours': data['creditHours'],
              'numberOfGroups': data['numberOfGroups'],
              'lecturesFrequency': data['lecturesFrequency'],
              'timings': data['timings'],
              'assessments': data['assessments'],
              'courseOwnerId': data['courseOwnerId'],
              'documentID': data['documentID'],
              'enrolledStudents': data['enrolledStudents'],
            });
          });
          var day1 = 10;
          var day2 = 10;
          for (var timing in data['timings']) {
            if (timing['1st Lecture Day'] == 'Saturday') {
              setState(() {
                day1 = 1;
              });
            } else if (timing['1st Lecture Day'] == 'Sunday') {
              setState(() {
                day1 = 2;
              });
            } else if (timing['1st Lecture Day'] == 'Monday') {
              setState(() {
                day1 = 3;
              });
            } else if (timing['1st Lecture Day'] == 'Tuesday') {
              setState(() {
                day1 = 4;
              });
            } else if (timing['1st Lecture Day'] == 'Wednesday') {
              setState(() {
                day1 = 5;
              });
            } else {
              setState(() {
                day1 = 6;
              });
            }
            if (data['lecturesFrequency'] == 'Twice a week') {
              for (var timing in data['timings']) {
                if (timing['2nd Lecture Day'] == 'Saturday') {
                  setState(() {
                    day2 = 1;
                  });
                } else if (timing['2nd Lecture Day'] == 'Sunday') {
                  setState(() {
                    day2 = 2;
                  });
                } else if (timing['2nd Lecture Day'] == 'Monday') {
                  setState(() {
                    day2 = 3;
                  });
                } else if (timing['2nd Lecture Day'] == 'Tuesday') {
                  setState(() {
                    day2 = 4;
                  });
                } else if (timing['2nd Lecture Day'] == 'Wednesday') {
                  setState(() {
                    day2 = 5;
                  });
                } else {
                  setState(() {
                    day2 = 6;
                  });
                }
              }
            }
            if (data['lecturesFrequency'] == 'Twice a week') {
              setState(() {
                item = {
                  'courseName': data['courseName'],
                  'courseCode': data['courseCode'],
                  'lecturesFrequency': '2',
                  'day1Lecture': timing['1st Lecture Day'],
                  'day1Slot': timing['1st Lecture Slot'],
                  'day1Location': timing['1st Lecture Location'],
                  'day2Lecture': timing['2nd Lecture Day'],
                  'day2Slot': timing['2nd Lecture Slot'],
                  'day2Location': timing['2nd Lecture Location'],
                  'day1': day1,
                  'day2': day2
                };
              });
              setState(() {
                myLectureTimings.add({
                  'courseName': data['courseName'],
                  'courseCode': data['courseCode'],
                  'lecturesFrequency': '2',
                  'day1Lecture': timing['1st Lecture Day'],
                  'day1Slot': timing['1st Lecture Slot'],
                  'day1Location': timing['1st Lecture Location'],
                  'day2Lecture': timing['2nd Lecture Day'],
                  'day2Slot': timing['2nd Lecture Slot'],
                  'day2Location': timing['2nd Lecture Location'],
                  'day1': day1,
                  'day2': day2
                });
              });
            } else {
              setState(() {
                item = {
                  'courseName': data['courseName'],
                  'courseCode': data['courseCode'],
                  'lecturesFrequency': '1',
                  'day1Lecture': timing['1st Lecture Day'],
                  'day1': day1,
                  'day1Slot': timing['1st Lecture Slot'],
                  'day1Location': timing['1st Lecture Location'],
                  'day2': day2
                };
              });
              setState(() {
                myLectureTimings.add({
                  'courseName': data['courseName'],
                  'courseCode': data['courseCode'],
                  'lecturesFrequency': '1',
                  'day1Lecture': timing['1st Lecture Day'],
                  'day1': day1,
                  'day1Slot': timing['1st Lecture Slot'],
                  'day1Location': timing['1st Lecture Location'],
                  'day2': day2
                });
              });
            }
          }
          switch (item['day1']) {
            case 1:
              {
                setState(() {
                  saturdayArray.add({
                    'courseName': item['courseName'],
                    'courseCode': item['courseCode'],
                    'slot': item['day1Slot'],
                    'location': item['day1Location'],
                  });
                });
              }
              break;
            case 2:
              {
                setState(() {
                  sundayArray.add({
                    'courseName': item['courseName'],
                    'courseCode': item['courseCode'],
                    'slot': item['day1Slot'],
                    'location': item['day1Location'],
                  });
                });
              }
              break;
            case 3:
              {
                setState(() {
                  mondayArray.add({
                    'courseName': item['courseName'],
                    'courseCode': item['courseCode'],
                    'slot': item['day1Slot'],
                    'location': item['day1Location'],
                  });
                });
              }
              break;
            case 4:
              {
                setState(() {
                  tuesdayArray.add({
                    'courseName': item['courseName'],
                    'courseCode': item['courseCode'],
                    'slot': item['day1Slot'],
                    'location': item['day1Location'],
                  });
                });
              }
              break;
            case 5:
              {
                setState(() {
                  wednesdayArray.add({
                    'courseName': item['courseName'],
                    'courseCode': item['courseCode'],
                    'slot': item['day1Slot'],
                    'location': item['day1Location'],
                  });
                });
              }
              break;
            case 6:
              {
                setState(() {
                  thursdayArray.add({
                    'courseName': item['courseName'],
                    'courseCode': item['courseCode'],
                    'slot': item['day1Slot'],
                    'location': item['day1Location'],
                  });
                });
              }
              break;

            default:
              {}
              break;
          }
          switch (item['day2']) {
            case 1:
              {
                setState(() {
                  saturdayArray.add({
                    'courseName': item['courseName'],
                    'courseCode': item['courseCode'],
                    'slot': item['day2Slot'],
                    'location': item['day2Location'],
                  });
                });
              }
              break;
            case 2:
              {
                setState(() {
                  sundayArray.add({
                    'courseName': item['courseName'],
                    'courseCode': item['courseCode'],
                    'slot': item['day2Slot'],
                    'location': item['day2Location'],
                  });
                });
              }
              break;
            case 3:
              {
                setState(() {
                  mondayArray.add({
                    'courseName': item['courseName'],
                    'courseCode': item['courseCode'],
                    'slot': item['day2Slot'],
                    'location': item['day2Location'],
                  });
                });
              }
              break;
            case 4:
              {
                setState(() {
                  tuesdayArray.add({
                    'courseName': item['courseName'],
                    'courseCode': item['courseCode'],
                    'slot': item['day2Slot'],
                    'location': item['day2Location'],
                  });
                });
              }
              break;
            case 5:
              {
                setState(() {
                  wednesdayArray.add({
                    'courseName': item['courseName'],
                    'courseCode': item['courseCode'],
                    'slot': item['day2Slot'],
                    'location': item['day2Location'],
                  });
                });
              }
              break;
            case 6:
              {
                setState(() {
                  thursdayArray.add({
                    'courseName': item['courseName'],
                    'courseCode': item['courseCode'],
                    'slot': item['day2Slot'],
                    'location': item['day2Location'],
                  });
                });
              }
              break;

            default:
              {}
              break;
          }
          for (int i = 0; i < saturdayArray.length - 1; i++) {
            for (int j = 0; j < saturdayArray.length - 1 - i; j++) {
              var slotj =
                  int.parse(saturdayArray.elementAt(j)['slot'].substring(0, 1));
              var slotjPlusOne = int.parse(
                  saturdayArray.elementAt(j + 1)['slot'].substring(0, 1));
              if (slotj > slotjPlusOne) {
                setState(() {
                  var temp = saturdayArray.elementAt(j);
                  saturdayArray[j] = saturdayArray.elementAt(j + 1);
                  saturdayArray[j + 1] = temp;
                });
              }
            }
          }
          for (int i = 0; i < sundayArray.length - 1; i++) {
            for (int j = 0; j < sundayArray.length - 1 - i; j++) {
              var slotj =
                  int.parse(sundayArray.elementAt(j)['slot'].substring(0, 1));
              var slotjPlusOne = int.parse(
                  sundayArray.elementAt(j + 1)['slot'].substring(0, 1));
              if (slotj > slotjPlusOne) {
                setState(() {
                  var temp = sundayArray.elementAt(j);
                  sundayArray[j] = sundayArray.elementAt(j + 1);
                  sundayArray[j + 1] = temp;
                });
              }
            }
          }
          for (int i = 0; i < mondayArray.length - 1; i++) {
            for (int j = 0; j < mondayArray.length - 1 - i; j++) {
              var slotj =
                  int.parse(mondayArray.elementAt(j)['slot'].substring(0, 1));
              var slotjPlusOne = int.parse(
                  mondayArray.elementAt(j + 1)['slot'].substring(0, 1));
              if (slotj > slotjPlusOne) {
                setState(() {
                  var temp = mondayArray.elementAt(j);
                  mondayArray[j] = mondayArray.elementAt(j + 1);
                  mondayArray[j + 1] = temp;
                });
              }
            }
          }
          for (int i = 0; i < tuesdayArray.length - 1; i++) {
            for (int j = 0; j < tuesdayArray.length - 1 - i; j++) {
              var slotj =
                  int.parse(tuesdayArray.elementAt(j)['slot'].substring(0, 1));
              var slotjPlusOne = int.parse(
                  tuesdayArray.elementAt(j + 1)['slot'].substring(0, 1));
              if (slotj > slotjPlusOne) {
                setState(() {
                  var temp = tuesdayArray.elementAt(j);
                  tuesdayArray[j] = tuesdayArray.elementAt(j + 1);
                  tuesdayArray[j + 1] = temp;
                });
              }
            }
          }
          for (int i = 0; i < wednesdayArray.length - 1; i++) {
            for (int j = 0; j < wednesdayArray.length - 1 - i; j++) {
              var slotj = int.parse(
                  wednesdayArray.elementAt(j)['slot'].substring(0, 1));
              var slotjPlusOne = int.parse(
                  wednesdayArray.elementAt(j + 1)['slot'].substring(0, 1));
              if (slotj > slotjPlusOne) {
                setState(() {
                  var temp = wednesdayArray.elementAt(j);
                  wednesdayArray[j] = wednesdayArray.elementAt(j + 1);
                  wednesdayArray[j + 1] = temp;
                });
              }
            }
          }
          for (int i = 0; i < thursdayArray.length - 1; i++) {
            for (int j = 0; j < thursdayArray.length - 1 - i; j++) {
              var slotj =
                  int.parse(thursdayArray.elementAt(j)['slot'].substring(0, 1));
              var slotjPlusOne = int.parse(
                  thursdayArray.elementAt(j + 1)['slot'].substring(0, 1));
              if (slotj > slotjPlusOne) {
                setState(() {
                  var temp = thursdayArray.elementAt(j);
                  thursdayArray[j] = thursdayArray.elementAt(j + 1);
                  thursdayArray[j + 1] = temp;
                });
              }
            }
          }
          //  if (!data['assessments'].elementAt(0).isEmpty) {
          setState(() {
            myAssessment.add({
              'courseName': data['courseName'],
              'courseCode': data['courseCode'],
              'assessments': data['assessments'],
            });
          });
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
              flag = "Assessment Passed";
            }
            for (int i = 0; i < upcomingAssessmentTimings.length - 1; i++) {
              for (int j = 0;
                  j < upcomingAssessmentTimings.length - i - 1;
                  j++) {
                if (upcomingAssessmentTimings.elementAt(j)['remainingTime'] >
                    upcomingAssessmentTimings
                        .elementAt(j + 1)['remainingTime']) {
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
        }
        //}
      });
    });

    for (var item in myLectureTimings) {
      switch (item['day2']) {
        case 1:
          {
            setState(() {
              saturdayArray.add({
                'courseName': item['courseName'],
                'courseCode': item['courseCode'],
                'slot': item['day2Slot'],
                'location': item['day2Location'],
              });
            });
          }
          break;
        case 2:
          {
            setState(() {
              sundayArray.add({
                'courseName': item['courseName'],
                'courseCode': item['courseCode'],
                'slot': item['day2Slot'],
                'location': item['day2Location'],
              });
            });
          }
          break;
        case 3:
          {
            setState(() {
              mondayArray.add({
                'courseName': item['courseName'],
                'courseCode': item['courseCode'],
                'slot': item['day2Slot'],
                'location': item['day2Location'],
              });
            });
          }
          break;
        case 4:
          {
            setState(() {
              tuesdayArray.add({
                'courseName': item['courseName'],
                'courseCode': item['courseCode'],
                'slot': item['day2Slot'],
                'location': item['day2Location'],
              });
            });
          }
          break;
        case 5:
          {
            setState(() {
              wednesdayArray.add({
                'courseName': item['courseName'],
                'courseCode': item['courseCode'],
                'slot': item['day2Slot'],
                'location': item['day2Location'],
              });
            });
          }
          break;
        case 6:
          {
            setState(() {
              thursdayArray.add({
                'courseName': item['courseName'],
                'courseCode': item['courseCode'],
                'slot': item['day2Slot'],
                'location': item['day2Location'],
              });
            });
          }
          break;
      }
    }
    setState(() {
      flagViewCourse = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
    super.initState();
    getInstructorData();
    viewMyCourses();
    // firebaseMessaging.subscribeToTopic("assessments");
  }

  @override
  Widget build(BuildContext context) {
    return !flagViewCourse
        ? CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              title: Text('Home Page'),
              actions: [
                GestureDetector(
                    child: Image(
                        image: AssetImage(
                            'lib/assets/images/calendar.png')),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CalendarScreen(upcomingAssessmentTimings),
                          ));
                    }),
                // IconButton(
                //     onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) =>
                //           CalendarScreen(upcomingAssessmentTimings),
                //     ));
                //     },
                //     icon: Icon(
                //       Icons.calendar_month,
                //       size: 30,
                //       color: Colors.white,
                //     )),

                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: TextButton(
                        child: Text(
                          'Edit My Profile',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () async {
                          var flagPop = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditInstructorScreen(),
                              ));
                          //if(flagPop){
                          Navigator.of(context).pop();
                          //}
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      content: Text(
                                          "Are you sure you want to logout?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("No",
                                                style: TextStyle(
                                                  color: Colors.blue.shade900,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ))),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              logOut();
                                            },
                                            child: Text("Yes",
                                                style: TextStyle(
                                                  color: Colors.blue.shade900,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ))),
                                      ],
                                    ));
                          },
                          child: Text('Logout',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                                fontSize: 16,
                              ))),
                    ),
                  ],
                ),
              ],
            ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            // Expanded(
                            //   child: Image(
                            //            image: AssetImage('lib/assets/images/issue2.png')),
                            // ),
                            Align(
                                child: Icon(
                              Icons.label_important_outlined,
                              size: 30,
                              color: Colors.red.shade900,
                            )),
                            SizedBox(width: 10),
                            Text(
                              'Important Events',
                              style: GoogleFonts.arvo(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade900),
                              //Colors.blue.shade900),
                            ),
                          ],
                        ),
                        // SizedBox(height:MediaQuery.of(context).size.height * 0.1 ,)
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: ListView.builder(
                       // physics: NeverScrollableScrollPhysics(),
                          itemCount: upcomingAssessmentTimings.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SingleChildScrollView(
                                child: Center(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.blue.shade900,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                elevation: 0,
                                color: Colors.lightBlue.shade100,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                                upcomingAssessmentTimings
                                                            .elementAt(index)[
                                                        'courseName'] +
                                                    " - " +
                                                    upcomingAssessmentTimings
                                                            .elementAt(index)[
                                                        'courseCode'], // "  " +
                                                style: GoogleFonts.merriweather(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      if (upcomingAssessmentTimings.elementAt(
                                                      index)['assessment']
                                                  ['assessmentType'] ==
                                              'Project' ||
                                          upcomingAssessmentTimings.elementAt(
                                                      index)['assessment']
                                                  ['assessmentType'] ==
                                              'Assignment')
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    upcomingAssessmentTimings
                                                                .elementAt(
                                                                    index)[
                                                            'assessment']
                                                        ['assessmentName'],
                                                    style: GoogleFonts.roboto(
                                                        color: Colors
                                                            .blue.shade900,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                          ],
                                        ),
                                      SizedBox(height: 5),
                                      if (upcomingAssessmentTimings.elementAt(
                                                      index)['assessment']
                                                  ['assessmentType'] ==
                                              'Project' ||
                                          upcomingAssessmentTimings.elementAt(
                                                      index)['assessment']
                                                  ['assessmentType'] ==
                                              'Assignment')
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'DueDate: ' +
                                                      upcomingAssessmentTimings
                                                              .elementAt(index)[
                                                          'assessment']['day'] +
                                                      ' @ ' +
                                                      upcomingAssessmentTimings
                                                              .elementAt(index)[
                                                          'assessment']['time'],
                                                  style: GoogleFonts.openSans(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          ],
                                        ),
                                      if (upcomingAssessmentTimings.elementAt(
                                                      index)['assessment']
                                                  ['assessmentType'] ==
                                              'Midterm' ||
                                          upcomingAssessmentTimings.elementAt(
                                                      index)['assessment']
                                                  ['assessmentType'] ==
                                              'Final')
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    upcomingAssessmentTimings
                                                                .elementAt(
                                                                    index)[
                                                            'assessment']
                                                        ['assessmentType'],
                                                    style: GoogleFonts.roboto(
                                                        color: Colors
                                                            .blue.shade900,
                                                        fontWeight:
                                                            FontWeight.bold)
                                                    // TextStyle(
                                                    //     )
                                                    )),
                                          ],
                                        ),
                                      if (upcomingAssessmentTimings.elementAt(
                                                      index)['assessment']
                                                  ['assessmentType'] ==
                                              'Midterm' ||
                                          upcomingAssessmentTimings.elementAt(
                                                      index)['assessment']
                                                  ['assessmentType'] ==
                                              'Final')
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  'Exam Date: ' +
                                                      upcomingAssessmentTimings
                                                              .elementAt(index)[
                                                          'assessment']['day'] +
                                                      ' @ ' +
                                                      upcomingAssessmentTimings
                                                              .elementAt(index)[
                                                          'assessment']['time'],
                                                  style: GoogleFonts.openSans(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  // TextStyle(
                                                  //     color: Colors.red,
                                                  //     fontWeight: FontWeight.bold),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      if (upcomingAssessmentTimings.elementAt(
                                                  index)['assessment']
                                              ['assessmentType'] ==
                                          'Quiz')
                                        Row(
                                          children: [
                                            SizedBox(width: 15),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  upcomingAssessmentTimings
                                                              .elementAt(index)[
                                                          'assessment']
                                                      ['assessmentName'],
                                                  style: GoogleFonts.roboto(
                                                      color:
                                                          Colors.blue.shade900,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  //TextStyle(color: Colors.blue.shade900),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      if (upcomingAssessmentTimings.elementAt(
                                                  index)['assessment']
                                              ['assessmentType'] ==
                                          'Quiz')
                                        Row(
                                          children: [
                                            SizedBox(width: 15),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Quiz Date: ' +
                                                    upcomingAssessmentTimings
                                                            .elementAt(index)[
                                                        'assessment']['day'] +
                                                    ' @ ' +
                                                    upcomingAssessmentTimings
                                                            .elementAt(index)[
                                                        'assessment']['time'],
                                                style: GoogleFonts.openSans(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                          }),
                    ),
                    // SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                     Row(
                      children: [
                        Align(
                            child: Icon(Icons.calendar_month,
                                size: 30, color: Colors.red.shade900)),
                        SizedBox(width: 10),
                        Text(
                          'My Schedule',
                          style: GoogleFonts.arvo(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade900),
                        ),
                      ],
                    ),
                    // Divider(
                    //   color: Colors.red.shade900,
                    // ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.43,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                      if (saturdayArray.length > 0)
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.17,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                            itemCount: saturdayArray.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.blue.shade900,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                elevation: 0,
                                color: Colors.lightBlue.shade100,
                                child: Column(children: [
                                  Center(child: Text("Saturday", style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold, 
                                        fontSize: 18, 
                                        color: Colors.blue.shade900
                                      )  )),
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('1st:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          saturdayArray.elementAt(index)['slot']=='1st'? 
                                      Text(saturdayArray.elementAt(index)['courseName'] + " @ "+ saturdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                 Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('2nd:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          saturdayArray.elementAt(index)['slot']=='2nd'? 
                                      Text(saturdayArray.elementAt(index)['courseName'] + " @ "+ saturdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                      
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('3rd:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          saturdayArray.elementAt(index)['slot']=='3rd'? 
                                      Text(saturdayArray.elementAt(index)['courseName'] + " @ "+ saturdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('4th:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          saturdayArray.elementAt(index)['slot']=='4th'? 
                                      Text(saturdayArray.elementAt(index)['courseName'] + " @ "+ saturdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ), 
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('5th:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          saturdayArray.elementAt(index)['slot']=='5th'? 
                                      Text(saturdayArray.elementAt(index)['courseName'] + " @ "+ saturdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                ],),
                              );
                            }),
                      ),
                      if (sundayArray.length > 0)
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.17,
                        child: ListView.builder(
                           physics: NeverScrollableScrollPhysics(),
                            itemCount: sundayArray.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.blue.shade900,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                elevation: 0,
                                color: Colors.lightBlue.shade100,
                                child: Column(children: [
                                  Center(child: Text("Sunday", style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold, 
                                        fontSize: 18, 
                                        color: Colors.blue.shade900
                                      )  )),
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('1st:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          sundayArray.elementAt(index)['slot']=='1st'? 
                                      Text(sundayArray.elementAt(index)['courseName'] + " @ "+ sundayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                 Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('2nd:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          sundayArray.elementAt(index)['slot']=='2nd'? 
                                      Text(sundayArray.elementAt(index)['courseName'] + " @ "+ sundayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                      
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('3rd:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          sundayArray.elementAt(index)['slot']=='3rd'? 
                                      Text(sundayArray.elementAt(index)['courseName'] + " @ "+ sundayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('4th:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          sundayArray.elementAt(index)['slot']=='4th'? 
                                      Text(sundayArray.elementAt(index)['courseName'] + " @ "+ sundayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ), 
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('5th:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          sundayArray.elementAt(index)['slot']=='5th'? 
                                      Text(sundayArray.elementAt(index)['courseName'] + " @ "+ sundayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                ],),
                              );
                            }),
                      ),
                      if (mondayArray.length > 0)
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.2,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                            itemCount: mondayArray.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.blue.shade900,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                elevation: 0,
                                color: Colors.lightBlue.shade100,
                                child: Column(children: [
                                  Center(child: Text("Monday", style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold, 
                                        fontSize: 18, 
                                        color: Colors.blue.shade900
                                      )  )),
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('1st:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          mondayArray.elementAt(index)['slot']=='1st'? 
                                      Text(mondayArray.elementAt(index)['courseName'] + " @ "+ mondayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                 Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('2nd:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          mondayArray.elementAt(index)['slot']=='2nd'? 
                                      Text(mondayArray.elementAt(index)['courseName'] + " @ "+ mondayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('3rd:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          mondayArray.elementAt(index)['slot']=='3rd'? 
                                      Text(mondayArray.elementAt(index)['courseName'] + " @ "+ mondayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('4th:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          mondayArray.elementAt(index)['slot']=='4th'? 
                                      Text(mondayArray.elementAt(index)['courseName'] + " @ "+ mondayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ), 
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('5th:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          mondayArray.elementAt(index)['slot']=='5th'? 
                                      Text(mondayArray.elementAt(index)['courseName'] + " @ "+ mondayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                ],),
                              );
                            }),
                      ),
                      if (tuesdayArray.length > 0)
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.2,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                            itemCount: tuesdayArray.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.blue.shade900,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                elevation: 0,
                                color: Colors.lightBlue.shade100,
                                child: Column(children: [
                                  Center(child: Text("Tuesday", style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold, 
                                        fontSize: 18, 
                                        color: Colors.blue.shade900
                                      )  )),
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('1st:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          tuesdayArray.elementAt(index)['slot']=='1st'? 
                                      Text(tuesdayArray.elementAt(index)['courseName'] + " @ "+ tuesdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                 Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('2nd:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          tuesdayArray.elementAt(index)['slot']=='2nd'? 
                                      Text(tuesdayArray.elementAt(index)['courseName'] + " @ "+ tuesdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('3rd:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          tuesdayArray.elementAt(index)['slot']=='3rd'? 
                                      Text(tuesdayArray.elementAt(index)['courseName'] + " @ "+ tuesdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('4th:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          tuesdayArray.elementAt(index)['slot']=='4th'? 
                                      Text(tuesdayArray.elementAt(index)['courseName'] + " @ "+ tuesdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ), 
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('5th:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          tuesdayArray.elementAt(index)['slot']=='5th'? 
                                      Text(tuesdayArray.elementAt(index)['courseName'] + " @ "+ tuesdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                ],),
                              );
                            }),
                      ),
                     if (wednesdayArray.length > 0)
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.2,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                            itemCount: wednesdayArray.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.blue.shade900,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                elevation: 0,
                                color: Colors.lightBlue.shade100,
                                child: Column(children: [
                                  Center(child: Text("Wednesday", style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold, 
                                        fontSize: 18, 
                                        color: Colors.blue.shade900
                                      )  )),
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('1st:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          wednesdayArray.elementAt(index)['slot']=='1st'? 
                                      Text(wednesdayArray.elementAt(index)['courseName'] + " @ "+ wednesdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                 Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('2nd:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          wednesdayArray.elementAt(index)['slot']=='2nd'? 
                                      Text(wednesdayArray.elementAt(index)['courseName'] + " @ "+ wednesdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('3rd:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          wednesdayArray.elementAt(index)['slot']=='3rd'? 
                                      Text(wednesdayArray.elementAt(index)['courseName'] + " @ "+ wednesdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('4th:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          wednesdayArray.elementAt(index)['slot']=='4th'? 
                                      Text(wednesdayArray.elementAt(index)['courseName'] + " @ "+ wednesdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ), 
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('5th:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          wednesdayArray.elementAt(index)['slot']=='5th'? 
                                      Text(wednesdayArray.elementAt(index)['courseName'] + " @ "+ wednesdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                ],),
                              );
                            }),
                      )
                          ])
                      ),
                    ),
                    if (thursdayArray.length > 0)
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.2,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                            itemCount: mondayArray.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.blue.shade900,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                elevation: 0,
                                color: Colors.lightBlue.shade100,
                                child: Column(children: [
                                  Center(child: Text("Monday", style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold, 
                                        fontSize: 18, 
                                        color: Colors.blue.shade900
                                      )  )),
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('1st:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          thursdayArray.elementAt(index)['slot']=='1st'? 
                                      Text(thursdayArray.elementAt(index)['courseName'] + " @ "+ thursdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                 Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('2nd:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          thursdayArray.elementAt(index)['slot']=='2nd'? 
                                      Text(thursdayArray.elementAt(index)['courseName'] + " @ "+ thursdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('3rd:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          thursdayArray.elementAt(index)['slot']=='3rd'? 
                                      Text(thursdayArray.elementAt(index)['courseName'] + " @ "+ thursdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('4th:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          thursdayArray.elementAt(index)['slot']=='4th'? 
                                      Text(thursdayArray.elementAt(index)['courseName'] + " @ "+ thursdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ), 
                                  Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Text('5th:  ', style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16, 
                                            color: Colors.blue.shade900
                                          ),),
                                          thursdayArray.elementAt(index)['slot']=='5th'? 
                                      Text(thursdayArray.elementAt(index)['courseName'] + " @ "+ thursdayArray.elementAt(index)['location'], 
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                      : Text('Free', style: GoogleFonts.openSans(fontWeight: FontWeight.bold,
                                       fontSize: 16, color: Colors.grey.shade700),),
                                   ],
                                 ),
                                ],),
                              );
                            }),
                      ),
                    //         if (saturdayArray.length > 0)
                    //           SizedBox(
                    //             child: Row(
                    //               children: [
                    //                 Container(
                    //                   child: Center(
                    //                       child: Column(
                    //                     children: [
                    //                       Text(
                    //                         'Saturday',
                    //                         style: TextStyle(
                    //                             fontSize: 14,
                    //                             color: Colors.blue.shade900,
                    //                             fontWeight: FontWeight.bold),
                    //                       ),
                    //                       Text(''),
                    //                     ],
                    //                   )),
                    //                   width:
                    //                       MediaQuery.of(context).size.width * 0.2,
                    //                 ),
                    //                 SizedBox(
                    //                   width:
                    //                       MediaQuery.of(context).size.width * 0.1,
                    //                 ),
                    //                 SizedBox(
                    //                   width:
                    //                       MediaQuery.of(context).size.width * 0.7,
                    //                   child: Column(
                    //                     children: [
                    //                       SizedBox(
                    //                         height:
                    //                             MediaQuery.of(context).size.height *
                    //                                 0.2,
                    //                         child: ListView.builder(
                    //                             itemCount: saturdayArray.length,
                    //                             itemBuilder: (BuildContext context,
                    //                                 int index) {
                    //                               return SingleChildScrollView(
                    //                                 scrollDirection:
                    //                                     Axis.horizontal,
                    //                                 child: Row(
                    //                                   children: [
                    //                                     Column(
                    //                                       children: [
                    //                                         Text(
                    //                                           saturdayArray.elementAt(
                    //                                                       index)[
                    //                                                   'slot'] +
                    //                                               ' : ',
                    //                                           style: TextStyle(
                    //                                               fontWeight:
                    //                                                   FontWeight
                    //                                                       .bold),
                    //                                         ),
                    //                                         Text('')
                    //                                       ],
                    //                                     ),
                    //                                     Column(
                    //                                       children: [
                    //                                         Align(
                    //                                           alignment: Alignment
                    //                                               .centerLeft,
                    //                                           child: Text(
                    //                                             saturdayArray
                    //                                                     .elementAt(
                    //                                                         index)[
                    //                                                 'courseName'],
                    //                                             style: TextStyle(),
                    //                                           ),
                    //                                         ),
                    //                                         Align(
                    //                                           alignment: Alignment
                    //                                               .bottomLeft,
                    //                                           child: Text(
                    //                                             saturdayArray
                    //                                                     .elementAt(
                    //                                                         index)[
                    //                                                 'courseCode'],
                    //                                             style: TextStyle(
                    //                                                 color: Colors
                    //                                                     .grey),
                    //                                           ),
                    //                                         ),
                    //                                       ],
                    //                                     ),
                    //                                     Column(
                    //                                       children: [
                    //                                         Text(
                    //                                             ' @ ' +
                    //                                                 saturdayArray
                    //                                                         .elementAt(
                    //                                                             index)[
                    //                                                     'location'],
                    //                                             style: TextStyle(
                    //                                                 fontWeight:
                    //                                                     FontWeight
                    //                                                         .bold)),
                    //                                         Text('')
                    //                                       ],
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               );
                    //                             }),
                    //                       ),
                    //                       Divider(
                    //                         color: Colors.grey,
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         if (saturdayArray.length > 0)
                    //           Divider(
                    //             color: Colors.blue.shade900,
                    //           ),
                    //         if (sundayArray.length > 0)
                    //           SizedBox(
                    //             child: Row(
                    //               children: [
                    //                 Container(
                    //                   child: Center(
                    //                       child: Column(
                    //                     children: [
                    //                       Text(
                    //                         'Sunday',
                    //                         style: TextStyle(
                    //                             fontSize: 14,
                    //                             color: Colors.blue.shade900,
                    //                             fontWeight: FontWeight.bold),
                    //                       ),
                    //                       Text(''),
                    //                     ],
                    //                   )),
                    //                   width:
                    //                       MediaQuery.of(context).size.width * 0.2,
                    //                 ),
                    //                 SizedBox(
                    //                   width:
                    //                       MediaQuery.of(context).size.width * 0.1,
                    //                 ),
                    //                 SizedBox(
                    //                   width:
                    //                       MediaQuery.of(context).size.width * 0.7,
                    //                   child: Column(
                    //                     children: [
                    //                       SizedBox(
                    //                         height:
                    //                             MediaQuery.of(context).size.height *
                    //                                 0.2,
                    //                         child: ListView.builder(
                    //                             itemCount: sundayArray.length,
                    //                             itemBuilder: (BuildContext context,
                    //                                 int index) {
                    //                               return SingleChildScrollView(
                    //                                 scrollDirection:
                    //                                     Axis.horizontal,
                    //                                 child: Row(
                    //                                   children: [
                    //                                     Column(
                    //                                       children: [
                    //                                         Text(
                    //                                           sundayArray.elementAt(
                    //                                                       index)[
                    //                                                   'slot'] +
                    //                                               ' : ',
                    //                                           style: TextStyle(
                    //                                               fontWeight:
                    //                                                   FontWeight
                    //                                                       .bold),
                    //                                         ),
                    //                                         Text('')
                    //                                       ],
                    //                                     ),
                    //                                     Column(
                    //                                       children: [
                    //                                         Align(
                    //                                           alignment: Alignment
                    //                                               .centerLeft,
                    //                                           child: Text(
                    //                                             sundayArray
                    //                                                     .elementAt(
                    //                                                         index)[
                    //                                                 'courseName'],
                    //                                             style: TextStyle(),
                    //                                           ),
                    //                                         ),
                    //                                         Align(
                    //                                           alignment: Alignment
                    //                                               .bottomLeft,
                    //                                           child: Text(
                                                                // sundayArray
                                                                //         .elementAt(
                                                                //             index)[
                                                                //     'courseCode'],
                    //                                             style: TextStyle(
                    //                                                 color: Colors
                    //                                                     .grey),
                    //                                           ),
                    //                                         ),
                    //                                       ],
                    //                                     ),
                    //                                     Column(
                    //                                       children: [
                    //                                         Text(
                    //                                             ' @ ' +
                    //                                                 sundayArray.elementAt(
                    //                                                         index)[
                    //                                                     'location'],
                    //                                             style: TextStyle(
                    //                                                 fontWeight:
                    //                                                     FontWeight
                    //                                                         .bold)),
                    //                                         Text('')
                    //                                       ],
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               );
                    //                             }),
                    //                       ),
                    //                       Divider(
                    //                         color: Colors.grey,
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         if (sundayArray.length > 0)
                    //           Divider(
                    //             color: Colors.blue.shade900,
                    //           ),
                    //         if (mondayArray.length > 0)
                    //           SizedBox(
                    //             child: Row(
                    //               children: [
                    //                 Container(
                    //                   child: Align(
                    //                       alignment: Alignment.topCenter,
                    //                       child: Column(
                    //                         children: [
                    //                           Text(
                    //                             'Monday',
                    //                             style: TextStyle(
                    //                                 fontSize: 14,
                    //                                 color: Colors.blue.shade900,
                    //                                 fontWeight: FontWeight.bold),
                    //                           ),
                    //                           Text(''),
                    //                         ],
                    //                       )),
                    //                   width:
                    //                       MediaQuery.of(context).size.width * 0.2,
                    //                 ),
                    //                 SizedBox(
                    //                   width:
                    //                       MediaQuery.of(context).size.width * 0.1,
                    //                 ),
                    //                 SizedBox(
                    //                   width:
                    //                       MediaQuery.of(context).size.width * 0.7,
                    //                   child: Column(
                    //                     children: [
                    //                       //Text('Monday', style: TextStyle(fontSize: 22, color: Colors.grey),),
                    //                       SizedBox(
                    //                         height:
                    //                             MediaQuery.of(context).size.height *
                    //                                 0.2,
                    //                         // child: Card(
                    //                         //   shape: RoundedRectangleBorder(
                    //                         //       borderRadius: BorderRadius.circular(5)),
                    //                         child: ListView.builder(
                    //                             itemCount: mondayArray.length,
                    //                             itemBuilder: (BuildContext context,
                    //                                 int index) {
                    //                               return SingleChildScrollView(
                    //                                 scrollDirection:
                    //                                     Axis.horizontal,
                    //                                 child: Row(
                    //                                   children: [
                    //                                     Column(
                    //                                       children: [
                    //                                         Text(
                    //                                           mondayArray.elementAt(
                    //                                                       index)[
                    //                                                   'slot'] +
                    //                                               ' : ',
                    //                                           style: TextStyle(
                    //                                               fontWeight:
                    //                                                   FontWeight
                    //                                                       .bold),
                    //                                         ),
                    //                                         Text('')
                    //                                       ],
                    //                                     ),
                    //                                     Column(
                    //                                       children: [
                    //                                         Align(
                    //                                           alignment: Alignment
                    //                                               .centerLeft,
                    //                                           child: Text(
                    //                                             mondayArray
                    //                                                     .elementAt(
                    //                                                         index)[
                    //                                                 'courseName'],
                    //                                             style: TextStyle(),
                    //                                           ),
                    //                                         ),
                    //                                         Align(
                    //                                           alignment: Alignment
                    //                                               .bottomLeft,
                    //                                           child: Text(
                    //                                             mondayArray
                    //                                                     .elementAt(
                    //                                                         index)[
                    //                                                 'courseCode'],
                    //                                             style: TextStyle(
                    //                                                 color: Colors
                    //                                                     .grey),
                    //                                           ),
                    //                                         ),
                    //                                       ],
                    //                                     ),
                    //                                     Column(
                    //                                       children: [
                    //                                         Text(
                    //                                             ' @ ' +
                    //                                                 mondayArray.elementAt(
                    //                                                         index)[
                    //                                                     'location'],
                    //                                             style: TextStyle(
                    //                                                 fontWeight:
                    //                                                     FontWeight
                    //                                                         .bold)),
                    //                                         Text('')
                    //                                       ],
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               );

                    //                               //);
                    //                             }),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         if (mondayArray.length > 0)
                    //           Divider(
                    //             color: Colors.blue.shade900,
                    //           ),
                    //         if (tuesdayArray.length > 0)
                    //           SizedBox(
                    //             child: Row(
                    //               children: [
                    //                 Container(
                    //                   child: Center(
                    //                       child: Column(
                    //                     children: [
                    //                       Text(
                    //                         'Tuesday',
                    //                         style: TextStyle(
                    //                             fontSize: 14,
                    //                             color: Colors.blue.shade900,
                    //                             fontWeight: FontWeight.bold),
                    //                       ),
                    //                       Text(''),
                    //                     ],
                    //                   )),
                    //                   width:
                    //                       MediaQuery.of(context).size.width * 0.2,
                    //                 ),
                    //                 SizedBox(
                    //                   width:
                    //                       MediaQuery.of(context).size.width * 0.1,
                    //                 ),
                    //                 SizedBox(
                    //                   width:
                    //                       MediaQuery.of(context).size.width * 0.7,
                    //                   child: Column(
                    //                     children: [
                    //                       SizedBox(
                    //                         height:
                    //                             MediaQuery.of(context).size.height *
                    //                                 0.2,
                    //                         child: ListView.builder(
                    //                             itemCount: tuesdayArray.length,
                    //                             itemBuilder: (BuildContext context,
                    //                                 int index) {
                    //                               return SingleChildScrollView(
                    //                                 scrollDirection:
                    //                                     Axis.horizontal,
                    //                                 child: Row(
                    //                                   children: [
                    //                                     Column(
                    //                                       children: [
                    //                                         Text(
                    //                                           tuesdayArray.elementAt(
                    //                                                       index)[
                    //                                                   'slot'] +
                    //                                               ' : ',
                    //                                           style: TextStyle(
                    //                                               fontWeight:
                    //                                                   FontWeight
                    //                                                       .bold),
                    //                                         ),
                    //                                         Text('')
                    //                                       ],
                    //                                     ),
                    //                                     Column(
                    //                                       children: [
                    //                                         Align(
                    //                                           alignment: Alignment
                    //                                               .centerLeft,
                    //                                           child: Text(
                    //                                             tuesdayArray
                    //                                                     .elementAt(
                    //                                                         index)[
                    //                                                 'courseName'],
                    //                                             style: TextStyle(),
                    //                                           ),
                    //                                         ),
                    //                                         Align(
                    //                                           alignment: Alignment
                    //                                               .bottomLeft,
                    //                                           child: Text(
                    //                                             tuesdayArray
                    //                                                     .elementAt(
                    //                                                         index)[
                    //                                                 'courseCode'],
                    //                                             style: TextStyle(
                    //                                                 color: Colors
                    //                                                     .grey),
                    //                                           ),
                    //                                         ),
                    //                                       ],
                    //                                     ),
                    //                                     Column(
                    //                                       children: [
                    //                                         Text(
                    //                                             ' @ ' +
                    //                                                 tuesdayArray
                    //                                                         .elementAt(
                    //                                                             index)[
                    //                                                     'location'],
                    //                                             style: TextStyle(
                    //                                                 fontWeight:
                    //                                                     FontWeight
                    //                                                         .bold)),
                    //                                         Text('')
                    //                                       ],
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               );
                    //                             }),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         if (tuesdayArray.length > 0)
                    //           Divider(
                    //             color: Colors.blue.shade900,
                    //           ),
                    
                    // SizedBox(
                    //   child:
                    //   Row(
                    //     children: [
                    //       Container(
                    //         child: Center(
                    //             child: Column(
                    //           children: [
                    //             Text(
                    //               'Wednesday',
                    //               style: TextStyle(
                    //                   fontSize: 14,
                    //                   color: Colors.blue.shade900,
                    //                   fontWeight: FontWeight.bold),
                    //             ),
                    //             Text(''),
                    //           ],
                    //         )),
                    //         width: MediaQuery.of(context).size.width * 0.2,
                    //       ),
                    //       SizedBox(
                    //         width: MediaQuery.of(context).size.width * 0.1,
                    //       ),
                    //       SizedBox(
                    //         width: MediaQuery.of(context).size.width * 0.7,
                    //         child: Column(
                    //           children: [
                    //             SizedBox(
                    //               height: MediaQuery.of(context).size.height *
                    //                   0.2,
                    //               child: ListView.builder(
                    //                   itemCount: wednesdayArray.length,
                    //                   itemBuilder:
                    //                       (BuildContext context, int index) {
                    //                     return Card(
                    //                       child: Column(
                    //                         children: [
                    //                           Text("1st:"),
                    //                           Text("2nd:"),
                    //                           Text("3rd:"),
                    //                           Text("4th:"),
                    //                           Text("5th:"),
                    //                         ],
                    //                       ) ,
                    //                     );
                    //                   }),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    //         if (wednesdayArray.length > 0)
                    //           Divider(
                    //             color: Colors.blue.shade900,
                    //           ),
                    //         if (thursdayArray.length > 0)
                    //           SizedBox(
                    //             child: Row(
                    //               children: [
                    //                 Container(
                    //                   child: Align(
                    //                       alignment: Alignment.topCenter,
                    //                       child: Column(
                    //                         children: [
                    //                           Text(
                    //                             'Thursday',
                    //                             style: TextStyle(
                    //                                 fontSize: 14,
                    //                                 color: Colors.blue.shade900,
                    //                                 fontWeight: FontWeight.bold),
                    //                           ),
                    //                         ],
                    //                       )),
                    //                   width:
                    //                       MediaQuery.of(context).size.width * 0.2,
                    //                 ),
                    //                 SizedBox(
                    //                   width:
                    //                       MediaQuery.of(context).size.width * 0.1,
                    //                 ),
                    //                 SizedBox(
                    //                   width:
                    //                       MediaQuery.of(context).size.width * 0.7,
                    //                   child: Column(
                    //                     children: [
                    //                       SizedBox(
                    //                         height:
                    //                             MediaQuery.of(context).size.height *
                    //                                 0.2,
                    //                         child: ListView.builder(
                    //                             itemCount: thursdayArray.length,
                    //                             itemBuilder: (BuildContext context,
                    //                                 int index) {
                    //                               return SingleChildScrollView(
                    //                                 scrollDirection:
                    //                                     Axis.horizontal,
                    //                                 child: Row(
                    //                                   children: [
                    //                                     Column(
                    //                                       children: [
                    //                                         Text(
                    //                                           thursdayArray.elementAt(
                    //                                                       index)[
                    //                                                   'slot'] +
                    //                                               ' : ',
                    //                                           style: TextStyle(
                    //                                               fontWeight:
                    //                                                   FontWeight
                    //                                                       .bold),
                    //                                         ),
                    //                                         Text('')
                    //                                       ],
                    //                                     ),
                    //                                     Column(
                    //                                       children: [
                    //                                         Align(
                    //                                           alignment: Alignment
                    //                                               .centerLeft,
                    //                                           child: Text(
                    //                                             thursdayArray
                    //                                                     .elementAt(
                    //                                                         index)[
                    //                                                 'courseName'],
                    //                                             style: TextStyle(),
                    //                                           ),
                    //                                         ),
                    //                                         Align(
                    //                                           alignment: Alignment
                    //                                               .bottomLeft,
                    //                                           child: Text(
                    //                                             thursdayArray
                    //                                                     .elementAt(
                    //                                                         index)[
                    //                                                 'courseCode'],
                    //                                             style: TextStyle(
                    //                                                 color: Colors
                    //                                                     .grey),
                    //                                           ),
                    //                                         ),
                    //                                       ],
                    //                                     ),
                    //                                     Column(
                    //                                       children: [
                    //                                         Text(
                    //                                             ' @ ' +
                    //                                                 thursdayArray
                    //                                                         .elementAt(
                    //                                                             index)[
                    //                                                     'location'],
                    //                                             style: TextStyle(
                    //                                                 fontWeight:
                    //                                                     FontWeight
                    //                                                         .bold)),
                    //                                         Text('')
                    //                                       ],
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               );
                    //                             }),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         if (thursdayArray.length > 0)
                    //           Divider(
                    //             color: Colors.blue.shade900,
                    //           ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // // Container(
                    // //     child: ElevatedButton(
                    // //   child: Text('Logout'),
                    // //   onPressed: logOut,
                    // // )),
                    //  TimetableExample(),
                  ],
                ),
              ),
            ),
          );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_complete_guide/screens/calender_screen.dart';
import 'package:flutter_complete_guide/screens/edit_student_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

var currentUserEmail = FirebaseAuth.instance.currentUser.email;

final userRef = Firestore.instance.collection('users');
final currentUserID = FirebaseAuth.instance.currentUser.uid;

class StudentHomeScreen extends StatefulWidget {
  static const routeName = '/student-home';

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FlutterLocalNotificationsPlugin flutterNotificationPlugin;
  final coursesRef = Firestore.instance.collection('courses');
  var myCourses = [];
  var reminders = [];
  var upcomingAssessmentTimings = [];
  var announcements = [];
  var firstName = '';
  var lastName = '';
  var email = '';
  var gucID = '';
  var lectureGroup = '';
  var major = '';
  var role = '';
  var userID = '';
  final usersRef = Firestore.instance.collection('users');
  var allCourses = [];
  var refresh = true;
  var myCoursesNames = [];
  Future notificationDefaultSound() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Notification Channel ID',
      'Channel Name',
      'Description',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    int i = 1;
    for (var assessment in upcomingAssessmentTimings) {
      DateTime dateSchedule = assessment['dateTimeAssessment'];
      dateSchedule = dateSchedule.subtract(Duration(hours: 1));
      var diff = dateSchedule.difference(DateTime.now());
      var splitted = diff.toString().split(":");
      print(diff);
      int hour = int.parse(splitted[0]);
      int min = int.parse(splitted[1]);
      print(hour);
      print(min);
      await flutterLocalNotificationsPlugin.zonedSchedule(
        i,
        assessment['courseName'],
        i.toString(),
        tz.TZDateTime.now(tz.local).add(Duration(seconds: 1)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
          'Notification Channel ID',
          'Channel Name',
          'Description',
        )),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      i++;
    }
  }

  // Future onSelectNotification(String payload) async {
  //   showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //            // title: Text("REMINDER", style: TextStyle(fontWeight: FontWeight.bold ),),
  //             content: Text("$payload", style: TextStyle(color: Colors.red),),
  //           ));
  // }

  getStudentData() async {
    var group = '0';
    usersRef.getDocuments().then((value) {
      value.documents.forEach((element) {
        var data = element.data();
        if (data['userID'] == FirebaseAuth.instance.currentUser.uid) {
          group = data['lectureGroup'];
          setState(() {
            email = data['email'];
            firstName = data['firstName'];
            lastName = data['lastName'];
            gucID = data['gucID'];
            lectureGroup = data['lectureGroup'];
            major = data['major'];
            role = data['role'];
            userID = data['userID'];
          });
        }
      });
    });
    await Firestore.instance.collection('courses').getDocuments().then((value) {
      value.documents.forEach((element) {
        var data = element.data();
        if (data['enrolledStudents'].contains(currentUserID)) {
          FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
          var name = data['courseName'].toString();
          var nameSpace = name.replaceAll(' ', '');
          firebaseMessaging.subscribeToTopic(nameSpace);
          setState(() {
            myCoursesNames.add(name);
          });
          name = name + group;
          nameSpace = name.replaceAll(' ', '');
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
          setState(() {
            myCourses.add(course);
          });
          firebaseMessaging.subscribeToTopic(nameSpace);
          print(nameSpace);
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
                reminders.add({
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
    print(upcomingAssessmentTimings.toString());
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Notification Channel ID',
      'Channel Name',
      'Description',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    int i = 1;
    for (var assessment in upcomingAssessmentTimings) {
      DateTime dateSchedule = assessment['dateTimeAssessment'];
      dateSchedule = dateSchedule.subtract(Duration(hours: 1));
      var diff = dateSchedule.difference(DateTime.now());
      var splitted = diff.toString().split(":");
      print(diff);
      int hour = int.parse(splitted[0]);
      int min = int.parse(splitted[1]);
      print(hour);
      print(min);
      var body = "";
      if (assessment['assessment']['assessmentType'] == 'Assignment' ||
          assessment['assessment']['assessmentType'] == 'Project') {
        body = assessment['courseName'] +
            " : " +
            assessment['assessment']['assessmentName'] +
            " deadline " +
            " @ " +
            assessment['assessment']['time'];
      } else {
        body = assessment['courseName'] +
            " : " +
            assessment['assessment']['assessmentName'] +
            " @ " +
            assessment['assessment']['time'];
      }
      if (assessment['remainingHours'] != 0) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
            i,
            'REMINDER',
            body,
            tz.TZDateTime.now(tz.local)
                .add(Duration(hours: hour, minutes: min)),
            const NotificationDetails(
                android: AndroidNotificationDetails(
              'Notification Channel ID',
              'Channel Name',
              'Description',
            )),
            androidAllowWhileIdle: true,
            payload: body,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);
      }
      i++;
    }
  }

  logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tz.initializeTimeZones();
    getStudentData();
    viewAllCourses();
    getAnnouncements();

    // var initializationSettingsAndroid =
    //     new AndroidInitializationSettings('@mipmap/ic_launcher');
    // var initializationSettingsIOS = new IOSInitializationSettings();
    // var initializationSettings = new InitializationSettings(
    //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    // flutterNotificationPlugin = FlutterLocalNotificationsPlugin();

    // flutterNotificationPlugin.initialize(initializationSettings,
    //     onSelectNotification: onSelectNotification);
    notificationDefaultSound();
    // flutterLocalNotificationsPlugin.zonedSchedule(
    //       0,
    //       'scheduled title',
    //       'Test',
    //       tz.TZDateTime.now(tz.local).add(Duration(seconds: 2)),
    //       const NotificationDetails(
    //           android: AndroidNotificationDetails(
    //         'Notification Channel ID',
    //         'Channel Name',
    //         'Description',
    //       )),
    //       androidAllowWhileIdle: true,
    //       uiLocalNotificationDateInterpretation:
    //           UILocalNotificationDateInterpretation.absoluteTime);
  }

  Function viewAllCourses() {
    coursesRef.getDocuments().then((value) {
      value.documents.forEach((element) {
        var data = element.data();
        setState(() {
          allCourses.add({
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
      });
    });
  }

  getAnnouncements() {
    Firestore.instance.collection('announcements').getDocuments().then((value) {
      value.documents.forEach((element) {
        var announcement = element.data();
        if (myCoursesNames.contains(announcement['courseName']) && (announcement['group']==lectureGroup ||announcement['group']=='All Groups' )) {
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

  @override
  Widget build(BuildContext context) {
    return !refresh
        ? CircleBorder()
        : Scaffold(
            appBar: AppBar(title: Text('Student Home'), actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CalendarScreen(upcomingAssessmentTimings),
                          ));
                    },
                    icon: Icon(
                      Icons.calendar_month,
                      size: 30,
                      color: Colors.white,
                    )),
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
                         var flagPop= await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditStudentScreen(),
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
              ],),
            body: Column(children: <Widget>[
               SizedBox(
                  height: 10,
                ),
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
                    style: TextStyle(
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
                  Spacer(),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: ListView.builder(
                    itemCount: upcomingAssessmentTimings.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {},
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      upcomingAssessmentTimings
                                              .elementAt(index)['courseName'] +
                                          " - " +
                                          upcomingAssessmentTimings.elementAt(
                                              index)['courseCode'], // "  " +
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              if (upcomingAssessmentTimings
                                                .elementAt(index)['assessment']
                                            ['assessmentType'] ==
                                        'Project' ||
                                    upcomingAssessmentTimings
                                                .elementAt(index)['assessment']
                                            ['assessmentType'] ==
                                        'Assignment')
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          upcomingAssessmentTimings.elementAt(
                                                  index)['assessment']
                                              ['assessmentName'],
                                          style: TextStyle(
                                              color: Colors.blue.shade900))),
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
                                              upcomingAssessmentTimings.elementAt(
                                                  index)['assessment']['day'] +
                                              ' @ ' +
                                              upcomingAssessmentTimings.elementAt(
                                                  index)['assessment']['time'],
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold))),
                                if (upcomingAssessmentTimings
                                                .elementAt(index)['assessment']
                                            ['assessmentType'] ==
                                        'Midterm' ||
                                    upcomingAssessmentTimings
                                                .elementAt(index)['assessment']
                                            ['assessmentType'] ==
                                        'Final')
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          upcomingAssessmentTimings.elementAt(
                                                  index)['assessment']
                                              ['assessmentType'],
                                          style: TextStyle(
                                              color: Colors.blue.shade900))),
                                if (upcomingAssessmentTimings
                                                .elementAt(index)['assessment']
                                            ['assessmentType'] ==
                                        'Midterm' ||
                                    upcomingAssessmentTimings
                                                .elementAt(index)['assessment']
                                            ['assessmentType'] ==
                                        'Final')
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        'Exam Date: ' +
                                            upcomingAssessmentTimings.elementAt(
                                                index)['assessment']['day'] +
                                            ' @ ' +
                                            upcomingAssessmentTimings.elementAt(
                                                index)['assessment']['time'],
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
                                      style: TextStyle(
                                          color: Colors.blue.shade900),
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
                                            upcomingAssessmentTimings.elementAt(
                                                index)['assessment']['day'] +
                                            ' @ ' +
                                            upcomingAssessmentTimings.elementAt(
                                                index)['assessment']['time'],
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
             // Divider(thickness: 1, color: Colors.blue.shade900,),
              Row(
                children: [
                  Align(
                      // alignment: Alignment.centerLeft,
                      child: Icon(
                    Icons.announcement_rounded,
                    size: 30,
                    color: Colors.red.shade900,
                  )),
                  SizedBox(width: 10),
                  Text(
                    'Announcements',
                    style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900),
                  ),
              //    Spacer(),
                ],
              ),
              
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: ListView.builder(
                    itemCount: announcements.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SingleChildScrollView(
                        child: Dismissible(
                          onDismissed: (direction) {
                            setState(() {
                              announcements.removeAt(index);
                            });
                            ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Announcement '+ (index+1).toString() +' dismissed')));
                          },
                          key: UniqueKey(),
                          background: Container(color: Colors.red),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 5),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                               announcements.elementAt(index)['courseName']  + " - "+announcements.elementAt(index)['title'],
                                  style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      announcements.elementAt(index)['body'], 
                                      style: TextStyle(fontWeight: FontWeight.bold ,color: Colors.blue.shade900),)),
                              Divider(color: Colors.blue.shade900,),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              //ElevatedButton(child: Text('Logout'), onPressed: logOut),
            ]),
          );
  }
}

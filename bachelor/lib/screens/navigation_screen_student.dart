import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


import './edit_student_screen.dart';
import './student_courses_screen.dart';
import './student_home_screen.dart';

class NavigationScreenStudent extends StatefulWidget {
  @override
  State<NavigationScreenStudent> createState() =>
      _NavigationScreenStudentState();
}

class _NavigationScreenStudentState extends State<NavigationScreenStudent> {
  FlutterLocalNotificationsPlugin flutterNotificationPlugin;
  final usersRef = Firestore.instance.collection('users');
  var email = '';
  var firstName = '';
  var lastName = '';
  var major = '';
  var gucID = '';
  var lectureGroup = '';
  var role = "";
  var userID = "";
  int _selectedIndex = 0;
  var pages = [
    StudentHomeScreen(),
    StudentCoursesScreen(),
    //EditStudentScreen()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Function getStudentData() {
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
            major = data['major'];
            gucID = data['gucID'];
            lectureGroup = data['lectureGroup'];
          });
        }
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudentData();
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterNotificationPlugin = FlutterLocalNotificationsPlugin();

    flutterNotificationPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);
  }
  Future notificationDefaultSound() async{
    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'Notification Channel ID',
      'Channel Name',
      'Description',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails();
    var platformChannelSpecifics =
    NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics
    );
    flutterNotificationPlugin.show(
        0,
        'New Alert',
        'How to show Local Notification',
        platformChannelSpecifics,
        payload: 'Default Sound'
    );
  }
  Future onSelectNotification(String payload) async{
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
              "REMINDER", style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
              "$payload", 
              style: TextStyle(color: Colors.red),
          ),
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 8,
       // backgroundColor: Colors.red,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.blue.shade700,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_align_justify), label: 'View My Courses'),
          
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

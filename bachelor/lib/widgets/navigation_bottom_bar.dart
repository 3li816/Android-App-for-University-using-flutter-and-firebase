import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/create_announcement_screen.dart';
import 'package:flutter_complete_guide/screens/edit_instructor_screen.dart';
import 'package:flutter_complete_guide/screens/instructor_courses_screen.dart';
import '/screens/instructor_home_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NavigationBottomBar extends StatefulWidget {
  static const routeName = '/navigatorBottomBar-instructor';
  // int selectedIndex;
  // NavigationBottomBar(this.selectedIndex);
  @override
  State<NavigationBottomBar> createState() => _NavigationBottomBarState();
}

class _NavigationBottomBarState extends State<NavigationBottomBar> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final usersRef = Firestore.instance.collection('users');
  var email = '';
  var firstName = '';
  var lastName = '';
  var role = "";
  var userID = "";
  // var editInstructorscreen =
  //     EditInstructorScreen(firstName, lastName, email, role, userID);

  Function getInstructorData() {
    usersRef.getDocuments().then((value) {
      value.documents.forEach((element) {
        var data = element.data();
        if (data['userID'] == FirebaseAuth.instance.currentUser.uid) {
          // print(data['email']);
          // print(data['firstName']);
          // print(data['lastName']);
          // print(data['role']);

          setState(() {
            email = data['email'];
//            print(email + " test");
            firstName = data['firstName'];
            lastName = data['lastName'];
            role = data['role'];
            userID = data['userID'];
          });
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInstructorData();
  }


  var pages = [
    InstructorHomeScreen(),
    InstructorCoursesScreen(),
    CreateAnnuncementScreen(""),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.blue.shade900,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 8,
        // backgroundColor: Colors.red,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_align_justify),
            label: 'View My Courses',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add),
            label: 'Create Announcement',
            backgroundColor: Colors.white,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

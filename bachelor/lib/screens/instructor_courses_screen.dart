import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './course_screen.dart';
import './new_course_screen.dart';
import 'package:badges/badges.dart';
import 'package:google_fonts/google_fonts.dart';

class InstructorCoursesScreen extends StatefulWidget {
  @override
  State<InstructorCoursesScreen> createState() =>
      _InstructorCoursesScreenState();
}

class _InstructorCoursesScreenState extends State<InstructorCoursesScreen> {
  var myCourses = [];
  var newQuestionsArray = [];
  var myAssessment = [];
  var role;
  var email = '';
  var firstName = '';
  var lastName = '';
  final usersRef = Firestore.instance.collection('users');
  var userID;
  var flagDoneCourses = false;
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
            firstName = data['firstName'];
            lastName = data['lastName'];
            role = data['role'];
            userID = data['userID'];
          });
        }
      });
    });
    // setState(() {
    //   flagDoneCourses = true;
    // });
  }

  viewMyCourses() async {
    var name = "";
    var documentID = "";
    var newQuestions = 0;
    await Firestore.instance.collection('courses').getDocuments().then((value) {
      value.documents.forEach((element) {
        var data = element.data();
        if (data['courseOwnerId'] == FirebaseAuth.instance.currentUser.uid) {
          //print(data['courseName']);
          setState(() {
            name = data['courseName'];
            documentID = data['documentID'];
          });
          setState(() {
            myCourses.add({
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
              //'newQuestions': newQuestions,
            });
            newQuestionsArray.add(0);
          });

          myAssessment.add({
            'courseName': data['courseName'],
            'courseCode': data['courseCode'],
            'assessments': data['assessments'],
          });
        }
      });
    });
    for (int i = 0; i < myCourses.length; i++) {
      var course = myCourses[i];
      await Firestore.instance.collection('discussions').getDocuments().then((value) {
        value.documents.forEach((element) {
          var question = element.data();
          if (question['courseName'] == course['courseName'] && question['courseDocumentID'] == course['documentID']&&question['answered'] ==false) {
            setState(() {
              newQuestions++;
            });
            print(newQuestions);
          }
        });
      });
      setState(() {
        newQuestionsArray[i] = newQuestions;
        newQuestions = 0;
      });
    }
    setState(() {
      flagDoneCourses = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInstructorData();
    viewMyCourses();
    // print(myAssessment);
  }

  @override
  Widget build(BuildContext context) {
    return !flagDoneCourses
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.blue.shade900,
            ),
          )
        : Scaffold(
            appBar: AppBar(title: Text('My Courses')),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                print(newQuestionsArray.toString());
                var newCourses;
                newCourses = await Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new NewCourseScreen(myCourses)));
                // print("new Courses");
                // print(newCourses);
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
            body: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView.builder(
                      itemCount: myCourses.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () async {
                              var myCoursesAfterDelete;
                              myCoursesAfterDelete = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CourseScreen(
                                      myCourses.elementAt(index)['courseName'],
                                      myCourses.elementAt(index)['courseCode'],
                                      myCourses.elementAt(index)['creditHours'],
                                      myCourses
                                          .elementAt(index)['numberOfGroups'],
                                      myCourses.elementAt(
                                          index)['lecturesFrequency'],
                                      myCourses.elementAt(index)['timings'],
                                      myCourses.elementAt(index)['assessments'],
                                      myCourses
                                          .elementAt(index)['courseOwnerId'],
                                      myCourses.elementAt(index)['documentID'],
                                      myCourses
                                          .elementAt(index)['enrolledStudents'],
                                      userID,
                                      role,
                                      myCourses,
                                      myCourses.elementAt(index)['major'],
                                      myCourses.elementAt(index)['semester'],
                                    ),
                                  ));

                              if (myCoursesAfterDelete != null) {
                                setState(() {
                                  myCourses = myCoursesAfterDelete;
                                });
                              }
                            },     
                            child: SingleChildScrollView(child: 
                            Column(
                              children: [
                                SizedBox(height: 15,),
                                Center(child: Card(
                                  shape: RoundedRectangleBorder(
                                    side:  BorderSide(color: Colors.blue.shade900, 
                                    ), 
                                    borderRadius: const BorderRadius.all(Radius.circular(12))
                                    ),
                                  elevation: 0,
                                  color: Colors.lightBlue.shade100,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height*0.1,
                                    child: Column(children: [
                                      SizedBox(height: 5,),
                                          Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            SizedBox(width: 10,),
                                            Text(
                                              myCourses.elementAt(index)['courseName'],
                                               style:  GoogleFonts.merriweather( fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              // TextStyle(
                                              //   fontFamily: GoogleFonts().,
                                                  // fontSize: 18,
                                                  // fontWeight: FontWeight.bold
                                              // ),
                                            ),
                                            Spacer(),
                                              Badge(
                                                  child: Icon(Icons.notifications, size: 30,),
                                                  badgeContent: Text(newQuestionsArray
                                                  .elementAt(index)
                                                  .toString(),),
                                                ),
                                               // Spacer(),
                                                SizedBox(width: 15,),
                                          ],
                                        )),
                                        SizedBox(height: 5,),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            SizedBox(width: 10,),
                                            Text(
                                              myCourses.elementAt(index)['courseCode'],
                                              style: GoogleFonts.openSans( fontSize: 16,
                                                  fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                                              //TextStyle(
                                              //     fontSize: 16, color: Colors.white, ),
                                            ),
                                          ],
                                        )),
                                    // Align(
                                    //     alignment: Alignment.centerLeft,
                                    //     child: Row(
                                    //       children: [
                                    //         SizedBox(width: 10,),
                                    //         Text(
                                    //           newQuestionsArray
                                    //               .elementAt(index)
                                    //               .toString(),
                                    //           style: TextStyle(
                                    //               fontSize: 18, color: Colors.red),
                                    //         ),
                                    //       ],
                                    //     )),
                                    ],),
                                    ),
                                )),
                                SizedBox(height: 15,)
                              ],
                            )
                            ),                       
                            // child: Column(
                            //   children: [
                                // Align(
                                //     alignment: Alignment.centerLeft,
                                //     child: Text(
                                //       myCourses.elementAt(index)['courseName'],
                                //       style: TextStyle(
                                //           fontSize: 18,
                                //           fontWeight: FontWeight.bold),
                                //     )),
                                // Align(
                                //     alignment: Alignment.centerLeft,
                                //     child: Text(
                                //       myCourses.elementAt(index)['courseCode'],
                                //       style: TextStyle(
                                //           fontSize: 18, color: Colors.grey),
                                //     )),
                                // Align(
                                //     alignment: Alignment.centerLeft,
                                //     child: Text(
                                //       newQuestionsArray
                                //           .elementAt(index)
                                //           .toString(),
                                //       style: TextStyle(
                                //           fontSize: 18, color: Colors.red),
                                //     )),
                            //     Divider(
                            //       color: Colors.grey,
                            //     ),
                            //     SizedBox(
                            //       height: 5,
                            //     )
                            //   ],
                            // )
                             );
                      }),
                ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: IconButton(icon: Icon(Icons.add),),
                // )
              ],
            ),
          );
  }
}

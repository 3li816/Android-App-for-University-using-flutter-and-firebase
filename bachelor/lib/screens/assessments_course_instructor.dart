import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/edit_assessment_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import './create_assessment_screen.dart';
import 'package:empty_widget/empty_widget.dart';

class AssessmentsCourseInstructor extends StatefulWidget {
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
  var major;
  var semester;
  AssessmentsCourseInstructor(
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
      this.major,
      this.semester);

  @override
  State<AssessmentsCourseInstructor> createState() =>
      _AssessmentsCourseInstructorState();
}

class _AssessmentsCourseInstructorState
    extends State<AssessmentsCourseInstructor> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var upcoming = [];
  MyGlobals myGlobals = MyGlobals();
  var sortedAssessments = [];
  var upcomingDone = false;
  var flagZeroAssessments = false;
  var flagErrorDelete = false;
  upcomingAssessments() {
    for (var assessment in widget.assessments) {
      var date = assessment['day'].toString();
      var dateSplitted = date.split("-");
      var day = int.parse(dateSplitted[0]);
      var month = int.parse(dateSplitted[1]);
      var year = int.parse(dateSplitted[2]);
      var hours = 100;
      var minutes = 100;
      DateTime assessmentDate = new DateTime(year, month, day, 18);
      if (assessment['assessmentType'] == 'Project' ||
          assessment['assessmentType'] == 'Assignment') {
        var splittedDate = assessment['day'].split('-');
        var date = new DateTime(int.parse(splittedDate[2]),
            int.parse(splittedDate[1]), int.parse(splittedDate[0]));
        var splittedTime = assessment['time'].split(' ');
        var hoursMinutes = splittedTime[0];
        var hoursMinutesSplit = hoursMinutes.split(':');
        hours = int.parse(hoursMinutesSplit[0]);
        minutes = int.parse(hoursMinutesSplit[1]);
        var amPm = splittedTime[1];
        if (amPm == 'PM' && hours != 12) {
          hours += 12;
        }
        if (hours == 100 && minutes == 100) {
          assessmentDate = new DateTime(int.parse(splittedDate[2]),
              int.parse(splittedDate[1]), int.parse(splittedDate[0]), 23, 59);
        } else {
          assessmentDate = new DateTime(
              int.parse(splittedDate[2]),
              int.parse(splittedDate[1]),
              int.parse(splittedDate[0]),
              hours,
              minutes);
        }
        setState(() {
          var assessmentSort = assessment;
          assessment['dateTimeAssessment'] = assessmentDate;
          sortedAssessments.add(assessment);
        });
      }

      if (assessmentDate.isAfter(DateTime.now())) {
        setState(() {
          upcoming.add(assessment);
        });
      }
    }
    if (upcoming.length == 0) {
      setState(() {
        flagZeroAssessments = true;
      });
    }
    setState(() {
      upcomingDone = true;
    });
    for (int i = 0; i < widget.assessments.length - 1; i++) {
      for (int j = 0; j < widget.assessments.length - i - 1; j++) {
        // var dayj = widget.assessments.elementAt(j)['dateTimeAssessment'].toString().split("-");
        //DateTime dt = (map['timestamp'] as Timestamp).toDate();
        var datej =
            (widget.assessments.elementAt(j)['dateTime'] as Timestamp).toDate();
        var datejPlusOne = (widget.assessments.elementAt(j+1)['dateTime'] as Timestamp).toDate();    
        if (datej
            .isBefore(datejPlusOne)) {
          setState(() {
            var temp = widget.assessments[j];
            widget.assessments[j] = widget.assessments.elementAt(j + 1);
            widget.assessments[j + 1] = temp;
          });
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    upcomingAssessments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: myGlobals.scaffoldKey,
      appBar: AppBar(title: Text("Course Assessments")),
      // floatingActionButton: Center(
      //   child: IconButton(
      //     icon: Icon(
      //       Icons.add,
      //       size: 30,
      //       color: Colors.blue,
      //     ),
      //     onPressed: () async {
      //       var newAssessments = await Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => CreateAssessmentScreen(
      //                 widget.courseName,
      //                 widget.courseCode,
      //                 widget.creditHours,
      //                 widget.numberOfGroups,
      //                 widget.lecturesFrequency,
      //                 widget.timings,
      //                 widget.assessments,
      //                 widget.enrolledStudents,
      //                 widget.courseOwnerID,
      //                 widget.documentID,
      //                 widget.userID,
      //                 widget.numberOfGroups,
      //                 widget.major,
      //                 widget.semester),
      //           ));
      //       if (newAssessments != null) {
      //         print("msh fady");
      //         setState(() {
      //           upcoming = newAssessments;
      //         });
      //       }
      //     },
      //   ),
      // ),
      body: !upcomingDone
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (widget.assessments.length == 0
              ? Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              child: EmptyWidget(
                                image: null,
                                packageImage: PackageImage.Image_3,
                                title: 'No Assessments',
                                //subTitle: 'No  questions available yet',
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
                          ),
                          Column(
                            children: [
                              Center(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    size: 45,
                                    color: Colors.blue.shade900,
                                  ),
                                  onPressed: () async {
                                    var newAssessments = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CreateAssessmentScreen(
                                                  widget.courseName,
                                                  widget.courseCode,
                                                  widget.creditHours,
                                                  widget.numberOfGroups,
                                                  widget.lecturesFrequency,
                                                  widget.timings,
                                                  widget.assessments,
                                                  widget.enrolledStudents,
                                                  widget.courseOwnerID,
                                                  widget.documentID,
                                                  widget.userID,
                                                  widget.numberOfGroups,
                                                  widget.major,
                                                  widget.semester),
                                        ));
                                    if (newAssessments != null) {
                                      setState(() {
                                        widget.assessments = newAssessments;
                                        //  for (int i = 0; i < widget.assessments.length - 1; i++) {
                                        //     for (int j = 0; j < widget.assessments.length - i - 1; j++) {
                                        //       // var dayj = widget.assessments.elementAt(j)['dateTimeAssessment'].toString().split("-");
                                        //       if (widget.assessments.elementAt(j)['dateTime'].isBefore(
                                        //           widget.assessments.elementAt(j + 1)['dateTime'])) {
                                        //         setState(() {
                                        //           var temp = widget.assessments[j];
                                        //           widget.assessments[j] = widget.assessments.elementAt(j + 1);
                                        //           widget.assessments[j + 1] = temp;
                                        //         });
                                        //       }
                                        //     }
                                        //   }
                                      });
                                    }
                                  },
                                ),
                              ),
                              // Center(child: Text('Create Assessment', style: TextStyle(color: Colors.blue),)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: ListView.builder(
                                    itemCount: widget.assessments.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Dismissible(
                                        onDismissed: (direction) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Assessment Dismissed')));
                                        },
                                        key:UniqueKey(),
                                        background: Container(color: Colors.red),
                                          child: Column(
                                            children: [
                                              SizedBox(height:15),
                                              Center(
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                    side:  BorderSide(color: Colors.blue.shade900, 
                                    ), 
                                    borderRadius: const BorderRadius.all(Radius.circular(12))
                                    ),
                                  elevation: 0,
                                  color: Colors.lightBlue.shade100,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: 15),
                                                      Column(
                                                        children: [
                                                          SizedBox(height:10),
                                                          Align(
                                                              alignment:
                                                                  Alignment.centerLeft,
                                                              child: Text(
                                                                widget.assessments
                                                                        .elementAt(
                                                                            index)[
                                                                    'assessmentName'],
                                                                style: GoogleFonts.merriweather( fontSize: 18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                //  TextStyle(
                                                                //     fontSize: 18,
                                                                //     fontWeight:
                                                                //         FontWeight
                                                                //             .bold),
                                                              )),
                                                              SizedBox(height:10 ,),
                                                          Align(
                                                              alignment:
                                                                  Alignment.centerLeft,
                                                              child: Text(
                                                                widget.assessments
                                                                    .elementAt(
                                                                        index)['day'],
                                                                style: GoogleFonts.roboto(fontSize: 18,
                                                                    color:Colors.blue.shade900 , fontWeight: FontWeight.bold, ),
                                                                // TextStyle(
                                                                //     fontSize: 18,
                                                                //     color: Colors.grey),
                                                              )),
                                                          
                                                          SizedBox(
                                                            height: 15,
                                                          )
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      Column(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () async {
                                                              var assessmentsEdit = await Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => EditAssessmentScreen(
                                                                          widget.courseName,
                                                                          widget.courseCode,
                                                                          widget.creditHours,
                                                                          widget.numberOfGroups,
                                                                          widget.lecturesFrequency,
                                                                          widget.timings,
                                                                          widget.assessments,
                                                                          widget.enrolledStudents,
                                                                          widget.courseOwnerID,
                                                                          widget.documentID,
                                                                          widget.userID,
                                                                          {
                                                                            'assessmentName': widget
                                                                                .assessments
                                                                                .elementAt(
                                                                                    index)['assessmentName'],
                                                                            'assessmentType': widget
                                                                                .assessments
                                                                                .elementAt(
                                                                                    index)['assessmentType'],
                                                                            'day': widget
                                                                                .assessments
                                                                                .elementAt(
                                                                                    index)['day'],
                                                                            'duration': widget
                                                                                .assessments
                                                                                .elementAt(
                                                                                    index)['duration'],
                                                                            'instructorNotes': widget
                                                                                .assessments
                                                                                .elementAt(
                                                                                    index)['instructorNotes'],
                                                                            'minutesHours': widget
                                                                                .assessments
                                                                                .elementAt(
                                                                                    index)['minutesHours'],
                                                                            'time': widget
                                                                                .assessments
                                                                                .elementAt(
                                                                                    index)['time'],
                                                                          },
                                                                          widget.assessments)));
                                                              if (assessmentsEdit !=
                                                                  null) {
                                                                setState(() {
                                                                  widget.assessments =
                                                                      assessmentsEdit;
                                                                });
                                                              }
                                                            },
                                                            icon: Icon(
                                                              Icons.edit,
                                                              color: Colors.blue.shade900,
                                                            ),
                                                          ),
                                                          SizedBox(height: 15),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () async {
                                                              var newDelete =
                                                                  await showDialog(
                                                                context: context,
                                                                builder: (_) =>
                                                                    AlertDialog(
                                                                  content: Text(
                                                                      'Are you sure you want to delete this assessment?',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red)),
                                                                  actions: [
                                                                    FlatButton(
                                                                        onPressed: () {
                                                                          Navigator.of(
                                                                                  context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            Text('No',style: TextStyle(color: Colors.blue.shade900,fontWeight: FontWeight.bold))),
                                                                    FlatButton(
                                                                        onPressed:
                                                                            () async {
                                                                          print(widget
                                                                              .assessments
                                                                              .length);
                                                                          widget
                                                                              .assessments
                                                                              .remove(upcoming
                                                                                  .elementAt(
                                                                                      index));
                                                                          // if (widget.assessments
                                                                          //         .length ==
                                                                          //     0) {
                                                                          //   widget.assessments = [
                                                                          //     {}
                                                                          //   ];
                                                                          // }
                                                
                                                                          Navigator.of(
                                                                                  context)
                                                                              .pop();
                                                                          try {
                                                                            var newDelete = await FirebaseFirestore
                                                                                .instance
                                                                                .collection(
                                                                                    'courses')
                                                                                .doc(widget
                                                                                    .documentID)
                                                                                .set({
                                                                              'courseName':
                                                                                  widget
                                                                                      .courseName,
                                                                              'courseCode':
                                                                                  widget
                                                                                      .courseCode,
                                                                              'creditHours':
                                                                                  widget
                                                                                      .creditHours,
                                                                              'numberOfGroups':
                                                                                  widget
                                                                                      .numberOfGroups,
                                                                              'lecturesFrequency':
                                                                                  widget
                                                                                      .lecturesFrequency,
                                                                              'major':
                                                                                  widget
                                                                                      .major,
                                                                              'semester':
                                                                                  widget
                                                                                      .semester,
                                                                              'timings':
                                                                                  widget
                                                                                      .timings,
                                                                              'assessments':
                                                                                  widget
                                                                                      .assessments,
                                                                              'enrolledStudents':
                                                                                  widget
                                                                                      .enrolledStudents,
                                                                              'courseOwnerId':
                                                                                  widget
                                                                                      .courseOwnerID,
                                                                              'documentID':
                                                                                  widget
                                                                                      .documentID
                                                                            });
                                                                            setState(
                                                                                () {
                                                                              // upcoming = newDelete;
                                                                            });
                                                                          } catch (error) {
                                                                            print(
                                                                                error);
                                                                            setState(
                                                                                () {
                                                                              flagErrorDelete =
                                                                                  true;
                                                                            });
                                                                          }
                                                                          if (!flagErrorDelete) {
                                                                            showDialog(
                                                                                context: myGlobals
                                                                                    .scaffoldKey
                                                                                    .currentContext,
                                                                                builder: (_) =>
                                                                                    AlertDialog(
                                                                                      content: Text('Assessment Deleted Successfuly'),
                                                                                      actions: [
                                                                                        FlatButton(
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop(widget.assessments);
                                                                                              // Navigator.of(context).pop();
                                                                                            },
                                                                                            child: Text('Dimiss',style: TextStyle(color: Colors.blue.shade900,fontWeight: FontWeight.bold)))
                                                                                      ],
                                                                                    ));
                                                                          }
                                                                        },
                                                                        child: Text(
                                                                            'Yes',style: TextStyle(color: Colors.blue.shade900,fontWeight: FontWeight.bold))),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                            icon: Icon(
                                                              Icons.delete,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20,)
                                            ],
                                          ));
                                    })),

                            // Align(
                            //   alignment: Alignment.bottomCenter,
                            //   child: IconButton(icon: Icon(Icons.add),),
                            // )
                            SizedBox(height: 50,)
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 45,
                              color: Colors.blue.shade900,
                            ),
                            onPressed: () async {
                              var newAssessments = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CreateAssessmentScreen(
                                            widget.courseName,
                                            widget.courseCode,
                                            widget.creditHours,
                                            widget.numberOfGroups,
                                            widget.lecturesFrequency,
                                            widget.timings,
                                            widget.assessments,
                                            widget.enrolledStudents,
                                            widget.courseOwnerID,
                                            widget.documentID,
                                            widget.userID,
                                            widget.numberOfGroups,
                                            widget.major,
                                            widget.semester),
                                  ));
                              if (newAssessments != null) {
                                setState(() {
                                  upcoming = newAssessments;
                                });
                              }
                            },
                          ),
                        ),
                        // Center(child: Text('Create Assessment', style: TextStyle(color: Colors.blue),)),
                      
                      ],
                    ),
                  ],
                )),
    );
  }
}

class MyGlobals {
  GlobalKey _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}

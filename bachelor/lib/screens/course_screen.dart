import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/screens/answer_question_screen.dart';
import 'package:flutter_complete_guide/screens/assessments_course_instructor.dart';
import 'package:flutter_complete_guide/screens/create_announcement_screen.dart';
import 'package:flutter_complete_guide/screens/questions_screen_instructor.dart';
import 'package:google_fonts/google_fonts.dart';
import '/screens/create_assessment_screen.dart';
import '/screens/edit_course_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:empty_widget/empty_widget.dart';

class CourseScreen extends StatefulWidget {
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
  var myCourses;
  var major;
  var semester;
  CourseScreen(
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
      this.role,
      this.myCourses,
      this.major,
      this.semester);

  static const routeName = '/courseScreen';

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userRef = Firestore.instance.collection('users');
  var group;
  var courses;
  var answer;
  var answerController = TextEditingController();
  var flagError = false;
  var flagUserEnrolled = false;
  var questions = [];
  var flagReload = false;
  var flagsValid = [];
  var controllers = [];
  void answerQuestion(question) {
    setState(() {
      question['answered'] = false;
      flagReload = true;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      role = widget.role;
    });
    checkUserEnrolled();
    getUserGroup();
    getCourseQuestions();
  }

  getCourseQuestions() {
    Firestore.instance.collection('discussions').getDocuments().then((value) {
      value.documents.forEach((element) {
        var data = element.data();
        if (data['courseName'] == widget.courseName &&
            data['courseDocumentID'] == widget.documentID) {
          if (data['answered'] == false) {
            setState(() {
              questions.add({
                'questionTitle': data['questionTitle'],
                'questionBody': data['questionBody'],
                'instructorAnswer': data['instructorAnswer'],
                'courseName': data['courseName'],
                'createdAt': data['createdAt'],
                'documentID': data['documentID'],
                'answered': data['answered'],
                'courseDocumentId': data['courseDocumentID'],
              });
              flagsValid.add(false);
            });
          }
        }
      });
    });
  }

  void getUserGroup() {
    userRef.getDocuments().then((value) {
      value.documents.forEach((element) {
        var data = element.data();
        if (data['userID'] == FirebaseAuth.instance.currentUser.uid) {
          //  print(data['lectureGroup']);
          setState(() {
            group = data['lectureGroup'];
          });
          //print(group + "group");
        }
      });
    });
  }

  void checkUserEnrolled() {
    if (widget.enrolledStudents != null &&
        widget.enrolledStudents.contains(widget.userID)) {
      print("in");
      setState(() {
        flagUserEnrolled = true;
      });
    } else {
      print("out");
      setState(() {
        flagUserEnrolled = false;
      });
    }
  }

  enrollInCourse() async {
    print(widget.enrolledStudents);
    print(widget.courseCode);
    if (widget.enrolledStudents == []) {
      widget.enrolledStudents = [widget.userID];
    } else {
      if (widget.enrolledStudents.contains(widget.userID)) {
        setState(() {
          textEnrolled = 'Already Enrolled';
        });

        return;
      }
      widget.enrolledStudents.add(widget.userID);
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

  var textEnrolled = "Enrolled Successfully";
  var flagErrorDelete = false;
  var role = '';
  var flagErrorEnrolled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back)),
        actions: [
          // IconButton(
          //     onPressed: () async {
          //       var myCourse = await Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => AssessmentsCourseInstructor(
          //               widget.courseName,
          //               widget.courseCode,
          //               widget.creditHours,
          //               widget.numberOfGroups,
          //               widget.lecturesFrequency,
          //               widget.timings,
          //               widget.assessments,
          //               widget.courseOwnerID,
          //               widget.documentID,
          //               widget.enrolledStudents,
          //               widget.userID,
          //               widget.major,
          //               widget.semester,
          //             ),
          //           ));
          //     },
          //     icon: Icon(
          //       Icons.assignment,
          //       color: Colors.white,
          //     )),
           
          PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(child: Row(
                  children: [
                    SizedBox(
                            width: 10,
                          ),
                    GestureDetector(
                      onTap: ()async{
                        var myCourse = await Navigator.push(
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
                      },
                      child: Text("Create Assessment", style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.blue.shade900),),
                    ),
                    Spacer(),
                    IconButton(
              onPressed: () async {
                    var myCourse = await Navigator.push(
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
              },
              icon: Icon(
                    Icons.add,
                    color: Colors.blue.shade900,
              )),
                  ],
                ),),
                PopupMenuItem(child: Row(
                  children: [
                    SizedBox(
                            width: 10,
                          ),
                    GestureDetector(
                      onTap: ()async{
                        var myCourse = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CreateAnnuncementScreen(widget.courseName),
                        ));
                      },
                      child: Text("Create Announcement", style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.blue.shade900),),
                    ),
                    Spacer(),
                    IconButton(
              onPressed: () async {
                    var myCourse = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CreateAnnuncementScreen(widget.courseName),
                        ));
              },
              icon: Icon(
                    Icons.notification_add,
                    color: Colors.blue.shade900,
              )),
                  ],
                ),),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              var myCourse = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditCourseScreen(
                                        widget.courseName,
                                        widget.courseCode,
                                        widget.creditHours,
                                        widget.numberOfGroups,
                                        widget.lecturesFrequency,
                                        widget.timings,
                                        widget.assessments,
                                        widget.enrolledStudents,
                                        widget.courseOwnerID,
                                        widget.documentID),
                                  ));
                              if (myCourse != null) {
                                setState(() {
                                  widget.courseName = myCourse['courseName'];
                                  widget.courseCode = myCourse['courseCode'];
                                  widget.creditHours = myCourse['creditHours'];
                                  widget.lecturesFrequency =
                                      myCourse['lecturesFrequency'];
                                  widget.numberOfGroups =
                                      myCourse['numberOfGroups'];
                                });
                              }
                            },
                            child: Text(
                              'Edit Course',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blue.shade900),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                              color: Colors.blue.shade900,
                              onPressed: () async {
                                var myCourse = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditCourseScreen(
                                          widget.courseName,
                                          widget.courseCode,
                                          widget.creditHours,
                                          widget.numberOfGroups,
                                          widget.lecturesFrequency,
                                          widget.timings,
                                          widget.assessments,
                                          widget.enrolledStudents,
                                          widget.courseOwnerID,
                                          widget.documentID),
                                    ));
                                if (myCourse != null) {
                                  setState(() {
                                    widget.courseName = myCourse['courseName'];
                                    widget.courseCode = myCourse['courseCode'];
                                    widget.creditHours =
                                        myCourse['creditHours'];
                                    widget.lecturesFrequency =
                                        myCourse['lecturesFrequency'];
                                    widget.numberOfGroups =
                                        myCourse['numberOfGroups'];
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue.shade900,
                              )),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              Navigator.of(context).pop();
                              try {
                                await FirebaseFirestore.instance
                                    .collection('courses')
                                    .doc(widget.documentID)
                                    .delete();
                                setState(() {
                                  widget.myCourses.removeWhere((item) =>
                                      item['documentID'] == widget.documentID);
                                });
                              } catch (error) {
                                print(error);
                                setState(() {
                                  flagErrorDelete = true;
                                });
                              }
                              if (!flagErrorDelete) {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          content: Text(
                                              'Course Deleted Successfuly'),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
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
                            child: Text(
                              'Delete Course',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.red),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          content: Text(
                                              'Are you sure you want to delete this course?',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('No',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .blue.shade900,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            FlatButton(
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                  try {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('courses')
                                                        .doc(widget.documentID)
                                                        .delete();
                                                    setState(() {
                                                      widget.myCourses
                                                          .removeWhere((item) =>
                                                              item[
                                                                  'documentID'] ==
                                                              widget
                                                                  .documentID);
                                                    });
                                                  } catch (error) {
                                                    print(error);
                                                    setState(() {
                                                      flagErrorDelete = true;
                                                    });
                                                  }
                                                  if (!flagErrorDelete) {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (_) => AlertDialog(
                                                                  content: Text(
                                                                      'Course Deleted Successfuly'),
                                                                  actions: [
                                                                    FlatButton(
                                                                        onPressed:
                                                                            () {
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
                                                child: Text('Yes',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .blue.shade900,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                          ],
                                        ));
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ],
                      ),
                    ),
                  ]),
        ],
        title: Text(
          widget.courseName,
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (questions.length == 0)
              // Container(
              //   alignment: Alignment.center,
              //   child: EmptyWidget(
              //     image: null,
              //     packageImage: PackageImage.Image_3,
              //     title: 'No Questions',
              //     subTitle: 'No  questions available yet',
              //     titleTextStyle: TextStyle(
              //       fontSize: 22,
              //       color: Color(0xff9da9c7),
              //       fontWeight: FontWeight.w500,
              //     ),
              //     subtitleTextStyle: TextStyle(
              //       fontSize: 14,
              //       color: Color(0xffabb8d6),
              //     ),
              //   ),
              // ),
            // if (questions.length > 0)
            //   SizedBox(
            //     height: 10,
            //   ),
            // if (questions.length > 0)
            //   Center(
            //     //  alignment: Alignment.centerLeft,
            //     child: Text('Available Questions',
            //         style: TextStyle(
            //             decoration: TextDecoration.underline,
            //             fontSize: 20,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.red.shade900)),
            //   ),
            // if (questions.length > 0)
            //   SizedBox(
            //     height: 10,
            //   ),
            if (role == 'student' && flagUserEnrolled == false)
              ElevatedButton(
                  onPressed: () {
                    enrollInCourse();
                    if (!flagErrorEnrolled) {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                content: Text(textEnrolled),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Dimiss',
                                        style: TextStyle(
                                            color: Colors.blue.shade900,
                                            fontWeight: FontWeight.bold),
                                      ))
                                ],
                              ));
                    }
                  },

                  child: Text('Enroll in Course')),
                  Column(
                    children: [
                      SizedBox(height:MediaQuery.of(context).size.height*0.1,),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionsScreenInstructor(widget.courseName,questions, widget.documentID),
                    ));
                        },
                        child: Center(child: Card(
                                        shape: RoundedRectangleBorder(
                                          side:  BorderSide(color: Colors.blue.shade900, 
                                          ), 
                                          borderRadius: const BorderRadius.all(Radius.circular(12))
                                          ),
                                        elevation: 0,
                                        color: Colors.lightBlue.shade100,
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context).size.height*0.25,
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Text('Questions', style: GoogleFonts.merriweather(
                                                  fontSize: 35, 
                                                ),),
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: Image(
                                                                        image: AssetImage(
                                                                            'lib/assets/images/questions.png')),
                                                ),
                                              ),
                                            ],
                                          ),)
                        )
                        ),
                      ),
                      SizedBox(height:MediaQuery.of(context).size.height*0.1,),
                      GestureDetector(
                        onTap: () async{
                          var myCourse = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssessmentsCourseInstructor(
                        widget.courseName,
                        widget.courseCode,
                        widget.creditHours,
                        widget.numberOfGroups,
                        widget.lecturesFrequency,
                        widget.timings,
                        widget.assessments,
                        widget.courseOwnerID,
                        widget.documentID,
                        widget.enrolledStudents,
                        widget.userID,
                        widget.major,
                        widget.semester,
                      ),
                    ));
                        },
                        child: Center(child: Card(
                                        shape: RoundedRectangleBorder(
                                          side:  BorderSide(color: Colors.blue.shade900, 
                                          ), 
                                          borderRadius: const BorderRadius.all(Radius.circular(12))
                                          ),
                                        elevation: 0,
                                        color: Colors.yellow.shade100,
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context).size.height*0.25,
                                          child: 
                                          Column(
                                            children: [
                                              Center(
                                                child: Text('Assessments', style: GoogleFonts.merriweather(
                                                  fontSize: 35, 
                                                ),),
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: Image(
                                                                        image: AssetImage(
                                                                            'lib/assets/images/report.png')),
                                                ),
                                              ),
                                            ],
                                          ),)
                        )
                        ),
                      ),

                    ],
                  ),
            // if (questions.length > 0)
            //   SizedBox(
            //     height: MediaQuery.of(context).size.height * 0.8,
            //     child: Form(
            //       key: _formKey,
            //       child: ListView.builder(
            //           itemCount: questions.length,
            //           itemBuilder: (BuildContext context, int index) {
            //             controllers.add("");
            //             return SingleChildScrollView(
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   if (!questions.elementAt(index)['answered'])
            //                     Center(
            //                         //alignment: Alignment.centerLeft,
            //                         child: Text(
            //                       questions.elementAt(index)['questionTitle'],
            //                       style: TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                           fontSize: 18,
            //                           color: Colors.blue.shade900),
            //                     )),
            //                   if (!questions.elementAt(index)['answered'])
            //                     SizedBox(
            //                       height: 4,
            //                     ),
            //                   if (!questions.elementAt(index)['answered'])
            //                     Align(
            //                         alignment: Alignment.centerLeft,
            //                         child: Text(
            //                           questions
            //                               .elementAt(index)['questionBody'],
            //                           style: TextStyle(
            //                               fontSize: 16,
            //                               fontWeight: FontWeight.bold),
            //                         )),
            //                   if (!questions.elementAt(index)['answered'])
            //                     SizedBox(
            //                       width:
            //                           MediaQuery.of(context).size.width * 0.5,
            //                       child: Column(
            //                         children: [
            //                           SizedBox(
            //                             height: 5,
            //                           ),
            //                           Align(
            //                             alignment: Alignment.topLeft,
            //                             child: TextFormField(
            //                               // controller: controllers[index],
            //                               key: ValueKey('answer'),
            //                               // autocorrect: true,
            //                               // keyboardType: TextInputType.multiline,
            //                               // textCapitalization:
            //                               //     TextCapitalization.words,
            //                               // enableSuggestions: false,
            //                               // autovalidateMode: AutovalidateMode
            //                               //     .onUserInteraction,
            //                               onChanged: (value) {
            //                                 if (!value.isEmpty) {
            //                                   controllers[index] =
            //                                       value.toString();
            //                                   setState(() {
            //                                     flagsValid[index] = true;
            //                                   });
            //                                 }
            //                               },
            //                               validator: (value) {
            //                                 if (value.isEmpty) {
            //                                   return 'Please enter a valid answer';
            //                                 }
            //                                 return null;
            //                               },
            //                               decoration: InputDecoration(
            //                                   labelText: 'Answer'),
            //                             ),
            //                             // child: TextFormField(
            //                             //   controller: controllers[index],
            //                             //   validator: ((value) {
            //                             //     if(value.isEmpty){
            //                             //       setState(() {
            //                             //         flagValid=false;
            //                             //       });
            //                             //       return "Please Enter an Answer";
            //                             //     }
            //                             //     setState(() {
            //                             //       flagValid=true;
            //                             //     });
            //                             //     return null;
            //                             //   }),
            //                             //   decoration: InputDecoration(

            //                             //     //                                     focusedBorder:OutlineInputBorder(
            //                             //     // borderSide: const BorderSide(color: Colors. blue, width: 2.0),
            //                             //     // borderRadius: BorderRadius. circular(25.0),
            //                             //     // ),
            //                             //     enabledBorder: UnderlineInputBorder(
            //                             //         borderSide: BorderSide(
            //                             //             color: Colors.blue.shade900)),
            //                             //     border: UnderlineInputBorder(
            //                             //         borderSide: BorderSide(
            //                             //             color: Colors.blue.shade900)),

            //                             //     labelText: 'Answer',
            //                             //     // hintText: 'Enter Your Name'
            //                             //   ),
            //                             //   onChanged: (value) {
            //                             //     controllers[index].text = value;
            //                             //   },
            //                             // ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   if (!questions.elementAt(index)['answered'])
            //                     TextButton(
            //                         onPressed: () async {
            //                           if (flagsValid[index]) {
            //                             //  print(controllers[index].text);
            //                             setState(() {
            //                               questions.elementAt(
            //                                   index)['answered'] = true;
            //                               questions.elementAt(
            //                                       index)['instructorAnswer'] =
            //                                   controllers[index];
            //                             });
            //                             print(questions.elementAt(
            //                                       index)['courseDocumentID']);
            //                             await FirebaseFirestore.instance
            //                                 .collection('discussions')
            //                                 .doc(questions
            //                                     .elementAt(index)['documentID'])
            //                                 .set({
            //                               'questionTitle': questions.elementAt(
            //                                   index)['questionTitle'],
            //                               'questionBody': questions
            //                                   .elementAt(index)['questionBody'],
            //                               'instructorAnswer':
            //                                   controllers[index],
            //                               'courseName': widget.courseName,
            //                               'createdAt': questions
            //                                   .elementAt(index)['createdAt'],
            //                               'documentID': questions
            //                                   .elementAt(index)['documentID'],
            //                               'answered': true,
            //                               'courseDocumentID':
            //                                   widget.documentID
            //                             });
            //                           }

            //                           // var questionsUpdated =
            //                           //     await Navigator.push(
            //                           //         context,
            //                           //         MaterialPageRoute(
            //                           //           builder: (context) =>
            //                           //               AnswerQuestionScreen(
            //                           //                   questions,
            //                           //                   index,
            //                           //                   widget.courseName,
            //                           //                   widget.documentID),
            //                           //         ));
            //                           // if (questionsUpdated != null) {
            //                           //   setState(() {
            //                           //     questions = questionsUpdated;
            //                           //   });
            //                           // }
            //                         },
            //                         child: Align(
            //                             alignment: Alignment.centerRight,
            //                             child: Text('Reply',
            //                                 style: TextStyle(
            //                                     color: Colors.blue.shade900,
            //                                     fontWeight: FontWeight.bold,
            //                                     fontSize: 16)))),
            //                   Divider(
            //                     color: Colors.grey,
            //                   ),
            //                 ],
            //               ),
            //             );
            //           }),
            //     ),
            //   ),
            // Center(
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       IconButton(
            //         icon: Icon(
            //           Icons.add,
            //           size: 30,
            //           color: Colors.blue,
            //         ),
            //         onPressed: () {
            //           print(questions);
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) => CreateAssessmentScreen(
            //                     widget.courseName,
            //                     widget.courseCode,
            //                     widget.creditHours,
            //                     widget.numberOfGroups,
            //                     widget.lecturesFrequency,
            //                     widget.timings,
            //                     widget.assessments,
            //                     widget.enrolledStudents,
            //                     widget.courseOwnerID,
            //                     widget.documentID,
            //                     widget.userID,
            //                     widget.numberOfGroups,
            //                     widget.major,
            //                     widget.semester),
            //               ));
            //         },
            //       ),
            //       Text(
            //         'Create Assessment',
            //         style: TextStyle(color: Colors.blue),
            //       )
            //     ],
            //   ),
            // ),
            if (flagUserEnrolled && group != null)
              EnrolledCourse(
                  group: group,
                  assessments: widget.assessments,
                  timings: widget.timings,
                  lectureFrequency: widget.lecturesFrequency)
          ],
        ),
      ),
    );
  }
}

class EnrolledCourse extends StatefulWidget {
  String group;
  var assessments;
  var timings;
  var lectureFrequency;

  EnrolledCourse(
      {@required this.group,
      @required this.assessments,
      @required this.timings,
      @required this.lectureFrequency});
  @override
  State<EnrolledCourse> createState() => _EnrolledCourseState();
}

class _EnrolledCourseState extends State<EnrolledCourse> {
  var day1 = 'not Changed';
  var slot1 = 'not Changed';
  var location1 = 'not Changed';
  var day2 = 'not Changed';
  var slot2 = 'not Changed';
  var location2 = 'not Changed';
  getTimings() {
    for (var element in widget.timings) {
      print(element['Group']);
      if (element['Group'] == widget.group) {
        setState(() {
          day1 = element['1st Lecture Day'];
          slot1 = element['1st Lecture Slot'];
          location1 = element['1st Lecture Location'];
        });
        if (widget.lectureFrequency == 'Twice a week') {
          setState(() {
            day2 = element['2nd Lecture Day'];
            slot2 = element['2nd Lecture Slot'];
            location2 = element['2nd Lecture Location'];
          });
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTimings();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: widget.assessments.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  Text(widget.assessments.elementAt(index)['assessmentType']),
                  Text(widget.assessments.elementAt(index)['day']),
                  Text(widget.assessments.elementAt(index)['time']),
                ],
              );
            }),
        Column(
          children: <Widget>[Text(day1), Text(location1), Text(slot1)],
        )
      ],
    );
  }
}

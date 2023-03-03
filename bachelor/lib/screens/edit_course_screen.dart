import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './instructor_home_screen.dart';

class EditCourseScreen extends StatefulWidget {
  var courseName;
  var courseCode;
  var creditHours;
  var numberOfGroups;
  var lecturesFrequency;
  var timings;
  var assessments;
  var enrolledStudents;
  var courseOwnerID;
  var documentID;

  static const routeName = '/editCourse';
  EditCourseScreen(
      this.courseName,
      this.courseCode,
      this.creditHours,
      this.numberOfGroups,
      this.lecturesFrequency,
      this.timings,
      this.assessments,
      this.enrolledStudents,
      this.courseOwnerID,
      this.documentID);

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  var _courseName = "";
  var _courseCode = "";
  var _creditHours = "";
  var _courseOwner =
      ""; // stores user id (uid) of Instructor who created Course
  var _enrolledStudents = []; // stores uid of all enrolled students
  var _otherInstructor = []; // stores uid of other imstructors
  var _assessment = {};
  var _noOfAssignments = 0;
  var _numberOfGroups = "";
  var _lectureFrequency = "";
  var flagError = false;
  var _day1 = "";
  var _slot1 = "";
  var _location1 = "";
  var _day2 = "";
  var _slot2 = "";
  var _location2 = "";

  var flagBiweekly = false;
  var slots = [
    {
      "display": "1st",
      "value": "1st",
    },
    {
      "display": "2nd",
      "value": "2nd",
    },
    {
      "display": "3rd",
      "value": "3rd",
    },
    {
      "display": "4th",
      "value": "4th",
    },
    {
      "display": "5th",
      "value": "5th",
    }
  ];
  var days = [
    {
      "display": "Sunday",
      "value": "Sunday",
    },
    {
      "display": "Monday",
      "value": "Monday",
    },
    {
      "display": "Tuesday",
      "value": "Tuesday",
    },
    {
      "display": "Wednesday",
      "value": "Wednesday",
    },
    {
      "display": "Thursday",
      "value": "Thursday",
    }
  ];
  var dataSourceOnetoEight = [
    {
      "display": "1",
      "value": "1",
    },
    {
      "display": "2",
      "value": "2",
    },
    {
      "display": "3",
      "value": "3",
    },
    {
      "display": "4",
      "value": "4",
    },
    {
      "display": "5",
      "value": "5",
    },
    {
      "display": "6",
      "value": "6",
    },
    {
      "display": "7",
      "value": "7",
    },
    {
      "display": "8",
      "value": "8",
    },
  ];
  var dataSourceTento100 = [
    {
      "display": "10 %",
      "value": "10 %",
    },
    {
      "display": "20 %",
      "value": "20 %",
    },
    {
      "display": "30 %",
      "value": "30 %",
    },
    {
      "display": "40 %",
      "value": "40 %",
    },
    {
      "display": "50 %",
      "value": "50 %",
    },
    {
      "display": "60 %",
      "value": "60 %",
    },
    {
      "display": "70 %",
      "value": "70 %",
    },
    {
      "display": "80 %",
      "value": "80 %",
    },
    {
      "display": "90 %",
      "value": "90 %",
    },
    {
      "display": "100 %",
      "value": "100 %",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Course')),
      body: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: ValueKey('courseName'),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    initialValue: widget.courseName,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid course name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Course Name'),
                    onSaved: (value) {
                      _courseName = value;
                    },
                    onChanged: (value) {
                      setState(() {
                        _courseName = value;
                      });
                    },
                  ),
                  TextFormField(
                    key: ValueKey('courseCode'),
                    autocorrect: true,
                    initialValue: widget.courseCode,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid course code';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Course Code'),
                    onSaved: (value) {
                      _courseCode = value;
                    },
                    onChanged: (value) {
                      setState(() {
                        _courseCode = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                    alignment: Alignment.centerLeft,
                    child: DropDownFormField(
                      titleText: 'Credit Hours',
                      hintText: 'Please choose one',
                      value: _creditHours == ""
                          ? widget.creditHours
                          : _creditHours,
                      onSaved: (value) {
                        setState(() {
                          _creditHours = value.toString();
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _creditHours = value.toString();
                        });
                      },
                      dataSource: dataSourceOnetoEight,
                      textField: 'display',
                      valueField: 'value',
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                    alignment: Alignment.centerLeft,
                    child: DropDownFormField(
                      titleText: 'Number of Groups',
                      hintText: 'Please choose one',
                      value: _numberOfGroups == ""
                          ? widget.numberOfGroups
                          : _numberOfGroups,
                      onSaved: (value) {
                        setState(() {
                          _numberOfGroups = value.toString();
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _numberOfGroups = value.toString();
                        });
                      },
                      dataSource: [
                        {'display': '1', 'value': '1'},
                        {'display': '2', 'value': '2'},
                        {'display': '3', 'value': '3'},
                        {'display': '4', 'value': '4'},
                      ],
                      textField: 'display',
                      valueField: 'value',
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                    alignment: Alignment.centerLeft,
                    child: DropDownFormField(
                      titleText: 'Lectures Frequency',
                      hintText: 'Please choose one',
                      value: _lectureFrequency == ""
                          ? widget.lecturesFrequency
                          : _lectureFrequency,
                      onSaved: (value) {
                        setState(() {
                          _lectureFrequency = value.toString();
                        });

                        if (value.toString() == 'Twice a week') {
                          setState(() {
                            flagBiweekly = true;
                          });
                        }
                        print(flagBiweekly.toString() + " flag");
                      },
                      onChanged: (value) {
                        setState(() {
                          _lectureFrequency = value.toString();
                        });
                        if (value.toString() == 'Twice a week') {
                          setState(() {
                            flagBiweekly = true;
                          });
                        }
                        print(flagBiweekly.toString() + " flag");
                      },
                      dataSource: [
                        {'display': 'Weekly', 'value': 'Weekly'},
                        {'display': 'Biweekly', 'value': 'Biweekly'},
                        {'display': 'Twice a week', 'value': 'Twice a week'},
                      ],
                      textField: 'display',
                      valueField: 'value',
                    ),
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                        alignment: Alignment.centerLeft,
                        child: DropDownFormField(
                          titleText: 'Lecture Day',
                          hintText: 'Please choose one',
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Choose Day';
                            }
                          },
                          value: _day1 == ""
                              ? widget.timings.elementAt(0)['1st Lecture Day']
                              : _day1,
                          onSaved: (value) {
                            setState(() {
                              _day1 = value.toString();
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _day1 = value.toString();
                            });
                          },
                          dataSource: days,
                          textField: 'display',
                          valueField: 'value',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                        alignment: Alignment.centerLeft,
                        child: DropDownFormField(
                          titleText: 'Slot',
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Choose Slot';
                            }
                          },
                          hintText: 'Choose One',
                          value: _slot1 == ""
                              ? widget.timings.elementAt(0)['1st Lecture Slot']
                              : _slot1,
                          onSaved: (value) {
                            setState(() {
                              _slot1 = value.toString();
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _slot1 = value.toString();
                            });
                          },
                          dataSource: slots,
                          textField: 'display',
                          valueField: 'value',
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        key: ValueKey('location'),
                        autocorrect: true,
                        enableSuggestions: false,
                        initialValue:
                            widget.timings.elementAt(0)['1st Lecture Location'],
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a valid location';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Location'),
                        onSaved: (value) {
                          _location1 = value;
                        },
                        onChanged: (value) {
                          setState(() {
                            _location1 = value;
                          });
                        },
                      ),
                    ),
                  ]),
                  if (flagBiweekly)
                    Row(children: <Widget>[
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                          alignment: Alignment.centerLeft,
                          child: DropDownFormField(
                            titleText: 'Lecture Day',
                            hintText: 'Please choose one',
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Choose Day';
                              }
                            },
                            value: _day2 == ""
                                ? widget.timings.elementAt(1)['2nd Lecture Day']
                                : _day2,
                            onSaved: (value) {
                              setState(() {
                                _day2 = value.toString();
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _day2 = value.toString();
                              });
                            },
                            dataSource: days,
                            textField: 'display',
                            valueField: 'value',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                          alignment: Alignment.centerLeft,
                          child: DropDownFormField(
                            titleText: 'Slot',
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Choose Slot';
                              }
                            },
                            hintText: 'Choose One',
                            value: _slot2 == ""
                                ? widget.timings
                                    .elementAt(1)['2nd Lecture Slot']
                                : _slot2,
                            onSaved: (value) {
                              setState(() {
                                _slot2 = value.toString();
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _slot2 = value.toString();
                              });
                            },
                            dataSource: slots,
                            textField: 'display',
                            valueField: 'value',
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          key: ValueKey('location2'),
                          autocorrect: true,
                          enableSuggestions: false,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid location';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Location'),
                          initialValue: widget.timings
                              .elementAt(1)['2nd Lecture Location'],
                          onSaved: (value) {
                            _location2 = value;
                          },
                          onChanged: (value) {
                            setState(() {
                              _location2 = value;
                            });
                          },
                        ),
                      ),
                    ]),
                  TextButton(
                      onPressed: () async {
                        final isValid = _formKey.currentState.validate();
                        FocusScope.of(context).unfocus();
                        if (isValid) {
                          _formKey.currentState.save();
                        }
                        if (flagBiweekly) {
                          widget.timings = [
                            {
                              '1st Lecture Day': _day1,
                              '1st Lecture Slot': _slot1,
                              '1st Lecture Location': _location1
                            },
                            {
                              '2nd Lecture Day': _day2,
                              '2nd Lecture Slot': _slot2,
                              '2nd Lecture Location': _location2
                            },
                          ];
                        } else {
                          widget.timings = [
                            {
                              '1st Lecture Day': _day1,
                              '1st Lecture Slot': _slot1,
                              '1st Lecture Location': _location1
                            }
                          ];
                        }
                        try {
                          await FirebaseFirestore.instance
                              .collection('courses')
                              .doc(widget.documentID)
                              .set({
                            'courseName': _courseName,
                            'courseCode': _courseCode,
                            'creditHours': _creditHours,
                            'numberOfGroups': _numberOfGroups,
                            'lecturesFrequency': _lectureFrequency,
                            'timings': widget.timings,
                            'assessments': widget.assessments,
                            'enrolledStudents': widget.enrolledStudents,
                            'courseOwnerId': widget.courseOwnerID,
                            'documentID': widget.documentID
                          });
                        } catch (error) {
                          print(error);
                          setState(() {
                            flagError = true;
                          });
                        }
                        var myCourse = {'courseName':_courseName,'courseCode':_courseCode,
                         'numberOfGroups':_numberOfGroups,'lecturesFrequency':_lectureFrequency, 'creditHours':_creditHours};
                        if (!flagError) {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    content: Text('Course Edited Successfuly',style: TextStyle(color: Colors.blue.shade900)),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop(myCourse);

                                            // Navigator.of(context).pushReplacementNamed(InstructorHomeScreen.routeName);
                                          },
                                          child: Text('Dimiss',style: TextStyle(color: Colors.blue.shade900)))
                                    ],
                                  ));
                        }
                      },
                      child: Text('Edit', style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold, fontSize: 16),))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

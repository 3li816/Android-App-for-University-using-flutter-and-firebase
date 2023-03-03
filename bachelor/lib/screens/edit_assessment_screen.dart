import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:intl/intl.dart';

class EditAssessmentScreen extends StatefulWidget {
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
  var userID;
  var currentAssessment;
  var upcoming;

  EditAssessmentScreen(
      this.courseName,
      this.courseCode,
      this.creditHours,
      this.numberOfGroups,
      this.lecturesFrequency,
      this.timings,
      this.assessments,
      this.enrolledStudents,
      this.courseOwnerID,
      this.documentID,
      this.userID,
      this.currentAssessment,
      this.upcoming);

  @override
  State<EditAssessmentScreen> createState() => _EditAssessmentScreenState();
}

class _EditAssessmentScreenState extends State<EditAssessmentScreen> {
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.currentAssessment['assessmentType'] == 'Quiz') {
      setState(() {
        flagQuiz = true;
        flagDeadline = 'Quiz Date';
        flagAssessmentName = true;
        flagQuiz = true;
        flagDeadlineDisplay = true;
        flagTime = true;
      });
    }
    if (widget.currentAssessment['assessmentType'] == 'Midterm' ||
        widget.currentAssessment['assessmentType'] == 'Final') {
      setState(() {
        flagAssessmentName = false;
        flagDeadline = 'Exam Date';
        flagQuiz = false;
        flagTime = false;
        flagDeadlineDisplay = false;
      });
    }
    if (widget.currentAssessment['assessmentType'] == 'Project' ||
        widget.currentAssessment['assessmentType'] == 'Assignment') {
      setState(() {
        flagAssessmentName = true;
        flagDeadline = 'Deadline';
        flagTime = true;
        flagQuiz = false;
        flagDeadlineDisplay = true;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  var _assessmentType = "";
  var _assessmentName = "";
  var flagQuiz = false;
  var duration = "";
  var formattedTimeOfDay;
  var flagError = false;
  // var _time = '';
  var minsHours = "";
  var groups = "";
  var splittedDate;
  var hours = 100;
  var minutes = 100;
  DateTime assessmentDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  var flagAssessmentName = false;
  var flagDeadlineDisplay = false;
  var flagDeadline = "";
  TimeOfDay _timeOfDay;
  var isLoading = false;
  var _instructorNotes = '';

  final coursesRef = Firestore.instance.collection('courses');
  var flagTime = false;
  var durationDataSource = [
    {
      "display": "Minutes",
      "value": "Minutes",
    },
    {
      "display": "Hours",
      "value": "Hours",
    },
  ];
  var dataAssessmentType = [
    {
      "display": "Assignment",
      "value": "Assignment",
    },
    {
      "display": "Quiz",
      "value": "Quiz",
    },
    {
      "display": "Project",
      "value": "Project",
    },
    {
      "display": "Midterm",
      "value": "Midterm",
    },
    {
      "display": "Final",
      "value": "Final",
    },
  ];
  @override
  Widget build(BuildContext context) {
    // var dateController = TextEditingController();

    //dateController.text = widget.currentAssessment['day'].toString();
    // var timeController = TextEditingController();
    //  timeController.text = widget.currentAssessment['time'].toString();
    //setState(() {
    var _time = ""; //widget.currentAssessment['time'].toString();
    var _day = ""; // widget.currentAssessment['day'].toString();
    //});
    return Scaffold(
      appBar: AppBar(title: Text("Edit Assessment")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        " Assessment Date: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue.shade900),
                      ),
                      Text(
                        widget.currentAssessment['day'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Text(
                        " Assessment Time: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue.shade900 ),
                      ),
                      Text(
                        widget.currentAssessment['time'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  Card(
                    margin: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 0),
                                alignment: Alignment.centerLeft,
                                child: DropDownFormField(
                                  titleText: 'Assessment Type',
                                  errorText: 'Please select one option',
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please Choose Assessment Type';
                                    }
                                  },
                                  hintText: 'Choose One',
                                  value: _assessmentType == ""
                                      ? widget.currentAssessment['assessmentType']
                                      : _assessmentType,
                                  onSaved: (value) {
                                    if (value == 'Assignment' ||
                                        value == 'Project' ||
                                        value == 'Quiz') {
                                      setState(() {
                                        flagAssessmentName = true;
                                      });
                                    }
                                    setState(() {
                                      _assessmentType = value.toString();
                                      flagDeadlineDisplay = true;
                                      flagTime = true;
                                    });
                                    if (value == 'Final' || value == 'Midterm') {
                                      setState(() {
                                        flagDeadline = 'Exam Date';
                                        _assessmentName = value;
                                      });
                                    }
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _assessmentType = value.toString();
                                      flagDeadlineDisplay = true;
                                      flagTime = true;
                                    });
                                    if (value == 'Assignment' ||
                                        value == 'Project') {
                                      setState(() {
                                        flagAssessmentName = true;
                                        flagDeadline = 'Deadline';
                                        flagTime = true;
                                        flagQuiz = false;
                                        flagDeadlineDisplay = true;
                                      });
                                    }
                                    if (value == 'Quiz') {
                                      setState(() {
                                        flagDeadline = 'Quiz Date';
                                        flagAssessmentName = true;
                                        flagQuiz = true;
                                        flagTime = true;
                                      });
                                    } else if (value == 'Final' ||
                                        value == 'Midterm') {
                                      setState(() {
                                        flagAssessmentName = false;
                                        flagDeadline = 'Exam Date';
                                        flagQuiz = false;
                                        flagTime = false;
                                      });
                                    }
                                  },
                                  dataSource: dataAssessmentType,
                                  textField: 'display',
                                  valueField: 'value',
                                ),
                              ),
                              if (flagAssessmentName)
                                TextFormField(
                                  key: ValueKey('Assessment Name'),
                                  initialValue: _assessmentName == ""
                                      ? widget.currentAssessment['assessmentName']
                                      : _assessmentName,
                                  autocorrect: true,
                                  textCapitalization: TextCapitalization.words,
                                  // autovalidateMode:
                                  //     AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a valid name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Assessment Name'),
                                  onSaved: (value) {
                                    setState(() {
                                      _assessmentName = value.toString();
                                    });
                                  },
                                ),
                              if (flagDeadlineDisplay)
                                TextFormField(
                                  key: ValueKey('Assessment Time'),
                                  controller: dateController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  // validator: (value) {
                                  //   if (value.isEmpty) {
                                  //     return 'Please enter a valid date';
                                  //   }
                                  //   return null;
                                  // },
                                  decoration: InputDecoration(
                                    labelText: flagDeadline,
                                  ),
                                  onTap: () async {
                                    DateTime date = DateTime.now();
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2100));
                                    final DateFormat formatter =
                                        DateFormat('dd-MM-yyyy');
                                    setState(() {
                                      dateController.text =
                                          formatter.format(date);
                                    });
                                    print(dateController.text);
                                  },
                                  onSaved: (value) {
                                    setState(() {
                                      _day = value.toString();
                                    });
                                  },
                                ),
                              if (flagTime)
                                TextFormField(
                                  key: ValueKey('examTime'),
                                  controller: timeController,
                                  // validator: (value) {
                                  //   if (value.isEmpty) {
                                  //     return 'Please enter a valid time';
                                  //   }
                                  //   return null;
                                  // },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(labelText: 'Time'),
                                  onTap: () async {
                                    final localizations =
                                        MaterialLocalizations.of(context);
                                    final TimeOfDay timeOfDay =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: selectedTime,
                                            initialEntryMode:
                                                TimePickerEntryMode.dial);
                                    if (timeOfDay != null &&
                                        timeOfDay != selectedTime) {
                                      setState(() {
                                        _timeOfDay = timeOfDay;
                                        selectedTime = timeOfDay;
                                        formattedTimeOfDay = localizations
                                            .formatTimeOfDay(selectedTime);
                                        timeController.text = formattedTimeOfDay;
                                      });
                                    }
                                  },
                                  onSaved: (value) {
                                    setState(() {
                                      _time = timeController.text;
                                    });
                                  },
                                ),
                              if (flagQuiz)
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextFormField(
                                        key: ValueKey('Duration'),
                                        autocorrect: true,
                                        enableSuggestions: false,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter a valid duration';
                                          }
                                          return null;
                                        },
                                        initialValue: duration == ""
                                            ? widget.currentAssessment['duration']
                                            : duration,
                                        decoration: InputDecoration(
                                            labelText: 'Duration'),
                                        onSaved: (value) {
                                          duration = value;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            duration = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16, horizontal: 0),
                                        alignment: Alignment.centerLeft,
                                        child: DropDownFormField(
                                          titleText: 'Duration',
                                          errorText: 'Please select one option',
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please Choose Duration';
                                            }
                                          },
                                          hintText: 'Choose One',
                                          value: minsHours == ""
                                              ? widget.currentAssessment[
                                                  'minutesHours']
                                              : minsHours,
                                          onSaved: (value) {
                                            setState(() {
                                              minsHours = value;
                                            });
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              minsHours = value;
                                            });
                                          },
                                          dataSource: durationDataSource,
                                          textField: 'display',
                                          valueField: 'value',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              TextFormField(
                                key: ValueKey('Instructor Notes'),
                                autocorrect: true,
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.multiline,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                    labelText: 'Instructor Notes'),
                                onSaved: (value) {
                                  setState(() {
                                    _instructorNotes = value.toString();
                                  });
                                },
                                initialValue: _instructorNotes == ""
                                    ? widget.currentAssessment['instructorNotes']
                                    : _instructorNotes,
                              ),
                              TextButton(
                                  onPressed: () async {
                                    print("day");
                                    print(_day.toString());
                                    final isValid =
                                        _formKey.currentState.validate();
                                    FocusScope.of(context).unfocus();
                                    if (isValid) {
                                      _formKey.currentState.save();
                                    }
                                    if (dateController.text.length > 0) {
                                      setState(() {
                                        _day = dateController.text;
                                      });
                                    }
                                    if (timeController.text.length > 0) {
                                      setState(() {
                                        _time = timeController.text;
                                      });
                                    }
                                    if (isValid) {
                                      setState(() {
                                        widget.assessments
                                            .remove(widget.currentAssessment);
                                        for (var i = 0;
                                            i < widget.upcoming.length;
                                            i++) {
                                          var assessment =
                                              widget.upcoming.elementAt(i);
                                          if (assessment['assessmentName'] ==
                                              widget.currentAssessment[
                                                  'assessmentName']) {
                                            setState(() {
                                              widget.upcoming.remove(assessment);
                                              widget.assessments.remove(
                                                  widget.currentAssessment);
                                            });
                                            i += widget.upcoming.length;
                                          }
                                        }
                                      });
                                      if (_day == "") {
                                        setState(() {
                                          _day = widget.currentAssessment['day'];
                                        });
                                      }
                                      if (_time == "") {
                                        setState(() {
                                          _time =
                                              widget.currentAssessment['time'];
                                        });
                                      }
                                      if (_assessmentType == 'Project' ||
                                          _assessmentType == 'Assignment') {
                                        splittedDate = _day.split('-');
                                        var date = new DateTime(
                                            int.parse(splittedDate[2]),
                                            int.parse(splittedDate[1]),
                                            int.parse(splittedDate[0]));
                                        var splittedTime = _time.split(' ');
                                        var hoursMinutes = splittedTime[0];
                                        var hoursMinutesSplit =
                                            hoursMinutes.split(':');
                                        hours = int.parse(hoursMinutesSplit[0]);
                                        minutes = int.parse(hoursMinutesSplit[1]);
                                        var amPm = splittedTime[1];
                                        if (amPm == 'PM' && hours != 12) {
                                          hours += 12;
                                        }
                                      }
                                      if (hours == 100 && minutes == 100) {
                                        assessmentDate = new DateTime(
                                            int.parse(splittedDate[2]),
                                            int.parse(splittedDate[1]),
                                            int.parse(splittedDate[0]),
                                            23,
                                            59);
                                      } else {
                                        assessmentDate = new DateTime(
                                            int.parse(splittedDate[2]),
                                            int.parse(splittedDate[1]),
                                            int.parse(splittedDate[0]),
                                            hours,
                                            minutes);
                                      }
                                      
                                      setState(() {
                                        widget.assessments.add({
                                      'assessmentType': _assessmentType,
                                      'assessmentName': _assessmentName,
                                      'day': _day,
                                      'duration': duration,
                                      'minutesHours': minsHours,
                                      'time': _time,
                                      'instructorNotes': _instructorNotes,
                                      'dateTime':
                                          Timestamp.fromDate(assessmentDate),
                                    });
                                        // widget.assessments.add({
                                        //   'assessmentType': _assessmentType,
                                        //   'assessmentName': _assessmentName,
                                        //   'day': _day,
                                        //   'duration': duration,
                                        //   'minutesHours': minsHours,
                                        //   'time': _time,
                                        //   'instructorNotes': _instructorNotes,
                                        //   'dateTime':
                                        //       Timestamp.fromDate(assessmentDate),
                                        // });
                                      });
                                      for (int i = 0;
                                      i < widget.assessments.length - 1;
                                      i++) {
                                    for (int j = 0;
                                        j < widget.assessments.length - i - 1;
                                        j++) {
                                      // var dayj = widget.assessments.elementAt(j)['dateTimeAssessment'].toString().split("-");
                                      //DateTime dt = (map['timestamp'] as Timestamp).toDate();
                                      var datej = (widget.assessments
                                                  .elementAt(j)['dateTime']
                                              as Timestamp)
                                          .toDate();
                                      var datejPlusOne = (widget.assessments
                                                  .elementAt(j + 1)['dateTime']
                                              as Timestamp)
                                          .toDate();
                                      if (datej.isBefore(datejPlusOne)) {
                                        setState(() {
                                          var temp = widget.assessments[j];
                                          widget.assessments[j] =
                                              widget.assessments.elementAt(j + 1);
                                          widget.assessments[j + 1] = temp;
                                        });
                                      }
                                    }
                                  }
          
                                      setState(() {
                                        print(_day);
                                        // widget.assessments.add({
                                        //   'assessmentType': _assessmentType,
                                        //   'assessmentName': _assessmentName,
                                        //   'day': _day,
                                        //   'duration': duration,
                                        //   'minutesHours': minsHours,
                                        //   'time': _time,
                                        //   'instructorNotes': _instructorNotes,
                                        // });
                                        // widget.upcoming.add({
                                        //   'assessmentType': _assessmentType,
                                        //   'assessmentName': _assessmentName,
                                        //   'day': _day,
                                        //   'duration': duration,
                                        //   'minutesHours': minsHours,
                                        //   'time': _time,
                                        //   'instructorNotes': _instructorNotes,
                                        // });
          
                                        //}
                                      });
                                    }
          
                                    // for (int i = 0;
                                    //     i < widget.assessments.length - 1;
                                    //     i++) {
                                    //   for (int j = 0;
                                    //       j < widget.assessments.length - i - 1;
                                    //       j++) {
                                    //     // var dayj = widget.assessments.elementAt(j)['dateTimeAssessment'].toString().split("-");
                                    //     //DateTime dt = (map['timestamp'] as Timestamp).toDate();
                                    //     var datej = (widget.assessments
                                    //                 .elementAt(j)['dateTime']
                                    //             as Timestamp)
                                    //         .toDate();
                                    //     var datejPlusOne = (widget.assessments
                                    //                 .elementAt(j + 1)['dateTime']
                                    //             as Timestamp)
                                    //         .toDate();
                                    //     if (datej.isBefore(datejPlusOne)) {
                                    //       setState(() {
                                    //         var temp = widget.assessments[j];
                                    //         widget.assessments[j] = widget
                                    //             .assessments
                                    //             .elementAt(j + 1);
                                    //         widget.assessments[j + 1] = temp;
                                    //       });
                                    //     }
                                    //   }
                                    // }
          
                                    var bodyText = "";
                                    if (_assessmentType == 'Quiz') {
                                      bodyText = _assessmentName +
                                          " will take place on " +
                                          _day +
                                          " @ " +
                                          _time;
                                    } else if (_assessmentType == 'Assignment' ||
                                        _assessmentType == 'Project') {
                                      bodyText = _assessmentName +
                                          " deadline is on " +
                                          _day +
                                          " @ " +
                                          _time;
                                    }
                                    if (isValid) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      // try {
                                      //   await FirebaseFirestore.instance
                                      //       .collection('assessments')
                                      //       .add({
                                      //     'courseName': widget.courseName,
                                      //     'courseCode': widget.courseCode,
                                      //     'assessmentType': _assessmentType,
                                      //     'assessmentName': _assessmentName,
                                      //     'day': _day,
                                      //     'duration': duration,
                                      //     'minutesHours': minsHours,
                                      //     'time': _time,
                                      //     'instructorNotes': _instructorNotes,
                                      //     'courseOwnerId': widget.userID,
                                      //     'bodyText': bodyText
                                      //   });
                                      // } catch (error) {
                                      //   print(error);
                                      //   setState(() {
                                      //     flagError = true;
                                      //   });
                                      // }
                                      if (isValid) {
                                        try {
                                          print(widget.assessments);
                                          await FirebaseFirestore.instance
                                              .collection('courses')
                                              .doc(widget.documentID)
                                              .set({
                                            'courseName': widget.courseName,
                                            'courseCode': widget.courseCode,
                                            'creditHours': widget.creditHours,
                                            'numberOfGroups':
                                                widget.numberOfGroups,
                                            'lecturesFrequency':
                                                widget.lecturesFrequency,
                                            'timings': widget.timings,
                                            'assessments': widget.assessments,
                                            'courseOwnerId': widget.userID,
                                            'enrolledStudents':
                                                widget.enrolledStudents,
                                            'documentID': widget.documentID
                                          });
                                        } catch (error) {
                                          print(error);
                                          setState(() {
                                            flagError = true;
                                          });
                                        }
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
          
                                      if (!flagError) {
                                        showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                                  content: Text(
                                                      'Assessment Edited Successfuly',style: TextStyle(color: Colors.blue.shade900)),
                                                  actions: [
                                                    FlatButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pop(widget
                                                                  .assessments);
                                                          //Navigator.of(context).pop();
                                                        },
                                                        child: Text('Dismiss', style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold, fontSize: 16),))
                                                  ],
                                                ));
                                      }
                                    }
                                  },
                                  child: Text('Edit',style: TextStyle(color: Colors.blue.shade900,fontWeight: FontWeight.bold,fontSize: 16)))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Dismissible(
                    key: UniqueKey(),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Note Dismissed')));
                    },
                    child: Card(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Note",
                                  style:
                                      TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                                )),
                                SizedBox(height: 5,),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Please if you don't want to change the date and time leave their fields empty or you can enter the old date and time again",
                                  style:
                                      TextStyle(color: Colors.blue.shade900, fontSize: 18),
                                ))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
          ),
    );
  }
}

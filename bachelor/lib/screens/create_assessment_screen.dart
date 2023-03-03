import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CreateAssessmentScreen extends StatefulWidget {
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
  var groups;
  var major;
  var semester;
  CreateAssessmentScreen(
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
      this.groups,
      this.major,
      this.semester);
  static const routeName = '/createAssessment';

  @override
  State<CreateAssessmentScreen> createState() => _CreateAssessmentScreenState();
}

class _CreateAssessmentScreenState extends State<CreateAssessmentScreen> {
  final _formKey = GlobalKey<FormState>();
  var uploadedFile;
  var fileName;
  var extension = "";
  var flagPDF = false;
  var flagImage = false;
  var path;
  var _assessmentType = "";
  var _assessmentName = "";
  var flagQuiz = false;
  var duration = "";
  var formattedTimeOfDay;
  var flagError = false;
  var _time;
  var splittedDate;
  var minsHours = "";
  var groups = "";
  TimeOfDay selectedTime = TimeOfDay.now();
  var flagAssessmentName = false;
  var flagDeadlineDisplay = false;
  var flagDeadline = "";
  var _day;
  TimeOfDay _timeOfDay;
  var isLoading = false;
  var _instructorNotes = '';
  DateTime assessmentDate = DateTime.now();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  final coursesRef = Firestore.instance.collection('courses');
  var flagTime = false;
  var hours = 100;
  var minutes = 100;
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
  // Function viewMyCourses() {
  //   coursesRef.do;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Assessment',)),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue.shade900,))
          : Card(
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
                          padding:
                              EdgeInsets.symmetric(vertical: 16, horizontal: 0),
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
                            value: _assessmentType,
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
                              if (value == 'Assignment' || value == 'Project') {
                                setState(() {
                                  flagAssessmentName = true;
                                  flagDeadline = 'Deadline';
                                  flagTime = true;
                                  flagQuiz = false;
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
                            decoration:
                                InputDecoration(labelText: 'Assessment Name'),
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
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid date';
                              }
                              return null;
                            },
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
                              dateController.text = formatter.format(date);
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
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid time';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(labelText: 'Time'),
                            onTap: () async {
                              final localizations =
                                  MaterialLocalizations.of(context);
                              final TimeOfDay timeOfDay = await showTimePicker(
                                  context: context,
                                  initialTime: selectedTime,
                                  initialEntryMode: TimePickerEntryMode.dial);
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
                                  decoration:
                                      InputDecoration(labelText: 'Duration'),
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
                                    value: minsHours,
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration:
                              InputDecoration(labelText: 'Instructor Notes'),
                          onSaved: (value) {
                            setState(() {
                              _instructorNotes = value.toString();
                            });
                          },
                        ),
                        if (!flagPDF && !flagImage)
                          FlatButton.icon(
                              onPressed: () async {
                                final result =
                                    await FilePicker.platform.pickFiles();
                                if (result == null) return;
                                setState(() {
                                  path = result.files.single.path;
                                });

                                final name = result.files.single.name
                                    .toString()
                                    .toLowerCase();
                                if (name.contains('.pdf')) {
                                  setState(() {
                                    flagPDF = true;
                                  });
                                }
                                //  else
                                if (name.contains('.jpg') ||
                                    name.contains('.png') ||
                                    name.contains('.jpeg') |
                                        name.contains('.svg')) {
                                  setState(() {
                                    flagImage = true;
                                  });
                                }
                                setState(() {
                                  extension = name;
                                });
                                final file = result.files.first;
                                setState(() {
                                  uploadedFile = new File(path);
                                });
                                // openFile(file);
                              },
                              icon: Icon(Icons.attach_file, color:Colors.blue.shade900 ,),
                              label: Text('Add an attachment', style: TextStyle(color: Colors.blue.shade900,),), ),
                        if (flagPDF || flagImage)
                          IconButton(
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  uploadedFile = null;
                                  flagPDF = false;
                                  flagImage = false;
                                });
                              },
                              icon: Icon(Icons.remove)),
                        if (flagPDF) SfPdfViewer.file(uploadedFile),
                        if (flagImage) Image.file(uploadedFile),
                        TextButton(
                            onPressed: () async {
                              final isValid = _formKey.currentState.validate();
                              FocusScope.of(context).unfocus();
                              if (isValid) {
                                _formKey.currentState.save();
                              }
                              print(isValid);
                              setState(() {
                                // if (widget.assessments[0].length==0) {
                                //   widget.assessments[0] = {
                                //     'assessmentType': _assessmentType,
                                //     'assessmentName': _assessmentName,
                                //     'day': _day,
                                //     'duration': duration,
                                //     'minutesHours': minsHours,
                                //     'time': formattedTimeOfDay,
                                //     'instructorNotes': _instructorNotes,
                                //   };
                                // } else {

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
                              });
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
                                var newDoc = await FirebaseFirestore.instance
                                    .collection('assessments')
                                    .doc();
                                var newDocRef = await newDoc.get();
                                var documentID = newDocRef.id;
                                var url = "";
                                if (flagPDF || flagImage) {
                                  final ref = FirebaseStorage.instance
                                      .ref()
                                      .child('files')
                                      .child(documentID);
                                  await ref.putFile(uploadedFile);
                                  url = await ref.getDownloadURL();
                                  await FirebaseFirestore.instance
                                      .collection('coursesMedia')
                                      .add({
                                    'courseName': widget.courseName,
                                    'url': url,
                                    'extension': extension,
                                    'caption': _assessmentName,
                                    'path': path,
                                    'courseDocumentID':widget.documentID
                                  });
                                }
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('assessments')
                                      .add({
                                    'courseName': widget.courseName,
                                    'assessmentType': _assessmentType,
                                    'assessmentName': _assessmentName,
                                    'day': _day,
                                    'duration': duration,
                                    'minutesHours': minsHours,
                                    'time': _time,
                                    'instructorNotes': _instructorNotes,
                                    'bodyText': bodyText,
                                    'url': url,
                                    'courseDocumentID':widget.documentID
                                  });
                                } catch (error) {
                                  print(error);
                                  setState(() {
                                    flagError = true;
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
                                    'lecturesFrequency':
                                        widget.lecturesFrequency,
                                    'timings': widget.timings,
                                    'assessments': widget.assessments,
                                    'courseOwnerId': widget.userID,
                                    'enrolledStudents': widget.enrolledStudents,
                                    'documentID': widget.documentID,
                                    'major': widget.major,
                                    'semester': widget.semester,
                                    'url': url
                                  });
                                  print(widget.major);
                                } catch (error) {
                                  print(error);
                                  setState(() {
                                    flagError = true;
                                  });
                                }
                                setState(() {
                                  isLoading = false;
                                });

                                if (!flagError) {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            content: Text(
                                                'Assessment Created Successfuly'),
                                            actions: [
                                              FlatButton(
                                                  onPressed: () {
                                                    print(widget.assessments
                                                        .toString());
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop(
                                                        widget.assessments);
                                                    // Navigator.of(context).pop(widget.assessments);
                                                  },
                                                  child: Text('Dimiss'))
                                            ],
                                          ));
                                }
                              }
                            },
                            child: Text('Create', style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold, fontSize: 16),))
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

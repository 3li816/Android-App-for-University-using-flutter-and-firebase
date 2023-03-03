import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:intl/intl.dart';

class CreateAnnuncementScreen extends StatefulWidget {
  String name;
  @override
  CreateAnnuncementScreen(this.name);
  State<CreateAnnuncementScreen> createState() =>
      _CreateAnnuncementScreenState();
}

class _CreateAnnuncementScreenState extends State<CreateAnnuncementScreen> {
  var uploadedFile;
  var fileName;
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  var flagError = false;
  var courseName = "";
  var flagSent = false;
  var extension = "";
  var courseDocumentID = "";
  var title = "";
  var _expiryDate = "";
  var dateController = TextEditingController();
  var flagPDF = false;
  var flagImage = false;
  var body = "";
  var path;
  var coursesDataSource = [];
  var groupDataSource = [];
  var flagCourseChosen = false;
  //   {
  //     "display": "1",
  //     "value": "1",
  //   },
  //   {
  //     "display": "2",
  //     "value": "2",
  //   },
  //   {
  //     "display": "3",
  //     "value": "3",
  //   },
  //   {
  //     "display": "4",
  //     "value": "4",
  //   },
  //   {
  //     "display": "All Groups",
  //     "value": "All Groups",
  //   },
  // ];
  var group = "";
  var flagViewCourses = false;
  void openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  Function viewMyCourses() {
    if (widget.name == "") {
      Firestore.instance.collection('courses').getDocuments().then((value) {
        value.documents.forEach((element) {
          var data = element.data();
          if (data['courseOwnerId'] == FirebaseAuth.instance.currentUser.uid) {
            setState(() {
              coursesDataSource.add(
                {
                  "display": data['courseName'],
                  "value": data['courseName'],
                },
              );
            });
          }
        });
      });
    } else {
      flagCourseChosen = true;
      setState(() {
        coursesDataSource.add({
          "display": widget.name,
          "value": widget.name,
        });
        courseName = widget.name;
      });
      Firestore.instance.collection('courses').getDocuments().then((value) {
        value.documents.forEach((element) {
          var data = element.data();
          if (data['courseName'] == courseName) {
            setState(() {
              courseDocumentID = data['documentID'];
            });
            for (var timing in data['timings']) {
              // print("in");
              setState(() {
                groupDataSource.add({
                  "display": "Group " +
                      timing['Group'].toString() +
                      " - " +
                      timing['1st Lecture Day'] +
                      " " +
                      timing['1st Lecture Slot'],
                  "value": timing['Group'].toString(),
                });
              });
            }
          }
        });
      });
    }

    setState(() {
      flagViewCourses = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewMyCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Announcement')),
      body: isLoading || !flagViewCourses
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.blue.shade900,
              ),
            )
          : Center(
              child: Card(
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
                              titleText: 'Course Name',
                              hintText: 'Please choose one',
                              errorText: 'Please select one option',
                              value: courseName,
                              onSaved: (value) {
                                setState(() {
                                  courseName = value.toString();
                                });
                              },
                              onChanged: (value) {
                                print("test my courses");
                                //   print(coursesDataSource.toString());
                                setState(() {
                                  groupDataSource = [];
                                  group = "";
                                  courseName = value.toString();
                                  Firestore.instance
                                      .collection('courses')
                                      .getDocuments()
                                      .then((value) {
                                    value.documents.forEach((element) {
                                      var data = element.data();
                                      if (data['courseName'] == courseName) {
                                        for (var timing in data['timings']) {
                                          print("in");
                                          setState(() {
                                            groupDataSource.add({
                                              "display": "Group " +
                                                  timing['Group'].toString() +
                                                  " - " +
                                                  timing['1st Lecture Day'] +
                                                  " " +
                                                  timing['1st Lecture Slot'],
                                              "value":
                                                  timing['Group'].toString(),
                                            });
                                          });
                                        }
                                      }
                                    });
                                  });
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please choose a course name';
                                }
                                return null;
                              },
                              dataSource: coursesDataSource,
                              textField: 'display',
                              valueField: 'value',
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 0),
                            alignment: Alignment.centerLeft,
                            child: DropDownFormField(
                              titleText: 'Group',
                              hintText: 'Please choose one',
                              errorText: 'Please select one option',
                              value: group,
                              onSaved: (value) {
                                setState(() {
                                  group = value.toString();
                                });
                              },
                              onChanged: (value) {
                                setState(() {
                                  group = value.toString();
                                });
                              },
                              dataSource: groupDataSource,
                              textField: 'display',
                              valueField: 'value',
                            ),
                          ),
                          TextFormField(
                            key: ValueKey('title'),
                            autocorrect: true,
                            textCapitalization: TextCapitalization.words,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid title';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Title'),
                            onSaved: (value) {
                              setState(() {
                                title = value.toString();
                              });
                            },
                          ),
                          TextFormField(
                            key: ValueKey('body'),
                            autocorrect: true,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.words,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid body';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Body'),
                            onSaved: (value) {
                              setState(() {
                                body = value.toString();
                              });
                            },
                          ),
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
                              labelText: "Announcement Expiry Date",
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
                                _expiryDate = value.toString();
                              });
                            },
                          ),
                          //FilePickerScreen(),
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
                                  setState(() {
                                    extension = name;
                                  });
                                  print(name + "   name");
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
                                  final file = result.files.first;
                                  setState(() {
                                    uploadedFile = new File(path);
                                  });
                                },
                                icon: Icon(
                                  Icons.attach_file,
                                  color: Colors.blue.shade900,
                                ),
                                label: Text(
                                  'Add an attachment',
                                  style: TextStyle(color: Colors.blue.shade900),
                                )),
                          if (flagPDF || flagImage)
                            IconButton(
                                color: Colors.blue.shade900,
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
                          // Text("In"),
                          TextButton(
                            onPressed: () async {
                              final isValid = _formKey.currentState.validate();
                              FocusScope.of(context).unfocus();
                              print(isValid);
                              if (isValid) {
                                _formKey.currentState.save();
                                setState(() {
                                  isLoading = true;
                                });
                              }
                              FirebaseMessaging firebaseMessaging =
                                  new FirebaseMessaging();
                              if (isValid) {
                                var newDoc = await FirebaseFirestore.instance
                                    .collection('announcements')
                                    .doc();
                                Firestore.instance
                                    .collection('courses')
                                    .getDocuments()
                                    .then((value) {
                                  value.documents.forEach((element) {
                                    var data = element.data();
                                    if (data['courseName'] == courseName) {
                                      setState(() {
                                        courseDocumentID = data['documentID'];
                                      });
                                    }
                                  });
                                });
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
                                    'courseName': courseName,
                                    'url': url,
                                    'extension': extension,
                                    'caption': title,
                                    'path': path,
                                    'courseDocumentID': courseDocumentID,
                                  });
                                }
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('announcements')
                                      .doc(documentID)
                                      .set({
                                    'courseName': courseName,
                                    'title': title,
                                    'body': body,
                                    'group': group,
                                    'expiryDate': _expiryDate,
                                    'documentID': documentID,
                                    'url': url,
                                    'courseDocumentID': courseDocumentID
                                  });
                                } catch (erorr) {
                                  print(erorr);
                                  setState(() {
                                    flagError = true;
                                  });
                                }
                                if (!flagError) {
                                  setState(() {
                                    isLoading = false;
                                    flagImage = false;
                                    flagPDF = false;
                                    uploadedFile = null;
                                  });
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            content: Text(
                                                'Announcement Created Successfuly'),
                                            actions: [
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    if(flagCourseChosen){
                                                      Navigator.of(context).pop();
                                                    }


                                                    setState(() {
                                                      courseName = "";
                                                      group = "";
                                                      _expiryDate = "";
                                                      //dateController.text.c
                                                      dateController.clear();
                                                    });
                                                    _formKey.currentState
                                                        .reset();
                                                  },
                                                  child: Text(
                                                    'Dimiss',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .blue.shade900),
                                                  ))
                                            ],
                                          ));
                                }
                              }
                            },
                            child: Text(
                              'Create',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

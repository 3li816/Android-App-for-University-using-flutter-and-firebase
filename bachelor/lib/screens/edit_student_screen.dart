import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import '/screens/student_home_screen.dart';

class EditStudentScreen extends StatefulWidget {
  EditStudentScreen();
  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final usersRef = Firestore.instance.collection('users');
  final _formKey = GlobalKey<FormState>();
  var firstName = '';
  var lastName = '';
  var email = '';
  var oldEmail = '';
  var gucID = '';
  var lectureGroup = '';
  var major = '';
  var role = '';
  var userID = '';
  var password = '';
  var flagGetDone = false;
  var flagError = false;
  var flagChangeEmail = false;
  var flagChangePassword = false;
  var isLoading = false;
  var majorDataSource = [
    {
      "display": "Business Informatics",
      "value": "Business Informatics",
    },
    {
      "display": "General Engineering",
      "value": "General Engineering",
    },
    {
      "display": "DMET ",
      "value": "DMET",
    },
    {
      "display": "IET ",
      "value": "IET",
    },
    {
      "display": "IET - Communications",
      "value": "IET - Communications",
    },
    {
      "display": "IET - Electronics",
      "value": "IET - Electronics",
    },
    {
      "display": "IET - Networks",
      "value": "IET - Networks",
    },
    {
      "display": "Management ",
      "value": "Management",
    },
    {
      "display": "Mechatronics",
      "value": "Mechatronics",
    },
    {
      "display": "MET - CSEN",
      "value": "MET - CSEN",
    },
    {
      "display": "Pharmacy ",
      "value": "Pharmacy",
    },
    {
      "display": "Production ",
      "value": "Production",
    },
  ];
  Function getStudentData() {
    usersRef.getDocuments().then((value) {
      value.documents.forEach((element) {
        var data = element.data();
        if (data['userID'] == FirebaseAuth.instance.currentUser.uid) {
          setState(() {
            email = data['email'];
            oldEmail = data['email'];
            firstName = data['firstName'];
            lastName = data['lastName'];
            role = data['role'];
            userID = data['userID'];
            major = data['major'];
            gucID = data['gucID'];
            lectureGroup = data['lectureGroup'];
            flagGetDone = true;
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
  }

  @override
  Widget build(BuildContext context) {
    return !flagGetDone || isLoading
        ? Scaffold(
          body: Center(
              child: CircularProgressIndicator(
              color: Colors.blue.shade900,
            )),
        )
        : Scaffold(
            appBar: AppBar(title: Text('Edit My Profile')),
            body: Center(
              child: Card(
                // color: Colors.,
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // Image.network('https://upload.wikimedia.org/wikipedia/commons/0/00/The_German_University_in_Cairo_Official_logo.jpg')
                          TextFormField(
                            key: ValueKey('firstName'),
                            autocorrect: true,
                            textCapitalization: TextCapitalization.words,
                            enableSuggestions: false,
                            initialValue: firstName,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid name';
                              }
                              return null;
                            },
                            decoration:
                                InputDecoration(labelText: 'First Name'),
                            onSaved: (value) {
                              firstName = value.trim().toString();
                            },
                            onChanged: (value) {
                              firstName = value.trim().toString();
                            },
                          ),
                          TextFormField(
                            key: ValueKey('lastName'),
                            autocorrect: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textCapitalization: TextCapitalization.words,
                            initialValue: lastName,
                            enableSuggestions: false,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Last Name'),
                            onSaved: (value) {
                              lastName = value.trim().toString();
                            },
                            onChanged: (value) {
                              lastName = value.trim().toString();
                            },
                          ),
                          if (flagGetDone)
                            TextFormField(
                                key: ValueKey('gucID'),
                                autocorrect: false,
                                initialValue: gucID,
                                textCapitalization: TextCapitalization.none,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enableSuggestions: false,
                                validator: (value) {
                                  final gucIDValidator =
                                      RegExp(r'^[0-9]+[0-9]-+[0-9]+$');
                                  if (value.isEmpty ||
                                      !gucIDValidator.hasMatch(value)) {
                                    return 'Please enter your guc id in the form of xx-';
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'GUC ID',
                                ),
                                onSaved: (value) {
                                  gucID = value.trim().toString();
                                },
                                onChanged: (value) {
                                  gucID = value.trim().toString();
                                }),
                          TextFormField(
                              key: ValueKey('groupNumber'),
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              enableSuggestions: false,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter valid group number';
                                }
                              },
                              initialValue: lectureGroup,
                              decoration: InputDecoration(
                                labelText: 'Group Number',
                              ),
                              onSaved: (value) {
                                lectureGroup = value.trim().toString();
                              },
                              onChanged: (value) {
                                lectureGroup = value.trim().toString();
                              }),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 0),
                            alignment: Alignment.centerLeft,
                            child: DropDownFormField(
                              validator: (value) {
                                if (value.isEmpty) return 'Please Choose Major';
                              },
                              titleText: 'Major',
                              errorText: 'Please Select an option',
                              hintText: 'Please select your major',
                              value: major,
                              onSaved: (value) {
                                setState(() {
                                  major = value.toString();
                                });
                              },
                              onChanged: (value) {
                                setState(() {
                                  major = value.toString();
                                });
                              },
                              dataSource: majorDataSource,
                              textField: 'display',
                              valueField: 'value',
                            ),
                          ),
                          if (flagChangeEmail)
                            TextFormField(
                              key: ValueKey('email'),
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              enableSuggestions: false,
                              validator: (value) {
                                if (value.isEmpty ||
                                    !value.contains('@student.guc.edu.eg')) {
                                  return 'Please enter email in the format @student.guc.edu.eg';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              initialValue: oldEmail,
                              decoration: InputDecoration(
                                labelText: 'GUC Email',
                              ),
                              onSaved: (value) {
                                email = value.trim().toString();
                                setState(() {
                                  flagChangeEmail = true;
                                });
                              },
                              onChanged: (value) {
                                email = value.trim().toString();
                                setState(() {
                                  flagChangeEmail = true;
                                });
                              },
                            ),
                          if (flagChangeEmail)
                            TextFormField(
                              key: ValueKey('password'),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty || value.length < 6) {
                                  return 'Password must be at least 6 characters long.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Please Enter your Password',
                              ),
                              obscureText: true,
                              onSaved: (value) {
                                password = value.trim().toString();
                              },
                              onChanged: (value) {
                                password = value.trim().toString();
                              },
                            ),
                          if (!flagChangeEmail)
                            FlatButton(
                                onPressed: () {
                                  setState(() {
                                    flagChangeEmail = true;
                                  });
                                },
                                child: Text('Change Email',
                                    style: TextStyle(
                                        color: Colors.blue.shade900))),
                          TextButton(
                              onPressed: () async {
                                //Navigator.of(context).pop();
                                // setState(() {
                                //   isLoading = true;
                                // });
                                print(isLoading);

                                final isValid =
                                    _formKey.currentState.validate();
                                FocusScope.of(context).unfocus();
                                if (isValid) {
                                  _formKey.currentState.save();
                                }

                                // if (email != oldEmail) {
                                if (flagChangeEmail) {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: oldEmail, password: password);

                                  await FirebaseAuth.instance.currentUser
                                      .updateEmail(email);
                                }

                                if (email == "") {
                                  setState(() {
                                    email = oldEmail;
                                  });
                                }

                                try {
                                  if (isValid) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                  }
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userID)
                                      .set({
                                    'email': email,
                                    'firstName': firstName,
                                    'lastName': lastName,
                                    'gucID': gucID,
                                    'lectureGroup': lectureGroup,
                                    'major': major,
                                    'role': role,
                                    'userID': userID
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
                                if (!flagError) {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            content: Text(
                                              ' Profile Edited Successfuly',
                                              style: TextStyle(
                                                  color: Colors.blue.shade900),
                                            ),
                                            actions: [
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                   Navigator.of(context).pop();
                                                },
                                                child: Text('Dimiss',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .blue.shade900)),
                                              )
                                            ],
                                          ));
                                }
                              },
                              child: Text('Edit',
                                  style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
    ;
  }
}

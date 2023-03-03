//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/widgets/navigation_bottom_bar.dart';

import './instructor_home_screen.dart';
import '../widgets/navigation_bottom_bar.dart';

class EditInstructorScreen extends StatefulWidget {
  static const routeName = '/instructor-home';
  String firstName;
  String lastName;
  String email;
  //String password;
  String role;
  String userID;

  EditInstructorScreen(); //this.firstName, this.lastName, this.email, this.role, this.userID);
  @override
  State<EditInstructorScreen> createState() => _EditInstructorScreenState();
}

class _EditInstructorScreenState extends State<EditInstructorScreen> {
  final _formKey = GlobalKey<FormState>();
  var _selectedIndex = 0;
  var firstName = "";
  var flagDone = false;
  final usersRef = Firestore.instance.collection('users');
  var lastName = "";
  var email = "";
  var role = "";
  var oldEmail = "";
  var userID = "";
  var flagError = false;
  var password = "";
  var flagChangeEmail = false;
  var flagChangePassword = false;
  var userCredentials =
      EmailAuthProvider.getCredential(email: 'email', password: 'password');
  var isLoading = false;
  Function getInstructorData() {
    usersRef.getDocuments().then((value) {
      value.documents.forEach((element) {
        var data = element.data();
        if (data['userID'] == FirebaseAuth.instance.currentUser.uid) {
          print(data['email']);
          print(data['firstName']);
          print(data['lastName']);
          print(data['role']);

          setState(() {
            oldEmail = data['email'];
            firstName = data['firstName'];
            lastName = data['lastName'];
            role = data['role'];
            userID = data['userID'];
            flagDone = true;
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

  @override
  Widget build(BuildContext context) {
    return !flagDone || isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.blue.shade900)))
        : Scaffold(
            appBar: AppBar(title: Text('Edit My Account')),
            body: isLoading
                ? Center(child: CircularProgressIndicator())
                : Center(
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
                                  decoration:
                                      InputDecoration(labelText: 'Last Name'),
                                  onSaved: (value) {
                                    lastName = value.trim().toString();
                                  },
                                  onChanged: (value) {
                                    lastName = value.trim().toString();
                                  },
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
                                          !value.contains('@guc.edu.eg')) {
                                        return 'Please enter email in the format @guc.edu.eg';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    initialValue:
                                        email == "" ? oldEmail : email,
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
                                      child: Text(
                                        'Change Email',
                                        style: TextStyle(
                                            color: Colors.blue.shade900),
                                      )),
                                TextButton(
                                    onPressed: () async {
                                      //Navigator.of(context).pop();

                                      print(isLoading);

                                      final isValid =
                                          _formKey.currentState.validate();
                                      FocusScope.of(context).unfocus();
                                      if (isValid) {
                                        _formKey.currentState.save();
                                        setState(() {
                                          isLoading = true;
                                        });
                                      }

                                      // if (email != oldEmail) {
                                      print(oldEmail + "email");
                                      if (flagChangeEmail) {
                                        await FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                                email: oldEmail,
                                                password: password);

                                        await FirebaseAuth.instance.currentUser
                                            .updateEmail(email);
                                      }
                                      if (email == "") {
                                        setState(() {
                                          email = oldEmail;
                                        });
                                      }
                                      //}
                                      try {
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(userID)
                                            .set({
                                          'email': email,
                                          'firstName': firstName,
                                          'lastName': lastName,
                                          'role': role,
                                          'userID': userID
                                        });
                                        print('Done');
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
                                        if (isLoading) {
                                          return CircularProgressIndicator();
                                        }
                                        showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                                  content: Text(
                                                      ' Profile Edited Successfuly',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .blue.shade900)),
                                                  actions: [
                                                    FlatButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            flagChangeEmail =
                                                                false;
                                                          });
                                                          Navigator.of(context).pop();
                                                          Navigator.of(context).pop(true);

                                                        },
                                                        child: Text('Dimiss',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue
                                                                    .shade900)))
                                                  ],
                                                ));
                                      }
                                    },
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                          color: Colors.blue.shade900,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ))
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

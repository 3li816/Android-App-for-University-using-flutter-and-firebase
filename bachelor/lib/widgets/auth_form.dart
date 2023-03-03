import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter_complete_guide/main.dart';

enum Role { student, instructor }

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String firstName,
    String lastName,
    String gucId,
    Role role,
    String lectureGroup,
    String major,
    String semester,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _passwordVisible;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }

  final passwordIcon = Icon(Icons.lock);
  final emailIcon = Icon(Icons.account_circle);
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _firstName = '';
  var _lasttName = '';
  var _gucID = '';
  var _userPassword = '';
  var _userRole = Role.student;
  var _lectureGroup = '';
  var _major = '';
  var semester = '';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var semesterDataSource = [
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
    {
      "display": "9",
      "value": "9",
    },
    {
      "display": "10",
      "value": "10",
    },
  ];
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

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _firstName.trim(),
        _lasttName.trim(),
        _gucID.trim(),
        _userRole,
        _lectureGroup.trim(),
        _major.trim(),
        semester.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('firstName'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                      
                      decoration: InputDecoration(labelText: 'First Name'),
                      onSaved: (value) {
                        _firstName = value.toString();
                      },
                      onChanged: (value) {
                        _firstName = value.toString();
                      },
                    ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('lastName'),
                      autocorrect: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Last Name'),
                      onSaved: (value) {
                        _lasttName = value.toString();
                      },
                      onChanged: (value) {
                        _lasttName = value.toString();
                      },
                    ),
                  TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    controller: _emailController,
                    textCapitalization: TextCapitalization.none,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    enableSuggestions: false,
                    validator: (value) {
                      if (_userRole.name == 'student' &&
                          !value.contains('@student.guc.edu.eg') &&
                          !_isLogin) {
                        return 'Please enter email in the format @student.guc.edu.eg';
                      }
                      if (value.isEmpty) {
                        return 'Please enter a valid email address.';
                      }
                      if (!value.contains('@guc.edu.eg') &&
                          !value.contains('@student.guc.edu.eg')) {
                        return 'Please enter your guc email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'GUC Email',
                        icon: _isLogin ? emailIcon : null),
                    onSaved: (value) {
                      _userEmail = value.toString();
                    },
                    onChanged: (value) {
                      _userEmail = value.toString();
                    },
                  ),
                  if (!_isLogin && _userRole.name == 'student')
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                      alignment: Alignment.centerLeft,
                      child: DropDownFormField(
                        validator: (value) {
                          if (value.isEmpty) return 'Please Choose Major';
                        },
                        titleText: 'Semester',
                        errorText: 'Please Select an option',
                        hintText: 'Please select your Semester',
                        value: semester,
                        onSaved: (value) {
                          setState(() {
                            semester = value.toString();
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            semester = value.toString();
                          });
                        },
                        dataSource: semesterDataSource,
                        textField: 'display',
                        valueField: 'value',
                      ),
                    ),
                  if (!_isLogin && _userRole.name == 'student')
                    TextFormField(
                      key: ValueKey('gucID'),
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: (value) {
                        final gucIDValidator = RegExp(r'^[0-9]+[0-9]-+[0-9]+$');
                        if (value.isEmpty || !gucIDValidator.hasMatch(value)) {
                          return 'Please enter your guc id in the form of xx-';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'GUC ID',
                      ),
                      onSaved: (value) {
                        _gucID = value.toString();
                      },
                      onChanged: (value) {
                        _gucID = value.toString();
                      },
                    ),
                  if (!_isLogin && _userRole.name == 'student')
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                      alignment: Alignment.centerLeft,
                      child: DropDownFormField(
                        validator: (value) {
                          if (value.isEmpty) return 'Please Choose Major';
                        },
                        titleText: 'Major',
                        errorText: 'Please Select an option',
                        hintText: 'Please select your major',
                        value: _major,
                        onSaved: (value) {
                          setState(() {
                            _major = value.toString();
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            _major = value.toString();
                          });
                        },
                        dataSource: majorDataSource,
                        textField: 'display',
                        valueField: 'value',
                      ),
                    ),

                  if (!_isLogin && _userRole.name == 'student')
                    TextFormField(
                      key: ValueKey('lectureGroup'),
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      textCapitalization: TextCapitalization.none,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      enableSuggestions: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your Lecture Group';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Lecture Group',
                      ),
                      onSaved: (value) {
                        _lectureGroup = value.toString();
                      },
                      onChanged: (value) {
                        _lectureGroup = value.toString();
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    controller: _passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return 'Password must be at least 6 characters long.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(!_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        labelText: 'Password',
                        icon: _isLogin ? passwordIcon : null),
                    obscureText: !_passwordVisible,
                    onSaved: (value) {
                      _userPassword = value.toString();
                    },
                    onChanged: (value) {
                      _userPassword = value.toString();
                    },
                  ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(color: Colors.blue.shade900,),
                  if (!widget.isLoading)
                    ElevatedButton(
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Colors.black,
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account', 
                          style: TextStyle(decoration: TextDecoration.underline, 
                          color: Colors.blue.shade900, fontSize: 15, fontWeight: FontWeight.bold ),),
                      onPressed: () {
                        if (_isLogin) {
                          setState(() {
                            _emailController.clear();
                            _passwordController.clear();
                          });

                          showDialog(
                            context: context,
                            builder: (_) => SizedBox(
                              width: MediaQuery.of(context).size.width*0.8,
                              child: AlertDialog(
                                buttonPadding: const EdgeInsets.symmetric(
                                    horizontal: 55, vertical: 10),
                                content: Text(
                                  'Are you a Student or an Instructor?',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16, 
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0))),
                                elevation: 20,
                                actions: [
                                  TextButton(
                                    //style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((_) => Colors.blue.shade900)) ,
                                    onPressed: () {
                                      setState(() {
                                        flagUser = 'instructor';
                                        _userRole = Role.instructor;
                                        Navigator.of(context).pop();
                                        _isLogin = !_isLogin;
                                      });
                                    },
                                    child: Text('Instructor', style: TextStyle(color: Colors.blue.shade900, fontSize: 15), ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        flagUser = 'student';
                                        _userRole = Role.student;
                                        Navigator.of(context).pop();
                                        _isLogin = !_isLogin;
                                      });
                                    },
                                    child: Text('Student', style: TextStyle(color: Colors.blue.shade900, fontSize: 15)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

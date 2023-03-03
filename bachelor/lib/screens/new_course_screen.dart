import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:provider/provider.dart';
import '../providers/course.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class NewCourseScreen extends StatefulWidget {
  //final Function refresh;
  List myCourses;
  NewCourseScreen(this.myCourses);
  static const routeName = '/createCourse';

  @override
  State<NewCourseScreen> createState() => _NewCourseFormState();
}

class _NewCourseFormState extends State<NewCourseScreen> {
  var currentUserID = FirebaseAuth.instance.currentUser.uid;
  final userRef = Firestore.instance.collection('users');
  final _formKey = GlobalKey<FormState>();
  var _courseName = "";
  var _courseCode = "";
  var _creditHours = "";
  var semester = "";
  int groups = 1;
  var documentID = "";
  var major = "";
  var _courseOwner =
      ""; // stores user id (uid) of Instructor who created Course
  var _enrolledStudents = []; // stores uid of all enrolled students
  var _otherInstructor = []; // stores uid of other imstructors
  var _assessment = {};
  var _numberOfGroups = "";
  var _lectureFrequency = "";
  var flagError = false;

  var _day1Group1 = "";
  var _slot1Group1 = "";
  var _location1Group1 = "";
  var _day1Group2 = "";
  var _slot1Group2 = "";
  var _location1Group2 = "";
  var _day1Group3 = "";
  var _slot1Group3 = "";
  var _location1Group3 = "";
  var _day1Group4 = "";
  var _slot1Group4 = "";
  var _location1Group4 = "";

  var _day2Group1 = "";
  var _slot2Group1 = "";
  var _location2Group1 = "";
  var _day2Group2 = "";
  var _slot2Group2 = "";
  var _location2Group2 = "";
  var _day2Group3 = "";
  var _slot2Group3 = "";
  var _location2Group3 = "";
  var _day2Group4 = "";
  var _slot2Group4 = "";
  var _location2Group4 = "";

  var _day2 = "";
  var _slot2 = "";
  var _location2 = "";
  var group1 = '';
  var group2 = '';
  var group3 = '';
  var group4 = '';

  var flagBiweekly = false;
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
      "display": "Saturday",
      "value": "Saturday",
    },
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
    return ChangeNotifierProvider(
      create: (context) =>
          Course(_courseName, _courseCode, _creditHours, _numberOfGroups),
      child: Scaffold(
        appBar: AppBar(title: Text('Create Course')),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a valid course name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Course Name'),
                      onSaved: (value) {
                        setState(() {
                          _courseName = value;
                        });
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
                      enableSuggestions: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                      alignment: Alignment.centerLeft,
                      child: DropDownFormField(
                        validator: (value) {
                          if (value==null) return 'Please Choose Major';
                        },
                        titleText: 'Major',
                        errorText: 'Please Select an option',
                        hintText: 'Please select major',
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
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                      alignment: Alignment.centerLeft,
                      child: DropDownFormField(
                        validator: (value) {
                          if (value==null) return 'Please Choose Semester';
                        },
                        titleText: 'Semester',
                        errorText: 'Please Select an option',
                        hintText: 'Please select Semester',
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
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                      alignment: Alignment.centerLeft,
                      child: DropDownFormField(
                        validator: (value) {
                          if (value==null) return 'Please Choose Number of Credit Hours';
                        },
                        titleText: 'Credit Hours',
                        hintText: 'Please choose one',
                        errorText: 'Please select one option',
                        value: _creditHours,
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
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                      alignment: Alignment.centerLeft,
                      child: DropDownFormField(
                        titleText: 'Number of Groups',
                        hintText: 'Please choose one',
                        errorText: 'Please select one option',
                        value: _numberOfGroups,
                        validator: (value) {
                          if (value==null) return 'Please Choose Number of Groups';
                        },
                        onSaved: (value) {
                          setState(() {
                            _numberOfGroups = value.toString();
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            _numberOfGroups = value.toString();
                          });
                          if (_numberOfGroups == '2') {
                            setState(() {
                              groups = 2;
                            });
                          } else if (_numberOfGroups == '3') {
                            setState(() {
                              groups = 3;
                            });
                          } else if (_numberOfGroups == '4') {
                            setState(() {
                              groups = 4;
                            });
                          } else {
                            setState(() {
                              groups = 1;
                            });
                          }
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
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                      alignment: Alignment.centerLeft,
                      child: DropDownFormField(
                        titleText: 'Lectures Frequency',
                        hintText: 'Please choose one',
                        errorText: 'Please select one option',
                        value: _lectureFrequency,
                        validator: (value) {
                          if (value==null) return 'Please Choose Lectures Frequency';
                        },
                        onSaved: (value) {
                          setState(() {
                            _lectureFrequency = value.toString();
                          });

                          if (value.toString() == 'Twice a week') {
                            setState(() {
                              flagBiweekly = true;
                            });
                          } else {
                            setState(() {
                              flagBiweekly = false;
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
                          } else {
                            setState(() {
                              flagBiweekly = false;
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
                    for (int i = 1; i <= groups; i++)
                      Row(children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 0),
                            alignment: Alignment.centerLeft,
                            child: DropDownFormField(
                              titleText: 'Group',
                              hintText: 'Please choose one',
                              errorText: 'Please select one option',
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Choose Group';
                                }
                              },
                              value: i == 1
                                  ? '1'
                                  : i == 2
                                      ? '2'
                                      : i == 3
                                          ? '3'
                                          : '4',
                              // onSaved: (value) {
                              //   if (i == 1) {
                              //     setState(() {
                              //       group1 = value.toString();
                              //     });
                              //   } else if (i == 2) {
                              //     setState(() {
                              //       group2 = value.toString();
                              //     });
                              //   } else if (i == 3) {
                              //     setState(() {
                              //       group3 = value.toString();
                              //     });
                              //   } else {
                              //     setState(() {
                              //       group4 = value.toString();
                              //     });
                              //   }
                              // },
                              // onChanged: (value) {
                              //   if (i == 1) {
                              //     setState(() {
                              //       group1 = value.toString();
                              //     });
                              //   } else if (i == 2) {
                              //     setState(() {
                              //       group2 = value.toString();
                              //     });
                              //   } else if (i == 3) {
                              //     setState(() {
                              //       group3 = value.toString();
                              //     });
                              //   } else {
                              //     setState(() {
                              //       group4 = value.toString();
                              //     });
                              //   }
                              // },
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
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 0),
                            alignment: Alignment.centerLeft,
                            child: DropDownFormField(
                              titleText: 'Lecture Day',
                              hintText: 'Please choose one',
                              errorText: 'Please select one option',
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Choose Day';
                                }
                              },
                              value: i == 1
                                  ? _day1Group1
                                  : i == 2
                                      ? _day1Group2
                                      : i == 3
                                          ? _day1Group3
                                          : _day1Group4,
                              onSaved: (value) {
                                if (i == 1) {
                                  setState(() {
                                    _day1Group1 = value.toString();
                                  });
                                } else if (i == 2) {
                                  setState(() {
                                    _day1Group2 = value.toString();
                                  });
                                } else if (i == 3) {
                                  setState(() {
                                    _day1Group3 = value.toString();
                                  });
                                } else {
                                  setState(() {
                                    _day1Group4 = value.toString();
                                  });
                                }
                              },
                              onChanged: (value) {
                                if (i == 1) {
                                  setState(() {
                                    _day1Group1 = value.toString();
                                  });
                                } else if (i == 2) {
                                  setState(() {
                                    _day1Group2 = value.toString();
                                  });
                                } else if (i == 3) {
                                  setState(() {
                                    _day1Group3 = value.toString();
                                  });
                                } else {
                                  setState(() {
                                    _day1Group4 = value.toString();
                                  });
                                }
                              },
                              dataSource: days,
                              textField: 'display',
                              valueField: 'value',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 0),
                            alignment: Alignment.centerLeft,
                            child: DropDownFormField(
                              titleText: 'Slot',
                              errorText: 'Please select one option',
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Choose Slot';
                                }
                              },
                              hintText: 'Choose One',
                              value: i == 1
                                  ? _slot1Group1
                                  : i == 2
                                      ? _slot1Group2
                                      : i == 3
                                          ? _slot1Group3
                                          : _slot1Group4,
                              onSaved: (value) {
                                if (i == 1) {
                                  setState(() {
                                    _slot1Group1 = value.toString();
                                  });
                                } else if (i == 2) {
                                  setState(() {
                                    _slot1Group2 = value.toString();
                                  });
                                } else if (i == 3) {
                                  setState(() {
                                    _slot1Group3 = value.toString();
                                  });
                                } else {
                                  setState(() {
                                    _slot1Group4 = value.toString();
                                  });
                                }
                              },
                              onChanged: (value) {
                                if (i == 1) {
                                  setState(() {
                                    _slot1Group1 = value.toString();
                                  });
                                } else if (i == 2) {
                                  setState(() {
                                    _slot1Group2 = value.toString();
                                  });
                                } else if (i == 3) {
                                  setState(() {
                                    _slot1Group3 = value.toString();
                                  });
                                } else {
                                  setState(() {
                                    _slot1Group4 = value.toString();
                                  });
                                }
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid location';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Location'),
                            onSaved: (value) {
                              if (i == 1) {
                                setState(() {
                                  _location1Group1 = value.toString();
                                });
                              } else if (i == 2) {
                                setState(() {
                                  _location1Group2 = value.toString();
                                });
                              } else if (i == 3) {
                                setState(() {
                                  _location1Group3 = value.toString();
                                });
                              } else {
                                setState(() {
                                  _location1Group4 = value.toString();
                                });
                              }
                            },
                            onChanged: (value) {
                              if (i == 1) {
                                setState(() {
                                  _location1Group1 = value.toString();
                                });
                              } else if (i == 2) {
                                setState(() {
                                  _location1Group2 = value.toString();
                                });
                              } else if (i == 3) {
                                setState(() {
                                  _location1Group3 = value.toString();
                                });
                              } else {
                                setState(() {
                                  _location1Group4 = value.toString();
                                });
                              }
                            },
                          ),
                        ),
                      ]),
                    if (flagBiweekly)
                      for (int i = 1; i <= groups; i++)
                        Row(children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 0),
                              alignment: Alignment.centerLeft,
                              child: DropDownFormField(
                                titleText: 'Group',
                                hintText: 'Please choose one',
                                errorText: 'Please select one option',
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please Choose Group';
                                  }
                                },
                                value: i == 1
                                    ? '1'
                                    : i == 2
                                        ? '2'
                                        : i == 3
                                            ? '3'
                                            : '4',
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
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 0),
                              alignment: Alignment.centerLeft,
                              child: DropDownFormField(
                                titleText: 'Lecture Day',
                                hintText: 'Please choose one',
                                errorText: 'Please select one option',
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please Choose Day';
                                  }
                                },
                                value: i == 1
                                    ? _day2Group1
                                    : i == 2
                                        ? _day2Group2
                                        : i == 3
                                            ? _day2Group3
                                            : _day2Group4,
                                onSaved: (value) {
                                  if (i == 1) {
                                    setState(() {
                                      _day2Group1 = value.toString();
                                    });
                                  } else if (i == 2) {
                                    setState(() {
                                      _day2Group2 = value.toString();
                                    });
                                  } else if (i == 3) {
                                    setState(() {
                                      _day2Group3 = value.toString();
                                    });
                                  } else {
                                    setState(() {
                                      _day2Group4 = value.toString();
                                    });
                                  }
                                },
                                onChanged: (value) {
                                  if (i == 1) {
                                    setState(() {
                                      _day2Group1 = value.toString();
                                    });
                                  } else if (i == 2) {
                                    setState(() {
                                      _day2Group2 = value.toString();
                                    });
                                  } else if (i == 3) {
                                    setState(() {
                                      _day2Group3 = value.toString();
                                    });
                                  } else {
                                    setState(() {
                                      _day2Group4 = value.toString();
                                    });
                                  }
                                },
                                dataSource: days,
                                textField: 'display',
                                valueField: 'value',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 0),
                              alignment: Alignment.centerLeft,
                              child: DropDownFormField(
                                titleText: 'Slot',
                                errorText: 'Please select one option',
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please Choose Slot';
                                  }
                                },
                                hintText: 'Choose One',
                                value: i == 1
                                    ? _slot2Group1
                                    : i == 2
                                        ? _slot2Group2
                                        : i == 3
                                            ? _slot2Group3
                                            : _slot2Group4,
                                onSaved: (value) {
                                  if (i == 1) {
                                    setState(() {
                                      _slot2Group1 = value.toString();
                                    });
                                  } else if (i == 2) {
                                    setState(() {
                                      _slot2Group2 = value.toString();
                                    });
                                  } else if (i == 3) {
                                    setState(() {
                                      _slot2Group3 = value.toString();
                                    });
                                  } else {
                                    setState(() {
                                      _slot2Group4 = value.toString();
                                    });
                                  }
                                },
                                onChanged: (value) {
                                  if (i == 1) {
                                    setState(() {
                                      _slot2Group1 = value.toString();
                                    });
                                  } else if (i == 2) {
                                    setState(() {
                                      _slot2Group2 = value.toString();
                                    });
                                  } else if (i == 3) {
                                    setState(() {
                                      _slot2Group3 = value.toString();
                                    });
                                  } else {
                                    setState(() {
                                      _slot2Group4 = value.toString();
                                    });
                                  }
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a valid location';
                                }
                                return null;
                              },
                              decoration:
                                  InputDecoration(labelText: 'Location'),
                              onSaved: (value) {
                                if (i == 1) {
                                  setState(() {
                                    _location2Group1 = value.toString();
                                  });
                                } else if (i == 2) {
                                  setState(() {
                                    _location2Group2 = value.toString();
                                  });
                                } else if (i == 3) {
                                  setState(() {
                                    _location2Group3 = value.toString();
                                  });
                                } else {
                                  setState(() {
                                    _location2Group4 = value.toString();
                                  });
                                }
                              },
                              onChanged: (value) {
                                if (i == 1) {
                                  setState(() {
                                    _location2Group1 = value.toString();
                                  });
                                } else if (i == 2) {
                                  setState(() {
                                    _location2Group2 = value.toString();
                                  });
                                } else if (i == 3) {
                                  setState(() {
                                    _location2Group3 = value.toString();
                                  });
                                } else {
                                  setState(() {
                                    _location2Group4 = value.toString();
                                  });
                                }
                              },
                            ),
                          ),
                        ]),
                    TextButton(
                        onPressed: () async {
                          var newDoc = await FirebaseFirestore.instance
                              .collection('courses')
                              .doc();
                          var newDocRef = await newDoc.get();
                          //  var documentID = "";
                          final isValid = _formKey.currentState.validate();
                          FocusScope.of(context).unfocus();
                          if (isValid) {
                            _formKey.currentState.save();
                          }
                          var course = new Course(_courseName, _courseCode,
                              _creditHours, _numberOfGroups);
                          var timings;
                          if (flagBiweekly) {
                            if (groups == 1) {
                              timings = [
                                {
                                  'Group': 1,
                                  '1st Lecture Day': _day1Group1,
                                  '1st Lecture Slot': _slot1Group1,
                                  '1st Lecture Location': _location1Group1,
                                  '2nd Lecture Day': _day2Group1,
                                  '2nd Lecture Slot': _slot2Group1,
                                  '2nd Lecture Location': _location2Group1,
                                }
                              ];
                            } else if (groups == 2) {
                              timings = [
                                {
                                  'Group': '1',
                                  '1st Lecture Day': _day1Group1,
                                  '1st Lecture Slot': _slot1Group1,
                                  '1st Lecture Location': _location1Group1,
                                  '2nd Lecture Day': _day2Group1,
                                  '2nd Lecture Slot': _slot2Group1,
                                  '2nd Lecture Location': _location2Group1,
                                },
                                {
                                  'Group': '2',
                                  '1st Lecture Day': _day1Group2,
                                  '1st Lecture Slot': _slot1Group2,
                                  '1st Lecture Location': _location1Group2,
                                  '2nd Lecture Day': _day2Group2,
                                  '2nd Lecture Slot': _slot2Group2,
                                  '2nd Lecture Location': _location2Group2,
                                },
                              ];
                            } else if (groups == 3) {
                              timings = [
                                {
                                  'Group': '1',
                                  '1st Lecture Day': _day1Group1,
                                  '1st Lecture Slot': _slot1Group1,
                                  '1st Lecture Location': _location1Group1,
                                  '2nd Lecture Day': _day2Group1,
                                  '2nd Lecture Slot': _slot2Group1,
                                  '2nd Lecture Location': _location2Group1,
                                },
                                {
                                  'Group': '2',
                                  '1st Lecture Day': _day1Group2,
                                  '1st Lecture Slot': _slot1Group2,
                                  '1st Lecture Location': _location1Group2,
                                  '2nd Lecture Day': _day2Group2,
                                  '2nd Lecture Slot': _slot2Group2,
                                  '2nd Lecture Location': _location2Group2,
                                },
                                {
                                  'Group': '3',
                                  '1st Lecture Day': _day1Group3,
                                  '1st Lecture Slot': _slot1Group3,
                                  '1st Lecture Location': _location1Group3,
                                  '2nd Lecture Day': _day2Group3,
                                  '2nd Lecture Slot': _slot2Group3,
                                  '2nd Lecture Location': _location2Group3,
                                },
                              ];
                            } else {
                              timings = [
                                {
                                  'Group': '1',
                                  '1st Lecture Day': _day1Group1,
                                  '1st Lecture Slot': _slot1Group1,
                                  '1st Lecture Location': _location1Group1,
                                  '2nd Lecture Day': _day2Group1,
                                  '2nd Lecture Slot': _slot2Group1,
                                  '2nd Lecture Location': _location2Group1,
                                },
                                {
                                  'Group': '2',
                                  '1st Lecture Day': _day1Group2,
                                  '1st Lecture Slot': _slot1Group2,
                                  '1st Lecture Location': _location1Group2,
                                  '2nd Lecture Day': _day2Group2,
                                  '2nd Lecture Slot': _slot2Group2,
                                  '2nd Lecture Location': _location2Group2,
                                },
                                {
                                  'Group': '3',
                                  '1st Lecture Day': _day1Group3,
                                  '1st Lecture Slot': _slot1Group3,
                                  '1st Lecture Location': _location1Group3,
                                  '2nd Lecture Day': _day2Group3,
                                  '2nd Lecture Slot': _slot2Group3,
                                  '2nd Lecture Location': _location2Group3,
                                },
                                {
                                  'Group': '4',
                                  '1st Lecture Day': _day1Group4,
                                  '1st Lecture Slot': _slot1Group4,
                                  '1st Lecture Location': _location1Group4,
                                  '2nd Lecture Day': _day2Group4,
                                  '2nd Lecture Slot': _slot2Group4,
                                  '2nd Lecture Location': _location2Group4,
                                },
                              ];
                            }
                          } else {
                            if (groups == 1) {
                              timings = [
                                {
                                  'Group': 1,
                                  '1st Lecture Day': _day1Group1,
                                  '1st Lecture Slot': _slot1Group1,
                                  '1st Lecture Location': _location1Group1
                                }
                              ];
                            } else if (groups == 2) {
                              timings = [
                                {
                                  'Group': '1',
                                  '1st Lecture Day': _day1Group1,
                                  '1st Lecture Slot': _slot1Group1,
                                  '1st Lecture Location': _location1Group1
                                },
                                {
                                  'Group': '2',
                                  '1st Lecture Day': _day1Group2,
                                  '1st Lecture Slot': _slot1Group2,
                                  '1st Lecture Location': _location1Group2
                                },
                              ];
                            } else if (groups == 3) {
                              timings = [
                                {
                                  'Group': '1',
                                  '1st Lecture Day': _day1Group1,
                                  '1st Lecture Slot': _slot1Group1,
                                  '1st Lecture Location': _location1Group1
                                },
                                {
                                  'Group': '2',
                                  '1st Lecture Day': _day1Group2,
                                  '1st Lecture Slot': _slot1Group2,
                                  '1st Lecture Location': _location1Group2
                                },
                                {
                                  'Group': '3',
                                  '1st Lecture Day': _day1Group3,
                                  '1st Lecture Slot': _slot1Group3,
                                  '1st Lecture Location': _location1Group3
                                },
                              ];
                            } else {
                              timings = [
                                {
                                  'Group': '1',
                                  '1st Lecture Day': _day1Group1,
                                  '1st Lecture Slot': _slot1Group1,
                                  '1st Lecture Location': _location1Group1
                                },
                                {
                                  'Group': '2',
                                  '1st Lecture Day': _day1Group2,
                                  '1st Lecture Slot': _slot1Group2,
                                  '1st Lecture Location': _location1Group2
                                },
                                {
                                  'Group': '3',
                                  '1st Lecture Day': _day1Group3,
                                  '1st Lecture Slot': _slot1Group3,
                                  '1st Lecture Location': _location1Group3
                                },
                                {
                                  'Group': '4',
                                  '1st Lecture Day': _day1Group4,
                                  '1st Lecture Slot': _slot1Group4,
                                  '1st Lecture Location': _location1Group4
                                },
                              ];
                            }
                          }
                          try {
                            course.createCourse(
                              _courseName,
                              _courseCode,
                              major, 
                              semester,
                              _creditHours,
                              _numberOfGroups,
                              _lectureFrequency,
                              timings,
                              currentUserID,
                              newDocRef.id,
                            );
                          } catch (error) {
                            setState(() {
                              flagError = true;
                            });
                            print(error);
                          }
                          setState(() {
                            widget.myCourses.add({
                              'courseName': _courseName,
                              'courseCode': _courseCode,
                              'creditHours': _creditHours,
                              'numberOfGroups': _numberOfGroups,
                              'lecturesFrequency': _lectureFrequency,
                              'timings': timings,
                              'assessments': [{}],
                              'courseOwnerId': _courseOwner,
                              'documentID': newDocRef.id,
                              'enrolledStudents': [],
                            });
                          });
                          // widget.refresh();
                          //  Navigator.of(context).pushNamedAndRemoveUntil(
                          //  InstructorHomeScreen.routeName, (route) => false);
                          // Navigator.of(context)
                          //   .pushNamed(InstructorHomeScreen.routeName);
                          //   pushNamed(context, InstructorHomeScreen.routeName);
                          if (!flagError) {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      content:
                                          Text('Course Created Successfuly'),
                                      actions: [
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context)
                                                  .pop(widget.myCourses);
                                            },
                                            child: Text('Dimiss', style: TextStyle(color: Colors.blue.shade900, fontSize: 16, fontWeight: FontWeight.bold
                                              )))
                                      ],
                                    ));
                          }
                        },
                        child: Text('Create', style: TextStyle(color: Colors.blue.shade900, fontSize: 16, fontWeight: FontWeight.bold),))
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

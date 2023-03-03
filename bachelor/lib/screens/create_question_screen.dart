import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateQuestionScreen extends StatefulWidget {
  String courseName;
  String courseDocumentID;

  CreateQuestionScreen(
    this.courseName,
    this.courseDocumentID
  );

  @override
  State<CreateQuestionScreen> createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  var flagError = false;
  var title = "";
  var body = "";
  var instructorAnswer = "";
  var createdAt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post Question')),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
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
                        TextFormField(
                          key: ValueKey('title'),
                          autocorrect: true,
                          textCapitalization: TextCapitalization.words,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.multiline,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid title';
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
                        TextButton(
                            onPressed: () async {
                              final isValid = _formKey.currentState.validate();
                              FocusScope.of(context).unfocus();
                              if (isValid) {
                                _formKey.currentState.save();
                              }
                              var newDoc = await FirebaseFirestore.instance
                                  .collection('discussions')
                                  .doc();
                              var newDocRef = await newDoc.get();
                              try {
                                await FirebaseFirestore.instance
                                    .collection('discussions')
                                    .doc(newDocRef.id)
                                    .set({
                                  'questionTitle': title,
                                  'questionBody': body,
                                  'instructorAnswer': '',
                                  'courseName': widget.courseName,
                                  'createdAt': DateTime.now(),
                                  'documentID': newDocRef.id,
                                  'answered': false,
                                  'courseDocumentID':widget.courseDocumentID,
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
                                              'Question Posted Successfuly'),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Dimiss',style: TextStyle(color:Colors.blue.shade900, fontWeight: FontWeight.bold, fontSize: 16 )))
                                          ],
                                        ));
                              }
                            },
                            child: Text('Post', style: TextStyle(color:Colors.blue.shade900, fontWeight: FontWeight.bold, fontSize: 16 ),))
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

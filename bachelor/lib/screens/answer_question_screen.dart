import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnswerQuestionScreen extends StatefulWidget {
  var questions;
  int index;
  String courseName;
  String courseDocumentID;
  AnswerQuestionScreen(this.questions, this.index, this.courseName, this.courseDocumentID);
  @override
  State<AnswerQuestionScreen> createState() => _AnswerQuestionScreenState();
}

class _AnswerQuestionScreenState extends State<AnswerQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  var answer = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.courseName)),
      body: Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: 300,
            child: Card(
              // color: Colors.,
              margin: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Text(widget.questions
                                  .elementAt(widget.index)['questionTitle'],style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18, 
                                          color: Colors.blue.shade900 )),
                            ),
                            SizedBox(height: 5,),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(widget.questions
                                  .elementAt(widget.index)['questionBody'], style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16
                                  ),),
                            ),
                            TextFormField(
                              key: ValueKey('answer'),
                              autocorrect: true,
                              keyboardType: TextInputType.multiline,
                              textCapitalization: TextCapitalization.words,
                              enableSuggestions: false,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a valid answer';
                                }
                                return null;
                              },
                              decoration: InputDecoration(labelText: 'Answer'),
                              onSaved: (value) {
                                answer = value.trim().toString();
                              },
                              onChanged: (value) {
                                answer = value.trim().toString();
                              },
                            ),
                            TextButton(
                                onPressed: () async {
                                  final isValid =
                                      _formKey.currentState.validate();
                                  FocusScope.of(context).unfocus();
                                  if (isValid) {
                                    _formKey.currentState.save();
                                    var documentID = widget.questions
                                      .elementAt(widget.index)['documentID'];
                                  var questionBody = widget.questions
                                      .elementAt(widget.index)['questionBody'];
                                  var questionTitle = widget.questions
                                      .elementAt(widget.index)['questionTitle'];
                                  var createdAt = widget.questions
                                      .elementAt(widget.index)['createdAt'];
                                  await FirebaseFirestore.instance
                                      .collection('discussions')
                                      .doc(documentID)
                                      .set({
                                    'questionTitle': questionTitle,
                                    'questionBody': questionBody,
                                    'instructorAnswer': answer,
                                    'courseName': widget.courseName,
                                    'createdAt': createdAt,
                                    'documentID': documentID,
                                    'answered': true,
                                    'courseDocumentID':widget.courseDocumentID
                                  });
                                  setState(() {
                                    widget.questions.elementAt(
                                        widget.index)['answered'] = true;
                                    widget.questions.elementAt(widget.index)[
                                        'instructorAnswer'] = answer;
                                  });

                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            content: Text(
                                                ' Question Posted Successfuly'),
                                            actions: [
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context)
                                                        .pop(widget.questions);
                                                  },
                                                  child: Text('Dimiss',style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold, fontSize: 16)))
                                            ],
                                          ));
  
                                  }
                                                                },
                                child: Text('Post Answer', style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold, fontSize: 16),))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

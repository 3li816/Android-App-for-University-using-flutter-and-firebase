import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './create_question_screen.dart';

class QuestionsAnswersScreen extends StatefulWidget {
  String courseName;
  String courseDocumentID;

  QuestionsAnswersScreen(this.courseName, this.courseDocumentID);

  @override
  State<QuestionsAnswersScreen> createState() => _QuestionsAnswersScreenState();
}

class _QuestionsAnswersScreenState extends State<QuestionsAnswersScreen> {
  var questions = [];
  getCourseQuestions() {
    Firestore.instance.collection('discussions').getDocuments().then((value) {
      value.documents.forEach((element) {
        var data = element.data();
        if (data['courseName'] ==
            widget
                .courseName /*&& data['courseDocumentID']==widget.courseDocumentID*/) {
          if (data['answered'] == true) {
            setState(() {
              questions.add({
                'questionTitle': data['questionTitle'],
                'questionBody': data['questionBody'],
                'instructorAnswer': data['instructorAnswer'],
                'courseName': data['courseName'],
                'createdAt': data['createdAt'],
                'documentID': data['documentID'],
                'answered': data['answered']
              });
            });
          }
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCourseQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: TextButton(
        onPressed: () async {
          print(questions.toString());
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateQuestionScreen(
                      widget.courseName, widget.courseDocumentID)));
        },
        child: Text(
          "Ask a question",
          style: TextStyle(
              color: Colors.blue.shade900,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
      appBar: AppBar(
        title: Text('Questions and Answers'),
      ),
      body: Column(children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  background: Container(color: Colors.red),
                  key: Key(index.toString()),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Center(
                            child: Text(
                          questions.elementAt(index)['questionTitle'],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900),
                        )),
                        SizedBox(
                          height: 8,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              questions.elementAt(index)['questionBody'],
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue.shade900,
                                  fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              questions.elementAt(index)['instructorAnswer'],
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.bold  ),
                            )),
                        Divider(
                          color: Colors.blue.shade900,
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionsScreenInstructor extends StatefulWidget {
  String courseName;
  var questions;
  var courseDocumentID;

  QuestionsScreenInstructor(
      this.courseName, this.questions, this.courseDocumentID);
  @override
  State<QuestionsScreenInstructor> createState() =>
      _QuestionsScreenInstructorState();
}

class _QuestionsScreenInstructorState extends State<QuestionsScreenInstructor> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _formKeys = [];

  var flagsValid = [];
  var controllers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var question in widget.questions) {
      setState(() {
        flagsValid.add(false);
        _formKeys.add(new GlobalKey<FormState>());
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.courseName),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          if (widget.questions.length == 0)
            Container(
              alignment: Alignment.center,
              child: EmptyWidget(
                image: null,
                packageImage: PackageImage.Image_3,
                title: 'No Questions',
                subTitle: 'No  questions available yet',
                titleTextStyle: TextStyle(
                  fontSize: 22,
                  color: Color(0xff9da9c7),
                  fontWeight: FontWeight.w500,
                ),
                subtitleTextStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xffabb8d6),
                ),
              ),
            ),
          if (widget.questions.length > 0)
            SizedBox(
              height: 10,
            ),
          if (widget.questions.length > 0)
          SizedBox(height: 15,),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.84,
              child: ListView.builder(
                  itemCount: widget.questions.length,
                  itemBuilder: (BuildContext context, int index) {
                    controllers.add("");
                    return SingleChildScrollView(
                      child: Form(
                        key: _formKeys[index],
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!widget.questions.elementAt(index)['answered'])
                           Center(child: Card(
                                  shape: RoundedRectangleBorder(
                                    side:  BorderSide(color: Colors.blue.shade900, 
                                    ), 
                                    borderRadius: const BorderRadius.all(Radius.circular(12))
                                    ),
                                  elevation: 0,
                                  color: Colors.lightBlue.shade100,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height*0.22,
                                    child: SingleChildScrollView(
                                      child: Column(children: [
                                        SizedBox(height: 15,),
                                        Center(
                                                                      //alignment: Alignment.centerLeft,
                                                                      child: Text(
                                                                    widget.questions
                                      .elementAt(index)['questionTitle'],
                                                                    style: GoogleFonts.roboto(
                                                                       fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.blue.shade900
                                                                    )
                                                                    // TextStyle(
                                                                    //     fontWeight: FontWeight.bold,
                                                                    //     fontSize: 18,
                                                                    //     color: Colors.blue.shade900),
                                                                  )),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(width: 10,),
                                                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.questions
                                              .elementAt(index)['questionBody'],
                                          style: GoogleFonts.openSans(
                                             fontSize: 16,
                                              fontWeight: FontWeight.bold),                                       
                                        )),
                                                                    ],
                                                                  ),
                                                                      SizedBox(
                                                                    width: MediaQuery.of(context).size.width * 0.5,
                                                                    child: Column(
                                                                      children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: TextFormField(
                                          // controller: controllers[index],
                                          key: ValueKey('answer'),
                                    
                                          autocorrect: true,
                                          keyboardType: TextInputType.multiline,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          enableSuggestions: false,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          onChanged: (value) {
                                            if (!value.isEmpty) {
                                              controllers[index] =
                                                  value.toString();
                                              setState(() {
                                                flagsValid[index] = true;
                                              });
                                            }
                                          },
                                          onSaved: (value) {
                                            
                                            if (!value.isEmpty) {
                                              controllers[index] =
                                                  value.toString();
                                              setState(() {
                                                flagsValid[index] = true;
                                              });
                                            }
                                          },
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter a valid answer';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'Answer'),
                                        ),
                                       
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: TextButton(
                                                                        onPressed: () async {
                                        final isValid =
                                            _formKeys[index].currentState.validate();
                                        FocusScope.of(context).unfocus();
                                                                         // print(isValid);
                                        if (isValid) {
                                          _formKeys[index].currentState.save();
                                        }
                                        if (isValid) {
                                          setState(() {
                                            widget.questions
                                                    .elementAt(index)['answered'] =
                                                true;
                                            widget.questions.elementAt(
                                                    index)['instructorAnswer'] =
                                                controllers[index];
                                          });
                                          print(widget.questions.elementAt(
                                              index)['courseDocumentID']);
                                          await FirebaseFirestore.instance
                                              .collection('discussions')
                                              .doc(widget.questions
                                                  .elementAt(index)['documentID'])
                                              .set({
                                            'questionTitle': widget.questions
                                                .elementAt(index)['questionTitle'],
                                            'questionBody': widget.questions
                                                .elementAt(index)['questionBody'],
                                            'instructorAnswer': controllers[index],
                                            'courseName': widget.courseName,
                                            'createdAt': widget.questions
                                                .elementAt(index)['createdAt'],
                                            'documentID': widget.questions
                                                .elementAt(index)['documentID'],
                                            'answered': true,
                                            'courseDocumentID':
                                                widget.courseDocumentID
                                          });
                                        }
                                                                        },
                                          //alignment: Alignment.bottomRight,
                                          child: Text('Reply',
                                              style: GoogleFonts.openSans(color: Colors.blue.shade900,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)
                                              // TextStyle(
                                              //     color: Colors.blue.shade900,
                                              //     fontWeight: FontWeight.bold,
                                              //     fontSize: 16)
                                                  )),
                                      ),
                                                                      ],
                                                                    ),
                                                                  ),
                                      ]),
                                    ),
                                  ),
                           ),
                           ),
                          ],
                        ),
                      ),
                    );
                  }),
              // ),
            ),
        ])));
  }
}

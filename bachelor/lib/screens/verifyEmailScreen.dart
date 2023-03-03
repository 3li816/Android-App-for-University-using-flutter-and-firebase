import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_complete_guide/widgets/navigation_bottom_bar.dart';
import './navigation_screen_student.dart';

class VerifyEmailScreen extends StatefulWidget {
  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  Timer timer;
  var canResendEmail = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser.emailVerified;
    });
    if (isEmailVerified) {
      timer.cancel();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isEmailVerified
        ? Scaffold(
            appBar: AppBar(
              title: Text("verifyEmail"),
            ),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'A verification email has been sent to your email',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                      ),
                      onPressed: canResendEmail ? sendVerificationEmail : null,
                      icon: Icon(Icons.email, size: 32),
                      label: Text('Resend Email')), 

                    SizedBox(height: 8,),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                      ),
                      onPressed: ()=> FirebaseAuth.instance.signOut(), child: Text("Cancel", style: TextStyle(fontSize: 24)))  
                ],
              ),
            ),
          )
        : (FirebaseAuth.instance.currentUser.email.contains('student')
            ? NavigationScreenStudent()
            : NavigationBottomBar());
  }
}

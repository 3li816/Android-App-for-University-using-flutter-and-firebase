import 'dart:isolate';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_complete_guide/screens/all_courses_screen.dart';
import 'package:flutter_complete_guide/screens/edit_instructor_screen.dart';
import 'package:flutter_complete_guide/screens/navigation_screen_student.dart';
import 'package:flutter_complete_guide/screens/verifyEmailScreen.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import './screens/instructor_home_screen.dart';
import './screens/student_home_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './widgets/navigation_bottom_bar.dart';
import './screens/all_courses_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var currentUserID = FirebaseAuth.instance.currentUser.uid;
var currentUserEmail = FirebaseAuth.instance.currentUser.email;
var userRef = Firestore.instance.collection('users');
var flagUser =
    ""; /////////////////////////////////////////////////////////////////////////////////////
AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
);
void downloadFile() async {
  final status = await Permission.storage.request();
  if (status.isGranted) {
    final baseStorage = await getExternalStorageDirectory();
    final id = await FlutterDownloader.enqueue(
        url:
            'https://firebasestorage.googleapis.com/v0/b/bachelor-8f4d9.appspot.com/o/files%2F4ArC8aWHf7f6D9h2cESa?alt=media&token=f77ba332-2c48-4dd8-9bb4-9f4fc43715cb',
        // 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        savedDir: baseStorage.path,
        fileName: 'fileName');
  } else {
    print("no permission");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // downloadFile();

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('@mipmap/ic_launcher');

  // final IOSInitializationSettings initializationSettingsIOS =
  //     IOSInitializationSettings(
  //         //onDidReceiveLocalNotification: (){}
  //         );
  // final MacOSInitializationSettings initializationSettingsMacOS =
  //     MacOSInitializationSettings();
  // final InitializationSettings initializationSettings = InitializationSettings(
  //     android: initializationSettingsAndroid,
  //     iOS: initializationSettingsIOS,
  //     macOS: initializationSettingsMacOS);
  // await flutterLocalNotificationsPlugin.initialize(
  //   initializationSettings,
  //   //onSelectNotification: ()=>return;
  // );
  // const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //     AndroidNotificationDetails(
  //       'channel id', 'channel name', 'channel description',
  //         importance: Importance.max
  //     );
  //     const NotificationDetails platformChannelSpecifics =
  //   NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //   0, 'plain title', 'plain body', platformChannelSpecifics,
  //   payload: 'item x');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  Function getUsers() {
    userRef.getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((DocumentSnapshot doc) {
        var data = doc.data();
        if (data['userID'] == currentUserID) {
          setState(() {
            flagUser = data['role'].toString();
          });
        }
      });
    });
  }

  int progress = 0;
  ReceivePort receivePort = ReceivePort();
  @override
  void initState() {
    super.initState();
    getUsers();
    IsolateNameServer.registerPortWithName(receivePort.sendPort, "downloading");
    receivePort.listen((message) {
      setState(() {
        progress = message;
      });
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  static downloadCallback(id, status, progress) {
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading");
    sendPort.send(progress);
  }

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, appSnapshot) {
          return MaterialApp(
            title: 'FlutterChat',
            theme: ThemeData(
             // primaryIconTheme:IconThemeData(color: Colors.blue.shade900) ,
              textButtonTheme:TextButtonThemeData(style: TextButton.styleFrom(textStyle: TextStyle(color: Colors.blue.shade900)) ) ,
              bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.blue.shade900 ) ,
              elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((_) => Colors.blue.shade900))),
              inputDecorationTheme: InputDecorationTheme(
                iconColor:Colors.blue.shade900,
                focusColor: Colors.blue.shade900,
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue.shade900)),
               // focusedBorder:OutlineInputBorder( borderSide:BorderSide(color: Colors.blue.shade900)),
                labelStyle:TextStyle(color: Colors.blue.shade900,) , 
                hintStyle:TextStyle(color: Colors.blue.shade900,) ,
                ),
                appBarTheme: AppBarTheme(backgroundColor: Colors.blue.shade900),
              iconTheme: IconThemeData(color: Colors.blue.shade900 ),
              hintColor: Colors.blue.shade900,
              selectedRowColor: Colors.blue.shade900,
              focusColor: Colors.blue.shade900,
              hoverColor: Colors.blue.shade900,
              primaryColor: Colors.white,
              backgroundColor: Colors.white,
              accentColor: Colors.blue.shade900,
              //Colors.green.shade700,
              accentColorBrightness: Brightness.dark,
              buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.blue.shade900,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            routes: {
              StudentHomeScreen.routeName: (ctx) => StudentHomeScreen(),
              InstructorHomeScreen.routeName: (ctx) => InstructorHomeScreen(),
              EditInstructorScreen.routeName: (ctx) => EditInstructorScreen(),
              AllCoursesScreen.routeName: (ctx) => AllCoursesScreen(),
            },
            home: appSnapshot.connectionState != ConnectionState.done
                ? SplashScreen()
                : StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (ctx, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return SplashScreen();
                      }
                      if (userSnapshot.hasData) {
                      //  return VerifyEmailScreen();
                          if (FirebaseAuth.instance.currentUser.email
                              .contains('student')) {
                            return NavigationScreenStudent();
                          } else {
                            return NavigationBottomBar();
                          }
                      }
                      return AuthScreen();
                    }),
          );
        });
  }
}

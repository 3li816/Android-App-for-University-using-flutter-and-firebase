import 'package:flutter/material.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:isolate';
import 'dart:ui';

class CourseMediaScreen extends StatefulWidget {
  var media;
  String courseName;
  CourseMediaScreen(this.media, this.courseName);

  @override
  State<CourseMediaScreen> createState() => _CourseMediaScreenState();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize();
}

class _CourseMediaScreenState extends State<CourseMediaScreen> {
  int progress = 0;
  ReceivePort receivePort = ReceivePort();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    IsolateNameServer.registerPortWithName(receivePort.sendPort, "downloading");
    receivePort.listen((message) {
      setState(() {
        progress = message;
      });
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void downloadFile1(String url) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      final id = await FlutterDownloader.enqueue(
          url: url,
          //'https://firebasestorage.googleapis.com/v0/b/bachelor-8f4d9.appspot.com/o/files%2F4ArC8aWHf7f6D9h2cESa?alt=media&token=f77ba332-2c48-4dd8-9bb4-9f4fc43715cb',
          // 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
          savedDir: baseStorage.path,
          fileName: 'fileName');
    } else {
      print("no permission");
    }
  }

  static downloadCallback(id, status, progress) {
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading");
    sendPort.send(progress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(icon: Icon(Icons.download) ,onPressed: () {
        //   downloadFile1();
        // }),
        title: Text(widget.courseName),
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              // childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemCount: widget.media.length,
          itemBuilder: (BuildContext ctx, index) {
            final path = widget.media.elementAt(index)['path'];
            final file = new File(path);
            final url = widget.media.elementAt(index)['url'];
            final extension = widget.media.elementAt(index)['extension'];
            if (extension.toString().contains('pdf')) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                  child: Card(
                    shape: RoundedRectangleBorder(),
                    child: Column(
                      children: [
                        Expanded(
                          child: SfPdfViewer.file(
                            File(path),
                            enableDoubleTapZooming: false,
                          ),
                        ),
                        // SizedBox(
                        //   height: 3,
                        // ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                 downloadFile1(url);
                                },
                                icon: Icon(Icons.download), color: Colors.blue.shade900,),
                                Spacer(),
                                IconButton(
                                onPressed: () {
                                OpenFile.open(file.path);
                                },
                                icon: Icon(Icons.file_open), color: Colors.blue.shade900,),
                          ],
                        ),
                      ],
                    ),
                  ),
              );
            } else {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                  child: Card(
                    shape: RoundedRectangleBorder(),
                    child: Column(
                      children: [
                        Expanded(child: Image.file(file)),
                        // SizedBox(
                        //   height: 3,
                        // ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  downloadFile1(url);
                                },
                                icon: Icon(Icons.download), color: Colors.blue.shade900),
                                Spacer(),
                                IconButton(
                                onPressed: () {
                                  OpenFile.open(file.path);
                                },
                                icon: Icon(Icons.file_open), color: Colors.blue.shade900),
                          ],
                        ),
                      ],
                    ),
                  ),
              );
            }
          }),
    );
  }
}

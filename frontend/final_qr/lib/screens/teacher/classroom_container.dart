import 'package:final_qr/models/view_classroom_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'view_classroom_teacher.dart';
import 'package:final_qr/constants_and_functions.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import "dart:io";
import 'package:android_path_provider/android_path_provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class ClassroomContainer extends StatelessWidget {
  String className;
  String qrURL;
  int index;
  int classId;
  ClassroomContainer(
      {required this.className,
      required this.qrURL,
      required this.index,
      required this.classId});

  late Color displayColor;
  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        displayColor = colorList[0];
        break;
      case 1:
        displayColor = colorList[1];
        break;
      case 2:
        displayColor = colorList[2];
        break;
      case 3:
        displayColor = colorList[3];
        break;
      case 4:
        displayColor = colorList[4];
        break;
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (context) => ViewClassroomProvider(),
              builder: (context, child) {
                return ViewClassroomTeacher(
                    className: className, classId: classId);
              },
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 0.20 * MediaQuery.of(context).size.height,
          width: 0.90 * MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: displayColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      className,
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QRScreen(
                                  qrURL: qrURL,
                                  index: index,
                                )));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: "qrImage_$index",
                          child: Image.network(
                            qrURL,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Center(
                            child: Text(
                              "Tap to expand",
                              style: TextStyle(
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QRScreen extends StatelessWidget {
  String qrURL;
  int index;
  QRScreen({required this.qrURL, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Center(
                child: Hero(
                  tag: "qrImage_$index",
                  child: Image.network(
                    qrURL,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.10),
            OutlinedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
              ),
              onPressed: () async {
                // print("pressed");
                // launchUrl(Uri.parse(qrURL));
                try {
                  final http.Response response =
                      await http.get(Uri.parse(qrURL));
                  final dir = await getTemporaryDirectory();
                  var filename = '${dir.path}/image.png';
                  final file = File(filename);
                  await file.writeAsBytes(response.bodyBytes);

                  final params =
                      SaveFileDialogParams(sourceFilePath: file.path);
                  final finalPath =
                      await FlutterFileDialog.saveFile(params: params);

                  if (finalPath != null) {
                    print('Image saved to disk');
                  }
                } catch (e) {
                  print(e.toString());
                  print('An error occured while saving the image');
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  "Save to device",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

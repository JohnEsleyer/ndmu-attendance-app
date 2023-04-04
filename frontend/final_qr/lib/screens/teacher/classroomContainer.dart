import 'package:final_qr/models/viewClassroomModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewClassroom_teacher.dart';
import 'package:final_qr/constants_and_functions.dart';

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
                        fontSize: 20,
                        color: Colors.white,
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
                    child: Hero(
                      tag: "qrImage_$index",
                      child: Image.network(
                        qrURL,
                      ),
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
              onPressed: () {},
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

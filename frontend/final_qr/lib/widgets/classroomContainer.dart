import 'package:flutter/material.dart';

class ClassroomContainer extends StatelessWidget {
  String subjectName;
  String qrURL;

  ClassroomContainer({required this.subjectName, required this.qrURL});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 0.20 * MediaQuery.of(context).size.height,
        width: 0.90 * MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.redAccent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(subjectName),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.10,
              width: MediaQuery.of(context).size.width * 0.10,
              child: Image.network(qrURL),
            ),
          ],
        ),
      ),
    );
  }
}

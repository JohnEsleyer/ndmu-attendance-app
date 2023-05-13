import 'dart:convert';

import 'package:flutter/material.dart';

class GreenWhiteContainer extends StatefulWidget {
  String title;
  Widget child;
  double fontSize;
  GreenWhiteContainer(
      {required this.title, required this.child, required this.fontSize});

  @override
  _GreenWhiteContainerState createState() => _GreenWhiteContainerState();
}

class _GreenWhiteContainerState extends State<GreenWhiteContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.07),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              child: Expanded(
                child: Center(
                  child: widget.child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

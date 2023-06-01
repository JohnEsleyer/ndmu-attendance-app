import 'package:flutter/material.dart';

// var server = "http://127.0.0.1:8080";
// var server = "10.0.2.2:8080";
var server = "https://lovely-donkey-38.telebit.io";

List<DateTime> getDateList(DateTime date) {
  return [
    date.subtract(Duration(days: 30)),
    date.subtract(Duration(days: 29)),
    date.subtract(Duration(days: 28)),
    date.subtract(Duration(days: 27)),
    date.subtract(Duration(days: 26)),
    date.subtract(Duration(days: 25)),
    date.subtract(Duration(days: 24)),
    date.subtract(Duration(days: 23)),
    date.subtract(Duration(days: 22)),
    date.subtract(Duration(days: 21)),
    date.subtract(Duration(days: 20)),
    date.subtract(Duration(days: 19)),
    date.subtract(Duration(days: 18)),
    date.subtract(Duration(days: 17)),
    date.subtract(Duration(days: 16)),
    date.subtract(Duration(days: 15)),
    date.subtract(Duration(days: 14)),
    date.subtract(Duration(days: 13)),
    date.subtract(Duration(days: 12)),
    date.subtract(Duration(days: 11)),
    date.subtract(Duration(days: 10)),
    date.subtract(Duration(days: 9)),
    date.subtract(Duration(days: 8)),
    date.subtract(Duration(days: 7)),
    date.subtract(Duration(days: 6)),
    date.subtract(Duration(days: 5)),
    date.subtract(Duration(days: 4)),
    date.subtract(Duration(days: 3)),
    date.subtract(Duration(days: 2)),
    date.subtract(Duration(days: 1)),
    date,
  ];
}

List<Color> colorList = [
  Color.fromARGB(255, 223, 192, 16),
  Color.fromARGB(255, 255, 156, 26),
  Color.fromARGB(255, 71, 192, 41),
  Color.fromARGB(255, 27, 196, 145),
  Color.fromARGB(255, 236, 108, 57),
];

double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class UserData {
  final String status;
  final int userId;
  final String userType;

  UserData(
      {required this.status, required this.userId, required this.userType});
}

class UserDataProvider extends ChangeNotifier {
  UserData _userData = UserData(
    status: "",
    userId: 0,
    userType: "",
  );

  UserData get getUserData => _userData;

  void updateUserData({
    required String status,
    required String userType,
    required int userId,
  }) {
    _userData = UserData(status: status, userType: userType, userId: userId);
    notifyListeners();
  }
}

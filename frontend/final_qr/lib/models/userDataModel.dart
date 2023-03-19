import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class UserDataModel {
  String status;
  int userId;
  String userType;

  UserDataModel(
      {required this.status, required this.userId, required this.userType});

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      status: json['status'],
      userId: json['userId'],
      userType: json['userType'],
    );
  }
}

class UserProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  late String _errorMessage;
  String get errorMessage => _errorMessage;

  late UserDataModel _data;
  UserDataModel get data => _data;

  Future<void> sendRequest(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://https://modern-dingo-32.telebit.io/login');
    final body = {
      "username": username,
      "password": password,
    };

    try {
      final response = await http.post(url, body: json.encode(body));
      _data = UserDataModel.fromJson(json.decode(response.body));
      _hasError = false;
    } catch (error) {
      _errorMessage = error.toString();
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }
}

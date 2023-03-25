import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'constants_and_functions.dart';
import 'models/userDataModel.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String _username = " ";
  late String _password = " ";
  bool _loginPressed = false;
  bool _didError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                        Color(0x6631ca52),
                        Color(0x9931ca52),
                        Color(0xcc31ca52),
                        Color(0xff31ca52),
                      ])),
                  child: Container(
                    padding: const EdgeInsets.all(50),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        const Image(
                          image: AssetImage('assets/ndmu.png'),
                          alignment: Alignment.center,
                          fit: BoxFit.fitHeight,
                          height: 200,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow:
                                    // ignore: prefer_const_literals_to_create_immutables
                                    [
                                  const BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 6,
                                      offset: Offset(0, 2))
                                ]),
                            height: 60,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  _username = value;
                                });
                              },
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                  hintText: 'Username',
                                  hintStyle: TextStyle(color: Colors.black26)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow:
                                    // ignore: prefer_const_literals_to_create_immutables
                                    [
                                  const BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 6,
                                      offset: Offset(0, 2))
                                ]),
                            height: 60,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  _password = value;
                                });
                              },
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.black,
                                  ),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(color: Colors.black26)),
                            ),
                          ),
                        ),
                        _loginPressed
                            ? Center(
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    top: 8.0,
                                    bottom: 8.0),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 25),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        _loginPressed = true;
                                        _didError = false;
                                      });
                                      var response = await http.post(
                                        Uri.parse('$server/login'),
                                        body: jsonEncode({
                                          "username": _username,
                                          "password": _password,
                                        }),
                                        headers: <String, String>{
                                          'Content-Type':
                                              'application/json; charset=UTF-8',
                                        },
                                      );
                                      if (response.statusCode == 200) {
                                        print("success");
                                        Map<String, dynamic> map =
                                            jsonDecode(response.body);
                                        String usrType = map['userType'];
                                        int usrId = map['userId'];
                                        String status = map['status'];
                                        Provider.of<UserDataProvider>(context,
                                                listen: false)
                                            .updateUserData(
                                                status: status,
                                                userType: usrType,
                                                userId: usrId);

                                        if (usrType == "student") {
                                          Navigator.of(context)
                                              .popAndPushNamed("/student");
                                        } else if (usrType == "teacher") {
                                          Navigator.of(context)
                                              .popAndPushNamed("/teacher");
                                        }
                                      } else {
                                        print("error");
                                        setState(() {
                                          _loginPressed = false;
                                          _didError = true;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                        if (_didError)
                          Center(
                            child: Text(
                              "Invalid username or password",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

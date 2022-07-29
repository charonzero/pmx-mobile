import 'package:flutter/material.dart';
import 'package:pmx/Screen/WelcomeScreen/WelcomeScreen.dart';
import 'package:pmx/Screen/WrapperScreen/wrapper_screen.dart';
import 'package:pmx/constant.dart';
import 'package:pmx/models/login.dart';

class LoginRouter extends StatelessWidget {
  final String title;

  const LoginRouter({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPref().read('sessiondata'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return WrapperScreen(title: appname);
          } else {
            return WelcomeScreen();
          }
        });
  }
}

// ignore_for_file: file_names, unused_import

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pmx/Screen/LoginScreen/LoginScreen.dart';
import 'package:pmx/Screen/WrapperScreen/wrapper_screen.dart';
import 'package:pmx/components/roundbutton.dart';
import 'package:pmx/constant.dart';
import 'package:pmx/models/login.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    welcomeRoute();
    super.initState();
  }

  Future<void> welcomeRoute() async {
    var data = await SharedPref().read('session_data');
    try {
      // JWT.verify(session.jwt, SecretKey('secret'));

      if (data != null) {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const WrapperScreen(title: appname))));
      } else {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen())));
      }
      // ignore: nullable_type_in_catch_clause
    } on JWTError {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())));
    }
    // var data = await SharedPref().read('session_data');
    if (data != null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const WrapperScreen(title: appname))));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: secondarycolor,
        body: Center(
            child: SizedBox(
                height: size.height * 0.3,
                child: Image.asset("assets/images/Logo.png",
                    width: size.width * 0.75, alignment: Alignment.center)
                // child: const Text("WelcomeScreen"),
                )));
  }
}

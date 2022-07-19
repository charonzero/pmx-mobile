import 'package:flutter/material.dart';
import 'package:pmx/Screen/WrapperScreen/wrapper_screen.dart';
import 'package:pmx/constant.dart';

import 'Screen/WelcomeScreen/WelcomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'PMXPress';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: primarycolor,
        ),
        primaryColor: primarycolor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const WrapperScreen(title: _title),
    );
  }
}
//

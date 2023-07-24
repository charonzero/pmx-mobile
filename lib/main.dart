import 'package:flutter/material.dart';
import 'package:pmx/Screen/WelcomeScreen/LoginRouter.dart';
import 'package:pmx/constant.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'PMXPRESS';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: _title,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: primaryColor,
          ),
          primaryColor: primaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const LoginRouter(
          title: "PMXPRESS",
        ));
  }
}

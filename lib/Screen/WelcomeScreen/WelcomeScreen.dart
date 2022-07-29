import 'package:flutter/material.dart';
import 'package:pmx/Screen/LoginScreen/LoginScreen.dart';
import 'package:pmx/Screen/WrapperScreen/wrapper_screen.dart';
import 'package:pmx/components/roundbutton.dart';
import 'package:pmx/constant.dart';
import 'package:pmx/models/login.dart';

import '../../components/background.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Background(
      size: size,
      child: SingleChildScrollView(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                height: size.height * 0.3,
                child: Image.asset("assets/images/Logo.png",
                    width: size.width * 0.75, alignment: Alignment.center)),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              width: size.width * 0.75,
              height: size.height * 0.3,
              child: Column(children: <Widget>[
                RoundButton(
                    text: Text("Login"),
                    color: primarycolor,
                    bcolor: primarycolor,
                    onpress: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const LoginScreen();
                      }));
                    }),
                SizedBox(
                  height: size.height * .01,
                ),
                RoundButton(
                    text: Text("Admin Login"),
                    color: secondarycolor,
                    bcolor: secondarycolor,
                    onpress: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return const RegisterScreen();
                      // }));
                    }),
              ]),
            )
          ],
        ),
      )),
    ));
  }
}

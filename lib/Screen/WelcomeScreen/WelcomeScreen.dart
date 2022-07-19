import 'package:flutter/material.dart';
import 'package:pmx/Screen/LoginScreen/LoginScreen.dart';
import 'package:pmx/components/roundbutton.dart';
import 'package:pmx/constant.dart';

import '../../components/background.dart';

class WelcomeScreen extends StatelessWidget {
  final String title;
  const WelcomeScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Background(
          child: SingleChildScrollView(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.2,
                ),
                Image.asset("assets/images/Logo.png",
                    width: size.width * 0.75, alignment: Alignment.center),
                SizedBox(
                  height: size.height * 0.2,
                ),
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

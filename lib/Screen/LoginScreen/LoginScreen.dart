// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:pmx/Screen/WrapperScreen/wrapper_screen.dart';
import 'package:pmx/components/RoundInputField.dart';
import 'package:pmx/components/RoundPasswordField.dart';
import 'package:pmx/components/RoundButton.dart';
import 'package:pmx/constant.dart';
import 'package:pmx/models/login.dart';

import '../../components/background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String username = '', password = '';
  late bool isLoading = false;
  late String errorText = '';
  setLoading(bool state) => setState(() => isLoading = state);
  final _loginformKey =
      GlobalKey<FormState>(debugLabel: 'login_form_${UniqueKey().toString()}');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: secondaryColor,
        resizeToAvoidBottomInset: false,
        body: Background(
          size: size,
          child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 40),
                      child: Image.asset("assets/images/Logo.png",
                          width: size.width * 0.75,
                          alignment: Alignment.center),
                    ),
                    Form(
                      key: _loginformKey,
                      child: Column(
                        children: <Widget>[
                          RoundedInputField(
                            hintText: "Username",
                            icon: Icons.verified_user,
                            keyboardType: TextInputType.text,
                            validatorText: 'Please enter your username',
                            onChanged: (value) {
                              username = value;
                            },
                          ),
                          RoundedPasswordField(
                            hintText: "Password",
                            icon: Icons.password,
                            onChanged: (value) {
                              password = value;
                            },
                          ),
                          SizedBox(
                              height: size.height * 0.025,
                              child: Container(
                                  constraints: const BoxConstraints(
                                      minWidth: 100, maxWidth: 300),
                                  width: size.width * 0.8 - 40,
                                  child: Row(children: [
                                    Text(
                                      errorText,
                                      style: const TextStyle(color: Colors.red),
                                    )
                                  ]))),
                          RoundButton(
                              text: Text(
                                  isLoading != true ? "Login" : 'Loading...'),
                              onpress: () async {
                                loginUsers();
                                // if (isLoading != true) {
                                //   if (_loginformKey.currentState!.validate()) {
                                //     loginUsers();
                                //   }
                                // }
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ));
  }

  Future<void> loginUsers() async {
    //_loginformKey.currentState!.validate()
    if (true) {
      username = "charon";
      password = "charon22";
      setLoading(true);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.none,
        duration: const Duration(days: 1),
        content: const Text('Processing Data'),
        backgroundColor: Colors.green.shade300,
      ));
      try {
        dynamic statuscode = await login(username, password);
        print(statuscode);
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          if (statuscode == 200) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const WrapperScreen(title: appName)),
                (Route<dynamic> route) => route is WrapperScreen);
          } else if (statuscode == 401) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Error: Wrong credentials provided'),
              backgroundColor: Colors.red.shade300,
            ));
          } else if (statuscode == -1) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text(
                  'Error: Connection Error. Please check your internet.'),
              backgroundColor: Colors.red.shade300,
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Error: Cant connect to server..'),
              backgroundColor: Colors.red.shade300,
            ));
          }
        }
        setLoading(false);
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Error: Cant connect to server..'),
          backgroundColor: Colors.red.shade300,
        ));
        setLoading(false);
      } finally {
        setLoading(false);
      }
    }
  }
}

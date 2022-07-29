import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pmx/Screen/WrapperScreen/wrapper_screen.dart';
import 'package:pmx/components/RoundInputField.dart';
import 'package:pmx/components/RoundPasswordField.dart';
import 'package:pmx/components/roundbutton.dart';
import 'package:pmx/constant.dart';
import 'package:pmx/models/login.dart';

import '../../components/background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // static final Config config = Config(
  //   tenant: '6e882fc5-ce57-4503-80ee-7146fa89b021',
  //   clientId: '4e5aa12e-a2b8-448f-9dcd-9d998989848e',
  //   scope: 'openid profile offline_access',
  //   redirectUri: 'https://login.live.com/oauth20_desktop.srf',
  // );
  // final AadOAuth oauth = AadOAuth(config);
  String phone = '', password = '';
  late bool isLoading = false;
  late String errorText = '';
  setLoading(bool state) => setState(() => isLoading = state);
  static final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Background(
          size: size,
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      RoundedInputField(
                        hintText: "Username",
                        icon: Icons.phone,
                        keyboardType: TextInputType.name,
                        validatorText: 'Please enter your username',
                        onChanged: (value) {
                          phone = value;
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
                                  style: TextStyle(color: Colors.red),
                                )
                              ]))),
                      RoundButton(
                          text:
                              Text(isLoading != true ? "Login" : 'Loading...'),
                          onpress: () async {
                            if (isLoading != true) {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  setLoading(true);
                                  var statuscode = await login(phone, password);
                                  print(statuscode);
                                  if (statuscode == 200) {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const WrapperScreen(
                                                  title: 'PMXpress',
                                                )));
                                  } else if (statuscode == 401) {
                                    errorText = 'Wrong credentials provided.';
                                  } else if (statuscode == -1) {
                                    errorText =
                                        'Connection Error. Please check your internet.';
                                  }
                                } on Exception catch (_) {
                                  setLoading(false);
                                } finally {
                                  setLoading(false);
                                }
                              }
                            }
                          }),
                      RoundButton(
                        color: secondarycolor,
                        bcolor: secondarycolor,
                        text: Text(
                          'Back to Home',
                        ),
                        onpress: () => Navigator.of(context).pop(false),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
        ));
  }
}

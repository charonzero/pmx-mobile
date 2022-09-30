// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pmx/Screen/LoginScreen/LoginScreen.dart';
import 'package:pmx/Screen/WrapperScreen/Pages/widgets/ProfileButton.dart';
import 'package:pmx/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pmx/models/login.dart';
import 'package:pmx/models/server.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: SharedPref().read('session_data'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            SessionData session = SessionData.fromJson(snapshot.data);
            return SafeArea(
              child: Scaffold(),
            );
          } else if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.error),
                SizedBox(
                  height: 5,
                ),
                Text('Connection Error.'),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        });
  }
}

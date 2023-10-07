// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pmx/models/login.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPref().read('session_data'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return const SafeArea(
              child: Scaffold(),
            );
          } else if (snapshot.hasError) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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

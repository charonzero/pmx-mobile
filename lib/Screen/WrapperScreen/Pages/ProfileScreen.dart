// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pmx/Screen/LoginScreen/LoginScreen.dart';
import 'package:pmx/Screen/WrapperScreen/Pages/ChangePassword.dart';
import 'package:pmx/Screen/WrapperScreen/Pages/widgets/ProfileButton.dart';
import 'package:pmx/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pmx/models/login.dart';
import 'package:pmx/models/server.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: SharedPref().read('session_data'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            SessionData session = SessionData.fromJson(snapshot.data);
            DefaultCacheManager().emptyCache();
            return SafeArea(
              child: Scaffold(
                body: Column(children: [
                  Row(children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40)),
                              border: Border.all(
                                width: 1,
                                color: primarycolor,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 40,
                              child: CachedNetworkImage(
                                color: Colors.white,
                                httpHeaders: {'Authorization': session.token},
                                imageUrl: serverurl +
                                    "staffimg/" +
                                    session.userid.toString(),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 80.0,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(
                                  strokeWidth: 1,
                                  color: primarycolor,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  color: primarycolor,
                                ),
                              ),
                            ))),
                    SizedBox(
                      width: size.width * 0.07,
                    ),
                    Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(session.username,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: size.width * 0.05))),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(session.role,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: size.width * 0.03))),
                        ]))
                  ]),
                  ProfileButton(
                    size: size,
                    name: 'My Account',
                    route: const ChangePassword(),
                  ),
                  ProfileButton(
                    size: size,
                    name: 'Change Account Information',
                    route: const ChangePassword(),
                  ),
                  ProfileButton(
                    size: size,
                    name: 'Change Password',
                    route: const ChangePassword(),
                  ),
                ]),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: primarycolor,
                  onPressed: () async {
                    var bool = await logout();
                    if (bool) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (route) => false);
                    }
                  },
                  child: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
              ),
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

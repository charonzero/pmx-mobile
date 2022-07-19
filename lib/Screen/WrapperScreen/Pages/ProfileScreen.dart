import 'package:flutter/material.dart';
import 'package:pmx/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
            Session_data session = Session_data.toJson(snapshot.data);
            return Container(
              width: size.width,
              height: size.height,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  Row(children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              border: Border.all(
                                width: 1,
                                color: primarycolor,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              child: CachedNetworkImage(
                                imageUrl: serverurl +
                                    "staffimg/" +
                                    session.userid.toString(),
                                imageBuilder:
                                    (context, imageProvider) =>
                                        Container(
                                  width: 80.0,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
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
                  Container(
                    width: size.width,
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                // var bool = await logout();
                                // if (bool) {
                                //   Navigator.pushAndRemoveUntil(
                                //       context,
                                //       const MaterialPageRoute(
                                //           builder: (context) =>
                                //               Login()),
                                //       (route) => false);
                                // }
                              },
                              child: Text('Logout'),
                            )
                          ],
                        )),
                  )
                ]),
              ));
          } else if (snapshot.hasError) {
            return Column(
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
            return Center(child: CircularProgressIndicator.adaptive());
          }
        });
  }
}

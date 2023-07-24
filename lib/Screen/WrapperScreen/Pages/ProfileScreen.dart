import 'package:flutter/material.dart';
import 'package:pmx/Screen/LoginScreen/LoginScreen.dart';
import 'package:pmx/Screen/WrapperScreen/Pages/ChangePassword.dart';
import 'package:pmx/Screen/WrapperScreen/Pages/widgets/ProfileButton.dart';
import 'package:pmx/constant.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pmx/main.dart';
import 'package:pmx/models/login.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: SharedPref().read('session_data'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else if (snapshot.data.isEmpty) {
          // Redirect to login screen if session data is not available
          Future.delayed(Duration.zero, () {
            navigatorKey.currentState!.push(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          });
          return const SizedBox.shrink();
        } else {
          try {
            SessionData session = SessionData.fromJson(snapshot.data);
            DefaultCacheManager().emptyCache();
            return Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF031B50),
                            Color(0xFF031B50),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Image.asset(
                            "assets/images/minilogo.png",
                            width: size.width * 0.3,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.25,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            RichText(
                              text: TextSpan(
                                text: session.name!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                                children: [
                                  TextSpan(
                                    text: " @${session.username!}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              session.role!.roleName!,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              // child: const Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     SizedBox(height: 30),
                              //     Text(
                              //       'Account Settings',
                              //       style: TextStyle(
                              //         fontSize: 22,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //     SizedBox(height: 20),
                              //     // ProfileButton(
                              //     //   size: size,
                              //     //   name: 'Change Password',
                              //     //   route: const ChangePassword(),
                              //     // ),
                              //     // const SizedBox(height: 10),
                              //     // ProfileButton(
                              //     //   size: size,
                              //     //   name: 'Privacy Settings',
                              //     //   route: const ChangePassword(),
                              //     // ),
                              //   ],
                              // ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    left: 0,
                    right: 0,
                    child: FloatingActionButton(
                      backgroundColor: primaryColor,
                      onPressed: () async {
                        var bool = await logout();
                        if (bool && context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } catch (error) {
            print("Error: $error");
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'An error occurred',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        var bool = await logout();
                        print(bool);
                        if (bool && context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }
}

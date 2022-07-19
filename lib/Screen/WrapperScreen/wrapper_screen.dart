import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pmx/Screen/WrapperScreen/Pages/HomeScreen.dart';
import 'package:pmx/constant.dart';

import 'Pages/ProfileScreen.dart';
import 'Pages/ScanScreen.dart';
// import 'package:nec/Screens/Wrapper/Pages/Search/Search_Screen.dart';
// import 'package:nec/Screens/Wrapper/Pages/Home/Home_Screen.dart';
// import 'package:nec/components/Sidebar.dart';
// import 'Pages/Profile/Profile_Screen.dart';a

class WrapperScreen extends StatefulWidget {
  const WrapperScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<WrapperScreen> createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<WrapperScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widget = <Widget>[
    const HomeScreen(),
    const ScanScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            extendBody: true,
            body: Center(child: _widget.elementAt(_selectedIndex)),
            bottomNavigationBar: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.qr_code),
                        label: 'QR',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    selectedItemColor: primarycolor,
                    onTap: _onItemTapped,
                  ),
                ))));
  }
}

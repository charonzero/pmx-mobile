// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pmx/Screen/WrapperScreen/Pages/Inventory.dart';
import 'package:pmx/Screen/WrapperScreen/Pages/InventoryDone.dart';
import 'package:pmx/Screen/WrapperScreen/Pages/TransitInventory.dart';

import 'package:pmx/models/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getuserdata();
    super.initState();
  }

  String userid = "";
  String role = "";
  Future<void> getuserdata() async {
    var session = await SharedPref().read('session_data');
    setState(() {
      userid = session['userid'].toString();
      role = session['role'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (role == 'Driver') {
      return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const TabBar(
                tabs: [
                  Tab(
                      icon: Icon(
                    Icons.fire_truck_outlined,
                  )),
                  Tab(
                      icon: Icon(
                    Icons.fire_truck,
                  )),
                ],
              ),
            ),
            body: const TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Inventory(),
                InventoryDone(),
              ],
            ),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
              child: Icon(
            Icons.warehouse,
            color: Colors.white,
          )),
        ),
        body: const TrasnsitInventory(),
      );
    }
  }
}

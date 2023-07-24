import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pmx/models/login.dart';
import 'package:pmx/models/modals.dart';
import 'package:pmx/Screen/WrapperScreen/Pages/Inventory.dart';
import 'package:pmx/models/package.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userId = "";
  String role = "";
  List<PackageData> currentPackages = [];
  List<PackageData> pastPackages = [];

  @override
  void initState() {
    super.initState();
    getUserData();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    try {
      if (mounted) {
        List<PackageData>? currentPackageList =
            await fetchInventory('/getCurrentPackages', context);
        setState(() {
          currentPackages = currentPackageList;
        });
      }
      // if (mounted) {
      //   List<PackageData>? pastPackageList =
      //       await fetchInventory('/getPastPackages', context);
      //   setState(() {
      //     pastPackages = pastPackageList ?? [];
      //   });
      // }
    } catch (e) {
      print('Error fetching packages: $e');
    }
  }

  Future<void> getUserData() async {
    var session = await SharedPref().read('session_data');
    setState(() {
      userId = session['userid'].toString();
      role = session['role'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDriver = role == 'Driver';
    return Inventory(
      packages: currentPackages,
      title: 'Inventory',
      refreshPackages: fetchPackages,
    );
  }
}

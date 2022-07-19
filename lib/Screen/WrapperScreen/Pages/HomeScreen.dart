import 'package:flutter/material.dart';
import 'package:pmx/Screen/WrapperScreen/Pages/Inventory.dart';
import 'package:pmx/Screen/WrapperScreen/Pages/InventoryDone.dart';
import 'package:pmx/constant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
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
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Inventory(),
              InventoryDone(),
            ],
          ),
        ));
  }
}

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pmx/Screen/WrapperScreen/Pages/components/OrderOverlay.dart';
import 'package:pmx/constant.dart';
import 'package:pmx/models/login.dart';
import 'package:pmx/models/order.dart';
import 'package:collection/collection.dart';

class TrasnsitInventory extends StatefulWidget {
  const TrasnsitInventory({Key? key}) : super(key: key);

  @override
  _TrasnsitInventoryState createState() => _TrasnsitInventoryState();
}

class _TrasnsitInventoryState extends State<TrasnsitInventory>
    with TickerProviderStateMixin {
  bool isSorted = false;
  List<Orders> order = [];
  var refreshkeytransit = GlobalKey<RefreshIndicatorState>();
  String userid = "";
  Future<void> setOrders() async {
    refreshkeytransit.currentState?.show(atTop: true);
    var session = await SharedPref().read('session_data');

    fetchOrders(session['userid'].toString()).then((value) {
      if (const DeepCollectionEquality.unordered().equals(order, value) ==
          false) {
        if (!mounted) return;
        setState(() {
          order = value;
        });
      }
      if (userid.isEmpty) {
        if (!mounted) return;
        setState(() {
          userid = session['userid'].toString();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setOrders();
  }

  void _showOverlay(BuildContext context, String orderid) {
    AnimationController controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    showDialog(
      context: context,
      builder: (_) =>
          OrderOverlay(controller: controller, orderid: orderid, past: false),
    ).then((val) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return RefreshIndicator(
      key: refreshkeytransit,
      onRefresh: setOrders,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: Column(children: <Widget>[
              const Text("Current Transits",
                  style: TextStyle(
                      color: primarycolor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                itemCount: order.length,
                itemBuilder: (context, index) {
                  return Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.symmetric(vertical: 4.5),
                      height: size.height * 0.1,
                      child: Center(
                        child: ListTile(
                          leading: SizedBox(
                              height: size.height * 0.1,
                              child: const Icon(
                                Icons.circle_outlined,
                                color: Colors.grey,
                              )),
                          title: Text("OrderID - " + order[index].orderid),
                          subtitle: Text(order[index].city +
                              " / " +
                              order[index].township),
                          trailing: const Icon(Icons.more_vert),
                          onTap: () {
                            _showOverlay(context, order[index].orderid);
                          },
                        ),
                      ));
                },
              )
            ])),
      ),
    );
  }
}

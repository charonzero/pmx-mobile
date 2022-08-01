import 'package:flutter/material.dart';
import 'package:pmx/Screen/WrapperScreen/Pages/components/OrderOverlay.dart';
import 'package:pmx/constant.dart';
import 'package:pmx/models/login.dart';
import 'package:pmx/models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import 'package:page_transition/page_transition.dart';

class Inventory extends StatefulWidget {
  Inventory({Key? key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> with TickerProviderStateMixin {
  bool isSorted = false;
  List<Orders> order = [];
  var refreshkey = GlobalKey<RefreshIndicatorState>();
  String userid = "";
  Future<void> setOrders() async {
    refreshkey.currentState?.show(atTop: true);
    var session = await SharedPref().read('session_data');

    fetchOrders(session['userid'].toString()).then((value) {
      if (DeepCollectionEquality.unordered().equals(order, value) == false) {
        if (!mounted) return;
        setState(() {
          order = value;
        });
      }
      if (userid.length == 0) {
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
      builder: (_) => OrderOverlay(
        controller: controller,
        orderid: orderid,
        past: false
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    String dropdownValue = 'ID';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Column(
        children: [
          Text("Your Packages",
              style: TextStyle(
                  color: primarycolor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Center(
                    child: Text("Your Packages",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w800))),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Center(
                    child: Row(
                  children: [
                    Text("Sort By  ",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      width: 5,
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_drop_down_rounded),
                      elevation: 8,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        color: Colors.transparent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                        setState(() => {
                              order.sort((a, b) => !isSorted
                                  ? b.orderid.compareTo(a.orderid)
                                  : a.orderid.compareTo(b.orderid)),
                              isSorted = !isSorted
                            });
                      },
                      items: <String>[
                        'ID',
                        'City',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ],
                )),
              )
            ],
          ),
          Divider(
            thickness: 1.0,
          ),
          Expanded(
            child: RefreshIndicator(
              key: refreshkey,
              onRefresh: setOrders,
              child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                      itemCount: order.length,
                      itemBuilder: (context, index) {
                        return Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.symmetric(vertical: 4.5),
                            height: size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: SizedBox(
                                    height: size.height * 0.1,
                                    child: Icon(
                                      Icons.circle_outlined,
                                      color: Colors.grey,
                                    )),
                                title: Text("OrderID - " +
                                    order[index].orderid),
                                subtitle: Text(order[index].city +
                                    " / " +
                                    order[index].township),
                                trailing: Icon(Icons.more_vert),
                                onTap: () {
                                  _showOverlay(context, order[index].orderid);
                                },
                              ),
                            ));
                      },
                    )
                  ])),
            ),
          ),
        ],
      ),
    );
  }
}

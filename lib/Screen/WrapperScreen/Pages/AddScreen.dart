import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:pmx/constant.dart';
import 'package:pmx/models/login.dart';
import 'package:pmx/models/order.dart';

class AddScreen extends StatefulWidget {
  final String orderid;
  const AddScreen({Key? key, required this.orderid}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    var orderId = widget.orderid.split('/')[4];
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Order ID - ' + orderId),
        ),
        extendBody: true,
        body: Center(
          child: SvgPicture.asset('/assets/images/box.svg'),
        ),
        bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
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
              child: Row(
                children: [
                  Container(
                      color: Colors.white,
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                                onTap: () async {
                                  // Session_data session =
                                  //     SharedPref().read('session_data');
                                  // String status =
                                  //     session.role == 'Admin' ? '3' : '2';
                                  var statuscode =
                                      await acceptOrder(orderId, '2', '16');
                                  print(statuscode);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: cwarning, width: 2.5),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                      )),
                                  child: const Text("Accept",
                                      style: TextStyle(
                                        color: cwarning,
                                        fontSize: 15,
                                      )),
                                )),
                          ),
                          const SizedBox(
                            width: 2.5,
                          ),
                          Expanded(
                            child: InkWell(
                                onTap: () {},
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: cdanger, width: 2.5),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(30),
                                      )),
                                  child: const Text("Decline",
                                      style: TextStyle(
                                        color: cdanger,
                                        fontSize: 15,
                                      )),
                                )),
                          ),
                        ],
                      ))
                ],
              ),
            )));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:pmx/Screen/WrapperScreen/wrapper_screen.dart';
import 'package:pmx/constant.dart';
import 'package:pmx/models/login.dart';
import 'package:pmx/models/order.dart';
import 'package:pmx/constant.dart';

class AddScreen extends StatefulWidget {
  final String orderid;
  const AddScreen({Key? key, required this.orderid}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var orderId = widget.orderid;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Add Order'),
        ),
        extendBody: true,
        body: Center(
            child: Column(
          children: [
            SvgPicture.asset(
              'assets/images/box.svg',
              width: size.width * .5,
              color: primarycolor,
            ),
            SizedBox(
              width: double.infinity,
              height: size.height * 0.005,
            ),
            Text(
              'OrderID : ' + orderId,
              style: TextStyle(
                  fontSize: size.width * .05, fontWeight: FontWeight.bold),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        )),
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
                                  var data =
                                      (await SharedPref().read('session_data'));
                                  Session_data session =
                                      Session_data.fromJson(data);
                                  String status =
                                      session.role == 'Admin' ? '3' : '2';
                                  var statuscode = await acceptOrder(orderId,
                                      status, session.userid.toString());
                                  print(statuscode);
                                  if (statuscode == 200) {
                                    Navigator.pop(context,
                                        MaterialPageRoute(builder: (context) {
                                      return WrapperScreen(title: appname);
                                    }));
                                  }
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
                                onTap: () {
                                  Navigator.pop(context,
                                      MaterialPageRoute(builder: (context) {
                                    return WrapperScreen(title: appname);
                                  }));
                                },
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

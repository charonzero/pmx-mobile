// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pmx/Screen/WrapperScreen/wrapper_screen.dart';
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
  late Orders order;
  bool isLoading = true;
  Future<void> getorderdetails() async {
    setState(() {
      isLoading = true;
    });
    var value = await getOrderDetails(widget.orderid);
    setState(() {
      order = value;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getorderdetails();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    Size size = MediaQuery.of(context).size;
    var orderId = widget.orderid;
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Add Order'),
          ),
          extendBody: true,
          body: Center(
              child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Text(
                        "Order ID: " + order.orderid,
                        style: const TextStyle(
                            color: primarycolor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(order.status.toString()),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      orderDetail("Customer Name", order.CName, size),
                      orderDetail("Phone", order.CPhone, size),
                      orderDetail("Remark", order.remark, size),
                      const Divider(
                        height: 10,
                      ),
                      orderDetail("Address", order.CAddress, size),
                      orderDetail("Township", order.township, size),
                      orderDetail("City", order.city, size),
                      const Divider(
                        thickness: 2,
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: size.width * .35,
                              child: const Text('Total:',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700)),
                            ),
                            Flexible(
                              child: Text(order.total.toString() + " MMK",
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // SvgPicture.asset(
              //   'assets/images/box.svg',
              //   width: size.width * .5,
              //   color: primarycolor,
              // ),
              // SizedBox(
              //   width: double.infinity,
              //   height: size.height * 0.005,
              // ),
              // Text(
              //   'OrderID : ' + orderId,
              //   style: TextStyle(
              //       fontSize: size.width * .05, fontWeight: FontWeight.bold),
              // )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          )),
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
                                    var data = (await SharedPref()
                                        .read('session_data'));
                                    SessionData session =
                                        SessionData.fromJson(data);
                                    String status = session.role == 'Admin' ||
                                            session.role == 'Super Admin'
                                        ? '3'
                                        : '2';
                                    var response =
                                        await acceptOrder(orderId, status);
                                    var statuscode = response['statusCode'];

                                    if (statuscode == 200) {
                                      Navigator.pop(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const WrapperScreen(
                                            title: appname);
                                      }));
                                    } else if (statuscode == 403) {
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Error'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text(response['msg'])
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Back'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      ).then((val) {
                                        Navigator.of(context).pop();
                                      });
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
                                    // Navigator.pop(context,
                                    //     MaterialPageRoute(builder: (context) {
                                    //   return const WrapperScreen(title: appname);
                                    // }));
                                    Navigator.pop(context, true);
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
  }

  Padding orderDetail(String text, String value, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: size.width * .35,
            child: Text(text,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          Flexible(
            child: Text(value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

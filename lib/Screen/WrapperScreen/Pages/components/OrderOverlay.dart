// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:pmx/constant.dart';
import 'package:pmx/models/login.dart';
import 'package:pmx/models/order.dart';

class OrderOverlay extends StatefulWidget {
  final AnimationController controller;
  final String orderid;
  final bool past;

  const OrderOverlay(
      {Key? key,
      required this.controller,
      required this.orderid,
      required this.past})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => OrderOverlayState();
}

class OrderOverlayState extends State<OrderOverlay> {
  Orders? order;
  bool isLoading = true;
  String role = "";
  getorderdetails() async {
    Orders response = await getOrderDetails(widget.orderid);
    var session = await SharedPref().read('session_data');
    setState(() {
      role = session['role'].toString();
      order = response;
      isLoading = false;
    });
  }

  @override
  void initState() {
    isLoading = true; 
    getorderdetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    Size size = MediaQuery.of(context).size;
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Material(
        color: Colors.transparent,
        child: Container(
          height: size.height,
          width: double.infinity,
          color: Colors.black54,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Positioned.fill(
                child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        color: Colors.black54,
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: const [],
                        ))),
              ),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white,
                ),
                height: size.height * .6,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Text(
                        "Order ID: " + order!.orderid,
                        style: const TextStyle(
                            color: primarycolor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(order!.status.toString()),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      orderDetail("Customer Name", order!.CName, size),
                      orderDetail("Phone", order!.CPhone, size),
                      orderDetail("Remark", order!.remark, size),
                      const Divider(
                        height: 10,
                      ),
                      orderDetail(
                          "Address",
                          order!.CAddress + '040123501512515125161621626166',
                          size),
                      orderDetail("Township", order!.township, size),
                      orderDetail("City", order!.city, size),
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
                              child: Text(order!.total.toString() + " MMK",
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                        height: 20,
                      ),
                      const Spacer(),
                      if (role == "Driver")
                        OverlayButtons(
                          orderid: order!.orderid,
                        )
                      else
                        Container()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
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
    widget.controller.dispose();
    super.dispose();
  }
}

// ignore: must_be_immutable
class OverlayButtons extends StatelessWidget {
  String orderid = "";
  OverlayButtons({Key? key, required this.orderid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextStyle textstyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: secondarycolor,
      fontSize: 16,
    );

    BoxDecoration boxdecor = BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(color: Colors.black12, width: 2));

    final Size size = MediaQuery.of(context).size;

    return SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                  onTap: () async {
                    bool confirm = await confirmDialog(context, 'Rescheduled');
                    if (confirm) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return ShowAlertDialog(orderid: orderid, status: '4');
                        },
                      );
                    }
                  },
                  child: Container(
                    width: size.width * 0.3,
                    alignment: Alignment.center,
                    decoration: boxdecor,
                    child: const Text("Reschedule", style: textstyle),
                  )),
              InkWell(
                  onTap: () async {
                    bool confirm = await confirmDialog(context, 'Delivered');
                    if (confirm) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return ShowAlertDialog(orderid: orderid, status: '6');
                        },
                      );
                    }
                  },
                  child: Container(
                    width: size.width * 0.3,
                    alignment: Alignment.center,
                    decoration: boxdecor,
                    child: const Text("Delivered", style: textstyle),
                  )),
              InkWell(
                  onTap: () async {
                    bool confirm = await confirmDialog(context, 'Cancel');
                    if (confirm) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return ShowAlertDialog(orderid: orderid, status: '5');
                        },
                      );
                    }
                  },
                  child: Container(
                    width: size.width * 0.3,
                    alignment: Alignment.center,
                    decoration: boxdecor,
                    child: const Text("Cancel", style: textstyle),
                  )),
            ],
          ),
        ));
  }
}

Future<bool> confirmDialog(BuildContext context, String status) async {
  final Size size = MediaQuery.of(context).size;
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
          child: Container(
        width: size.width * 0.05,
        height: size.height * 0.15,
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'This parcel will be $status!',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 50,
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        )),
                        alignment: Alignment.center,
                        child: const Text('Proceed'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        )),
                        alignment: Alignment.center,
                        child: const Text('Cancel'),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ));
    },
  );
}

// ignore: must_be_immutable
class ShowAlertDialog extends StatefulWidget {
  String orderid;
  String status;
  ShowAlertDialog({Key? key, required this.orderid, required this.status})
      : super(key: key);

  @override
  State<ShowAlertDialog> createState() => _ShowAlertDialogState();
}

class _ShowAlertDialogState extends State<ShowAlertDialog> {
  bool isLoading = true;
  var response;
  @override
  void initState() {
    acceptOrder(widget.orderid, widget.status).then((value) => {
          setState(() {
            response = value;
            isLoading = false;
          })
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: MediaQuery.of(context).size.width * 0.2,
                width: MediaQuery.of(context).size.width * 0.2,
                child: const CircularProgressIndicator(
                  color: primarycolor,
                )),
          )
        : AlertDialog(
            title:
                Text(response['statusCode'] == 200 ? 'Successful' : 'Failed'),
            content: Text(response['msg']),
            actions: [
              Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: const Text('Ok'),
                    ),
                  )),
            ],
          );
  }
}

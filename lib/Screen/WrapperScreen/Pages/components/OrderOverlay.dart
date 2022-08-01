import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pmx/constant.dart';
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
  bool loading = true;
  bool isLoading = false;
  late Animation<double> opacityAnimation;
  Tween<double> opacityTween = Tween<double>(begin: 0.0, end: 1.0);
  Tween<double> marginTopTween = Tween<double>(begin: -50, end: 0);
  late Animation<double> marginTopAnimation;
  late AnimationStatus animationStatus;

  getorderdetails() async {
    Orders response = await getOrderDetails(widget.orderid);
    setState(() {
      order = response;
      loading = false;
    });
  }

  @override
  void initState() {
    getorderdetails();
    super.initState();

    marginTopAnimation = marginTopTween.animate(widget.controller)
      ..addListener(() {
        animationStatus = widget.controller.status;

        if (animationStatus == AnimationStatus.dismissed) {
          Navigator.of(context).pop();
        }

        if (mounted) {
          setState(() {});
        }
      });
    widget.controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return FadeTransition(
      opacity: opacityTween.animate(widget.controller),
      child: WillPopScope(
        onWillPop: () async {
          await widget.controller.reverse();
          return true;
        },
        child: isLoading
            ? Center(
                child: const CircularProgressIndicator(
                  color: primarycolor,
                ),
              )
            : Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(children: [
                  Positioned.fill(
                      child: GestureDetector(
                    onTap: () {
                      widget.controller.reverse();
                    },
                    behavior: HitTestBehavior.opaque,
                  )),
                  Positioned(
                    top: size.height * .08,
                    left: marginTopAnimation.value,
                    child: Container(
                      height: size.height * .8,
                      width: size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      height: size.height * 0.7,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              height: size.height * 0.1,
                                              color: secondarycolor,
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'Order Details',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0.75,
                                                        fontSize: 22),
                                                  ),
                                                  Image.asset(
                                                    'assets/images/minilogo.png',
                                                    height: size.height * 0.08,
                                                  )
                                                ],
                                              )),
                                          Container(
                                            height: 5,
                                            width: size.width,
                                            decoration: BoxDecoration(
                                                color: primarycolor,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          ),
                                          Container(
                                              width: size.width - 20,
                                              height: size.height * 0.56,
                                              child: loading
                                                  ? Center(
                                                      child: Container(
                                                        height: 50,
                                                        width: 50,
                                                        child:
                                                            const CircularProgressIndicator(
                                                                color:
                                                                    primarycolor),
                                                      ),
                                                    )
                                                  : Container(
                                                      padding: EdgeInsets.only(
                                                          left:
                                                              size.width * 0.02,
                                                          right: size.width *
                                                              0.02),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                height: 40,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.45,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    const Text(
                                                                        'OrderId',
                                                                        style: TextStyle(
                                                                            letterSpacing:
                                                                                0.25,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize: 15)),
                                                                    Text(
                                                                      order!
                                                                          .orderid,
                                                                      style: const TextStyle(
                                                                          letterSpacing:
                                                                              0.25,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              15),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                height: 40,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.45,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    const Text(
                                                                        'City',
                                                                        style: TextStyle(
                                                                            letterSpacing:
                                                                                0.25,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize: 15)),
                                                                    Text(
                                                                      order!
                                                                          .CName,
                                                                      style: const TextStyle(
                                                                          letterSpacing:
                                                                              0.25,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              15),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                height: 40,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.45,
                                                                child: Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      const Text(
                                                                          'Remark',
                                                                          style: TextStyle(
                                                                              letterSpacing: 0.25,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 15)),
                                                                      Text(
                                                                        order!
                                                                            .city,
                                                                        style: const TextStyle(
                                                                            letterSpacing:
                                                                                0.25,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize: 15),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                height: 40,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.45,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    const Text(
                                                                        'Township',
                                                                        style: TextStyle(
                                                                            letterSpacing:
                                                                                0.25,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize: 15)),
                                                                    Text(
                                                                      order!
                                                                          .township,
                                                                      style: const TextStyle(
                                                                          letterSpacing:
                                                                              0.25,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              15),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                height: 40,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.45,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    const Text(
                                                                        'Customer Name',
                                                                        style: TextStyle(
                                                                            letterSpacing:
                                                                                0.25,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize: 15)),
                                                                    Text(
                                                                      order!
                                                                          .remark,
                                                                      style: const TextStyle(
                                                                          letterSpacing:
                                                                              0.25,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              15),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                height: 40,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.45,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    const Text(
                                                                        'Total',
                                                                        style: TextStyle(
                                                                            letterSpacing:
                                                                                0.25,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize: 15)),
                                                                    Text(
                                                                      order!
                                                                          .total
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          letterSpacing:
                                                                              0.25,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              15),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              const Text(
                                                                  'Customer Phone',
                                                                  style:
                                                                      TextStyle(
                                                                    letterSpacing:
                                                                        0.25,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        15,
                                                                  )),
                                                              Text(
                                                                order!.CPhone,
                                                                style: const TextStyle(
                                                                    letterSpacing:
                                                                        0.25,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        15),
                                                              )
                                                            ],
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              const Text(
                                                                  'Customer Address',
                                                                  style: TextStyle(
                                                                      letterSpacing:
                                                                          0.25,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          15)),
                                                              Text(
                                                                order!.CAddress,
                                                                style: const TextStyle(
                                                                    letterSpacing:
                                                                        0.25,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        15),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                        ],
                                      )))),
                          widget.past
                              ? Container(
                                  height: 50,
                                  width: 100,
                                  alignment: Alignment.center,
                                  // margin: EdgeInsets.only(top: 10),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 5.5 ,
                                        color: Colors.black54,
                                        offset: Offset(3, 4),
                                        )
                                      ],
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                  child: loading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: primarycolor,
                                          ),
                                        )
                                      : Text(order!.status ?? "",
                                          style: const TextStyle(
                                              color: secondarycolor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                )
                              : OverlayButtons(orderid: widget.orderid)
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}

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

    const BoxDecoration boxdecor = BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 5.5 ,
            color: Colors.black54,
            offset: Offset(3, 4),
            )
          ],
        borderRadius: BorderRadius.all(Radius.circular(10)));

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
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'This parcel will be ${status}!',
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
                        alignment: Alignment.center,
                        decoration:
                            BoxDecoration(border: Border.all(width: 0.5)),
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
                        alignment: Alignment.center,
                        decoration:
                            BoxDecoration(border: Border.all(width: 0.5)),
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
    // TODO: implement initState
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
            child: SizedBox(
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
              SizedBox(
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

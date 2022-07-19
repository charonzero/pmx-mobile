import 'package:flutter/material.dart';
import 'package:pmx/constant.dart';

class OrderOverlay extends StatefulWidget {
  final AnimationController controller;

  const OrderOverlay({Key? key, required this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OrderOverlayState();
}

class OrderOverlayState extends State<OrderOverlay> {
  late Animation<double> opacityAnimation;
  Tween<double> opacityTween = Tween<double>(begin: 0.0, end: 1.0);
  Tween<double> marginTopTween = Tween<double>(begin: -600, end: 0);
  late Animation<double> marginTopAnimation;
  late AnimationStatus animationStatus;

  @override
  void initState() {
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
        child: Scaffold(
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
              bottom: marginTopAnimation.value,
              child: Container(
                height: size.height * .5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              color: Colors.green,
                              child: Column(
                                children: [Text('Hello')],
                              ),
                            ))),
                    const Spacer(),
                    Divider(),
                    const OverlayButtons()
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
  const OverlayButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: cwarning, width: 2.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                        )),
                    child: const Text("Reschedule",
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
                      border: Border.all(color: csuccess, width: 2.5),
                    ),
                    child: const Text("Delivered",
                        style: TextStyle(
                          color: csuccess,
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
                        border: Border.all(color: cdanger, width: 2.5),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                        )),
                    child: const Text("Cancel",
                        style: TextStyle(
                          color: cdanger,
                          fontSize: 15,
                        )),
                  )),
            ),
          ],
        ));
  }
}

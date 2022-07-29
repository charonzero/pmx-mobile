import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final Size size;
  const Background({Key? key, required this.child, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              "assets/images/welcomeflat.jpg",
              width: size.width,
              fit: BoxFit.cover,
            ),
          ),
          child
        ],
      ),
    );
  }
}

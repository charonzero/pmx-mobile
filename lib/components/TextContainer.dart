// ignore_for_file: file_names

import 'package:flutter/material.dart';

class TextContainer extends StatelessWidget {
  final Widget child;
  const TextContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      constraints: const BoxConstraints(minWidth: 100, maxWidth: 350),
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      // decoration: BoxDecoration(
      //     color: kBackgroundColor, borderRadius: BorderRadius.circular(29)),
      child: child,
    );
  }
}

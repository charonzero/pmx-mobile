// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pmx/constant.dart';

class RoundButton extends StatelessWidget {
  final Widget text;
  final Function onpress;
  final Color color, ccolor, textcolor, bcolor;

  const RoundButton({
    Key? key,
    required this.text,
    required this.onpress,
    this.color = primarycolor,
    this.textcolor = Colors.white,
    this.ccolor = primarycolor,
    this.bcolor = primarycolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      width: size.width * 0.8 - 40,
      height: size.height * 0.05,
      child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: textcolor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: color,
            side:
                BorderSide(color: bcolor, width: .75, style: BorderStyle.solid),
          ),
          onPressed: () {
            onpress();
          },
          child: text),
    );
  }
}

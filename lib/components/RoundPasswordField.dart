// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pmx/components/TextContainer.dart';
import 'package:pmx/constant.dart';

class RoundedPasswordField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final IconData suffixicon;
  final ValueChanged<String> onChanged;
  final String validatorText;
  const RoundedPasswordField({
    Key? key,
    required this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
    this.suffixicon = Icons.visibility,
    this.validatorText = 'Please enter your password',
  }) : super(key: key);

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextContainer(
        child: TextFormField(
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return widget.validatorText;
        }
        return null;
      },
      decoration: InputDecoration(
        errorStyle: const TextStyle(
          fontSize: 10.0,
        ),
        suffixIcon: IconButton(
            onPressed: () {
              _toggle();
            },
            icon: Icon(
              widget.suffixicon,
              color: primaryColor,
            )),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Icon(
            widget.icon,
            color: primaryColor,
          ),
        ),
        hintText: widget.hintText,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black87, width: 0),
            borderRadius: BorderRadius.circular(10.0)),
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    ));
  }
}

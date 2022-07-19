import 'dart:ui' as ui;
import 'package:flutter/material.dart';

const primarycolor = Color(0xFFe17624);
const secondarycolor = Color(0xFF1d1a2f);

const cinfo = Color(0xFF17a2b8);
const csuccess = Color(0xFF28a745);
const cwarning = Color(0xFFffc107);
const cdanger = Color(0xFFdc3545);
const cdark = Color(0xFF343a40);

// /// Darken a color by [percent] amount (100 = black)
// // ........................................................
// Color darken(Color c, [int percent = 10]) {
//   assert(1 <= percent && percent <= 100);
//   var f = 1 - percent / 100;
//   return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
//       (c.blue * f).round());
// }

// /// Lighten a color by [percent] amount (100 = white)
// // ........................................................
// Color lighten(Color c, [int percent = 10]) {
//   assert(1 <= percent && percent <= 100);
//   var p = percent / 100;
//   return Color.fromARGB(
//       c.alpha,
//       c.red + ((255 - c.red) * p).round(),
//       c.green + ((255 - c.green) * p).round(),
//       c.blue + ((255 - c.blue) * p).round());
// }

// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pmx/models/login.dart';
import 'package:pmx/models/server.dart';

class Status {
  final double Delivered, Cancel, Rescheduled, Null;

  Status(
      {this.Delivered = 0,
      this.Cancel = 0,
      this.Rescheduled = 0,
      this.Null = 0});

  factory Status.fromjson(Map<String, dynamic> json) {
    return Status(
        Delivered: json['Delivered'] != null ? json['Delivered'].toDouble() : 0,
        Cancel: json['Cancel'] != null ? json['Cancel'].toDouble() : 0,
        Rescheduled:
            json['Rescheduled'] != null ? json['Rescheduled'].toDouble() : 0,
        Null: json['Null'] != null ? json['Null'].toDouble() : 0);
  }

  Map<String, double> toMap() {
    Map<String, double> status = <String, double>{};
    status['Delivered'] = Delivered;
    status['Cancel'] = Cancel;
    status['Rescheduled'] = Rescheduled;
    status['Null'] = Null;
    return status;
  }

  @override
  String toString() {
    return Delivered.toString() +
        "," +
        Cancel.toString() +
        "," +
        Rescheduled.toString() +
        "," +
        Null.toString();
  }
}

// Future<Map<String, double>> fetchStatus(bool a) async {
//   SessionData session = SharedPref().read('session_data');
//   var userid = session.userid;
//   String s = a ? '/getDriverPerformancetdy' : '/getDriverPerformance';

//   String token = session.token;
//   var fetchorders = await http.post(
//     Uri.parse(serverurl + s),
//     headers: {'authorization': token},
//     body: {'userid': userid.toString()},
//   );
//   final decoded = jsonDecode(fetchorders.body);
//   Status status = Status.fromjson(decoded['driverPerformance']);
//   return status.toMap();
// }
// Future<Map<String, double>> fetchStatus(bool a, BuildContext context) async {
//   const pathTdy = '/getDriverPerformancetdy';
//   const path = '/getDriverPerformance';
//   final prefs = SharedPref();
//   final sessionData = await prefs.read('session_data');
//   if (sessionData == null) {
//     Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//     await prefs.remove('session_data');
//     throw 'User is not authenticated';
//   }
//   final token = sessionData['token'];
//   final userid = sessionData['userid'];
//   final response = await Api.post(a ? pathTdy : path, context,
//       headers: {'Authorization': token}, body: {'userid': userid.toString()});
//   if (response.statusCode != 200) {
//     throw 'Failed to fetch driver performance data';
//   }
//   final decoded = jsonDecode(response.body);
//   final status = Status.fromjson(decoded['driverPerformance']);
//   return status.toMap();
// }

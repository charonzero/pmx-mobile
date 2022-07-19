import 'package:flutter/services.dart';
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
    Map<String, double> status = Map<String, double>();
    status['Delivered'] = this.Delivered;
    status['Cancel'] = this.Cancel;
    status['Rescheduled'] = this.Rescheduled;
    status['Null'] = this.Null;
    return status;
  }

  String toString() {
    return this.Delivered.toString() +
        "," +
        this.Cancel.toString() +
        "," +
        this.Rescheduled.toString() +
        "," +
        this.Null.toString();
  }
}

Future<Map<String, double>> fetchStatus(bool a) async {
  Session_data session = SharedPref().read('session_data');
  var userid = session.userid;
  // String s =  a ? 'getPerformanceStatus': 'getTotalStatus';'http://192.168.100.106:2000/'
  // https://05ae60d3-8144-4268-8ceb-f5b3577bd086.mock.pstmn.io/
  String s = a ? 'getDriverPerformancetdy' : 'getDriverPerformance';
  
  String token = session.token;
  var fetchorders = await http.post(
    Uri.parse(serverurl + s),
    headers: {'authorization': token},
    body: {'userid': userid.toString()},
  );
  print(fetchorders.body);
  final decoded = jsonDecode(fetchorders.body);
  Status status = Status.fromjson(decoded['driverPerformance']);
  return status.toMap();
}

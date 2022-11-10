// ignore_for_file: non_constant_identifier_names

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

Future<Map<String, double>> fetchStatus(bool a) async {
  SessionData session = SharedPref().read('session_data');
  var userid = session.userid;
  String s = a ? 'getDriverPerformancetdy' : 'getDriverPerformance';

  String token = session.token;
  var fetchorders = await http.post(
    Uri.parse(serverurl + s),
    headers: {'authorization': token},
    body: {'userid': userid.toString()},
  );
  final decoded = jsonDecode(fetchorders.body);
  Status status = Status.fromjson(decoded['driverPerformance']);
  return status.toMap();
}

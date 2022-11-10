// ignore_for_file: non_constant_identifier_names, annotate_overrides

import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:pmx/models/login.dart';
import 'package:pmx/models/server.dart';

class Orders extends Equatable {
  final int total;
  final String orderid, CName, CAddress, CPhone, remark, township, city;
  final String? status;

  const Orders(
      {required this.orderid,
      required this.CName,
      required this.CAddress,
      required this.CPhone,
      required this.remark,
      required this.township,
      required this.city,
      required this.total,
      this.status});

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
        orderid: json['ordersecret'],
        CName: json['name'],
        CAddress: json['address'],
        CPhone: json['phone'],
        remark: json['remark'] ?? '',
        township: json['township'],
        city: json['city'],
        total: json['total'],
        status: json['status']);
  }

  List<Object> get props => [orderid];

  bool get Stringify => true;
}

Future<List<Orders>> fetchOrders(String userid) async {
  List<Orders> orders = [];
  var data = await SharedPref().read('session_data');
  SessionData session = SessionData.fromJson(data);
  bool isAdmin = !(session.role == 'Driver');
  String url = serverurl + 'getDeliOrders';
  String token = session.token;

  var body = {'userid': userid, 'admin': isAdmin.toString()};

  var fetchorders = await http.post(
    Uri.parse(url),
    headers: {"Access-Control_Allow_Origin": "*", "Authorization": token},
    body: body,
  );
  print(fetchorders.statusCode);
  print(fetchorders.body);
  if (fetchorders.body.isEmpty || fetchorders.statusCode != 200) return orders;
  final decoded =
      jsonDecode(fetchorders.body)['deliorders'].cast<Map<String, dynamic>>();
  orders = decoded.map<Orders>((json) => Orders.fromJson(json)).toList();
  // if(isSorted) orders.sort((a,b) => b.orderid.compareTo(a.orderid));
  return orders;
}

Future<List<Orders>> fetchPastOrders(String userid) async {
  List<Orders> orders = [];
  var data = await SharedPref().read('session_data');
  SessionData session = SessionData.fromJson(data);
  bool isAdmin = session.role == 'Admin' || session.role == 'Super Admin';

  String url = serverurl + 'getDeliOrders';
  String token = session.token;

  var body = {'userid': userid, 'admin': isAdmin.toString(), 'past': 'true'};
  var fetchorders = await http.post(
    Uri.parse(url),
    headers: {"Access-Control_Allow_Origin": "*", "Authorization": token},
    body: body,
  );
  if (fetchorders.body.isEmpty || fetchorders.statusCode != 200) return orders;
  final decoded =
      jsonDecode(fetchorders.body)['deliorders'].cast<Map<String, dynamic>>();
  orders = decoded.map<Orders>((json) => Orders.fromJson(json)).toList();
  // if(isSorted) orders.sort((a,b) => b.orderid.compareTo(a.orderid));
  return orders;
}

Future<Orders> getOrderDetails(String orderid) async {
  var url = serverurl + "getOrderDetails";
  var data = await SharedPref().read('session_data');
  SessionData session = SessionData.fromJson(data);
  String token = session.token;
  var fetchorders = await http.post(
    Uri.parse(url),
    headers: {"Access-Control_Allow_Origin": "*", "authorization": token},
    body: {'orderid': orderid},
  );
  final decoded = jsonDecode(fetchorders.body)["orderdetails"];
  Orders orders = Orders.fromJson(decoded);

  // if(isSorted) orders.sort((a,b) => b.orderid.compareTo(a.orderid));
  return orders;
}

Future<Map<String, dynamic>> acceptOrder(
    String ordersecret, String status) async {
  var url = serverurl + "takeOrder";
  SessionData session =
      SessionData.fromJson(await SharedPref().read('session_data'));
  String token = session.token;
  var fetchorders = await http.post(
    Uri.parse(url),
    headers: {"Access-Control_Allow_Origin": "*", "authorization": token},
    body: {
      'ordersecret': ordersecret,
      "delistatus": status,
      "userid": session.userid.toString()
    },
  );

  return {'statusCode': fetchorders.statusCode, 'msg': fetchorders.body};
}

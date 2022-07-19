import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:pmx/models/login.dart';
import 'package:pmx/models/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Orders extends Equatable {
  final int orderid, total;
  // ignore: non_constant_identifier_names
  final String CName, CAddress, CPhone, remark, township, city;

  Orders(
      {required this.orderid,
      required this.CName,
      required this.CAddress,
      required this.CPhone,
      required this.remark,
      required this.township,
      required this.city,
      required this.total});

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
        orderid: json['orderid'],
        CName: json['CName'],
        CAddress: json['CAddress'],
        CPhone: json['CPhone'],
        remark: json['remark'],
        township: json['township'],
        city: json['city'],
        total: json['total']);
  }

  List<Object> get props => [orderid];

  bool get Stringify => true;
}

Future<List<Orders>> fetchOrders(userid) async {
  List<Orders> orders = [];
  //'https://05ae60d3-8144-4268-8ceb-f5b3577bd086.mock.pstmn.io/getParcels'"http://192.168.100.106:2000/getDeliOrderstdy";
  String url = serverurl + "getDeliOrderstdy";
  Session_data session = SharedPref().read('session_data');
  String token = session.token;
  var fetchorders = await http.post(
    Uri.parse(url),
    headers: {"Access-Control_Allow_Origin": "*", "authorization": token},
    body: {'userid': userid},
  );
  if (fetchorders.body.isEmpty || fetchorders.statusCode != 200) return orders;
  final decoded =
      jsonDecode(fetchorders.body)['deliorders'].cast<Map<String, dynamic>>();
  orders = decoded.map<Orders>((json) => Orders.fromJson(json)).toList();
  // if(isSorted) orders.sort((a,b) => b.orderid.compareTo(a.orderid));
  return orders;
}

Future<List<Orders>> fetchPastOrders(userid) async {
  //'https://05ae60d3-8144-4268-8ceb-f5b3577bd086.mock.pstmn.io/getParcels'"http://192.168.100.106:2000/getDeliOrdersPast"
  String url = serverurl + "getDeliOrdersPast";
  Session_data session = SharedPref().read('session_data');
  String token = session.token;
  var fetchorders = await http.post(
    Uri.parse(url),
    headers: {"Access-Control_Allow_Origin": "*", "authorization": token},
    body: {'userid': userid.toString()},
  );
  final decoded =
      jsonDecode(fetchorders.body)['deliorders'].cast<Map<String, dynamic>>();
  List<Orders> orders =
      decoded.map<Orders>((json) => Orders.fromJson(json)).toList();
  // if(isSorted) orders.sort((a,b) => b.orderid.compareTo(a.orderid));
  return orders;
}

Future<Orders> getOrderDetails(orderid) async {
  //https://05ae60d3-8144-4268-8ceb-f5b3577bd086.mock.pstmn.io/getOrderDetails
  //http://192.168.100.106:2000/getOrderDetails
  var url = serverurl + "getOrderDetails";
  Session_data session = SharedPref().read('session_data');
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

Future<int> acceptOrder(ordersecret, status, userid) async {
  //'https://05ae60d3-8144-4268-8ceb-f5b3577bd086.mock.pstmn.io/acceptOrder'
  //"http://192.168.100.106:2000/takeOrder"
  var url = serverurl + "takeOrder";
  print(url);
  // Session_data session = SharedPref().read('session_data');
  // String token = session.token;
  var fetchorders = await http.post(
    Uri.parse(url),
    headers: {
      "Access-Control_Allow_Origin": "*",
      // "authorization": token
    },
    body: {'ordersecret': ordersecret, "delistatus": status, "userid": userid},
  );
  print(fetchorders.statusCode);

  return fetchorders.statusCode;
}

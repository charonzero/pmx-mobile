import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:pmx/models/login.dart';
import 'package:pmx/models/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Orders extends Equatable {
  final int total;
  // ignore: non_constant_identifier_names
  final String orderid, CName, CAddress, CPhone, remark, township, city;
  final String? status;

  Orders(
      {required this.orderid,
      required this.CName,
      required this.CAddress,
      required this.CPhone,
      required this.remark,
      required this.township,
      required this.city,
      required this.total,
      this.status
      }
      );

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
        orderid: json['ordersecret'],
        CName: json['name'],
        CAddress: json['address'],
        CPhone: json['phone'],
        remark: json['remark'],
        township: json['township'],
        city: json['city'],
        total: json['total'],
        status: json['status']
        );
  }

  List<Object> get props => [orderid];

  bool get Stringify => true;
}

Future<List<Orders>> fetchOrders(String userid) async {
  List<Orders> orders = [];
  var data = await SharedPref().read('session_data');
  Session_data session = Session_data.fromJson(data);
  bool isAdmin = session.role == 'Admin' || session.role == 'Super Admin';

  String url =
      // serverurl + (isAdmin ? "getAdminOrdersPast" : "getDeliOrdersPast");
      serverurl + 'getDeliOrders';
  String token = session.token;

  var body = {'userid': userid, 'admin': isAdmin.toString()};

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

Future<List<Orders>> fetchPastOrders(String userid) async {
  List<Orders> orders = [];
  //'https://05ae60d3-8144-4268-8ceb-f5b3577bd086.mock.pstmn.io/getParcels'"http://192.168.100.106:2000/getDeliOrdersPast"
  var data = await SharedPref().read('session_data');
  Session_data session = Session_data.fromJson(data);
  bool isAdmin = session.role == 'Admin' || session.role == 'Super Admin';

  String url =
      // serverurl + (isAdmin ? "getAdminOrdersPast" : "getDeliOrdersPast");
      serverurl + 'getDeliOrders';
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
  //https://05ae60d3-8144-4268-8ceb-f5b3577bd086.mock.pstmn.io/getOrderDetails
  //http://192.168.100.106:2000/getOrderDetails
  var url = serverurl + "getOrderDetails";
  var data = await SharedPref().read('session_data');
  Session_data session = Session_data.fromJson(data);
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
  //'https://05ae60d3-8144-4268-8ceb-f5b3577bd086.mock.pstmn.io/acceptOrder'
  //"http://192.168.100.106:2000/takeOrder"
  var url = serverurl + "takeOrder";
  Session_data session =
      Session_data.fromJson(await SharedPref().read('session_data'));
  //Session_data.fromJson(await SharedPref().read('session_data'));
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

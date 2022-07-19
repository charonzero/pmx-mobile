import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Session_data {
  final String username;
  final int userid;
  final String role;
  final String token;

  Session_data(
      {required this.username,
      required this.userid,
      required this.role,
      required this.token});

  factory Session_data.toJson(Map<String, dynamic> json) {
    return Session_data(
      username: json['username'],
      userid: json['userid'],
      role: json['role'],
      token: json['token'],
    );
  }

  String toString() {
    return "{ username: $username, userid: $userid }";
  }
}

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key)!);
    // return json.decode(prefs.getString(key) ?? ''); better
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}

Future<int> login(String username, String password) async {
  //https://05ae60d3-8144-4268-8ceb-f5b3577bd086.mock.pstmn.io/checklogin
  //'http://192.168.100.163:2000/mlogin'
  var url = 'http://192.168.100.163:2000/login';
  // await geturl() + "login";
  var response = await http
      .post(Uri.parse(url), body: {'username': username, 'password': password});
  print(response.body);
  debugPrint(response.body);
  Map<String, dynamic> decoded = jsonDecode(response.body)["userdata"];
  decoded['token'] = jsonDecode(response.body)["token"];

  if (response.statusCode == 200) {
    Session_data data = Session_data.toJson(decoded);
    (await SharedPreferences.getInstance())
        .setString('session_data', jsonEncode(data));
  }

  return response.statusCode;
}

Future<bool> logout() async {
  try {
    (await SharedPreferences.getInstance()).clear();
    return true;
  } catch (err) {
    return false;
  }
}

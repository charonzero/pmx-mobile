import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pmx/models/server.dart';
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

  factory Session_data.fromJson(Map<String, dynamic> json) {
    return Session_data(
      username: json['username'],
      userid: json['userid'],
      role: json['role'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'userid': userid,
      'role': role,
      'token': token
    };
  }

  String toString() {
    return "{ username: $username, userid: $userid }";
  }
}

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(key);
    if (data != null) {
      return jsonDecode(data);
    } else {
      return null;
    }
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
  try {
    var url = serverurl + '/login';

    var response = await http.post(Uri.parse(url), body: {
      'username': username,
      'password': password
    }).timeout(const Duration(minutes: 5));
    
    if (response.statusCode == 200) {
      Map<String, dynamic> decoded = jsonDecode(response.body)["userdata"];
      decoded['token'] = jsonDecode(response.body)["token"];
      Session_data data = Session_data.fromJson(decoded);
      (await SharedPreferences.getInstance())
          .setString('session_data', jsonEncode(data.toJson()));
    }

    return response.statusCode;
  } on TimeoutException catch (err) {
    return -1;
  }
}

Future<bool> logout() async {
  try {
    (await SharedPreferences.getInstance()).clear();
    return true;
  } catch (err) {
    return false;
  }
}

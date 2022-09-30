import 'dart:async';
import 'dart:convert';
import 'package:pmx/models/server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SessionData {
  final String username;
  final int userid;
  final String role;
  final String token;

  SessionData(
      {required this.username,
      required this.userid,
      required this.role,
      required this.token});

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
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

  @override
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
    }).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      Map<String, dynamic> decoded = jsonDecode(response.body)["userdata"];
      decoded['token'] = jsonDecode(response.body)["token"];
      SessionData data = SessionData.fromJson(decoded);
      (await SharedPreferences.getInstance())
          .setString('session_data', jsonEncode(data.toJson()));
    }

    return response.statusCode;
  } on TimeoutException {
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

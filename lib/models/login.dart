import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pmx/Screen/LoginScreen/LoginScreen.dart';
import 'package:pmx/models/modals.dart';
import 'package:pmx/models/server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class SessionData extends UserData {
  final String token;
  final String jwt;

  SessionData({
    required String username,
    required int user_id,
    required int role_id,
    required this.token,
    required this.jwt,
    required int roleId,
    required String email,
    required String name,
    required String address,
    required int townshipId,
    required String phone,
    RoleData? role,
    TownshipData? township,
    CityData? city,
    StateData? state,
    CountryData? country,
    String? img,
    String? image,
  }) : super(
          userId: user_id,
          username: username,
          password: null,
          salt: null,
          roleId: roleId,
          role: role,
          email: email,
          name: name,
          address: address,
          townshipId: townshipId,
          phone: phone,
          township: township,
          city: city,
          state: state,
          country: country,
          img: img,
          image: image,
        );

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      username: json['username'],
      user_id: json['user_id'],
      role_id: json['role_id'],
      token: json['token'],
      jwt: json['jwt'] ?? '',
      roleId: json['role_id'],
      email: json['email'],
      name: json['name'],
      address: json['address'],
      townshipId: json['township_id'],
      phone: json['phone'],
      role: json['role'] != null
          ? RoleData.fromJson(json['role'] as Map<String, dynamic>)
          : null,
      township: json['township'] != null
          ? TownshipData.fromJson(json['township'] as Map<String, dynamic>)
          : null,
      city: json['city'] != null
          ? CityData.fromJson(json['city'] as Map<String, dynamic>)
          : null,
      state: json['state'] != null
          ? StateData.fromJson(json['state'] as Map<String, dynamic>)
          : null,
      country: json['country'] != null
          ? CountryData.fromJson(json['country'] as Map<String, dynamic>)
          : null,
      img: json['img'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['token'] = token;
    data['jwt'] = jwt;
    return data;
  }

  @override
  String toString() {
    return "{ username: $username, user_id: $userId }";
  }
}

class SharedPref {
  Future<Map<String, dynamic>> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data != null) {
      return jsonDecode(data);
    } else {
      return <String, dynamic>{};
    }
  }

  Future<void> save(String key, Map<String, dynamic> value) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonValue = jsonEncode(value);
    prefs.setString(key, jsonValue);
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  Future<bool> isUserAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionData = prefs.getString('session_data');
    return sessionData != null;
  }

  Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionData = prefs.getString('session_data');
    if (sessionData != null) {
      final data = jsonDecode(sessionData);
      return data['token'];
    } else {
      return null;
    }
  }
}

class Api {
  static const baseUrl = serverurl;
  static const headers = {'Content-Type': 'application/json'};

  static Future<http.Response> get(String path, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionData = prefs.getString('session_data');
    final token = sessionData != null ? jsonDecode(sessionData)['token'] : null;
    final headersWithAuth = {...headers, 'Authorization': 'Bearer $token'};
    final response =
        await http.get(Uri.parse(baseUrl + path), headers: headersWithAuth);

    if (response.statusCode == 401) {
      logoutAndRedirect();
    }
    return response;
  }

  static Future<http.Response> post(
    String path,
    BuildContext context, {
    required Map<String, dynamic> body,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionData = prefs.getString('session_data');
    final token = sessionData != null ? jsonDecode(sessionData)['token'] : null;

    final headersWithAuth = {
      ...headers ?? {},
      ...Api.headers,
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse(baseUrl + path),
      headers: headersWithAuth,
      body: jsonEncode(body),
    );

    if (response.statusCode == 401) {
      logoutAndRedirect();
    }
    return response;
  }

  static void logoutAndRedirect() async {
    await logout();
    navigatorKey.currentState!
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}

Future<int> login(String username, String password) async {
  try {
    var url = '$serverurl/login';
    var response = await http.post(Uri.parse(url), body: {
      'username': username,
      'password': password,
    }).timeout(const Duration(seconds: 15));

    final statusCode = response.statusCode;
    if (statusCode == 200) {
      Map<String, dynamic> decoded = jsonDecode(response.body)["userdata"];
      final token = jsonDecode(response.body)["token"];
      final jwt = jsonDecode(response.body)['jwt'];

      // Create a new SessionData object with the received token and jwt
      SessionData data = SessionData.fromJson({
        ...decoded,
        'token': token,
        'jwt': jwt,
      });

      // Store the new SessionData in shared preferences
      (await SharedPreferences.getInstance())
          .setString('session_data', jsonEncode(data.toJson()));
    }

    return statusCode;
  } on TimeoutException {
    return -1;
  } catch (err) {
    print(err);
    return -1;
  }
}

Future<bool> logout() async {
  final sessionData = await SharedPref().read('session_data');
  if (sessionData == null) {
    return false;
  }

  await SharedPref().remove('session_data');

  navigatorKey.currentState!
      .push(MaterialPageRoute(builder: (context) => const LoginScreen()));

  return true;
}

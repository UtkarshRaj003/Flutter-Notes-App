import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';

class AuthService {
  // LOGIN
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.login),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({'email': email, 'password': password}),
    );

    debugPrint(response.body);
    debugPrint(response.statusCode.toString());

    return jsonDecode(response.body);
  }

  // REGISTER
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.register),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getUserProfile({required String token}) async {
    final response = await http.get(
      Uri.parse(ApiConstants.profile),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Guard middleware check pass karne ke liye
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to load profile',
      );
    }
  }

  // 2. UPDATE PROFILE DATA
  Future<Map<String, dynamic>> updateProfile({
    required String token,
    required String name,
    required String email,
    String? password,
  }) async {
    final Map<String, dynamic> bodyData = {'name': name, 'email': email};

    if (password != null && password.isNotEmpty) {
      bodyData['password'] = password;
    }

    final response = await http.put(
      Uri.parse(ApiConstants.profile),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(bodyData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to update profile',
      );
    }
  }
}

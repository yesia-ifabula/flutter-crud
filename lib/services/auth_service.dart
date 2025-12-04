import 'dart:convert';

import 'package:flutter_crud/models/auth_request.dart';
import 'package:flutter_crud/models/auth_response.dart';
import 'package:flutter_crud/services/endpoint.dart';
import 'package:http/http.dart' as http;

class AuthService {

  Future<AuthResponse> register(AuthRequest authRequest) async {
    // Call the registration endpoint
    final response = await http.post(
      Uri.parse(Endpoint.register),
      body: authRequest.toJson(),
    );

    return AuthResponse.fromJson(jsonDecode(response.body));
  }

  Future<AuthResponse> login(AuthRequest authRequest) async {
    // Call the login endpoint
    final response = await http.post(
      Uri.parse(Endpoint.login),
      body: authRequest.toJson(),
    );

    return AuthResponse.fromJson(jsonDecode(response.body));
  }

  Future<void> logout() async {
    // Call the logout endpoint
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_crud/models/auth_request.dart';
import 'package:flutter_crud/models/auth_response.dart';
import 'package:flutter_crud/services/auth_service.dart';
import 'package:flutter_crud/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  // Add your authentication logic and state management here

  final AuthService _authService;
  late bool _isLoading;
  late String? name;
  late String? email;
  late String? password; 
  late String? passwordConfirmation;
  final formKey = GlobalKey<FormState>();

  AuthProvider(this._authService) {
    _isLoading = false;
    name = '';
    email = '';
    password = '';
    passwordConfirmation = '';
  }

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<AuthResponse> register() async {
    isLoading = true;
    try {
      final request = AuthRequest(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      final response =  await _authService.register(request);
      return response;
    } catch (e) {
      throw 'Registration failed: $e';
    } finally {
      isLoading = false;
    }
  }

  Future<AuthResponse> login() async {
    isLoading = true;
    try {
      final request = AuthRequest(
        email: email,
        password: password,
      );
      final response = await _authService.login(request);

      if (response.status == 'success') {
        final session = await SharedPreferences.getInstance();
        session.setString(Helper.TOKEN, response.data?.token ?? '');
        session.setBool(Helper.IS_LOGIN, true);
      }

      return response;
    } catch (e) {
      throw 'Login failed: $e';
    } finally {
      isLoading = false;
    }
  }

}

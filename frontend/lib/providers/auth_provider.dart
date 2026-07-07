import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _token;
  String? _userName;
  String? _userEmail; // Naya state parameter email store karne ke liye

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;
  String? get token => _token;
  String? get userName => _userName ?? 'User';
  String? get userEmail => _userEmail ?? '';

  // 1. GET USER PROFILE (Backend se dynamic fetch karne ke liye)
  Future<void> getUserProfile() async {
    if (_token == null) return;
    try {
      _isLoading = true;
      notifyListeners();

      // Make sure aapke AuthService me getUser Profile implemented ho jo get request bheje header ke sath
      final response = await _authService.getUserProfile(token: _token!);
      
      _userName = response['name'];
      _userEmail = response['email'];
    } catch (e) {
      debugPrint("Failed to fetch user: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. UPDATE USER PROFILE
  Future<bool> updateProfile({required String name, required String email, String? password}) async {
    if (_token == null) return false;
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _authService.updateProfile(
        token: _token!,
        name: name,
        email: email,
        password: password,
      );

      _userName = response['name'];
      _userEmail = response['email'];
      
      // Agar backend naya token bhejta hai update par:
      if (response['token'] != null) {
        _token = response['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Update Profile failed: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // LOGIN (Keep as is, but we remove the dependency of name from login if preferred)
  Future<bool> login({required String email, required String password}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _authService.login(email: email, password: password);

      if (response['token'] != null) {
        _token = response['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        
        // Login ke turant baad background me dynamic profile fetch kar lega
        await getUserProfile();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
    }
  }

  // REGISTER
  Future<bool> register({required String name, required String email, required String password}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _authService.register(name: name, email: email, password: password);

      if (response['token'] != null) {
        _token = response['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        
        await getUserProfile();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
    }
  }

  // AUTO LOGIN
  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');

    if (savedToken != null) {
      _token = savedToken;
      // Auto login hote hi pure details token ke bihaf par backend se fresh load honge
      await getUserProfile(); 
    }
  }

  // LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token = null;
    _userName = null;
    _userEmail = null;
    notifyListeners();
  }
}
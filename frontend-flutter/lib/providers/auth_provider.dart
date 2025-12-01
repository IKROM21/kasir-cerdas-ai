import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    setLoading(true);
    try {
      final response = await _apiService.login(email, password);
      if (response.success && response.data != null) {
        _user = response.data;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> register(String name, String email, String password) async {
    setLoading(true);
    try {
      final response = await _apiService.register(name, email, password);
      if (response.success && response.data != null) {
        _user = response.data;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    _user = null;
    notifyListeners();
  }
}
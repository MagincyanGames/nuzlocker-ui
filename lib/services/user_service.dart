import 'package:flutter/material.dart';
import 'api_service.dart';
import '../generated_code/api.swagger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService extends ChangeNotifier {
  bool _isAuthenticated = false;
  UserResponseDto? _currentUser;
  String? _userId;
  String? _username;
  String? _token;
  late ApiService _apiService;

  bool get isAuthenticated => _isAuthenticated;
  UserResponseDto? get currentUser => _currentUser;
  String? get userId => _userId;
  String? get username => _username;
  String? get token => _token;

  Future<void> init() async {
    _apiService = ApiService();
    await _apiService.init();

    // Check if token exists in shared preferences
    if (_apiService.hasToken) {
      _token = await _loadToken();
      await _loadUserData(); // Load cached user data

      // Try to validate authentication by getting user profile
      try {
        await getCurrentUser();
      } catch (e) {
        // If fetching user profile fails, user is not authenticated
        _clearUserData();
      }
    } else {
      _clearUserData();
    }
  }

  Future<String?> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('user_id');
    _username = prefs.getString('username');

    if (_userId != null && _username != null) {
      // Create minimal user object from cached data
      _currentUser = UserResponseDto(
        id: _userId!,
        username: _username!,
        name: prefs.getString('user_name') ?? _username!,
      );
      _isAuthenticated = true;
    }
  }

  Future<void> _saveUserData() async {
    if (_currentUser != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', _currentUser!.id);
      await prefs.setString('username', _currentUser!.username);
      if (_currentUser!.name != null) {
        await prefs.setString('user_name', _currentUser!.name);
      }
    }
  }

  void _clearUserData() {
    _isAuthenticated = false;
    _currentUser = null;
    _userId = null;
    _username = null;
    _token = null;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await _apiService.login(username, password);

      if (response != null && response.success) {
        _isAuthenticated = true;
        _token = response.accessToken;
        _userId = response.id;
        _username = username;

        // Get complete user profile
        await getCurrentUser();

        // Save user data to shared preferences
        await _saveUserData();

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _clearUserData();
      rethrow;
    }
  }

  Future<bool> register(
    String username,
    String password, {
    String? name,
  }) async {
    try {
      // Transform username to a formatted name if name is null
      String processedName;
      if (name == null) {
        // Replace underscores with spaces
        String noUnderscores = username.replaceAll('_', ' ');

        // Add a space before each uppercase letter (except at the beginning)
        String formatted = noUnderscores.replaceAllMapped(
          RegExp(r'(?<=[a-z])[A-Z]'),
          (match) => ' ${match.group(0)}',
        );

        // Split by spaces and capitalize each word
        List<String> words = formatted.split(' ');
        processedName = words
            .map(
              (word) =>
                  word.isNotEmpty
                      ? '${word[0].toUpperCase()}${word.substring(1)}'
                      : '',
            )
            .join(' ');
      } else {
        processedName = name;
      }

      final response = await _apiService.register(
        username,
        password,
        processedName,
      );
      if (response != null) {
        // After registration, login automatically
        return await login(username, password);
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _apiService.clearToken();

    // Clear user data from shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('username');
    await prefs.remove('user_name');

    _clearUserData();
  }

  Future<UserResponseDto?> getCurrentUser() async {
    try {
      if (_apiService.hasToken) {
        // In a real implementation, you would fetch the current user profile
        // For example:
        // final response = await _api.apiUsersProfileGet();
        // _currentUser = response.body;

        // For now, we'll use the minimal user object we have
        if (_userId != null && _username != null && _currentUser == null) {
          _currentUser = UserResponseDto(
            id: _userId!,
            username: _username!,
            name: _username!, // Default to username if name not available
          );
        }

        _isAuthenticated = true;
        notifyListeners();
      } else {
        _clearUserData();
      }
      return _currentUser;
    } catch (e) {
      _clearUserData();
      return null;
    }
  }

  Future<void> updateProfile({String? name, String? email}) async {
    // This would need an implementation in ApiService
    // In a real implementation, add a method to update user profile

    // After successful update:
    if (name != null && _currentUser != null) {
      _currentUser = _currentUser!.copyWith(name: name);
      await _saveUserData();
      notifyListeners();
    }
  }
}

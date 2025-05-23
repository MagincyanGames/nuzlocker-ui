import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeveloperService extends ChangeNotifier {
  static const String _developerModeKey = 'developer_mode';
  bool _isDeveloperMode = false;
  int _clickCount = 0;

  bool get isDeveloperMode => _isDeveloperMode;
  int get clickCount => _clickCount;

  DeveloperService() {
    _loadDeveloperMode();
  }

  Future<void> _loadDeveloperMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDeveloperMode = prefs.getBool(_developerModeKey) ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading developer mode: $e');
    }
  }

  Future<void> _saveDeveloperMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_developerModeKey, _isDeveloperMode);
    } catch (e) {
      debugPrint('Error saving developer mode: $e');
    }
  }

  void onPokeballTap(BuildContext context) {
    // Only count clicks if developer mode is not already active
    if (!_isDeveloperMode) {
      _clickCount++;

      if (_clickCount >= 6) {
        _activateDeveloperMode();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('🚀 Modo developer activado'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
        _clickCount = 0; // Reset counter
      }

      // Reset counter after 3 seconds if not enough clicks
      Future.delayed(const Duration(seconds: 3), () {
        if (_clickCount < 6) {
          _clickCount = 0;
        }
      });
    }
  }

  Future<void> _activateDeveloperMode() async {
    _isDeveloperMode = true;
    await _saveDeveloperMode();
    notifyListeners();

    debugPrint('Developer mode enabled');
  }

  Future<void> disableDeveloperMode() async {
    _isDeveloperMode = false;
    _clickCount = 0; // Reset click count when disabling
    await _saveDeveloperMode();
    notifyListeners();

    debugPrint('Developer mode disabled');
  }

  Future<void> enableDeveloperMode() async {
    return _activateDeveloperMode();
  }
}

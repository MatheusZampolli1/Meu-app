import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppPreferences {
  AppPreferences(this._box);

  static const String onboardingCompletedKey = 'onboarding_completed';

  final Box<dynamic> _box;

  bool get onboardingCompleted =>
      _box.get(onboardingCompletedKey, defaultValue: false) as bool;

  Future<void> setOnboardingCompleted(bool value) async {
    await _box.put(onboardingCompletedKey, value);
  }

  ValueListenable<Box<dynamic>> listenable() => _box.listenable();
}

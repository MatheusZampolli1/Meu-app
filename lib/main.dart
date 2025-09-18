import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:game_master_plus/modules/automation/data/automation_rule_repository.dart';
import 'package:game_master_plus/modules/dashboard/data/metric_history_repository.dart';
import 'package:game_master_plus/modules/security/data/security_event_repository.dart';
import 'package:game_master_plus/shared/app.dart';
import 'package:game_master_plus/shared/services/app_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Object? initializationError;

  try {
    await _ensureBox(MetricHistoryRepository.boxName);
    await _ensureBox(AutomationRuleRepository.boxName);
    await _ensureBox(SecurityEventRepository.boxName);
  } catch (error, stack) {
    initializationError = error;
    debugPrint('Hive initialization failed: $error\n$stack');
  }

  late final Box<dynamic> preferencesBox;
  try {
    preferencesBox = await Hive.openBox<dynamic>('app_preferences');
  } catch (error, stack) {
    initializationError ??= error;
    debugPrint('Opening preferences failed: $error\n$stack');
    preferencesBox = await Hive.openBox<dynamic>('app_preferences_fallback');
  }

  runApp(
    FluxonApp(
      preferences: AppPreferences(preferencesBox),
      initializationError: initializationError,
    ),
  );
}

Future<void> _ensureBox(String name) async {
  if (Hive.isBoxOpen(name)) {
    final box = Hive.box(name);
    if (box is Box<Map<String, dynamic>>) {
      return;
    }
    await box.close();
  }

  await Hive.openBox<Map<String, dynamic>>(name);
}

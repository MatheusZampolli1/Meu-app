import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:game_master_plus/modules/automation/data/automation_rule_repository.dart';
import 'package:game_master_plus/modules/dashboard/data/metric_history_repository.dart';
import 'package:game_master_plus/modules/security/data/security_event_repository.dart';
import 'package:game_master_plus/shared/app.dart';
import 'package:game_master_plus/shared/services/app_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late Box<dynamic> preferencesBox;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('fluxon_test_hive');
    Hive.init(tempDir.path);

    await Hive.openBox<Map<String, dynamic>>(MetricHistoryRepository.boxName);
    await Hive.openBox<Map<String, dynamic>>(AutomationRuleRepository.boxName);
    await Hive.openBox<Map<String, dynamic>>(SecurityEventRepository.boxName);
    preferencesBox = await Hive.openBox<dynamic>('app_preferences_test');
  });

  tearDownAll(() async {
    await Hive.deleteBoxFromDisk(MetricHistoryRepository.boxName);
    await Hive.deleteBoxFromDisk(AutomationRuleRepository.boxName);
    await Hive.deleteBoxFromDisk(SecurityEventRepository.boxName);
    await preferencesBox.deleteFromDisk();
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  testWidgets('FluxonApp renders onboarding by default', (tester) async {
    final preferences = AppPreferences(preferencesBox);

    await tester.pumpWidget(FluxonApp(preferences: preferences));
    await tester.pumpAndSettle();

    expect(find.byType(FluxonApp), findsOneWidget);
    expect(find.textContaining('Fluxon'), findsWidgets);
  });
}

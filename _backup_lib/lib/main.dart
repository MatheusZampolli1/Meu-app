import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:game_master_plus/modules/automation/data/automation_rule_repository.dart';
import 'package:game_master_plus/modules/dashboard/data/metric_history_repository.dart';\nimport 'package:game_master_plus/modules/security/data/security_event_repository.dart';
import 'package:game_master_plus/shared/app.dart';

export 'package:game_master_plus/shared/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<Map<String, dynamic>>(MetricHistoryRepository.boxName);
  await Hive.openBox<Map<String, dynamic>>(AutomationRuleRepository.boxName);\n  await Hive.openBox<Map<String, dynamic>>(SecurityEventRepository.boxName);
  runApp(const FluxonApp());
}


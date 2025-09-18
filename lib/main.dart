import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:game_master_plus/modules/automation/data/automation_rule_repository.dart';
import 'package:game_master_plus/modules/dashboard/data/metric_history_repository.dart';
import 'package:game_master_plus/modules/security/data/security_event_repository.dart';
import 'package:game_master_plus/shared/app.dart';
import 'package:game_master_plus/shared/services/app_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Hive
  await Hive.initFlutter();

  Object? initializationError;

  try {
    // Garante que os boxes principais sejam abertos
    await _ensureBox(MetricHistoryRepository.boxName);
    await _ensureBox(AutomationRuleRepository.boxName);
    await _ensureBox(SecurityEventRepository.boxName);
  } catch (error, stack) {
    initializationError = error;
    debugPrint('Hive initialization failed: $error\n$stack');
  }

  late final Box<dynamic> preferencesBox;
  try {
    // Abre box de preferências principal
    preferencesBox = await Hive.openBox<dynamic>('app_preferences');
  } catch (error, stack) {
    initializationError ??= error;
    debugPrint('Opening preferences failed: $error\n$stack');
    // Fallback para não travar o app
    preferencesBox = await Hive.openBox<dynamic>('app_preferences_fallback');
  }

  // 🔑 Antes de rodar o app, solicita permissões
  await _requestPermissions();

  // Roda o app
  runApp(
    FluxonApp(
      preferences: AppPreferences(preferencesBox),
      initializationError: initializationError,
    ),
  );
}

/// Função auxiliar para garantir abertura dos boxes Hive
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

/// 🔑 Função para pedir permissões necessárias
Future<void> _requestPermissions() async {
  final permissions = [
    Permission.storage, // para ver armazenamento livre
    Permission.ignoreBatteryOptimizations, // para métricas de energia
    Permission.notification, // para alertas
    Permission.systemAlertWindow, // se precisar de overlay futuramente
  ];

  for (final perm in permissions) {
    final status = await perm.request();
    if (status.isDenied) {
      debugPrint('⚠️ Permissão negada: $perm');
    }
  }
}

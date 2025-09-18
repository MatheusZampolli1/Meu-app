import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class DeviceMetrics {
  const DeviceMetrics({
    required this.cpuUsage,
    required this.ramUsage,
    required this.storageFree,
    required this.temperature,
    required this.batteryLevel,
    required this.updatedAt,
  });

  final double cpuUsage;
  final double ramUsage;
  final double storageFree;
  final double temperature;
  final int batteryLevel;
  final DateTime updatedAt;

  static double _parseDouble(dynamic value, double fallback) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  static int _parseInt(dynamic value, int fallback) {
    if (value is num) return value.round();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  factory DeviceMetrics.fromMap(Map<dynamic, dynamic> data) {
    final map = Map<dynamic, dynamic>.from(data);
    return DeviceMetrics(
      cpuUsage: _parseDouble(map['cpuUsage'], 0),
      ramUsage: _parseDouble(map['ramUsage'], 0),
      storageFree: _parseDouble(map['storageFreeGb'] ?? map['storageFree'], 0),
      temperature: _parseDouble(map['temperatureC'] ?? map['temperature'], 0),
      batteryLevel: _parseInt(map['batteryLevel'], 0),
      updatedAt: DateTime.now(),
    );
  }

  factory DeviceMetrics.fromStorageMap(Map<String, dynamic> data) {
    return DeviceMetrics(
      cpuUsage: _parseDouble(data['cpuUsage'], 0),
      ramUsage: _parseDouble(data['ramUsage'], 0),
      storageFree: _parseDouble(data['storageFreeGb'] ?? data['storageFree'], 0),
      temperature: _parseDouble(data['temperatureC'] ?? data['temperature'], 0),
      batteryLevel: _parseInt(data['batteryLevel'], 0),
      updatedAt: DateTime.tryParse(data['updatedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toStorageMap() {
    return {
      'cpuUsage': cpuUsage,
      'ramUsage': ramUsage,
      'storageFreeGb': storageFree,
      'temperatureC': temperature,
      'batteryLevel': batteryLevel,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory DeviceMetrics.initial() {
    final random = Random();
    return DeviceMetrics(
      cpuUsage: (25 + random.nextInt(55)).toDouble(),
      ramUsage: (35 + random.nextInt(50)).toDouble(),
      storageFree: (16 + random.nextInt(100)).toDouble(),
      temperature: (28 + random.nextInt(12)).toDouble() + random.nextDouble(),
      batteryLevel: 40 + random.nextInt(60),
      updatedAt: DateTime.now(),
    );
  }
}

class SystemMetricsService {
  SystemMetricsService({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('fluxon/metrics');

  final MethodChannel _channel;
  DeviceMetrics? _last;

  Future<DeviceMetrics> fetchMetrics() async {
    final dynamic result = await _channel.invokeMethod<dynamic>('getMetrics');
    if (result is Map) {
      final metrics = DeviceMetrics.fromMap(result);
      _last = metrics;
      return metrics;
    }
    throw const FormatException('Invalid metrics payload');
  }

  Stream<DeviceMetrics> metricsStream({Duration period = const Duration(seconds: 5)}) async* {
    while (true) {
      try {
        final metrics = await fetchMetrics();
        yield metrics;
      } catch (_) {
        _last ??= DeviceMetrics.initial();
        yield _last!;
      }
      await Future<void>.delayed(period);
    }
  }
}

class SystemAutomationService {
  SystemAutomationService({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('game_master_plus/device_actions');

  final MethodChannel _channel;

  Future<void> applyPerformanceProfile({
    required String performanceProfile,
    required String networkProfile,
    required double brightnessLevel,
    required bool limitBackgroundApps,
    required bool adaptiveBattery,
  }) async {
    try {
      await _channel.invokeMethod<void>('applyPerformanceProfile', {
        'performanceProfile': performanceProfile,
        'networkProfile': networkProfile,
        'brightness': brightnessLevel,
        'limitBackgroundApps': limitBackgroundApps,
        'adaptiveBattery': adaptiveBattery,
      });
    } catch (_) {
      await openBatterySaverSettings();
    }
  }

  Future<void> runQuickOptimize() async {
    try {
      await _channel.invokeMethod<void>('runQuickOptimize');
    } catch (_) {
      await openBatterySaverSettings();
    }
  }

  Future<void> scheduleUnlockOptimization({required bool enable}) async {
    try {
      await _channel.invokeMethod<void>('scheduleUnlockOptimization', {'enable': enable});
    } catch (_) {
      // fallback noop when native side is absent
    }
  }

  Future<void> scheduleNightlyCleanup({required bool enable}) async {
    try {
      await _channel.invokeMethod<void>('scheduleNightlyCleanup', {'enable': enable});
    } catch (_) {
      if (enable) {
        await openStorageSettings();
      }
    }
  }

  Future<void> openDisplaySettings() async {
    if (Platform.isAndroid) {
      await const AndroidIntent(action: 'android.settings.DISPLAY_SETTINGS').launch();
    } else {
      await _launchUri(Uri.parse('app-settings:'));
    }
  }

  Future<void> openBatterySaverSettings() async {
    if (Platform.isAndroid) {
      await const AndroidIntent(action: 'android.settings.BATTERY_SAVER_SETTINGS').launch();
    } else {
      await _launchUri(Uri.parse('app-settings:'));
    }
  }

  Future<void> openStorageSettings() async {
    if (Platform.isAndroid) {
      await const AndroidIntent(action: 'android.settings.INTERNAL_STORAGE_SETTINGS').launch();
    } else {
      await _launchUri(Uri.parse('app-settings:'));
    }
  }

  Future<void> openNetworkSettings() async {
    if (Platform.isAndroid) {
      await const AndroidIntent(action: 'android.settings.WIFI_SETTINGS').launch();
    } else {
      await _launchUri(Uri.parse('app-settings:'));
    }
  }

  Future<void> openDoNotDisturbSettings() async {
    if (Platform.isAndroid) {
      await const AndroidIntent(action: 'android.settings.NOTIFICATION_POLICY_ACCESS_SETTINGS').launch();
    } else {
      await _launchUri(Uri.parse('app-settings:'));
    }
  }

  Future<void> _launchUri(Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw PlatformException(code: 'launch_failed', message: 'N�o foi poss�vel abrir ');
    }
  }
}

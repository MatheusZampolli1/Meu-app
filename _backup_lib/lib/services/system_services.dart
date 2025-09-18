import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:android_intent_plus/android_intent.dart';
import 'package:battery_plus/battery_plus.dart';
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
    return DeviceMetrics(
      cpuUsage: _parseDouble(data['cpuUsage'], 0),
      ramUsage: _parseDouble(data['ramUsage'], 0),
      storageFree: _parseDouble(data['storageFree'], 0),
      temperature: _parseDouble(data['temperature'], 0),
      batteryLevel: _parseInt(data['batteryLevel'], 0),
      updatedAt: DateTime.now(),
    );
  }

  factory DeviceMetrics.fromStorageMap(Map<String, dynamic> data) {
    return DeviceMetrics(
      cpuUsage: _parseDouble(data['cpuUsage'], 0),
      ramUsage: _parseDouble(data['ramUsage'], 0),
      storageFree: _parseDouble(data['storageFree'], 0),
      temperature: _parseDouble(data['temperature'], 0),
      batteryLevel: _parseInt(data['batteryLevel'], 0),
      updatedAt: DateTime.tryParse(data['updatedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toStorageMap() {
    return {
      'cpuUsage': cpuUsage,
      'ramUsage': ramUsage,
      'storageFree': storageFree,
      'temperature': temperature,
      'batteryLevel': batteryLevel,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory DeviceMetrics.initial() {
    final random = Random();
    return DeviceMetrics.fallback(random);
  }

  factory DeviceMetrics.fallback(Random random, {int? batteryLevel}) {
    return DeviceMetrics(
      cpuUsage: (25 + random.nextInt(55)).toDouble(),
      ramUsage: (35 + random.nextInt(50)).toDouble(),
      storageFree: (16 + random.nextInt(100)).toDouble(),
      temperature: 28 + random.nextInt(12) + random.nextDouble(),
      batteryLevel: batteryLevel ?? (40 + random.nextInt(60)),
      updatedAt: DateTime.now(),
    );
  }
}

class SystemMetricsService {
  SystemMetricsService({MethodChannel? channel, Battery? battery})
      : _channel = channel ?? const MethodChannel('game_master_plus/system_metrics'),
        _battery = battery ?? Battery(),
        _random = Random();

  final MethodChannel _channel;
  final Battery _battery;
  final Random _random;

  Future<DeviceMetrics> fetchMetrics() async {
    Map<dynamic, dynamic>? data;
    try {
      final result = await _channel.invokeMethod<dynamic>('getMetrics');
      if (result is Map) {
        data = result;
      }
    } on PlatformException {
      data = null;
    }

    int? batteryLevel;
    try {
      batteryLevel = await _battery.batteryLevel;
    } catch (_) {
      batteryLevel = null;
    }

    if (data != null) {
      final metrics = DeviceMetrics.fromMap(data);
      if (batteryLevel != null && batteryLevel > 0) {
        return DeviceMetrics(
          cpuUsage: metrics.cpuUsage,
          ramUsage: metrics.ramUsage,
          storageFree: metrics.storageFree,
          temperature: metrics.temperature,
          batteryLevel: batteryLevel,
          updatedAt: DateTime.now(),
        );
      }
      return metrics;
    }

    return DeviceMetrics.fallback(_random, batteryLevel: batteryLevel);
  }

  Stream<DeviceMetrics> metricsStream({Duration interval = const Duration(seconds: 5)}) async* {
    while (true) {
      yield await fetchMetrics();
      await Future<void>.delayed(interval);
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
      throw PlatformException(code: 'launch_failed', message: 'Não foi possível abrir ${uri.toString()}');
    }
  }
}




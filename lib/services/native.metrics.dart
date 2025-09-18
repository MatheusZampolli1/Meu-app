import 'package:flutter/services.dart';

class NativeMetrics {
  static const _channel = MethodChannel('fluxon/metrics');

  static Future<Map<String, dynamic>> getSystemMetrics() async {
    final result = await _channel.invokeMethod<Map>('getSystemMetrics');
    return Map<String, dynamic>.from(result ?? {});
  }
}
import 'package:flutter/services.dart';

class PerfNative {
  static const MethodChannel _channel = MethodChannel('fluxon/perf');

  static Future<void> startTurbo() => _channel.invokeMethod('startTurbo');

  static Future<void> stopTurbo() => _channel.invokeMethod('stopTurbo');

  static Future<void> requestIgnoreBatteryOpt() =>
      _channel.invokeMethod('requestIgnoreBatteryOpt');
}

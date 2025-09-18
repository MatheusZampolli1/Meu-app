import 'dart:async';
import 'package:hive/hive.dart';

import '../domain/security_event.dart';

class SecurityEventRepository {
  SecurityEventRepository(Box<Map<String, dynamic>> box) : _box = box;

  static const String boxName = 'security_events';
  static const int _maxEntries = 200;

  final Box<Map<String, dynamic>> _box;

  Box<Map<String, dynamic>> get box => _box;

  Future<SecurityEvent> addEvent({
    required String type,
    required String message,
    Map<String, dynamic>? meta,
    String? title,
  }) async {
    final now = DateTime.now();
    final event = SecurityEvent(
      id: now.microsecondsSinceEpoch.toString(),
      type: type,
      title: title ?? _deriveTitle(type),
      message: message,
      createdAt: now,
      meta: meta,
    );

    await add(event);
    return event;
  }

  Future<void> add(SecurityEvent event) async {
    await _box.add(event.toMap());
    await _enforceLimit();
  }

  List<SecurityEvent> recent({int limit = 20}) {
    final events = _box.values
        .map((value) => SecurityEvent.fromMap(Map<String, dynamic>.from(value)))
        .toList(growable: false)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return events.take(limit).toList(growable: false);
  }

  Future<void> clear() => _box.clear();

  Future<void> clearAll() => _box.clear();

  Future<void> _enforceLimit() async {
    if (_box.length <= _maxEntries) {
      return;
    }

    final overflow = _box.length - _maxEntries;
    final keysToRemove = _box.keys.cast<dynamic>().take(overflow).toList();
    if (keysToRemove.isNotEmpty) {
      await _box.deleteAll(keysToRemove);
    }
  }

  String _deriveTitle(String type) {
    if (type.isEmpty) {
      return 'Security event';
    }

    final formatted = type[0].toUpperCase() + type.substring(1);
    return '$formatted alert';
  }
}

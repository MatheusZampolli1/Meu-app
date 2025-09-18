import 'package:hive_flutter/hive_flutter.dart';

import 'package:game_master_plus/services/system_services.dart';

class MetricHistoryRepository {
  MetricHistoryRepository(Box<Map<String, dynamic>> box) : _box = box;

  static const String boxName = 'metric_history';
  static const int _maxEntries = 288; // ~24h at 5-minute intervals

  final Box<Map<String, dynamic>> _box;

  Future<void> addSnapshot(DeviceMetrics metrics) async {
    await _box.add(metrics.toStorageMap());
    if (_box.length > _maxEntries) {
      final overflow = _box.length - _maxEntries;
      final keysToDelete = _box.keys.cast<int>().take(overflow).toList();
      await _box.deleteAll(keysToDelete);
    }
  }

  List<DeviceMetrics> recent({int limit = 24}) {
    if (_box.isEmpty) return const [];
    final entries = _box.values.toList(growable: false);
    final start = entries.length > limit ? entries.length - limit : 0;
    final slice = entries.sublist(start);
    return slice
        .map((entry) => DeviceMetrics.fromStorageMap(Map<String, dynamic>.from(entry)))
        .toList(growable: false);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}


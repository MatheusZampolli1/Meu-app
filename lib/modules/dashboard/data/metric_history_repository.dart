import 'package:hive/hive.dart';
import 'package:game_master_plus/services/system_services.dart';

class MetricHistoryRepository {
  static const boxName = 'metric_history';

  final Box<Map<String, dynamic>> _box;

  MetricHistoryRepository(this._box);

  /// Salva uma nova métrica no histórico
  Future<void> addSnapshot(DeviceMetrics metrics) async {
    await _box.add(metrics.toStorageMap());
  }

  /// Retorna os registros mais recentes, limitados por [limit]
  List<DeviceMetrics> recent({int limit = 32}) {
    final values = _box.values.toList();
    final slice = values.length > limit ? values.sublist(values.length - limit) : values;

    return slice
        .map((entry) => DeviceMetrics.fromStorageMap(Map<String, dynamic>.from(entry)))
        .toList(growable: false);
  }

  /// Retorna todos os registros
  List<DeviceMetrics> getAll() {
    return _box.values
        .map((entry) => DeviceMetrics.fromStorageMap(Map<String, dynamic>.from(entry)))
        .toList(growable: false);
  }

  /// Limpa todo o histórico
  Future<void> clear() async {
    await _box.clear();
  }

  /// Quantidade de registros salvos
  int count() => _box.length;
}

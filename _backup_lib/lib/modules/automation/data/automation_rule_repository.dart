import 'package:hive/hive.dart';

import 'package:game_master_plus/modules/automation/domain/automation_rule.dart';

class AutomationRuleRepository {
  const AutomationRuleRepository(this._box);

  static const String boxName = 'automation_rules';

  final Box<Map<String, dynamic>> _box;

  List<AutomationRule> getAll() {
    return _box.values
        .map((value) => AutomationRule.fromMap(Map<String, dynamic>.from(value)))
        .toList(growable: false);
  }

  Future<void> upsertRule(AutomationRule rule) async {
    final existingKey = _findKey(rule.id);
    if (existingKey != null) {
      await _box.put(existingKey, rule.toMap());
    } else {
      await _box.add(rule.toMap());
    }
  }

  Future<void> deleteRule(String ruleId) async {
    final key = _findKey(ruleId);
    if (key != null) {
      await _box.delete(key);
    }
  }

  Future<void> clear() async => _box.clear();

  dynamic _findKey(String id) {
    for (final key in _box.keys) {
      final value = _box.get(key);
      if (value != null && value['id'] == id) {
        return key;
      }
    }
    return null;
  }
}

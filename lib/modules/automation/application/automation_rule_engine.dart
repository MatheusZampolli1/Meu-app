import 'package:flutter/material.dart';

import 'package:game_master_plus/modules/automation/data/automation_rule_repository.dart';
import 'package:game_master_plus/modules/automation/domain/automation_condition.dart';
import 'package:game_master_plus/modules/automation/domain/automation_rule.dart';
import 'package:game_master_plus/services/system_services.dart';

class AutomationRuleEngine {
  AutomationRuleEngine({
    required AutomationRuleRepository repository,
    required SystemAutomationService automationService,
  })  : _repository = repository,
        _automationService = automationService;

  final AutomationRuleRepository _repository;
  final SystemAutomationService _automationService;

  List<AutomationRule> get rules => _repository.getAll();

  Future<void> saveRule(AutomationRule rule) => _repository.upsertRule(rule);

  Future<void> deleteRule(String id) => _repository.deleteRule(id);

  Future<void> toggleRule(String id, bool enabled) async {
    final current = rules.where((rule) => rule.id == id).toList();
    if (current.isEmpty) return;
    await _repository.upsertRule(current.first.copyWith(enabled: enabled));
  }

  Future<List<AutomationRule>> evaluateForMetrics(DeviceMetrics metrics) async {
    final executed = <AutomationRule>[];
    final now = DateTime.now();
    for (final rule in rules) {
      if (!rule.enabled) continue;
      if (!_canRun(rule, now)) continue;
      if (_shouldTrigger(rule.condition, metrics: metrics, now: now)) {
        await rule.action.execute(_automationService);
        final updatedRule = rule.copyWith(lastRun: now);
        await _repository.upsertRule(updatedRule);
        executed.add(updatedRule);
      }
    }
    return executed;
  }

  Future<List<AutomationRule>> evaluateUnlockEvent() async {
    final executed = <AutomationRule>[];
    final now = DateTime.now();
    for (final rule in rules) {
      if (!rule.enabled) continue;
      if (rule.condition.type != AutomationConditionType.unlock) continue;
      if (!_canRun(rule, now)) continue;
      await rule.action.execute(_automationService);
      final updatedRule = rule.copyWith(lastRun: now);
      await _repository.upsertRule(updatedRule);
      executed.add(updatedRule);
    }
    return executed;
  }

  bool _shouldTrigger(
    AutomationCondition condition, {
    required DeviceMetrics metrics,
    required DateTime now,
  }) {
    switch (condition.type) {
      case AutomationConditionType.unlock:
        return false;
      case AutomationConditionType.batteryBelow:
        final threshold = condition.threshold?.toDouble() ?? 20;
        return metrics.batteryLevel <= threshold;
      case AutomationConditionType.timeOfDay:
        final time = condition.time ?? const TimeOfDay(hour: 22, minute: 0);
        final scheduled = DateTime(now.year, now.month, now.day, time.hour, time.minute);
        final diff = now.difference(scheduled).inMinutes;
        return diff.abs() <= 10;
    }
  }

  bool _canRun(AutomationRule rule, DateTime now) {
    final last = rule.lastRun;
    if (last == null) return true;
    switch (rule.condition.type) {
      case AutomationConditionType.unlock:
        return now.difference(last).inMinutes >= 5;
      case AutomationConditionType.batteryBelow:
        return now.difference(last).inMinutes >= 30;
      case AutomationConditionType.timeOfDay:
        return !(last.year == now.year && last.month == now.month && last.day == now.day);
    }
  }
}

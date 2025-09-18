import 'package:game_master_plus/modules/automation/domain/automation_action.dart';
import 'package:game_master_plus/modules/automation/domain/automation_condition.dart';

class AutomationRule {
  const AutomationRule({
    required this.id,
    required this.name,
    required this.condition,
    required this.action,
    required this.enabled,
    required this.createdAt,
    this.lastRun,
  });

  factory AutomationRule.create({
    required String name,
    required AutomationCondition condition,
    required AutomationAction action,
  }) {
    final now = DateTime.now();
    return AutomationRule(
      id: now.millisecondsSinceEpoch.toString(),
      name: name,
      condition: condition,
      action: action,
      enabled: true,
      createdAt: now,
    );
  }

  final String id;
  final String name;
  final AutomationCondition condition;
  final AutomationAction action;
  final bool enabled;
  final DateTime createdAt;
  final DateTime? lastRun;

  AutomationRule copyWith({
    String? name,
    AutomationCondition? condition,
    AutomationAction? action,
    bool? enabled,
    DateTime? lastRun,
  }) {
    return AutomationRule(
      id: id,
      name: name ?? this.name,
      condition: condition ?? this.condition,
      action: action ?? this.action,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt,
      lastRun: lastRun ?? this.lastRun,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'condition': condition.toMap(),
      'action': action.toMap(),
      'enabled': enabled,
      'createdAt': createdAt.toIso8601String(),
      'lastRun': lastRun?.toIso8601String(),
    };
  }

  factory AutomationRule.fromMap(Map<String, dynamic> map) {
    return AutomationRule(
      id: map['id'] as String,
      name: map['name'] as String? ?? 'Rule',
      condition: AutomationCondition.fromMap(Map<String, dynamic>.from(map['condition'] as Map)),
      action: AutomationAction.fromMap(Map<String, dynamic>.from(map['action'] as Map)),
      enabled: map['enabled'] as bool? ?? true,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      lastRun: map['lastRun'] != null
          ? DateTime.tryParse(map['lastRun'] as String? ?? '')
          : null,
    );
  }
}

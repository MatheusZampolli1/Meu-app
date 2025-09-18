import 'package:flutter/material.dart';

enum AutomationConditionType { unlock, batteryBelow, timeOfDay }

class AutomationCondition {
  const AutomationCondition._({
    required this.type,
    this.threshold,
    this.time,
  });

  factory AutomationCondition.unlock() =>
      const AutomationCondition._(type: AutomationConditionType.unlock);

  factory AutomationCondition.batteryBelow(int percent) =>
      AutomationCondition._(
        type: AutomationConditionType.batteryBelow,
        threshold: percent.clamp(1, 100).toDouble(),
      );

  factory AutomationCondition.timeOfDay(TimeOfDay time) =>
      AutomationCondition._(type: AutomationConditionType.timeOfDay, time: time);

  final AutomationConditionType type;
  final double? threshold;
  final TimeOfDay? time;

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      if (threshold != null) 'threshold': threshold,
      if (time != null) ...{'hour': time!.hour, 'minute': time!.minute},
    };
  }

  factory AutomationCondition.fromMap(Map<String, dynamic> map) {
    final type = AutomationConditionType.values
        .firstWhere((value) => value.name == map['type'] as String);
    switch (type) {
      case AutomationConditionType.unlock:
        return AutomationCondition.unlock();
      case AutomationConditionType.batteryBelow:
        final threshold = (map['threshold'] as num?)?.toDouble() ?? 20;
        return AutomationCondition.batteryBelow(threshold.round());
      case AutomationConditionType.timeOfDay:
        final hour = map['hour'] as int? ?? 20;
        final minute = map['minute'] as int? ?? 0;
        return AutomationCondition.timeOfDay(TimeOfDay(hour: hour, minute: minute));
    }
  }
}

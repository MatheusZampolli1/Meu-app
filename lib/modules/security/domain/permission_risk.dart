import 'package:flutter/material.dart';

enum PermissionRiskLevel { low, medium, high }

enum PermissionType {
  camera,
  microphone,
  location,
  contacts,
  notifications,
  accessibility,
}

class PermissionRisk {
  const PermissionRisk({
    required this.type,
    required this.level,
    required this.granted,
  });

  final PermissionType type;
  final PermissionRiskLevel level;
  final bool granted;

  Color color(ColorScheme scheme) {
    switch (level) {
      case PermissionRiskLevel.high:
        return Colors.redAccent;
      case PermissionRiskLevel.medium:
        return Colors.orangeAccent;
      case PermissionRiskLevel.low:
        return scheme.secondary;
    }
  }

  Map<String, dynamic> toMap() => {
        'type': type.name,
        'level': level.name,
        'granted': granted,
      };

  factory PermissionRisk.fromMap(Map<String, dynamic> map) {
    final type = PermissionType.values
        .firstWhere((value) => value.name == map['type'] as String);
    final level = PermissionRiskLevel.values
        .firstWhere((value) => value.name == map['level'] as String);
    final granted = map['granted'] as bool? ?? false;
    return PermissionRisk(type: type, level: level, granted: granted);
  }
}

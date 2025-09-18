import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

import 'package:game_master_plus/modules/security/domain/permission_risk.dart';
import 'package:game_master_plus/modules/security/domain/security_event.dart';
import 'package:game_master_plus/modules/security/data/security_event_repository.dart';

class SecurityScanResult {
  const SecurityScanResult({
    required this.risks,
    required this.score,
  });

  final List<PermissionRisk> risks;
  final double score; // 0-100 health score (higher is better)
}

class SecurityScanner {
  SecurityScanner(this._eventRepository);

  final SecurityEventRepository _eventRepository;

  Future<SecurityScanResult> runScan() async {
    final risks = <PermissionRisk>[];

    Future<void> checkPermission(Permission permission, PermissionRiskLevel level, PermissionType type) async {
      try {
        final status = await permission.status;
        final granted = status == PermissionStatus.granted || status == PermissionStatus.limited;
        risks.add(PermissionRisk(type: type, level: level, granted: granted));
      } catch (_) {
        risks.add(PermissionRisk(type: type, level: level, granted: false));
      }
    }

    await Future.wait([
      checkPermission(Permission.camera, PermissionRiskLevel.medium, PermissionType.camera),
      checkPermission(Permission.microphone, PermissionRiskLevel.medium, PermissionType.microphone),
      checkPermission(Permission.locationWhenInUse, PermissionRiskLevel.high, PermissionType.location),
      checkPermission(Permission.contacts, PermissionRiskLevel.high, PermissionType.contacts),
      checkPermission(Permission.notification, PermissionRiskLevel.low, PermissionType.notifications),
      checkPermission(Permission.accessibilityService, PermissionRiskLevel.high, PermissionType.accessibility),
    ]);

    final riskValue = risks.fold<double>(0, (value, risk) {
      if (!risk.granted) return value;
      switch (risk.level) {
        case PermissionRiskLevel.low:
          return value + 10;
        case PermissionRiskLevel.medium:
          return value + 20;
        case PermissionRiskLevel.high:
          return value + 35;
      }
    });

    final score = (100 - riskValue).clamp(0, 100);

    final event = SecurityEvent(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: 'scan',
      title: 'Security scan completed',
      message: 'Detected ${risks.where((risk) => risk.granted).length} granted sensitive permissions.',
      createdAt: DateTime.now(),
    );
    await _eventRepository.add(event);

    return SecurityScanResult(risks: risks, score: score);
  }
}

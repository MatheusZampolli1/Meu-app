import 'package:game_master_plus/modules/security/application/security_scanner.dart';
import 'package:game_master_plus/modules/security/data/security_event_repository.dart';
import 'package:game_master_plus/modules/security/domain/security_event.dart';

class SecurityCenterService {
  SecurityCenterService({
    required SecurityScanner scanner,
    required SecurityEventRepository events,
  })  : _scanner = scanner,
        _events = events;

  final SecurityScanner _scanner;
  final SecurityEventRepository _events;

  Future<SecurityScanResult> scanPermissions() => _scanner.runScan();

  List<SecurityEvent> recentEvents({int limit = 20}) => _events.recent(limit: limit);
}

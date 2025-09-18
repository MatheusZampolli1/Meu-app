import 'package:game_master_plus/services/system_services.dart';

enum AutomationActionType {
  quickOptimize,
  nightlyCleanup,
  openBatterySettings,
  openDisplaySettings,
  openNetworkSettings,
}

class AutomationAction {
  const AutomationAction({required this.type});

  final AutomationActionType type;

  Map<String, dynamic> toMap() => {'type': type.name};

  factory AutomationAction.fromMap(Map<String, dynamic> map) {
    final type = AutomationActionType.values
        .firstWhere((value) => value.name == map['type'] as String);
    return AutomationAction(type: type);
  }

  Future<void> execute(SystemAutomationService service) async {
    switch (type) {
      case AutomationActionType.quickOptimize:
        await service.runQuickOptimize();
        break;
      case AutomationActionType.nightlyCleanup:
        await service.scheduleNightlyCleanup(enable: true);
        break;
      case AutomationActionType.openBatterySettings:
        await service.openBatterySaverSettings();
        break;
      case AutomationActionType.openDisplaySettings:
        await service.openDisplaySettings();
        break;
      case AutomationActionType.openNetworkSettings:
        await service.openNetworkSettings();
        break;
    }
  }
}

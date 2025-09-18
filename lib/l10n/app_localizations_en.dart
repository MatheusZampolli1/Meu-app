// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fluxon';

  @override
  String get appTagline =>
      'Your phone faster, safer, and smarter—effortlessly.';

  @override
  String get tabDashboard => 'Dashboard';

  @override
  String get tabTuning => 'Tuning';

  @override
  String get tabAutomation => 'Automation';

  @override
  String get dashboardHeroMessage =>
      'Unlock performance, security, and automation in one place.';

  @override
  String get metricCpuTitle => 'CPU usage';

  @override
  String get metricCpuSubtitle => 'Active processes and recent apps';

  @override
  String get metricRamTitle => 'RAM usage';

  @override
  String get metricRamSubtitle => 'Memory available for new apps';

  @override
  String get metricStorageTitle => 'Free storage';

  @override
  String get metricStorageSubtitle => 'Space for apps, photos, and videos';

  @override
  String get metricTemperatureTitle => 'Device temperature';

  @override
  String get metricTemperatureSubtitle => 'Monitor overheating';

  @override
  String get metricBatteryTitle => 'Battery level';

  @override
  String get metricBatterySubtitle => 'Consider enabling power saver below 30%';

  @override
  String get buttonOneTapOptimize => 'One Tap Optimize';

  @override
  String get buttonCacheGuide => 'Cache cleaning guide';

  @override
  String get automationCardTitle => 'Automation rules';

  @override
  String get toggleAutoOptimize => 'Auto optimize on unlock';

  @override
  String get toggleNightlyCleanup => 'Nightly cleanup reminder';

  @override
  String get toggleFocusMode => 'Distraction-free focus';

  @override
  String get toggleBatteryReminder => 'Low battery alert';

  @override
  String get messageQuickOptimizeStarted =>
      'Started a rapid optimization routine.';

  @override
  String get messageQuickOptimizeFailed =>
      'Could not optimize automatically. Adjust it in Settings > Battery.';

  @override
  String get messageStorageGuideOpened =>
      'Storage settings opened. Clear caches from the system menus.';

  @override
  String get messageAutoOptimizePermission =>
      'Battery optimization exemption permission is required.';

  @override
  String get messageAutoOptimizeEnabled =>
      'Automatic optimization scheduled for unlock.';

  @override
  String get messageAutoOptimizeDisabled => 'Automatic optimization disabled.';

  @override
  String get messageNightlyPermission =>
      'Alarm scheduling permission is required.';

  @override
  String get messageNightlyEnabled => 'Nightly reminder scheduled.';

  @override
  String get messageNightlyDisabled => 'Nightly reminder cancelled.';

  @override
  String get messageFocusEnabled =>
      'Enable Do Not Disturb to silence distractions.';

  @override
  String get messageFocusDisabled => 'Focus hint disabled.';

  @override
  String get messageNotificationPermission =>
      'Allow notifications to receive alerts.';

  @override
  String get messageBatteryReminderEnabled => 'Low battery reminder enabled.';

  @override
  String get messageBatteryReminderDisabled => 'Low battery reminder disabled.';

  @override
  String get messageManualSettingsFallback =>
      'Open the system settings manually.';

  @override
  String get performanceProfileEconomy => 'Economy';

  @override
  String get performanceProfileBalanced => 'Balanced';

  @override
  String get performanceProfileTurbo => 'Turbo';

  @override
  String get networkProfileStreaming => 'Streaming';

  @override
  String get networkProfileGaming => 'Gaming';

  @override
  String get networkProfileProductivity => 'Productivity';

  @override
  String messageProfileApplied(Object performance, Object network) {
    return 'Performance profile $performance and network $network sent to the system.';
  }

  @override
  String get actionSummary => 'Summary';

  @override
  String get messageManualAdjustmentsOpened =>
      'We opened the relevant settings so you can finish manually.';

  @override
  String get dialogOptimizationTitle => 'Optimization summary';

  @override
  String dialogOptimizationContent(Object gain, Object performance) {
    return 'Estimated battery savings of $gain% over the next hours.\nTip: keep $performance mode for long tasks.';
  }

  @override
  String get dialogPrimaryAction => 'Got it';

  @override
  String get messageShortcutFailure =>
      'Couldn\'t open automatically. Adjust manually in settings.';

  @override
  String get dropdownPerformanceLabel => 'Performance profile';

  @override
  String get dropdownNetworkLabel => 'Network priority';

  @override
  String get labelBrightnessControl => 'Brightness control';

  @override
  String get toggleLimitBackgroundTitle => 'Limit background apps';

  @override
  String get toggleLimitBackgroundSubtitle =>
      'Reduces energy usage for inactive apps';

  @override
  String get toggleAdaptiveBatteryTitle => 'Adaptive battery';

  @override
  String get toggleAdaptiveBatterySubtitle =>
      'Prioritizes power for frequently used apps';

  @override
  String get messageDisplaySettingsOpened =>
      'Brightness settings opened for manual adjustment.';

  @override
  String get labelDisplaySettings => 'Display settings';

  @override
  String get messageBatterySettingsOpened => 'Battery settings opened.';

  @override
  String get labelBatterySettings => 'Power saver';

  @override
  String get messageNetworkSettingsOpened =>
      'Network settings opened so you can prioritize connections.';

  @override
  String get labelNetworkSettings => 'Network & Wi-Fi';

  @override
  String get buttonApplySystemSettings => 'Apply system settings';

  @override
  String get insightCpuSpikeTitle => 'CPU at full throttle';

  @override
  String insightCpuSpikeBody(Object value) {
    return 'CPU usage is at $value% right now. Close heavy apps or switch to Balance mode to cool down.';
  }

  @override
  String get insightCpuTrendTitle => 'CPU trend rising';

  @override
  String insightCpuTrendBody(Object value) {
    return 'Processing load increased by $value% in the last minutes. Consider enabling an efficiency profile.';
  }

  @override
  String get insightHighTempTitle => 'Device getting hot';

  @override
  String insightHighTempBody(Object value) {
    return 'Temperature reached $value°C. Ventilate the device or pause high intensity tasks.';
  }

  @override
  String get insightStorageLowTitle => 'Low storage available';

  @override
  String insightStorageLowBody(Object value) {
    return 'Only $value GB free remain. Run storage cleanup or move media to the cloud.';
  }

  @override
  String get insightBatteryLowTitle => 'Battery running low';

  @override
  String insightBatteryLowBody(Object value) {
    return 'Battery is at $value%. Activate power saver or connect your charger.';
  }

  @override
  String get insightRamHighTitle => 'Memory usage high';

  @override
  String insightRamHighBody(Object value) {
    return 'Apps are using $value% of RAM. Close background apps to avoid slowdowns.';
  }

  @override
  String get insightAllGoodTitle => 'Everything optimized';

  @override
  String get insightAllGoodBody =>
      'Fluxon is keeping performance and temperature under control. Keep it up!';

  @override
  String get automationRuleSectionTitle => 'Intelligent automation';

  @override
  String get automationRuleSectionSubtitle =>
      'Create rules that react to battery, time or unlock events.';

  @override
  String get automationRunRulesNow => 'Run rules now';

  @override
  String get automationCreateRule => 'New automation rule';

  @override
  String automationRuleCreatedMessage(Object name) {
    return '$name activated. Fluxon will monitor it from now on.';
  }

  @override
  String get automationRuleNoExecutionMessage =>
      'No rules were triggered. Adjust the conditions if needed.';

  @override
  String automationRuleExecutedMessage(Object count) {
    return 'Executed $count automation(s).';
  }

  @override
  String get automationDeleteRule => 'Delete';

  @override
  String get automationConditionUnlock => 'When the device is unlocked';

  @override
  String automationConditionBattery(Object value) {
    return 'When battery goes below $value%';
  }

  @override
  String automationConditionTime(Object value) {
    return 'Around $value';
  }

  @override
  String get automationConditionBatteryLabel => 'Battery level';

  @override
  String get automationConditionTimeLabel => 'Time of day';

  @override
  String get automationRuleFormTitle => 'New automation rule';

  @override
  String get automationRuleNameLabel => 'Rule name';

  @override
  String get automationRuleNameError => 'Give this rule a name.';

  @override
  String get automationConditionLabel => 'Condition';

  @override
  String get automationActionLabel => 'Action';

  @override
  String automationConditionBatteryInput(Object value) {
    return 'Trigger when battery is at $value%.';
  }

  @override
  String automationConditionTimeInput(Object value) {
    return 'Trigger at $value.';
  }

  @override
  String get automationPickTimeButton => 'Choose time';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get automationActionQuickOptimize => 'Run quick optimization';

  @override
  String get automationActionNightlyCleanup => 'Schedule nightly cleanup';

  @override
  String get automationActionOpenBattery => 'Open battery settings';

  @override
  String get automationActionOpenDisplay => 'Open display settings';

  @override
  String get automationActionOpenNetwork => 'Open network settings';

  @override
  String get automationQuickShortcutsTitle => 'Shortcuts';

  @override
  String get automationEmptyState =>
      'No automation rules yet. Create one to automate your routine.';

  @override
  String get automationDefaultRuleName => 'Fluxon Rule';
}

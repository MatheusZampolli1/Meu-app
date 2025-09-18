import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Fluxon'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Your phone faster, safer, and smarter—effortlessly.'**
  String get appTagline;

  /// No description provided for @tabDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get tabDashboard;

  /// No description provided for @tabTuning.
  ///
  /// In en, this message translates to:
  /// **'Tuning'**
  String get tabTuning;

  /// No description provided for @tabAutomation.
  ///
  /// In en, this message translates to:
  /// **'Automation'**
  String get tabAutomation;

  /// No description provided for @dashboardHeroMessage.
  ///
  /// In en, this message translates to:
  /// **'Unlock performance, security, and automation in one place.'**
  String get dashboardHeroMessage;

  /// No description provided for @metricCpuTitle.
  ///
  /// In en, this message translates to:
  /// **'CPU usage'**
  String get metricCpuTitle;

  /// No description provided for @metricCpuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Active processes and recent apps'**
  String get metricCpuSubtitle;

  /// No description provided for @metricRamTitle.
  ///
  /// In en, this message translates to:
  /// **'RAM usage'**
  String get metricRamTitle;

  /// No description provided for @metricRamSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Memory available for new apps'**
  String get metricRamSubtitle;

  /// No description provided for @metricStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Free storage'**
  String get metricStorageTitle;

  /// No description provided for @metricStorageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Space for apps, photos, and videos'**
  String get metricStorageSubtitle;

  /// No description provided for @metricTemperatureTitle.
  ///
  /// In en, this message translates to:
  /// **'Device temperature'**
  String get metricTemperatureTitle;

  /// No description provided for @metricTemperatureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor overheating'**
  String get metricTemperatureSubtitle;

  /// No description provided for @metricBatteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Battery level'**
  String get metricBatteryTitle;

  /// No description provided for @metricBatterySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Consider enabling power saver below 30%'**
  String get metricBatterySubtitle;

  /// No description provided for @buttonOneTapOptimize.
  ///
  /// In en, this message translates to:
  /// **'One Tap Optimize'**
  String get buttonOneTapOptimize;

  /// No description provided for @buttonCacheGuide.
  ///
  /// In en, this message translates to:
  /// **'Cache cleaning guide'**
  String get buttonCacheGuide;

  /// No description provided for @automationCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Automation rules'**
  String get automationCardTitle;

  /// No description provided for @toggleAutoOptimize.
  ///
  /// In en, this message translates to:
  /// **'Auto optimize on unlock'**
  String get toggleAutoOptimize;

  /// No description provided for @toggleNightlyCleanup.
  ///
  /// In en, this message translates to:
  /// **'Nightly cleanup reminder'**
  String get toggleNightlyCleanup;

  /// No description provided for @toggleFocusMode.
  ///
  /// In en, this message translates to:
  /// **'Distraction-free focus'**
  String get toggleFocusMode;

  /// No description provided for @toggleBatteryReminder.
  ///
  /// In en, this message translates to:
  /// **'Low battery alert'**
  String get toggleBatteryReminder;

  /// No description provided for @messageQuickOptimizeStarted.
  ///
  /// In en, this message translates to:
  /// **'Started a rapid optimization routine.'**
  String get messageQuickOptimizeStarted;

  /// No description provided for @messageQuickOptimizeFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not optimize automatically. Adjust it in Settings > Battery.'**
  String get messageQuickOptimizeFailed;

  /// No description provided for @messageStorageGuideOpened.
  ///
  /// In en, this message translates to:
  /// **'Storage settings opened. Clear caches from the system menus.'**
  String get messageStorageGuideOpened;

  /// No description provided for @messageAutoOptimizePermission.
  ///
  /// In en, this message translates to:
  /// **'Battery optimization exemption permission is required.'**
  String get messageAutoOptimizePermission;

  /// No description provided for @messageAutoOptimizeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Automatic optimization scheduled for unlock.'**
  String get messageAutoOptimizeEnabled;

  /// No description provided for @messageAutoOptimizeDisabled.
  ///
  /// In en, this message translates to:
  /// **'Automatic optimization disabled.'**
  String get messageAutoOptimizeDisabled;

  /// No description provided for @messageNightlyPermission.
  ///
  /// In en, this message translates to:
  /// **'Alarm scheduling permission is required.'**
  String get messageNightlyPermission;

  /// No description provided for @messageNightlyEnabled.
  ///
  /// In en, this message translates to:
  /// **'Nightly reminder scheduled.'**
  String get messageNightlyEnabled;

  /// No description provided for @messageNightlyDisabled.
  ///
  /// In en, this message translates to:
  /// **'Nightly reminder cancelled.'**
  String get messageNightlyDisabled;

  /// No description provided for @messageFocusEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enable Do Not Disturb to silence distractions.'**
  String get messageFocusEnabled;

  /// No description provided for @messageFocusDisabled.
  ///
  /// In en, this message translates to:
  /// **'Focus hint disabled.'**
  String get messageFocusDisabled;

  /// No description provided for @messageNotificationPermission.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications to receive alerts.'**
  String get messageNotificationPermission;

  /// No description provided for @messageBatteryReminderEnabled.
  ///
  /// In en, this message translates to:
  /// **'Low battery reminder enabled.'**
  String get messageBatteryReminderEnabled;

  /// No description provided for @messageBatteryReminderDisabled.
  ///
  /// In en, this message translates to:
  /// **'Low battery reminder disabled.'**
  String get messageBatteryReminderDisabled;

  /// No description provided for @messageManualSettingsFallback.
  ///
  /// In en, this message translates to:
  /// **'Open the system settings manually.'**
  String get messageManualSettingsFallback;

  /// No description provided for @performanceProfileEconomy.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get performanceProfileEconomy;

  /// No description provided for @performanceProfileBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get performanceProfileBalanced;

  /// No description provided for @performanceProfileTurbo.
  ///
  /// In en, this message translates to:
  /// **'Turbo'**
  String get performanceProfileTurbo;

  /// No description provided for @networkProfileStreaming.
  ///
  /// In en, this message translates to:
  /// **'Streaming'**
  String get networkProfileStreaming;

  /// No description provided for @networkProfileGaming.
  ///
  /// In en, this message translates to:
  /// **'Gaming'**
  String get networkProfileGaming;

  /// No description provided for @networkProfileProductivity.
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get networkProfileProductivity;

  /// No description provided for @messageProfileApplied.
  ///
  /// In en, this message translates to:
  /// **'Performance profile {performance} and network {network} sent to the system.'**
  String messageProfileApplied(Object performance, Object network);

  /// No description provided for @actionSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get actionSummary;

  /// No description provided for @messageManualAdjustmentsOpened.
  ///
  /// In en, this message translates to:
  /// **'We opened the relevant settings so you can finish manually.'**
  String get messageManualAdjustmentsOpened;

  /// No description provided for @dialogOptimizationTitle.
  ///
  /// In en, this message translates to:
  /// **'Optimization summary'**
  String get dialogOptimizationTitle;

  /// No description provided for @dialogOptimizationContent.
  ///
  /// In en, this message translates to:
  /// **'Estimated battery savings of {gain}% over the next hours.\nTip: keep {performance} mode for long tasks.'**
  String dialogOptimizationContent(Object gain, Object performance);

  /// No description provided for @dialogPrimaryAction.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get dialogPrimaryAction;

  /// No description provided for @messageShortcutFailure.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open automatically. Adjust manually in settings.'**
  String get messageShortcutFailure;

  /// No description provided for @dropdownPerformanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Performance profile'**
  String get dropdownPerformanceLabel;

  /// No description provided for @dropdownNetworkLabel.
  ///
  /// In en, this message translates to:
  /// **'Network priority'**
  String get dropdownNetworkLabel;

  /// No description provided for @labelBrightnessControl.
  ///
  /// In en, this message translates to:
  /// **'Brightness control'**
  String get labelBrightnessControl;

  /// No description provided for @toggleLimitBackgroundTitle.
  ///
  /// In en, this message translates to:
  /// **'Limit background apps'**
  String get toggleLimitBackgroundTitle;

  /// No description provided for @toggleLimitBackgroundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reduces energy usage for inactive apps'**
  String get toggleLimitBackgroundSubtitle;

  /// No description provided for @toggleAdaptiveBatteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Adaptive battery'**
  String get toggleAdaptiveBatteryTitle;

  /// No description provided for @toggleAdaptiveBatterySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prioritizes power for frequently used apps'**
  String get toggleAdaptiveBatterySubtitle;

  /// No description provided for @messageDisplaySettingsOpened.
  ///
  /// In en, this message translates to:
  /// **'Brightness settings opened for manual adjustment.'**
  String get messageDisplaySettingsOpened;

  /// No description provided for @labelDisplaySettings.
  ///
  /// In en, this message translates to:
  /// **'Display settings'**
  String get labelDisplaySettings;

  /// No description provided for @messageBatterySettingsOpened.
  ///
  /// In en, this message translates to:
  /// **'Battery settings opened.'**
  String get messageBatterySettingsOpened;

  /// No description provided for @labelBatterySettings.
  ///
  /// In en, this message translates to:
  /// **'Power saver'**
  String get labelBatterySettings;

  /// No description provided for @messageNetworkSettingsOpened.
  ///
  /// In en, this message translates to:
  /// **'Network settings opened so you can prioritize connections.'**
  String get messageNetworkSettingsOpened;

  /// No description provided for @labelNetworkSettings.
  ///
  /// In en, this message translates to:
  /// **'Network & Wi-Fi'**
  String get labelNetworkSettings;

  /// No description provided for @buttonApplySystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Apply system settings'**
  String get buttonApplySystemSettings;

  /// No description provided for @insightCpuSpikeTitle.
  ///
  /// In en, this message translates to:
  /// **'CPU at full throttle'**
  String get insightCpuSpikeTitle;

  /// No description provided for @insightCpuSpikeBody.
  ///
  /// In en, this message translates to:
  /// **'CPU usage is at {value}% right now. Close heavy apps or switch to Balance mode to cool down.'**
  String insightCpuSpikeBody(Object value);

  /// No description provided for @insightCpuTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'CPU trend rising'**
  String get insightCpuTrendTitle;

  /// No description provided for @insightCpuTrendBody.
  ///
  /// In en, this message translates to:
  /// **'Processing load increased by {value}% in the last minutes. Consider enabling an efficiency profile.'**
  String insightCpuTrendBody(Object value);

  /// No description provided for @insightHighTempTitle.
  ///
  /// In en, this message translates to:
  /// **'Device getting hot'**
  String get insightHighTempTitle;

  /// No description provided for @insightHighTempBody.
  ///
  /// In en, this message translates to:
  /// **'Temperature reached {value}°C. Ventilate the device or pause high intensity tasks.'**
  String insightHighTempBody(Object value);

  /// No description provided for @insightStorageLowTitle.
  ///
  /// In en, this message translates to:
  /// **'Low storage available'**
  String get insightStorageLowTitle;

  /// No description provided for @insightStorageLowBody.
  ///
  /// In en, this message translates to:
  /// **'Only {value} GB free remain. Run storage cleanup or move media to the cloud.'**
  String insightStorageLowBody(Object value);

  /// No description provided for @insightBatteryLowTitle.
  ///
  /// In en, this message translates to:
  /// **'Battery running low'**
  String get insightBatteryLowTitle;

  /// No description provided for @insightBatteryLowBody.
  ///
  /// In en, this message translates to:
  /// **'Battery is at {value}%. Activate power saver or connect your charger.'**
  String insightBatteryLowBody(Object value);

  /// No description provided for @insightRamHighTitle.
  ///
  /// In en, this message translates to:
  /// **'Memory usage high'**
  String get insightRamHighTitle;

  /// No description provided for @insightRamHighBody.
  ///
  /// In en, this message translates to:
  /// **'Apps are using {value}% of RAM. Close background apps to avoid slowdowns.'**
  String insightRamHighBody(Object value);

  /// No description provided for @insightAllGoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Everything optimized'**
  String get insightAllGoodTitle;

  /// No description provided for @insightAllGoodBody.
  ///
  /// In en, this message translates to:
  /// **'Fluxon is keeping performance and temperature under control. Keep it up!'**
  String get insightAllGoodBody;

  /// No description provided for @automationRuleSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Intelligent automation'**
  String get automationRuleSectionTitle;

  /// No description provided for @automationRuleSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create rules that react to battery, time or unlock events.'**
  String get automationRuleSectionSubtitle;

  /// No description provided for @automationRunRulesNow.
  ///
  /// In en, this message translates to:
  /// **'Run rules now'**
  String get automationRunRulesNow;

  /// No description provided for @automationCreateRule.
  ///
  /// In en, this message translates to:
  /// **'New automation rule'**
  String get automationCreateRule;

  /// No description provided for @automationRuleCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} activated. Fluxon will monitor it from now on.'**
  String automationRuleCreatedMessage(Object name);

  /// No description provided for @automationRuleNoExecutionMessage.
  ///
  /// In en, this message translates to:
  /// **'No rules were triggered. Adjust the conditions if needed.'**
  String get automationRuleNoExecutionMessage;

  /// No description provided for @automationRuleExecutedMessage.
  ///
  /// In en, this message translates to:
  /// **'Executed {count} automation(s).'**
  String automationRuleExecutedMessage(Object count);

  /// No description provided for @automationDeleteRule.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get automationDeleteRule;

  /// No description provided for @automationConditionUnlock.
  ///
  /// In en, this message translates to:
  /// **'When the device is unlocked'**
  String get automationConditionUnlock;

  /// No description provided for @automationConditionBattery.
  ///
  /// In en, this message translates to:
  /// **'When battery goes below {value}%'**
  String automationConditionBattery(Object value);

  /// No description provided for @automationConditionTime.
  ///
  /// In en, this message translates to:
  /// **'Around {value}'**
  String automationConditionTime(Object value);

  /// No description provided for @automationConditionBatteryLabel.
  ///
  /// In en, this message translates to:
  /// **'Battery level'**
  String get automationConditionBatteryLabel;

  /// No description provided for @automationConditionTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time of day'**
  String get automationConditionTimeLabel;

  /// No description provided for @automationRuleFormTitle.
  ///
  /// In en, this message translates to:
  /// **'New automation rule'**
  String get automationRuleFormTitle;

  /// No description provided for @automationRuleNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Rule name'**
  String get automationRuleNameLabel;

  /// No description provided for @automationRuleNameError.
  ///
  /// In en, this message translates to:
  /// **'Give this rule a name.'**
  String get automationRuleNameError;

  /// No description provided for @automationConditionLabel.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get automationConditionLabel;

  /// No description provided for @automationActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get automationActionLabel;

  /// No description provided for @automationConditionBatteryInput.
  ///
  /// In en, this message translates to:
  /// **'Trigger when battery is at {value}%.'**
  String automationConditionBatteryInput(Object value);

  /// No description provided for @automationConditionTimeInput.
  ///
  /// In en, this message translates to:
  /// **'Trigger at {value}.'**
  String automationConditionTimeInput(Object value);

  /// No description provided for @automationPickTimeButton.
  ///
  /// In en, this message translates to:
  /// **'Choose time'**
  String get automationPickTimeButton;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @automationActionQuickOptimize.
  ///
  /// In en, this message translates to:
  /// **'Run quick optimization'**
  String get automationActionQuickOptimize;

  /// No description provided for @automationActionNightlyCleanup.
  ///
  /// In en, this message translates to:
  /// **'Schedule nightly cleanup'**
  String get automationActionNightlyCleanup;

  /// No description provided for @automationActionOpenBattery.
  ///
  /// In en, this message translates to:
  /// **'Open battery settings'**
  String get automationActionOpenBattery;

  /// No description provided for @automationActionOpenDisplay.
  ///
  /// In en, this message translates to:
  /// **'Open display settings'**
  String get automationActionOpenDisplay;

  /// No description provided for @automationActionOpenNetwork.
  ///
  /// In en, this message translates to:
  /// **'Open network settings'**
  String get automationActionOpenNetwork;

  /// No description provided for @automationQuickShortcutsTitle.
  ///
  /// In en, this message translates to:
  /// **'Shortcuts'**
  String get automationQuickShortcutsTitle;

  /// No description provided for @automationEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No automation rules yet. Create one to automate your routine.'**
  String get automationEmptyState;

  /// No description provided for @automationDefaultRuleName.
  ///
  /// In en, this message translates to:
  /// **'Fluxon Rule'**
  String get automationDefaultRuleName;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

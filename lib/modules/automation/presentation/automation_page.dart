import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:game_master_plus/l10n/app_localizations.dart';
import 'package:game_master_plus/modules/automation/application/automation_rule_engine.dart';
import 'package:game_master_plus/modules/automation/data/automation_rule_repository.dart';
import 'package:game_master_plus/modules/automation/application/one_tap_optimize.dart';
import 'package:game_master_plus/modules/automation/domain/automation_action.dart';
import 'package:game_master_plus/modules/automation/domain/automation_condition.dart';
import 'package:game_master_plus/modules/automation/domain/automation_rule.dart';
import 'package:game_master_plus/services/system_services.dart';

class AutomationPage extends StatefulWidget {
  const AutomationPage({super.key});

  @override
  State<AutomationPage> createState() => _AutomationPageState();
}

class _AutomationPageState extends State<AutomationPage> {
  final SystemAutomationService _automationService = SystemAutomationService();
  final SystemMetricsService _metricsService = SystemMetricsService();

  late final AutomationRuleRepository _ruleRepository;
  late final AutomationRuleEngine _ruleEngine;

  bool _evaluating = false;
  List<AutomationRule> _rules = const [];

  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _ruleRepository = AutomationRuleRepository(
      Hive.box<Map<String, dynamic>>(AutomationRuleRepository.boxName),
    );
    _ruleEngine = AutomationRuleEngine(
      repository: _ruleRepository,
      automationService: _automationService,
    );
    _loadRules();
  }

  void _loadRules() {
    setState(() => _rules = _ruleEngine.rules);
  }

  Future<void> _createRule() async {
    final rule = await showModalBottomSheet<AutomationRule>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _AutomationRuleForm(),
    );
    if (rule == null) return;
    await _ruleEngine.saveRule(rule);
    _loadRules();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_l10n.automationRuleCreatedMessage(rule.name))),
    );
  }

  Future<void> _deleteRule(String id) async {
    await _ruleEngine.deleteRule(id);
    _loadRules();
  }

  Future<void> _toggleRule(AutomationRule rule, bool value) async {
    await _ruleEngine.toggleRule(rule.id, value);
    _loadRules();
  }

  Future<void> _evaluateRules() async {
    setState(() => _evaluating = true);
    try {
      final metrics = await _metricsService.fetchMetrics();
      final executed = await _ruleEngine.evaluateForMetrics(metrics);
      if (!mounted) return;
      _loadRules();
      final message = executed.isEmpty
          ? _l10n.automationRuleNoExecutionMessage
          : _l10n.automationRuleExecutedMessage(executed.length);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _evaluating = false);
    }
  }

  Future<void> _runAction(
    Future<void> Function() action,
    String success, {
    String? failure,
  }) async {
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure ?? _l10n.messageManualSettingsFallback)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = _l10n;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            try {
              await runOneTapOptimize(context);
            } catch (e, st) {
              debugPrint("OneTap error: $e\n$st");
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Falha ao otimizar.')),
                );
              }
            }
          },
          icon: const Icon(Icons.flash_on),
          label: Text(l10n.buttonOneTapOptimize),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => _runAction(
            () => _automationService.openStorageSettings(),
            l10n.messageStorageGuideOpened,
          ),
          icon: const Icon(Icons.delete_sweep),
          label: Text(l10n.buttonCacheGuide),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.automationRuleSectionTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.automationRuleSectionSubtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              onPressed: _evaluating ? null : _evaluateRules,
              icon: _evaluating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_circle),
              label: Text(l10n.automationRunRulesNow),
            ),
            OutlinedButton.icon(
              onPressed: _createRule,
              icon: const Icon(Icons.add_circle_outline),
              label: Text(l10n.automationCreateRule),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (_rules.isEmpty)
          _EmptyState(message: l10n.automationEmptyState)
        else
          ..._rules.map(
            (rule) => _AutomationRuleCard(
              rule: rule,
              onDelete: () => _deleteRule(rule.id),
              onToggle: (value) => _toggleRule(rule, value),
            ),
          ),
        const SizedBox(height: 24),
        Text(
          l10n.automationQuickShortcutsTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            OutlinedButton.icon(
              onPressed: () => _runAction(
                () => _automationService.openDisplaySettings(),
                l10n.messageDisplaySettingsOpened,
              ),
              icon: const Icon(Icons.brightness_6),
              label: Text(l10n.labelDisplaySettings),
            ),
            OutlinedButton.icon(
              onPressed: () => _runAction(
                () => _automationService.openBatterySaverSettings(),
                l10n.messageBatterySettingsOpened,
              ),
              icon: const Icon(Icons.battery_saver),
              label: Text(l10n.labelBatterySettings),
            ),
            OutlinedButton.icon(
              onPressed: () => _runAction(
                () => _automationService.openNetworkSettings(),
                l10n.messageNetworkSettingsOpened,
              ),
              icon: const Icon(Icons.wifi),
              label: Text(l10n.labelNetworkSettings),
            ),
          ],
        ),
      ],
    );
  }
}

class _AutomationRuleCard extends StatelessWidget {
  const _AutomationRuleCard({
    required this.rule,
    required this.onDelete,
    required this.onToggle,
  });

  final AutomationRule rule;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accent = Theme.of(context).colorScheme.primary;

    final conditionDescription = _describeCondition(rule.condition, l10n);
    final actionDescription = _describeAction(rule.action, l10n);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    rule.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Switch.adaptive(
                  value: rule.enabled,
                  onChanged: onToggle,
                  thumbColor: WidgetStatePropertyAll(accent),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              conditionDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(
              actionDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  label: Text(l10n.automationDeleteRule),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _describeCondition(AutomationCondition condition, AppLocalizations l10n) {
    return switch (condition.type) {
      AutomationConditionType.unlock => l10n.automationConditionUnlock,
      AutomationConditionType.batteryBelow =>
          l10n.automationConditionBattery(condition.threshold?.toInt() ?? 20),
      AutomationConditionType.timeOfDay => () {
        final time = condition.time ?? const TimeOfDay(hour: 22, minute: 0);
        final formatted = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        return l10n.automationConditionTime(formatted);
      }(),
    };
  }

  String _describeAction(AutomationAction action, AppLocalizations l10n) {
    return switch (action.type) {
      AutomationActionType.quickOptimize => l10n.automationActionQuickOptimize,
      AutomationActionType.nightlyCleanup => l10n.automationActionNightlyCleanup,
      AutomationActionType.openBatterySettings => l10n.automationActionOpenBattery,
      AutomationActionType.openDisplaySettings => l10n.automationActionOpenDisplay,
      AutomationActionType.openNetworkSettings => l10n.automationActionOpenNetwork,
    };
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          const Icon(Icons.auto_mode, color: Colors.white54),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

class _AutomationRuleForm extends StatefulWidget {
  const _AutomationRuleForm();

  @override
  State<_AutomationRuleForm> createState() => _AutomationRuleFormState();
}

class _AutomationRuleFormState extends State<_AutomationRuleForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  AutomationConditionType _conditionType = AutomationConditionType.unlock;
  AutomationActionType _actionType = AutomationActionType.quickOptimize;
  int _batteryThreshold = 25;
  TimeOfDay _timeOfDay = const TimeOfDay(hour: 22, minute: 0);

  @override
  void initState() {
    super.initState();
    final l10n = AppLocalizations.of(context);
    _nameController = TextEditingController(text: l10n?.automationDefaultRuleName ?? 'Fluxon Rule');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final media = MediaQuery.of(context);
    final padding = media.viewInsets + const EdgeInsets.symmetric(horizontal: 20, vertical: 24);

    return Padding(
      padding: padding,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.automationRuleFormTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.automationRuleNameLabel),
              validator: (value) => value == null || value.trim().isEmpty
                  ? l10n.automationRuleNameError
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<AutomationConditionType>(
              // ignore: deprecated_member_use
              value: _conditionType,
              decoration: InputDecoration(labelText: l10n.automationConditionLabel),
              items: [
                DropdownMenuItem(
                  value: AutomationConditionType.unlock,
                  child: Text(l10n.automationConditionUnlock),
                ),
                DropdownMenuItem(
                  value: AutomationConditionType.batteryBelow,
                  child: Text(l10n.automationConditionBatteryLabel),
                ),
                DropdownMenuItem(
                  value: AutomationConditionType.timeOfDay,
                  child: Text(l10n.automationConditionTimeLabel),
                ),
              ],
              onChanged: (value) => setState(() => _conditionType = value ?? _conditionType),
            ),
            const SizedBox(height: 16),
            if (_conditionType == AutomationConditionType.batteryBelow)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.automationConditionBatteryInput(_batteryThreshold)),
                  Slider(
                    value: _batteryThreshold.toDouble(),
                    min: 5,
                    max: 60,
                    divisions: 11,
                    label: '$_batteryThreshold%',
                    onChanged: (value) => setState(() => _batteryThreshold = value.round()),
                  ),
                ],
              ),
            if (_conditionType == AutomationConditionType.timeOfDay)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.automationConditionTimeInput(
                        '${_timeOfDay.hour.toString().padLeft(2, '0')}:${_timeOfDay.minute.toString().padLeft(2, '0')}',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final selected = await showTimePicker(
                        context: context,
                        initialTime: _timeOfDay,
                      );
                      if (selected != null) {
                        setState(() => _timeOfDay = selected);
                      }
                    },
                    child: Text(l10n.automationPickTimeButton),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            DropdownButtonFormField<AutomationActionType>(
              // ignore: deprecated_member_use
              value: _actionType,
              decoration: InputDecoration(labelText: l10n.automationActionLabel),
              items: [
                DropdownMenuItem(
                  value: AutomationActionType.quickOptimize,
                  child: Text(l10n.automationActionQuickOptimize),
                ),
                DropdownMenuItem(
                  value: AutomationActionType.nightlyCleanup,
                  child: Text(l10n.automationActionNightlyCleanup),
                ),
                DropdownMenuItem(
                  value: AutomationActionType.openBatterySettings,
                  child: Text(l10n.automationActionOpenBattery),
                ),
                DropdownMenuItem(
                  value: AutomationActionType.openDisplaySettings,
                  child: Text(l10n.automationActionOpenDisplay),
                ),
                DropdownMenuItem(
                  value: AutomationActionType.openNetworkSettings,
                  child: Text(l10n.automationActionOpenNetwork),
                ),
              ],
              onChanged: (value) => setState(() => _actionType = value ?? _actionType),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.commonCancel),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(l10n.commonSave),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final condition = switch (_conditionType) {
      AutomationConditionType.unlock => AutomationCondition.unlock(),
      AutomationConditionType.batteryBelow =>
          AutomationCondition.batteryBelow(_batteryThreshold),
      AutomationConditionType.timeOfDay => AutomationCondition.timeOfDay(_timeOfDay),
    };
    final action = AutomationAction(type: _actionType);
    final rule = AutomationRule.create(
      name: _nameController.text.trim(),
      condition: condition,
      action: action,
    );
    Navigator.of(context).pop(rule);
  }
}




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
    return Card(
      child: ListTile(
        title: Text(rule.name),
        subtitle: Text("${rule.condition.type} → ${rule.action.type}"),
        trailing: Switch.adaptive(
          value: rule.enabled,
          onChanged: onToggle,
        ),
        onLongPress: onDelete,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
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
    _nameController = TextEditingController(text: "Nova Regra");
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final padding = media.viewInsets + const EdgeInsets.all(20);

    return Padding(
      padding: padding,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nome da Regra"),
                validator: (v) => v == null || v.isEmpty ? "Digite um nome" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<AutomationConditionType>(
                value: _conditionType,
                items: AutomationConditionType.values
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toString()),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _conditionType = v!),
              ),
              if (_conditionType == AutomationConditionType.batteryBelow)
                Slider(
                  value: _batteryThreshold.toDouble(),
                  min: 5,
                  max: 60,
                  divisions: 11,
                  label: "$_batteryThreshold%",
                  onChanged: (v) => setState(() => _batteryThreshold = v.round()),
                ),
              if (_conditionType == AutomationConditionType.timeOfDay)
                TextButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _timeOfDay,
                    );
                    if (picked != null) {
                      setState(() => _timeOfDay = picked);
                    }
                  },
                  child: const Text("Selecionar horário"),
                ),
              const SizedBox(height: 16),
              DropdownButtonFormField<AutomationActionType>(
                value: _actionType,
                items: AutomationActionType.values
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toString()),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _actionType = v!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Salvar"),
              ),
            ],
          ),
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
      AutomationConditionType.timeOfDay =>
          AutomationCondition.timeOfDay(_timeOfDay),
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

import 'dart:math';

import 'package:flutter/material.dart';

import 'package:game_master_plus/l10n/app_localizations.dart';
import 'package:game_master_plus/services/system_services.dart';
import 'package:game_master_plus/shared/theme/app_theme.dart';

class DeviceTunerPage extends StatefulWidget {
  const DeviceTunerPage({super.key});

  @override
  State<DeviceTunerPage> createState() => _DeviceTunerPageState();
}

class _DeviceTunerPageState extends State<DeviceTunerPage> {
  static const List<String> _performanceKeys = ['economy', 'balanced', 'turbo'];
  static const List<String> _networkKeys = ['streaming', 'gaming', 'productivity'];

  final SystemAutomationService _automationService = SystemAutomationService();

  String _selectedPerformanceKey = 'balanced';
  String _selectedNetworkKey = 'productivity';
  double _brightness = 0.65;
  bool _limitBackgroundApps = true;
  bool _adaptiveBattery = true;

  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String _performanceLabel(String key) {
    final l10n = _l10n;
    switch (key) {
      case 'economy':
        return l10n.performanceProfileEconomy;
      case 'turbo':
        return l10n.performanceProfileTurbo;
      case 'balanced':
      default:
        return l10n.performanceProfileBalanced;
    }
  }

  String _networkLabel(String key) {
    final l10n = _l10n;
    switch (key) {
      case 'streaming':
        return l10n.networkProfileStreaming;
      case 'gaming':
        return l10n.networkProfileGaming;
      case 'productivity':
      default:
        return l10n.networkProfileProductivity;
    }
  }

  Future<void> _applyDeviceSettings() async {
    final l10n = _l10n;
    final performance = _performanceLabel(_selectedPerformanceKey);
    final network = _networkLabel(_selectedNetworkKey);
    try {
      await _automationService.applyPerformanceProfile(
        performanceProfile: performance,
        networkProfile: network,
        brightnessLevel: _brightness,
        limitBackgroundApps: _limitBackgroundApps,
        adaptiveBattery: _adaptiveBattery,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.messageProfileApplied(performance, network)),
          action: SnackBarAction(
            label: l10n.actionSummary,
            onPressed: _showOptimizationSummary,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      _showSnack(l10n.messageManualAdjustmentsOpened);
    }
  }

  void _showOptimizationSummary() {
    final l10n = _l10n;
    final random = Random();
    final projectedGain = 5 + random.nextInt(10);
    final performance = _performanceLabel(_selectedPerformanceKey);
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: FluxonTheme.cardColor,
          title: Text(l10n.dialogOptimizationTitle),
          content: Text(l10n.dialogOptimizationContent(projectedGain, performance)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.dialogPrimaryAction,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleShortcut(
    Future<void> Function() action,
    String successMessage,
  ) async {
    try {
      await action();
      if (!mounted) return;
      _showSnack(successMessage);
    } catch (_) {
      if (!mounted) return;
      _showSnack(_l10n.messageShortcutFailure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = _l10n;
    final accent = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDropdown(
            label: l10n.dropdownPerformanceLabel,
            selected: _selectedPerformanceKey,
            options: _performanceKeys,
            itemLabel: _performanceLabel,
            onChanged: (value) =>
                setState(() => _selectedPerformanceKey = value ?? _selectedPerformanceKey),
          ),
          const SizedBox(height: 18),
          _buildDropdown(
            label: l10n.dropdownNetworkLabel,
            selected: _selectedNetworkKey,
            options: _networkKeys,
            itemLabel: _networkLabel,
            onChanged: (value) =>
                setState(() => _selectedNetworkKey = value ?? _selectedNetworkKey),
          ),
          const SizedBox(height: 24),
          Text(l10n.labelBrightnessControl, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: FluxonTheme.mediumAnimation,
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accent.withValues(alpha: 0.12 + (_brightness * 0.12)),
                  FluxonTheme.secondaryAccent
                      .withValues(alpha: 0.08 + (_brightness * 0.06)),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Slider(
              value: _brightness,
              onChanged: (value) => setState(() => _brightness = value),
              activeColor: accent,
              label: '${(_brightness * 100).round()}%',
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile.adaptive(
            value: _limitBackgroundApps,
            onChanged: (value) => setState(() => _limitBackgroundApps = value),
            title: Text(l10n.toggleLimitBackgroundTitle),
            subtitle: Text(l10n.toggleLimitBackgroundSubtitle),
            secondary: Icon(Icons.layers_clear, color: accent),
          ),
          SwitchListTile.adaptive(
            value: _adaptiveBattery,
            onChanged: (value) => setState(() => _adaptiveBattery = value),
            title: Text(l10n.toggleAdaptiveBatteryTitle),
            subtitle: Text(l10n.toggleAdaptiveBatterySubtitle),
            secondary: Icon(Icons.battery_saver, color: accent),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              OutlinedButton.icon(
                onPressed: () => _handleShortcut(
                  () => _automationService.openDisplaySettings(),
                  l10n.messageDisplaySettingsOpened,
                ),
                icon: const Icon(Icons.brightness_6),
                label: Text(l10n.labelDisplaySettings),
              ),
              OutlinedButton.icon(
                onPressed: () => _handleShortcut(
                  () => _automationService.openBatterySaverSettings(),
                  l10n.messageBatterySettingsOpened,
                ),
                icon: const Icon(Icons.battery_std),
                label: Text(l10n.labelBatterySettings),
              ),
              OutlinedButton.icon(
                onPressed: () => _handleShortcut(
                  () => _automationService.openNetworkSettings(),
                  l10n.messageNetworkSettingsOpened,
                ),
                icon: const Icon(Icons.wifi),
                label: Text(l10n.labelNetworkSettings),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _applyDeviceSettings,
            icon: const Icon(Icons.system_update_alt),
            label: Text(l10n.buttonApplySystemSettings),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String selected,
    required List<String> options,
    required String Function(String) itemLabel,
    required ValueChanged<String?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: FluxonTheme.accentColor),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected,
          iconEnabledColor: FluxonTheme.accentColor,
          dropdownColor: const Color(0xFF1F212A),
          borderRadius: BorderRadius.circular(14),
          items: options
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(itemLabel(option)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

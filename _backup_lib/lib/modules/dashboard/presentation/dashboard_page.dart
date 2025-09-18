import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:game_master_plus/l10n/app_localizations.dart';
import 'package:game_master_plus/modules/dashboard/application/insights_service.dart';
import 'package:game_master_plus/modules/dashboard/data/metric_history_repository.dart';
import 'package:game_master_plus/modules/dashboard/domain/metric_insight.dart';
import 'package:game_master_plus/services/system_services.dart';
import 'package:game_master_plus/shared/theme/app_theme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final SystemMetricsService _metricsService = SystemMetricsService();
  late final MetricHistoryRepository _historyRepository;
  late final InsightsService _insightsService;

  DeviceMetrics _metrics = DeviceMetrics.initial();
  List<MetricInsight> _insights = const [];
  StreamSubscription<DeviceMetrics>? _subscription;
  bool _heroVisible = false;

  @override
  void initState() {
    super.initState();
    _historyRepository = MetricHistoryRepository(
      Hive.box<Map<String, dynamic>>(MetricHistoryRepository.boxName),
    );
    _insightsService = InsightsService();

    _loadMetrics();
    _subscription = _metricsService.metricsStream().listen(_processMetrics);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _heroVisible = true);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _loadMetrics() async {
    final metrics = await _metricsService.fetchMetrics();
    await _processMetrics(metrics);
  }

  Future<void> _processMetrics(DeviceMetrics metrics) async {
    await _historyRepository.addSnapshot(metrics);
    final history = _historyRepository.recent(limit: 32);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final insights = _insightsService.buildInsights(
      latest: metrics,
      history: history,
      l10n: l10n,
    );
    if (!mounted) return;
    setState(() {
      _metrics = metrics;
      _insights = insights;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accent = Theme.of(context).colorScheme.primary;

    return RefreshIndicator(
      color: accent,
      onRefresh: _loadMetrics,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: _DashboardHero(
              message: l10n.dashboardHeroMessage,
              visible: _heroVisible,
            ),
          ),
          if (_insights.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _InsightsSection(insights: _insights),
            ),
          _MetricCard(
            title: l10n.metricCpuTitle,
            value: '${_metrics.cpuUsage.toStringAsFixed(0)}%',
            subtitle: l10n.metricCpuSubtitle,
            icon: Icons.memory,
          ),
          _MetricCard(
            title: l10n.metricRamTitle,
            value: '${_metrics.ramUsage.toStringAsFixed(0)}%',
            subtitle: l10n.metricRamSubtitle,
            icon: Icons.developer_board,
          ),
          _MetricCard(
            title: l10n.metricStorageTitle,
            value: '${_metrics.storageFree.toStringAsFixed(0)} GB',
            subtitle: l10n.metricStorageSubtitle,
            icon: Icons.sd_storage,
          ),
          _MetricCard(
            title: l10n.metricTemperatureTitle,
            value: '${_metrics.temperature.toStringAsFixed(1)} °C',
            subtitle: l10n.metricTemperatureSubtitle,
            icon: Icons.thermostat_auto,
          ),
          _MetricCard(
            title: l10n.metricBatteryTitle,
            value: '${_metrics.batteryLevel}%',
            subtitle: l10n.metricBatterySubtitle,
            icon: Icons.battery_charging_full,
          ),
        ],
      ),
    );
  }
}

class _DashboardHero extends StatelessWidget {
  const _DashboardHero({required this.message, required this.visible});

  final String message;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return AnimatedSlide(
      duration: FluxonTheme.mediumAnimation,
      curve: Curves.easeOutCubic,
      offset: visible ? Offset.zero : const Offset(0, 0.08),
      child: AnimatedOpacity(
        duration: FluxonTheme.mediumAnimation,
        opacity: visible ? 1 : 0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accent.withValues(alpha: 0.28),
                FluxonTheme.secondaryAccent.withValues(alpha: 0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: accent.withValues(alpha: 0.3)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.appTitle,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!.appTagline,
                style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(icon, color: accent, size: 28),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  AnimatedSwitcher(
                    duration: FluxonTheme.fastAnimation,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.92, end: 1).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      value,
                      key: ValueKey(value),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: accent, fontWeight: FontWeight.w700),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(subtitle!, style: const TextStyle(color: Colors.white60)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightsSection extends StatelessWidget {
  const _InsightsSection({required this.insights});

  final List<MetricInsight> insights;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return AnimatedSwitcher(
      duration: FluxonTheme.mediumAnimation,
      child: Column(
        key: ValueKey(insights.length),
        children: insights
            .map((insight) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _InsightCard(insight: insight, accent: accent),
                ))
            .toList(),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.insight, required this.accent});

  final MetricInsight insight;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final severityColor = _colorForSeverity(insight.severity, colorScheme, accent);
    final icon = _iconForSeverity(insight.severity);

    return Container(
      decoration: BoxDecoration(
        color: FluxonTheme.cardColor.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: severityColor.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: severityColor.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: severityColor.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: severityColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  insight.message,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _colorForSeverity(InsightSeverity severity, ColorScheme scheme, Color accent) {
    switch (severity) {
      case InsightSeverity.critical:
        return Colors.redAccent;
      case InsightSeverity.warning:
        return Colors.orangeAccent;
      case InsightSeverity.info:
        return scheme.secondary;
      case InsightSeverity.positive:
        return accent;
    }
  }

  IconData _iconForSeverity(InsightSeverity severity) {
    switch (severity) {
      case InsightSeverity.critical:
        return Icons.report_gmailerrorred;
      case InsightSeverity.warning:
        return Icons.warning_amber_rounded;
      case InsightSeverity.info:
        return Icons.insights;
      case InsightSeverity.positive:
        return Icons.verified_rounded;
    }
  }
}



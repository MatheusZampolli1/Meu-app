import 'dart:math';

import 'package:game_master_plus/l10n/app_localizations.dart';
import 'package:game_master_plus/modules/dashboard/domain/metric_insight.dart';
import 'package:game_master_plus/services/system_services.dart';

class InsightsService {
  List<MetricInsight> buildInsights({
    required DeviceMetrics latest,
    required List<DeviceMetrics> history,
    required AppLocalizations l10n,
  }) {
    final insights = <MetricInsight>[];
    final recent = List<DeviceMetrics>.from(history)..add(latest);
    recent.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));

    double average(List<DeviceMetrics> data, double Function(DeviceMetrics) selector) {
      if (data.isEmpty) return 0;
      return data.map(selector).reduce((a, b) => a + b) / data.length;
    }

    double minValue(List<DeviceMetrics> data, double Function(DeviceMetrics) selector) {
      if (data.isEmpty) return 0;
      return data.map(selector).reduce(min);
    }

    double roundValue(double value) => double.parse(value.toStringAsFixed(0));

    final cpu = latest.cpuUsage;
    final ram = latest.ramUsage;
    final storage = latest.storageFree;
    final battery = latest.batteryLevel.toDouble();
    final temperature = latest.temperature;

    final recentWindow = recent.length >= 6 ? recent.sublist(recent.length - 6) : recent;
    final earlyWindowLength = recentWindow.length ~/ 2;
    final earlyWindow = recentWindow.take(earlyWindowLength).toList();
    final lateWindow = recentWindow.skip(earlyWindowLength).toList();

    final cpuTrend = average(lateWindow, (m) => m.cpuUsage) - average(earlyWindow, (m) => m.cpuUsage);
    final ramTrend = average(lateWindow, (m) => m.ramUsage) - average(earlyWindow, (m) => m.ramUsage);

    if (cpu >= 90) {
      insights.add(MetricInsight(
        severity: InsightSeverity.critical,
        title: l10n.insightCpuSpikeTitle,
        message: l10n.insightCpuSpikeBody(roundValue(cpu)),
      ));
    } else if (cpu >= 80 || cpuTrend >= 12) {
      insights.add(MetricInsight(
        severity: InsightSeverity.warning,
        title: l10n.insightCpuTrendTitle,
        message: l10n.insightCpuTrendBody(roundValue(cpuTrend)),
      ));
    }

    if (ram >= 90 || ramTrend >= 15) {
      insights.add(MetricInsight(
        severity: InsightSeverity.warning,
        title: l10n.insightRamHighTitle,
        message: l10n.insightRamHighBody(roundValue(ram)),
      ));
    }

    if (temperature >= 42) {
      insights.add(MetricInsight(
        severity: InsightSeverity.warning,
        title: l10n.insightHighTempTitle,
        message: l10n.insightHighTempBody(roundValue(temperature)),
      ));
    }

    if (storage <= 8) {
      final lowest = minValue(recentWindow, (m) => m.storageFree);
      insights.add(MetricInsight(
        severity: storage <= 4 ? InsightSeverity.critical : InsightSeverity.warning,
        title: l10n.insightStorageLowTitle,
        message: l10n.insightStorageLowBody(roundValue(lowest)),
      ));
    }

    if (battery <= 25) {
      insights.add(MetricInsight(
        severity: battery <= 15 ? InsightSeverity.critical : InsightSeverity.warning,
        title: l10n.insightBatteryLowTitle,
        message: l10n.insightBatteryLowBody(roundValue(battery)),
      ));
    }

    if (insights.isEmpty) {
      final healthyTemp = temperature < 35;
      final healthyCpu = cpu < 60;
      final healthyStorage = storage > 20;
      if (healthyTemp && healthyCpu && healthyStorage && battery >= 60) {
        insights.add(MetricInsight(
          severity: InsightSeverity.positive,
          title: l10n.insightAllGoodTitle,
          message: l10n.insightAllGoodBody,
        ));
      }
    }

    return insights;
  }
}



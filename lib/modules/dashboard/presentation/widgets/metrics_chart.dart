import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:game_master_plus/l10n/app_localizations.dart';
import 'package:game_master_plus/modules/dashboard/data/metric_history_repository.dart';
import 'package:game_master_plus/shared/i18n/fluxon_strings.dart';
import 'package:game_master_plus/services/system_services.dart';

class MetricsChart extends StatefulWidget {
  const MetricsChart({super.key, this.limit = 32});

  final int limit;

  @override
  State<MetricsChart> createState() => _MetricsChartState();
}

class _MetricsChartState extends State<MetricsChart> {
  late final MetricHistoryRepository _repository;
  late final Box<Map<String, dynamic>> _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<Map<String, dynamic>>(MetricHistoryRepository.boxName);
    _repository = MetricHistoryRepository(_box);
  }

  Color _statusColor(BuildContext context, double value) {
    final theme = Theme.of(context);
    if (value >= 80) {
      return theme.colorScheme.error;
    }
    if (value >= 60) {
      return Colors.amberAccent;
    }
    return Colors.lightGreenAccent;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final strings = FluxonStrings.of(context);
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ValueListenableBuilder<Box<dynamic>>(
          valueListenable: _box.listenable(),
          builder: (context, _, __) {
            final history = _repository.recent(limit: widget.limit);
            if (history.length < 2) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    strings.metricsChartEmpty,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final chartData = _MetricsChartData.fromHistory(history, theme);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.metricsChartTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Semantics(
                  label: strings.metricsChartSemantics(
                    chartData.cpuSeries.values.last.toStringAsFixed(0),
                    chartData.ramSeries.values.last.toStringAsFixed(0),
                    chartData.batterySeries.values.last.toStringAsFixed(0),
                  ),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: _MetricsLineChartPainter(
                        series: [
                          chartData.cpuSeries,
                          chartData.ramSeries,
                          chartData.batterySeries,
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _MetricsLegendChip(
                      label: l10n.metricCpuTitle,
                      color: chartData.cpuSeries.color,
                      value: chartData.cpuSeries.values.last,
                      statusColor: _statusColor(
                        context,
                        chartData.cpuSeries.values.last,
                      ),
                    ),
                    _MetricsLegendChip(
                      label: l10n.metricRamTitle,
                      color: chartData.ramSeries.color,
                      value: chartData.ramSeries.values.last,
                      statusColor: _statusColor(
                        context,
                        chartData.ramSeries.values.last,
                      ),
                    ),
                    _MetricsLegendChip(
                      label: l10n.metricBatteryTitle,
                      color: chartData.batterySeries.color,
                      value: chartData.batterySeries.values.last,
                      statusColor: _statusColor(
                        context,
                        chartData.batterySeries.values.last,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MetricsChartData {
  const _MetricsChartData({
    required this.cpuSeries,
    required this.ramSeries,
    required this.batterySeries,
  });

  factory _MetricsChartData.fromHistory(List<DeviceMetrics> history, ThemeData theme) {
    final accent = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;
    final batteryColor = Colors.lightGreenAccent.shade400;

    return _MetricsChartData(
      cpuSeries: _ChartSeries(
        color: accent,
        values: history
            .map((e) => e.cpuUsage.clamp(0, 100).toDouble())
            .toList(growable: false),
      ),
      ramSeries: _ChartSeries(
        color: secondary,
        values: history
            .map((e) => e.ramUsage.clamp(0, 100).toDouble())
            .toList(growable: false),
      ),
      batterySeries: _ChartSeries(
        color: batteryColor,
        values: history
            .map((e) => e.batteryLevel.toDouble().clamp(0, 100).toDouble())
            .toList(growable: false),
      ),
    );
  }

  final _ChartSeries cpuSeries;
  final _ChartSeries ramSeries;
  final _ChartSeries batterySeries;
}

class _ChartSeries {
  const _ChartSeries({required this.color, required this.values});

  final Color color;
  final List<double> values;
}

class _MetricsLineChartPainter extends CustomPainter {
  const _MetricsLineChartPainter({required this.series});

  final List<_ChartSeries> series;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withAlpha((0.08 * 255).round())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const gridLines = 4;
    for (var i = 0; i <= gridLines; i++) {
      final y = size.height - (size.height / gridLines) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    for (final chart in series) {
      if (chart.values.isEmpty) {
        continue;
      }

      final path = Path();
      final values = chart.values;
      final stepX = values.length > 1 ? size.width / (values.length - 1) : size.width;

      for (var i = 0; i < values.length; i++) {
        final value = values[i].clamp(0, 100).toDouble();
        final x = values.length > 1 ? stepX * i : size.width / 2;
        final y = size.height - (value / 100) * size.height;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      final paint = Paint()
        ..color = chart.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(path, paint);

      final markerPaint = Paint()
        ..color = chart.color
        ..style = PaintingStyle.fill;

      final lastX = values.length > 1 ? stepX * (values.length - 1) : size.width / 2;
      final lastY = size.height - (values.last.clamp(0, 100).toDouble() / 100) * size.height;
      canvas.drawCircle(Offset(lastX, lastY), 4, markerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MetricsLineChartPainter oldDelegate) {
    if (oldDelegate.series.length != series.length) return true;
    for (var i = 0; i < series.length; i++) {
      final oldValues = oldDelegate.series[i].values;
      final newValues = series[i].values;
      if (oldValues.length != newValues.length) return true;
      for (var j = 0; j < newValues.length; j++) {
        if (!oldValues[j].isFinite || !newValues[j].isFinite) return true;
        if ((oldValues[j] - newValues[j]).abs() > 0.01) {
          return true;
        }
      }
    }
    return false;
  }
}

class _MetricsLegendChip extends StatelessWidget {
  const _MetricsLegendChip({
    required this.label,
    required this.color,
    required this.value,
    required this.statusColor,
  });

  final String label;
  final Color color;
  final double value;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha((0.4 * 255).round())),
        color: theme.colorScheme.surfaceContainerHighest.withAlpha((0.2 * 255).round()),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: theme.textTheme.labelLarge),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withAlpha((0.16 * 255).round()),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '${value.toStringAsFixed(0)}%',
              style: theme.textTheme.labelMedium?.copyWith(color: statusColor),
            ),
          ),
        ],
      ),
    );
  }
}











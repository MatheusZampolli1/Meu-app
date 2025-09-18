enum InsightSeverity { positive, info, warning, critical }

class MetricInsight {
  const MetricInsight({
    required this.severity,
    required this.title,
    required this.message,
  });

  final InsightSeverity severity;
  final String title;
  final String message;
}

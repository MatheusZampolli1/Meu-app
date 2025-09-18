import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'package:game_master_plus/shared/i18n/fluxon_strings.dart';
import 'package:game_master_plus/modules/security/data/security_event_repository.dart';
import 'package:game_master_plus/modules/security/domain/security_event.dart';

class SecurityCenterPage extends StatefulWidget {
  const SecurityCenterPage({super.key});

  static const String routeName = '/security-center';

  @override
  State<SecurityCenterPage> createState() => _SecurityCenterPageState();
}

class _SecurityCenterPageState extends State<SecurityCenterPage> {
  late final SecurityEventRepository _repository;

  @override
  void initState() {
    super.initState();
    final box = Hive.box<Map<String, dynamic>>(SecurityEventRepository.boxName);
    _repository = SecurityEventRepository(box);
  }

  Future<void> _clearEvents() async {
    final strings = FluxonStrings.of(context);
    try {
      await _repository.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.securityCenterCleared)),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  IconData _iconForEvent(SecurityEvent event) {
    switch (event.type) {
      case 'scan':
        return LucideIcons.radar;
      case 'system':
        return LucideIcons.shield_check;
      case 'alert':
        return LucideIcons.triangle_alert;
      default:
        return LucideIcons.info;
    }
  }

  Color _colorForEvent(SecurityEvent event, ThemeData theme) {
    final severity = event.meta?['severity']?.toString() ?? 'info';
    switch (severity) {
      case 'critical':
        return theme.colorScheme.error;
      case 'warning':
        return Colors.amberAccent;
      case 'info':
      default:
        return theme.colorScheme.primary;
    }
  }

  String _formatTimestamp(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final formatter = DateFormat.yMMMd(locale).add_Hm();
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = FluxonStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.securityCenterTitle),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _clearEvents,
        icon: const Icon(LucideIcons.eraser),
        label: Text(strings.securityCenterClearAction),
      ),
      body: ValueListenableBuilder<Box<Map<String, dynamic>>>(
        valueListenable: _repository.box.listenable(),
        builder: (context, _, __) {
          final events = _repository.recent(limit: 50);
          if (events.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  strings.securityCenterEmpty,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemBuilder: (context, index) {
              final event = events[index];
              final color = _colorForEvent(event, theme);
              return Semantics(
                label: '${event.type}. ${event.message}. ${_formatTimestamp(context, event.createdAt)}',
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.15),
                    child: Icon(_iconForEvent(event), color: color),
                  ),
                  title: Text(event.title),
                  subtitle: Text(event.message),
                  trailing: Text(
                    _formatTimestamp(context, event.createdAt),
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.4),
            itemCount: events.length,
          );
        },
      ),
    );
  }
}







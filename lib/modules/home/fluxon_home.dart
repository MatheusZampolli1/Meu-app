import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'package:game_master_plus/l10n/app_localizations.dart';
import 'package:game_master_plus/modules/automation/presentation/automation_page.dart';
import 'package:game_master_plus/modules/dashboard/presentation/dashboard_page.dart';
import 'package:game_master_plus/modules/security/presentation/security_center_page.dart';
import 'package:game_master_plus/modules/tuning/presentation/device_tuner_page.dart';
import 'package:game_master_plus/shared/i18n/fluxon_strings.dart';

class FluxonHome extends StatefulWidget {
  const FluxonHome({super.key});

  @override
  State<FluxonHome> createState() => _FluxonHomeState();
}

class _FluxonHomeState extends State<FluxonHome> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final strings = FluxonStrings.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.appTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              l10n.appTagline,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(LucideIcons.layout_dashboard), text: l10n.tabDashboard),
            Tab(icon: const Icon(LucideIcons.sun_medium), text: l10n.tabTuning),
            Tab(icon: const Icon(LucideIcons.workflow), text: l10n.tabAutomation),
            Tab(icon: const Icon(LucideIcons.shield_half), text: strings.securityCenterTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DashboardPage(),
          DeviceTunerPage(),
          AutomationPage(),
          SecurityCenterPage(),
        ],
      ),
    );
  }
}

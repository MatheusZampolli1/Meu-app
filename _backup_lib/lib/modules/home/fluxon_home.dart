import 'package:flutter/material.dart';

import 'package:game_master_plus/l10n/app_localizations.dart';
import 'package:game_master_plus/modules/automation/presentation/automation_page.dart';
import 'package:game_master_plus/modules/dashboard/presentation/dashboard_page.dart';
import 'package:game_master_plus/modules/tuning/presentation/device_tuner_page.dart';

class FluxonHome extends StatefulWidget {
  const FluxonHome({super.key});

  @override
  State<FluxonHome> createState() => _FluxonHomeState();
}

class _FluxonHomeState extends State<FluxonHome>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            Tab(icon: const Icon(Icons.dashboard_customize), text: l10n.tabDashboard),
            Tab(icon: const Icon(Icons.tune), text: l10n.tabTuning),
            Tab(icon: const Icon(Icons.auto_mode), text: l10n.tabAutomation),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DashboardPage(),
          DeviceTunerPage(),
          AutomationPage(),
        ],
      ),
    );
  }
}


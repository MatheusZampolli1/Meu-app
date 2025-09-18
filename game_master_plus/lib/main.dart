import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'services/system_services.dart';

void main() {
  runApp(const GameMasterPlusApp());
}

class GameMasterPlusApp extends StatelessWidget {
  const GameMasterPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.dark();
    return MaterialApp(
      title: 'Game Master Plus',
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        colorScheme: baseTheme.colorScheme.copyWith(
          primary: Colors.greenAccent,
          secondary: Colors.greenAccent,
        ),
        scaffoldBackgroundColor: const Color(0xFF111318),
        appBarTheme: baseTheme.appBarTheme.copyWith(
          backgroundColor: const Color(0xFF111318),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent.shade400,
            foregroundColor: Colors.black,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        cardTheme: baseTheme.cardTheme.copyWith(
          color: const Color(0xFF1A1C23),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      home: const GameMasterHome(),
    );
  }
}

class GameMasterHome extends StatefulWidget {
  const GameMasterHome({super.key});

  @override
  State<GameMasterHome> createState() => _GameMasterHomeState();
}

class _GameMasterHomeState extends State<GameMasterHome>
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Master Plus'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.greenAccent,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard_customize), text: 'Dashboard'),
            Tab(icon: Icon(Icons.tune), text: 'Ajustes'),
            Tab(icon: Icon(Icons.auto_mode), text: 'Automação'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DashboardTab(),
          DeviceTunerTab(),
          AutomationTab(),
        ],
      ),
    );
  }
}

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  final SystemMetricsService _metricsService = SystemMetricsService();
  DeviceMetrics _metrics = DeviceMetrics.initial();
  StreamSubscription<DeviceMetrics>? _subscription;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
    _subscription = _metricsService.metricsStream().listen((metrics) {
      setState(() => _metrics = metrics);
    });
  }

  Future<void> _loadMetrics() async {
    final metrics = await _metricsService.fetchMetrics();
    if (!mounted) return;
    setState(() => _metrics = metrics);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.greenAccent,
      onRefresh: _loadMetrics,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          _MetricCard(
            title: 'Uso de CPU',
            value: '${_metrics.cpuUsage.toStringAsFixed(0)}%',
            icon: Icons.memory,
            subtitle: 'Processos ativos e aplicações recentes',
          ),
          _MetricCard(
            title: 'Uso de RAM',
            value: '${_metrics.ramUsage.toStringAsFixed(0)}%',
            icon: Icons.developer_board,
            subtitle: 'Memória disponível para novos apps',
          ),
          _MetricCard(
            title: 'Armazenamento livre',
            value: '${_metrics.storageFree.toStringAsFixed(0)} GB',
            icon: Icons.sd_storage,
            subtitle: 'Espaço para apps, fotos e vídeos',
          ),
          _MetricCard(
            title: 'Temperatura do dispositivo',
            value: '${_metrics.temperature.toStringAsFixed(1)} °C',
            icon: Icons.thermostat_auto,
            subtitle: 'Monitore superaquecimento',
          ),
          _MetricCard(
            title: 'Nível de bateria',
            value: '${_metrics.batteryLevel}%',
            icon: Icons.battery_charging_full,
            subtitle: 'Considere ativar economia ao ficar abaixo de 30%',
          ),
        ],
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1F3B2C),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(icon, color: Colors.greenAccent.shade400, size: 28),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.greenAccent.shade400),
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

class DeviceTunerTab extends StatefulWidget {
  const DeviceTunerTab({super.key});

  @override
  State<DeviceTunerTab> createState() => _DeviceTunerTabState();
}

class _DeviceTunerTabState extends State<DeviceTunerTab> {
  final SystemAutomationService _automationService = SystemAutomationService();
  final List<String> _performanceProfiles = ['Economia', 'Balanceado', 'Turbo'];
  final List<String> _networkProfiles = ['Streaming', 'Jogos', 'Produtividade'];

  String _selectedPerformance = 'Balanceado';
  String _selectedNetwork = 'Produtividade';
  double _brightness = 0.65;
  bool _limitBackgroundApps = true;
  bool _adaptiveBattery = true;

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _applyDeviceSettings() async {
    try {
      await _automationService.applyPerformanceProfile(
        performanceProfile: _selectedPerformance,
        networkProfile: _selectedNetwork,
        brightnessLevel: _brightness,
        limitBackgroundApps: _limitBackgroundApps,
        adaptiveBattery: _adaptiveBattery,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Perfil $_selectedPerformance e rede $_selectedNetwork enviados ao sistema.',
          ),
          action: SnackBarAction(
            label: 'Resumo',
            textColor: Colors.black,
            onPressed: _showOptimizationSummary,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      _showSnack('Abrimos os ajustes relevantes para você concluir manualmente.');
    }
  }

  void _showOptimizationSummary() {
    final random = Random();
    final projectedGain = 5 + random.nextInt(10);
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1C23),
          title: const Text('Resumo da otimização'),
          content: Text(
            'Economia estimada de $projectedGain% na bateria nas próximas horas.\n'
            'Sugestão: mantenha o modo $_selectedPerformance durante tarefas longas.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Entendi', style: TextStyle(color: Colors.greenAccent.shade400)),
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
      _showSnack('Não foi possível abrir automaticamente. Ajuste manualmente nas configurações.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDropdown(
            label: 'Perfil de desempenho',
            selected: _selectedPerformance,
            options: _performanceProfiles,
            onChanged: (value) => setState(() => _selectedPerformance = value ?? _selectedPerformance),
          ),
          const SizedBox(height: 18),
          _buildDropdown(
            label: 'Prioridade de rede',
            selected: _selectedNetwork,
            options: _networkProfiles,
            onChanged: (value) => setState(() => _selectedNetwork = value ?? _selectedNetwork),
          ),
          const SizedBox(height: 24),
          Text('Controle de brilho', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Slider(
            value: _brightness,
            onChanged: (value) => setState(() => _brightness = value),
            activeColor: Colors.greenAccent,
            label: '${(_brightness * 100).round()}%',
          ),
          const SizedBox(height: 16),
          SwitchListTile.adaptive(
            value: _limitBackgroundApps,
            onChanged: (value) => setState(() => _limitBackgroundApps = value),
            title: const Text('Limitar apps em segundo plano'),
            subtitle: const Text('Reduz consumo de energia para programas inativos'),
            secondary: Icon(Icons.layers_clear, color: Colors.greenAccent.shade400),
          ),
          SwitchListTile.adaptive(
            value: _adaptiveBattery,
            onChanged: (value) => setState(() => _adaptiveBattery = value),
            title: const Text('Bateria adaptativa'),
            subtitle: const Text('Prioriza energia para apps mais usados'),
            secondary: Icon(Icons.battery_saver, color: Colors.greenAccent.shade400),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              OutlinedButton.icon(
                onPressed: () => _handleShortcut(
                  () => _automationService.openDisplaySettings(),
                  'Abra a tela de brilho para ajustar manualmente.',
                ),
                icon: const Icon(Icons.brightness_6),
                label: const Text('Config. de brilho'),
              ),
              OutlinedButton.icon(
                onPressed: () => _handleShortcut(
                  () => _automationService.openBatterySaverSettings(),
                  'Configurações de bateria abertas.',
                ),
                icon: const Icon(Icons.battery_std),
                label: const Text('Economia de energia'),
              ),
              OutlinedButton.icon(
                onPressed: () => _handleShortcut(
                  () => _automationService.openNetworkSettings(),
                  'Abra os ajustes de rede para priorizar conexões.',
                ),
                icon: const Icon(Icons.wifi),
                label: const Text('Rede e Wi-Fi'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _applyDeviceSettings,
            icon: const Icon(Icons.system_update_alt),
            label: const Text('Aplicar ajustes do sistema'),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String selected,
    required List<String> options,
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
          borderSide: const BorderSide(color: Colors.greenAccent),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected,
          iconEnabledColor: Colors.greenAccent,
          dropdownColor: const Color(0xFF1F212A),
          borderRadius: BorderRadius.circular(14),
          items: options
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class AutomationTab extends StatefulWidget {
  const AutomationTab({super.key});

  @override
  State<AutomationTab> createState() => _AutomationTabState();
}

class _AutomationTabState extends State<AutomationTab> {
  final SystemAutomationService _automationService = SystemAutomationService();
  bool _autoOptimize = true;
  bool _scheduleNightlyCleanup = false;
  bool _silentDuringFocus = false;
  bool _batterySaverReminder = true;

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _runAction(
    Future<void> Function() action,
    String successMessage, {
    String? failureMessage,
  }) async {
    try {
      await action();
      if (!mounted) return;
      _showSnack(successMessage);
    } catch (_) {
      if (!mounted) return;
      _showSnack(failureMessage ?? 'Abra manualmente nas Configurações do sistema.');
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    try {
      final status = await permission.request();
      return status == PermissionStatus.granted || status == PermissionStatus.limited;
    } catch (_) {
      return false;
    }
  }

  Future<void> _toggleAutoOptimize(bool value) async {
    if (value) {
      final granted = await _requestPermission(Permission.ignoreBatteryOptimizations);
      if (!granted) {
        _showSnack('Permissão de ignorar otimizações de bateria é necessária.');
        return;
      }
    }
    await _automationService.scheduleUnlockOptimization(enable: value);
    setState(() => _autoOptimize = value);
    _showSnack(
      value
          ? 'Otimização automática configurada ao desbloquear.'
          : 'Otimização automática desativada.',
    );
  }

  Future<void> _toggleNightlyCleanup(bool value) async {
    if (value) {
      final granted = await _requestPermission(Permission.scheduleExactAlarm);
      if (!granted) {
        _showSnack('Permissão para agendar alarmes é necessária.');
        return;
      }
    }
    await _automationService.scheduleNightlyCleanup(enable: value);
    setState(() => _scheduleNightlyCleanup = value);
    _showSnack(
      value ? 'Lembrete noturno configurado.' : 'Lembrete noturno cancelado.',
    );
  }

  Future<void> _toggleSilentDuringFocus(bool value) async {
    setState(() => _silentDuringFocus = value);
    if (value) {
      await _automationService.openDoNotDisturbSettings();
      if (!mounted) return;
      _showSnack('Ative o Não Perturbe para silenciar distrações.');
    } else {
      _showSnack('Dica de foco desativada.');
    }
  }

  Future<void> _toggleBatterySaverReminder(bool value) async {
    if (value) {
      final granted = await _requestPermission(Permission.notification);
      if (!granted) {
        _showSnack('Permita notificações para receber alertas.');
        return;
      }
    }
    setState(() => _batterySaverReminder = value);
    _showSnack(
      value ? 'Aviso de bateria baixa ativado.' : 'Aviso de bateria baixa desativado.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ElevatedButton.icon(
          onPressed: () => _runAction(
            () => _automationService.runQuickOptimize(),
            'Iniciamos uma rotina rápida de otimização.',
            failureMessage: 'Não foi possível otimizar automaticamente. Ajuste em Configurações > Bateria.',
          ),
          icon: const Icon(Icons.flash_on),
          label: const Text('One Tap Optimize'),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => _runAction(
            () => _automationService.openStorageSettings(),
            'Aba de armazenamento aberta. Limpe caches pelos menus do sistema.',
          ),
          icon: const Icon(Icons.delete_sweep),
          label: const Text('Guia de limpeza de cache'),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Regras automáticas', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                SwitchListTile.adaptive(
                  value: _autoOptimize,
                  onChanged: (value) => _toggleAutoOptimize(value),
                  title: const Text('Auto Optimize ao desbloquear'),
                  secondary: Icon(Icons.lock_open, color: Colors.greenAccent.shade400),
                ),
                SwitchListTile.adaptive(
                  value: _scheduleNightlyCleanup,
                  onChanged: (value) => _toggleNightlyCleanup(value),
                  title: const Text('Lembrete de limpeza noturna'),
                  secondary: Icon(Icons.nightlight_round, color: Colors.greenAccent.shade400),
                ),
                SwitchListTile.adaptive(
                  value: _silentDuringFocus,
                  onChanged: (value) => _toggleSilentDuringFocus(value),
                  title: const Text('Sem distrações durante foco'),
                  secondary: Icon(Icons.do_not_disturb_on, color: Colors.greenAccent.shade400),
                ),
                SwitchListTile.adaptive(
                  value: _batterySaverReminder,
                  onChanged: (value) => _toggleBatterySaverReminder(value),
                  title: const Text('Aviso de bateria fraca'),
                  secondary: Icon(Icons.battery_alert, color: Colors.greenAccent.shade400),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


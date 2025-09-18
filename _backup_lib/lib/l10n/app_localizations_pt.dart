// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Fluxon';

  @override
  String get appTagline =>
      'Seu celular mais rápido, seguro e inteligente, sem esforço.';

  @override
  String get tabDashboard => 'Painel';

  @override
  String get tabTuning => 'Ajustes';

  @override
  String get tabAutomation => 'Automação';

  @override
  String get dashboardHeroMessage =>
      'Destrave performance, segurança e automação em um só lugar.';

  @override
  String get metricCpuTitle => 'Uso de CPU';

  @override
  String get metricCpuSubtitle => 'Processos ativos e aplicativos recentes';

  @override
  String get metricRamTitle => 'Uso de RAM';

  @override
  String get metricRamSubtitle => 'Memória disponível para novos apps';

  @override
  String get metricStorageTitle => 'Armazenamento livre';

  @override
  String get metricStorageSubtitle => 'Espaço para apps, fotos e vídeos';

  @override
  String get metricTemperatureTitle => 'Temperatura do dispositivo';

  @override
  String get metricTemperatureSubtitle => 'Monitore superaquecimento';

  @override
  String get metricBatteryTitle => 'Nível de bateria';

  @override
  String get metricBatterySubtitle => 'Considere ativar economia abaixo de 30%';

  @override
  String get buttonOneTapOptimize => 'One Tap Optimize';

  @override
  String get buttonCacheGuide => 'Guia de limpeza de cache';

  @override
  String get automationCardTitle => 'Regras automáticas';

  @override
  String get toggleAutoOptimize => 'Auto Optimize ao desbloquear';

  @override
  String get toggleNightlyCleanup => 'Lembrete de limpeza noturna';

  @override
  String get toggleFocusMode => 'Sem distrações durante foco';

  @override
  String get toggleBatteryReminder => 'Aviso de bateria fraca';

  @override
  String get messageQuickOptimizeStarted =>
      'Iniciamos uma rotina rápida de otimização.';

  @override
  String get messageQuickOptimizeFailed =>
      'Não foi possível otimizar automaticamente. Ajuste em Configurações > Bateria.';

  @override
  String get messageStorageGuideOpened =>
      'Abrimos armazenamento. Limpe caches pelo menu do sistema.';

  @override
  String get messageAutoOptimizePermission =>
      'Permissão de ignorar otimizações de bateria é necessária.';

  @override
  String get messageAutoOptimizeEnabled =>
      'Otimização automática configurada ao desbloquear.';

  @override
  String get messageAutoOptimizeDisabled => 'Otimização automática desativada.';

  @override
  String get messageNightlyPermission =>
      'Permissão para agendar alarmes é necessária.';

  @override
  String get messageNightlyEnabled => 'Lembrete noturno configurado.';

  @override
  String get messageNightlyDisabled => 'Lembrete noturno cancelado.';

  @override
  String get messageFocusEnabled =>
      'Ative o Não Perturbe para silenciar distrações.';

  @override
  String get messageFocusDisabled => 'Dica de foco desativada.';

  @override
  String get messageNotificationPermission =>
      'Permita notificações para receber alertas.';

  @override
  String get messageBatteryReminderEnabled => 'Aviso de bateria baixa ativado.';

  @override
  String get messageBatteryReminderDisabled =>
      'Aviso de bateria baixa desativado.';

  @override
  String get messageManualSettingsFallback =>
      'Abra manualmente nas configurações do sistema.';

  @override
  String get performanceProfileEconomy => 'Economia';

  @override
  String get performanceProfileBalanced => 'Balanceado';

  @override
  String get performanceProfileTurbo => 'Turbo';

  @override
  String get networkProfileStreaming => 'Streaming';

  @override
  String get networkProfileGaming => 'Jogos';

  @override
  String get networkProfileProductivity => 'Produtividade';

  @override
  String messageProfileApplied(Object performance, Object network) {
    return 'Perfil $performance e rede $network enviados ao sistema.';
  }

  @override
  String get actionSummary => 'Resumo';

  @override
  String get messageManualAdjustmentsOpened =>
      'Abrimos os ajustes relevantes para você concluir manualmente.';

  @override
  String get dialogOptimizationTitle => 'Resumo da otimização';

  @override
  String dialogOptimizationContent(Object gain, Object performance) {
    return 'Economia estimada de $gain% na bateria nas próximas horas.\nDica: mantenha o modo $performance em tarefas longas.';
  }

  @override
  String get dialogPrimaryAction => 'Entendi';

  @override
  String get messageShortcutFailure =>
      'Não foi possível abrir automaticamente. Ajuste manualmente nas configurações.';

  @override
  String get dropdownPerformanceLabel => 'Perfil de desempenho';

  @override
  String get dropdownNetworkLabel => 'Prioridade de rede';

  @override
  String get labelBrightnessControl => 'Controle de brilho';

  @override
  String get toggleLimitBackgroundTitle => 'Limitar apps em segundo plano';

  @override
  String get toggleLimitBackgroundSubtitle =>
      'Reduz o consumo para apps inativos';

  @override
  String get toggleAdaptiveBatteryTitle => 'Bateria adaptativa';

  @override
  String get toggleAdaptiveBatterySubtitle =>
      'Prioriza energia para apps mais usados';

  @override
  String get messageDisplaySettingsOpened =>
      'Abrimos a tela de brilho para ajuste manual.';

  @override
  String get labelDisplaySettings => 'Config. de brilho';

  @override
  String get messageBatterySettingsOpened =>
      'Configurações de bateria abertas.';

  @override
  String get labelBatterySettings => 'Economia de energia';

  @override
  String get messageNetworkSettingsOpened =>
      'Abrimos os ajustes de rede para priorizar conexões.';

  @override
  String get labelNetworkSettings => 'Rede e Wi-Fi';

  @override
  String get buttonApplySystemSettings => 'Aplicar ajustes do sistema';

  @override
  String get insightCpuSpikeTitle => 'CPU no limite';

  @override
  String insightCpuSpikeBody(Object value) {
    return 'O uso de CPU está em $value% agora. Feche apps pesados ou mude para o modo Balanceado para esfriar.';
  }

  @override
  String get insightCpuTrendTitle => 'Uso de CPU em alta';

  @override
  String insightCpuTrendBody(Object value) {
    return 'A carga de processamento aumentou $value% nos últimos minutos. Considere ativar um perfil de eficiência.';
  }

  @override
  String get insightHighTempTitle => 'Dispositivo aquecendo';

  @override
  String insightHighTempBody(Object value) {
    return 'A temperatura chegou a $value°C. Ventile o aparelho ou interrompa tarefas intensas.';
  }

  @override
  String get insightStorageLowTitle => 'Pouco armazenamento livre';

  @override
  String insightStorageLowBody(Object value) {
    return 'Restam apenas $value GB livres. Execute a limpeza de armazenamento ou mova arquivos para a nuvem.';
  }

  @override
  String get insightBatteryLowTitle => 'Bateria baixa';

  @override
  String insightBatteryLowBody(Object value) {
    return 'A bateria está em $value%. Ative a economia de energia ou conecte o carregador.';
  }

  @override
  String get insightRamHighTitle => 'Memória quase cheia';

  @override
  String insightRamHighBody(Object value) {
    return 'Os apps usam $value% da RAM. Feche processos em segundo plano para evitar travamentos.';
  }

  @override
  String get insightAllGoodTitle => 'Tudo otimizado';

  @override
  String get insightAllGoodBody =>
      'Fluxon está controlando performance e temperatura. Continue assim!';

  @override
  String get automationRuleSectionTitle => 'Automação inteligente';

  @override
  String get automationRuleSectionSubtitle =>
      'Crie regras que reagem à bateria, horário ou desbloqueio.';

  @override
  String get automationRunRulesNow => 'Executar regras agora';

  @override
  String get automationCreateRule => 'Nova regra de automação';

  @override
  String automationRuleCreatedMessage(Object name) {
    return '$name foi ativada. O Fluxon cuida dela a partir de agora.';
  }

  @override
  String get automationRuleNoExecutionMessage =>
      'Nenhuma regra foi disparada. Ajuste as condições se necessário.';

  @override
  String automationRuleExecutedMessage(Object count) {
    return 'Executamos $count automação(ões).';
  }

  @override
  String get automationDeleteRule => 'Excluir';

  @override
  String get automationConditionUnlock => 'Quando o aparelho é desbloqueado';

  @override
  String automationConditionBattery(Object value) {
    return 'Quando a bateria ficar abaixo de $value%';
  }

  @override
  String automationConditionTime(Object value) {
    return 'Por volta de $value';
  }

  @override
  String get automationConditionBatteryLabel => 'Nível de bateria';

  @override
  String get automationConditionTimeLabel => 'Horário do dia';

  @override
  String get automationRuleFormTitle => 'Nova regra de automação';

  @override
  String get automationRuleNameLabel => 'Nome da regra';

  @override
  String get automationRuleNameError => 'Dê um nome para esta regra.';

  @override
  String get automationConditionLabel => 'Condição';

  @override
  String get automationActionLabel => 'Ação';

  @override
  String automationConditionBatteryInput(Object value) {
    return 'Disparar quando a bateria estiver em $value%.';
  }

  @override
  String automationConditionTimeInput(Object value) {
    return 'Disparar às $value.';
  }

  @override
  String get automationPickTimeButton => 'Escolher horário';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonSave => 'Salvar';

  @override
  String get automationActionQuickOptimize => 'Rodar otimização rápida';

  @override
  String get automationActionNightlyCleanup => 'Agendar limpeza noturna';

  @override
  String get automationActionOpenBattery => 'Abrir ajustes de bateria';

  @override
  String get automationActionOpenDisplay => 'Abrir ajustes de tela';

  @override
  String get automationActionOpenNetwork => 'Abrir ajustes de rede';

  @override
  String get automationQuickShortcutsTitle => 'Atalhos';

  @override
  String get automationEmptyState =>
      'Nenhuma regra criada ainda. Monte uma para automatizar sua rotina.';

  @override
  String get automationDefaultRuleName => 'Regra Fluxon';
}

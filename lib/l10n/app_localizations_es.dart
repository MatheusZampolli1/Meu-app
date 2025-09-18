// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Fluxon';

  @override
  String get appTagline =>
      'Tu teléfono más rápido, seguro e inteligente, sin esfuerzo.';

  @override
  String get tabDashboard => 'Panel';

  @override
  String get tabTuning => 'Ajustes';

  @override
  String get tabAutomation => 'Automatización';

  @override
  String get dashboardHeroMessage =>
      'Activa rendimiento, seguridad y automatización en un solo lugar.';

  @override
  String get metricCpuTitle => 'Uso de CPU';

  @override
  String get metricCpuSubtitle => 'Procesos activos y apps recientes';

  @override
  String get metricRamTitle => 'Uso de RAM';

  @override
  String get metricRamSubtitle => 'Memoria disponible para nuevas apps';

  @override
  String get metricStorageTitle => 'Almacenamiento libre';

  @override
  String get metricStorageSubtitle => 'Espacio para apps, fotos y videos';

  @override
  String get metricTemperatureTitle => 'Temperatura del dispositivo';

  @override
  String get metricTemperatureSubtitle => 'Supervisa el sobrecalentamiento';

  @override
  String get metricBatteryTitle => 'Nivel de batería';

  @override
  String get metricBatterySubtitle =>
      'Activa el ahorro de energía cuando baje del 30%';

  @override
  String get buttonOneTapOptimize => 'One Tap Optimize';

  @override
  String get buttonCacheGuide => 'Guía de limpieza de caché';

  @override
  String get automationCardTitle => 'Reglas automáticas';

  @override
  String get toggleAutoOptimize => 'Auto Optimize al desbloquear';

  @override
  String get toggleNightlyCleanup => 'Recordatorio de limpieza nocturna';

  @override
  String get toggleFocusMode => 'Enfoque sin distracciones';

  @override
  String get toggleBatteryReminder => 'Alerta de batería baja';

  @override
  String get messageQuickOptimizeStarted =>
      'Iniciamos una rutina rápida de optimización.';

  @override
  String get messageQuickOptimizeFailed =>
      'No fue posible optimizar automáticamente. Ajusta en Configuración > Batería.';

  @override
  String get messageStorageGuideOpened =>
      'Se abrió el almacenamiento. Limpia cachés desde el menú del sistema.';

  @override
  String get messageAutoOptimizePermission =>
      'Se requiere permiso para ignorar optimizaciones de batería.';

  @override
  String get messageAutoOptimizeEnabled =>
      'Optimización automática configurada al desbloquear.';

  @override
  String get messageAutoOptimizeDisabled =>
      'Optimización automática desactivada.';

  @override
  String get messageNightlyPermission =>
      'Se requiere permiso para programar alarmas.';

  @override
  String get messageNightlyEnabled => 'Recordatorio nocturno configurado.';

  @override
  String get messageNightlyDisabled => 'Recordatorio nocturno cancelado.';

  @override
  String get messageFocusEnabled =>
      'Activa No molestar para silenciar distracciones.';

  @override
  String get messageFocusDisabled => 'Sugerencia de enfoque desactivada.';

  @override
  String get messageNotificationPermission =>
      'Permite notificaciones para recibir alertas.';

  @override
  String get messageBatteryReminderEnabled => 'Aviso de batería baja activado.';

  @override
  String get messageBatteryReminderDisabled =>
      'Aviso de batería baja desactivado.';

  @override
  String get messageManualSettingsFallback =>
      'Abre manualmente la configuración del sistema.';

  @override
  String get performanceProfileEconomy => 'Ahorro';

  @override
  String get performanceProfileBalanced => 'Balanceado';

  @override
  String get performanceProfileTurbo => 'Turbo';

  @override
  String get networkProfileStreaming => 'Streaming';

  @override
  String get networkProfileGaming => 'Juegos';

  @override
  String get networkProfileProductivity => 'Productividad';

  @override
  String messageProfileApplied(Object performance, Object network) {
    return 'Perfil $performance y red $network enviados al sistema.';
  }

  @override
  String get actionSummary => 'Resumen';

  @override
  String get messageManualAdjustmentsOpened =>
      'Abrimos los ajustes relevantes para que termines manualmente.';

  @override
  String get dialogOptimizationTitle => 'Resumen de la optimización';

  @override
  String dialogOptimizationContent(Object gain, Object performance) {
    return 'Ahorro estimado de $gain% de batería en las próximas horas.\nConsejo: mantén el modo $performance en tareas largas.';
  }

  @override
  String get dialogPrimaryAction => 'Entendido';

  @override
  String get messageShortcutFailure =>
      'No se pudo abrir automáticamente. Ajusta manualmente en la configuración.';

  @override
  String get dropdownPerformanceLabel => 'Perfil de rendimiento';

  @override
  String get dropdownNetworkLabel => 'Prioridad de red';

  @override
  String get labelBrightnessControl => 'Control de brillo';

  @override
  String get toggleLimitBackgroundTitle => 'Limitar apps en segundo plano';

  @override
  String get toggleLimitBackgroundSubtitle =>
      'Reduce el consumo de energía de apps inactivas';

  @override
  String get toggleAdaptiveBatteryTitle => 'Batería adaptativa';

  @override
  String get toggleAdaptiveBatterySubtitle =>
      'Prioriza energía para las apps más usadas';

  @override
  String get messageDisplaySettingsOpened =>
      'Se abrió la pantalla de brillo para ajustes manuales.';

  @override
  String get labelDisplaySettings => 'Config. de brillo';

  @override
  String get messageBatterySettingsOpened =>
      'Configuración de batería abierta.';

  @override
  String get labelBatterySettings => 'Ahorro de energía';

  @override
  String get messageNetworkSettingsOpened =>
      'Se abrieron los ajustes de red para priorizar conexiones.';

  @override
  String get labelNetworkSettings => 'Red y Wi-Fi';

  @override
  String get buttonApplySystemSettings => 'Aplicar ajustes del sistema';

  @override
  String get insightCpuSpikeTitle => 'CPU al máximo';

  @override
  String insightCpuSpikeBody(Object value) {
    return 'El uso de CPU está en $value% ahora. Cierra apps pesadas o cambia a modo Balanceado para enfriar.';
  }

  @override
  String get insightCpuTrendTitle => 'Tendencia de CPU en aumento';

  @override
  String insightCpuTrendBody(Object value) {
    return 'La carga de procesamiento aumentó $value% en los últimos minutos. Considera activar un perfil eficiente.';
  }

  @override
  String get insightHighTempTitle => 'Dispositivo calentándose';

  @override
  String insightHighTempBody(Object value) {
    return 'La temperatura alcanzó $value°C. Ventila el equipo o pausa tareas intensas.';
  }

  @override
  String get insightStorageLowTitle => 'Poco almacenamiento disponible';

  @override
  String insightStorageLowBody(Object value) {
    return 'Quedan solo $value GB libres. Ejecuta la limpieza de almacenamiento o mueve archivos a la nube.';
  }

  @override
  String get insightBatteryLowTitle => 'Batería baja';

  @override
  String insightBatteryLowBody(Object value) {
    return 'La batería está en $value%. Activa el ahorro de energía o conecta el cargador.';
  }

  @override
  String get insightRamHighTitle => 'Memoria exigida';

  @override
  String insightRamHighBody(Object value) {
    return 'Las apps usan $value% de la RAM. Cierra procesos en segundo plano para evitar lentitud.';
  }

  @override
  String get insightAllGoodTitle => 'Todo optimizado';

  @override
  String get insightAllGoodBody =>
      'Fluxon mantiene controlados rendimiento y temperatura. ¡Buen trabajo!';

  @override
  String get automationRuleSectionTitle => 'Automatización inteligente';

  @override
  String get automationRuleSectionSubtitle =>
      'Crea reglas que reaccionan a la batería, horario o desbloqueo.';

  @override
  String get automationRunRulesNow => 'Ejecutar reglas ahora';

  @override
  String get automationCreateRule => 'Nueva regla de automatización';

  @override
  String automationRuleCreatedMessage(Object name) {
    return '$name está activa. Fluxon la vigilará a partir de ahora.';
  }

  @override
  String get automationRuleNoExecutionMessage =>
      'Ninguna regla se disparó. Ajusta las condiciones si es necesario.';

  @override
  String automationRuleExecutedMessage(Object count) {
    return 'Se ejecutaron $count automatización(es).';
  }

  @override
  String get automationDeleteRule => 'Eliminar';

  @override
  String get automationConditionUnlock => 'Cuando el dispositivo se desbloquea';

  @override
  String automationConditionBattery(Object value) {
    return 'Cuando la batería baja de $value%';
  }

  @override
  String automationConditionTime(Object value) {
    return 'Alrededor de $value';
  }

  @override
  String get automationConditionBatteryLabel => 'Nivel de batería';

  @override
  String get automationConditionTimeLabel => 'Hora del día';

  @override
  String get automationRuleFormTitle => 'Nueva regla de automatización';

  @override
  String get automationRuleNameLabel => 'Nombre de la regla';

  @override
  String get automationRuleNameError => 'Asigna un nombre a esta regla.';

  @override
  String get automationConditionLabel => 'Condición';

  @override
  String get automationActionLabel => 'Acción';

  @override
  String automationConditionBatteryInput(Object value) {
    return 'Disparar cuando la batería esté en $value%.';
  }

  @override
  String automationConditionTimeInput(Object value) {
    return 'Disparar a las $value.';
  }

  @override
  String get automationPickTimeButton => 'Elegir hora';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get automationActionQuickOptimize => 'Ejecutar optimización rápida';

  @override
  String get automationActionNightlyCleanup => 'Programar limpieza nocturna';

  @override
  String get automationActionOpenBattery => 'Abrir ajustes de batería';

  @override
  String get automationActionOpenDisplay => 'Abrir ajustes de pantalla';

  @override
  String get automationActionOpenNetwork => 'Abrir ajustes de red';

  @override
  String get automationQuickShortcutsTitle => 'Accesos directos';

  @override
  String get automationEmptyState =>
      'No hay reglas todavía. Crea una para automatizar tu rutina.';

  @override
  String get automationDefaultRuleName => 'Regla Fluxon';
}

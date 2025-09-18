import 'package:flutter/widgets.dart';

class FluxonStrings {
  FluxonStrings._(this.languageCode);

  factory FluxonStrings.of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return FluxonStrings._(locale.languageCode.toLowerCase());
  }

  final String languageCode;

  String _resolve(Map<String, String> translations, String fallback) {
    return translations[languageCode] ?? fallback;
  }

  String get securityCenterTab => _resolve(
        const {
          'pt': 'Segurança',
          'es': 'Seguridad',
        },
        'Security',
      );

  String get onboardingMonitorTitle => _resolve(
        const {
          'pt': 'Monitore a performance do seu dispositivo',
          'es': 'Monitorea el rendimiento de tu dispositivo',
        },
        'Monitor your device performance',
      );

  String get onboardingMonitorSubtitle => _resolve(
        const {
          'pt': 'Acompanhe CPU, memória e rede em tempo real com o Fluxon.',
          'es': 'Controla CPU, memoria y red en tiempo real con Fluxon.',
        },
        'Track CPU, memory, and network health in real time with Fluxon.',
      );

  String get onboardingAutomationTitle => _resolve(
        const {
          'pt': 'Automatize tarefas e economize tempo',
          'es': 'Automatiza tareas y ahorra tiempo',
        },
        'Automate tasks and save time',
      );

  String get onboardingAutomationSubtitle => _resolve(
        const {
          'pt': 'Crie rotinas inteligentes para otimizar o uso do dispositivo.',
          'es': 'Crea rutinas inteligentes para optimizar el uso del dispositivo.',
        },
        'Build smart routines to keep your device optimized effortlessly.',
      );

  String get onboardingSecurityTitle => _resolve(
        const {
          'pt': 'Proteja-se contra riscos de segurança',
          'es': 'Protégete contra riesgos de seguridad',
        },
        'Protect yourself against security risks',
      );

  String get onboardingSecuritySubtitle => _resolve(
        const {
          'pt': 'Receba alertas e monitore permissões sensíveis.',
          'es': 'Recibe alertas y monitorea permisos sensibles.',
        },
        'Get alerts and keep sensitive permissions in check.',
      );

  String get onboardingSkip => _resolve(
        const {
          'pt': 'Pular',
          'es': 'Omitir',
        },
        'Skip',
      );

  String get onboardingStart => _resolve(
        const {
          'pt': 'Começar',
          'es': 'Comenzar',
        },
        'Get started',
      );

  String get onboardingNext => _resolve(
        const {
          'pt': 'Avançar',
          'es': 'Siguiente',
        },
        'Next',
      );

  String get metricsChartTitle => _resolve(
        const {
          'pt': 'Histórico de desempenho',
          'es': 'Historial de rendimiento',
        },
        'Performance history',
      );

  String get metricsChartEmpty => _resolve(
        const {
          'pt': 'Precisamos de mais tempo para coletar histórico. Mantenha o Fluxon rodando.',
          'es': 'Necesitamos un poco más de tiempo para recolectar historial. Mantén Fluxon abierto.',
        },
        'We need a little more time to collect history. Keep Fluxon running.',
      );

  String metricsChartSemantics(String cpu, String ram, String battery) {
    final template = _resolve(
      const {
        'pt': 'CPU {cpu} porcento, RAM {ram} porcento, bateria {battery} porcento.',
        'es': 'CPU {cpu} por ciento, RAM {ram} por ciento, batería {battery} por ciento.',
      },
      'CPU {cpu} percent, RAM {ram} percent, battery {battery} percent.',
    );
    return template
        .replaceAll('{cpu}', cpu)
        .replaceAll('{ram}', ram)
        .replaceAll('{battery}', battery);
  }

  String get securityCenterTitle => _resolve(
        const {
          'pt': 'Centro de Segurança',
          'es': 'Centro de Seguridad',
        },
        'Security Center',
      );

  String get securityCenterClearAction => _resolve(
        const {
          'pt': 'Limpar riscos',
          'es': 'Limpiar riesgos',
        },
        'Clear risks',
      );

  String get securityCenterEmpty => _resolve(
        const {
          'pt': 'Nenhum evento de segurança registrado.',
          'es': 'No hay eventos de seguridad registrados.',
        },
        'No security events recorded yet.',
      );

  String get securityCenterCleared => _resolve(
        const {
          'pt': 'Eventos de segurança limpos.',
          'es': 'Eventos de seguridad eliminados.',
        },
        'Security events cleared.',
      );

  String get initializationErrorTitle => _resolve(
        const {
          'pt': 'Erro de inicialização',
          'es': 'Error de inicialización',
        },
        'Initialization error',
      );

  String get initializationErrorBody => _resolve(
        const {
          'pt': 'Reinicie o Fluxon após liberar acesso ao armazenamento ou limpar os dados do app.',
          'es': 'Reinicia Fluxon después de otorgar acceso al almacenamiento o limpiar los datos de la app.',
        },
        'Please restart Fluxon after granting storage access or clearing app data.',
      );
}

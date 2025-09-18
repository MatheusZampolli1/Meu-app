import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';

import 'package:game_master_plus/l10n/app_localizations.dart';
import 'package:game_master_plus/modules/home/fluxon_home.dart';
import 'package:game_master_plus/modules/onboarding/presentation/onboarding_page.dart';
import 'package:game_master_plus/modules/security/presentation/security_center_page.dart';
import 'package:game_master_plus/shared/i18n/fluxon_strings.dart';
import 'package:game_master_plus/shared/services/app_preferences.dart';
import 'package:game_master_plus/shared/theme/app_theme.dart';

class FluxonApp extends StatelessWidget {
  const FluxonApp({
    super.key,
    required this.preferences,
    this.initializationError,
  });

  final AppPreferences preferences;
  final Object? initializationError;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: FluxonTheme.build(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routes: {
        SecurityCenterPage.routeName: (context) => const SecurityCenterPage(),
      },
      home: ValueListenableBuilder<Box<dynamic>>(
        valueListenable: preferences.listenable(),
        builder: (context, _, __) {
          if (initializationError != null) {
            return InitializationErrorScreen(error: initializationError!);
          }

          if (preferences.onboardingCompleted) {
            return const FluxonHome();
          }

          return OnboardingPage(
            onFinished: () => preferences.setOnboardingCompleted(true),
          );
        },
      ),
    );
  }
}

class InitializationErrorScreen extends StatelessWidget {
  const InitializationErrorScreen({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = FluxonStrings.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(
                strings.initializationErrorTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                error.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                strings.initializationErrorBody,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:game_master_plus/l10n/app_localizations.dart';
import 'package:game_master_plus/modules/home/fluxon_home.dart';
import 'package:game_master_plus/shared/theme/app_theme.dart';

class FluxonApp extends StatelessWidget {
  const FluxonApp({super.key});

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
      home: const FluxonHome(),
    );
  }
}

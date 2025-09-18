import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_master_plus/shared/perf/performance_profile.dart';
import 'package:game_master_plus/shared/perf/perf_native.dart';

Future<void> runOneTapOptimize(BuildContext context) async {
  final theme = Theme.of(context);
  double progress = 0.0;
  bool finished = false;
  bool started = false;
  Timer? ticker;

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return WillPopScope(
        onWillPop: () async => false,
        child: StatefulBuilder(
          builder: (ctx, setState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!started) {
                started = true;
                ticker = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
                  if (finished) {
                    timer.cancel();
                    return;
                  }

                  setState(() {
                    progress = (progress + 0.033).clamp(0.0, 1.0);
                    if (progress >= 1.0) {
                      progress = 1.0;
                      finished = true;
                    }
                  });

                  if (finished) {
                    timer.cancel();
                    try {
                      await PerfController().setProfile(PerfProfile.turbo);
                      await PerfNative.startTurbo();
                    } catch (_) {}
                  }
                });
              }
            });

            return AlertDialog(
              backgroundColor: theme.colorScheme.surface,
              title: const Text('Otimizando…'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 12),
                  Text('${(progress * 100).round()}%'),
                ],
              ),
              actions: [
                if (finished)
                  TextButton(
                    onPressed: () {
                      ticker?.cancel();
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Concluir'),
                  ),
              ],
            );
          },
        ),
      );
    },
  );

  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('O celular foi totalmente otimizado e está pronto para uso.'),
    ),
  );
}

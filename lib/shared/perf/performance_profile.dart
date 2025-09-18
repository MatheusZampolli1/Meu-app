import 'perf_native.dart';

enum PerfProfile { economy, balanced, turbo }

class PerfController {
  PerfProfile _current = PerfProfile.balanced;
  Duration _pollingInterval = const Duration(seconds: 5);
  double _animationScale = 1.0;

  PerfProfile get current => _current;
  Duration get pollingInterval => _pollingInterval;
  double get animationScale => _animationScale;

  Future<void> setProfile(PerfProfile profile) async {
    if (_current == profile) {
      return;
    }

    switch (profile) {
      case PerfProfile.economy:
        _pollingInterval = const Duration(seconds: 8);
        _animationScale = 0.75;
        await PerfNative.stopTurbo();
        break;
      case PerfProfile.balanced:
        _pollingInterval = const Duration(seconds: 5);
        _animationScale = 1.0;
        await PerfNative.stopTurbo();
        break;
      case PerfProfile.turbo:
        _pollingInterval = const Duration(seconds: 2);
        _animationScale = 1.25;
        await PerfNative.startTurbo();
        break;
    }

    _current = profile;
  }
}


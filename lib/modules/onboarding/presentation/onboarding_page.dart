import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'package:game_master_plus/modules/home/fluxon_home.dart';
import 'package:game_master_plus/shared/i18n/fluxon_strings.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.onFinished});

  final Future<void> Function() onFinished;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const _maxSlides = 3;

  late final PageController _controller;
  int _currentIndex = 0;
  bool _isFinishing = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_OnboardingSlide> _buildSlides(FluxonStrings strings, Color accent) {
    return [
      _OnboardingSlide(
        icon: LucideIcons.memory_stick,
        title: strings.onboardingMonitorTitle,
        description: strings.onboardingMonitorSubtitle,
        accent: accent,
      ),
      _OnboardingSlide(
        icon: LucideIcons.settings_2,
        title: strings.onboardingAutomationTitle,
        description: strings.onboardingAutomationSubtitle,
        accent: accent,
      ),
      _OnboardingSlide(
        icon: LucideIcons.shield_check,
        title: strings.onboardingSecurityTitle,
        description: strings.onboardingSecuritySubtitle,
        accent: accent,
      ),
    ];
  }

  Future<void> _finishOnboarding() async {
    if (_isFinishing) return;
    setState(() => _isFinishing = true);
    try {
      await widget.onFinished();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const FluxonHome()),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isFinishing = false);
      }
    }
  }

  void _handleNext() {
    if (_currentIndex >= _maxSlides - 1) {
      _finishOnboarding();
      return;
    }

    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = FluxonStrings.of(context);
    final accent = theme.colorScheme.primary;
    final slides = _buildSlides(strings, accent);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.surfaceContainerHighest, theme.colorScheme.surface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isFinishing ? null : _finishOnboarding,
                  child: Text(strings.onboardingSkip),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: slides.length,
                  onPageChanged: (index) => setState(() => _currentIndex = index),
                  itemBuilder: (context, index) {
                    final slide = slides[index];
                    return Semantics(
                      label: slide.description != null && slide.description!.isNotEmpty
                          ? '${slide.title}. ${slide.description!}'
                          : slide.title,
                      child: _OnboardingSlideView(slide: slide),
                    );
                  },
                ),
              ),
              _OnboardingIndicator(
                itemCount: slides.length,
                currentIndex: _currentIndex,
                accent: accent,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isFinishing ? null : _handleNext,
                    icon: Icon(
                      _currentIndex >= slides.length - 1
                          ? LucideIcons.check
                          : LucideIcons.arrow_right,
                    ),
                    label: Text(
                      _currentIndex >= slides.length - 1
                          ? strings.onboardingStart
                          : strings.onboardingNext,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.icon,
    required this.title,
    this.description,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String? description;
  final Color accent;
}

class _OnboardingSlideView extends StatelessWidget {
  const _OnboardingSlideView({required this.slide});

  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
              color: slide.accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(24),
            child: Icon(slide.icon, size: 48, color: slide.accent),
          ),
          const SizedBox(height: 36),
          Text(
            slide.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (slide.description != null && slide.description!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              slide.description!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _OnboardingIndicator extends StatelessWidget {
  const _OnboardingIndicator({
    required this.itemCount,
    required this.currentIndex,
    required this.accent,
  });

  final int itemCount;
  final int currentIndex;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(itemCount, (index) {
          final isActive = index == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive
                  ? accent
                  : accent.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(999),
            ),
          );
        }),
      ),
    );
  }
}



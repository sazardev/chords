import 'dart:async' show unawaited;

import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/core/analytics/settings_analytics_events.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/onboarding/onboarding_controller.dart';
import 'package:chords/presentation/features/onboarding/onboarding_steps.dart';
import 'package:chords/presentation/features/profile/profile_controller.dart';
import 'package:chords/presentation/features/profile/profile_pickers.dart';
import 'package:chords/presentation/theme/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Onboarding de primer uso: conoce a la persona y prepara su plan.
///
/// Seis pasos —bienvenida, guitarra, cómo toca, géneros, experiencia y plan—
/// con transición animada entre ellos. Cada elección se guarda al momento y
/// se puede omitir todo el recorrido.
class OnboardingPage extends StatefulWidget {
  /// Crea la página de onboarding.
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const int _stepCount = 6;

  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isLast => _index == _stepCount - 1;

  void _move(int delta) {
    final int target = (_index + delta).clamp(0, _stepCount - 1);
    unawaited(
      _controller.animateToPage(
        target,
        duration: kMotionSlow,
        curve: kEmphasizedCurve,
      ),
    );
  }

  void _next() {
    if (_isLast) {
      context.read<ProfileController>().confirm();
      _finish();
    } else {
      _move(1);
    }
  }

  void _finish() {
    unawaited(context.read<OnboardingController>().complete());
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _TopBar(
              index: _index,
              count: _stepCount,
              onBack: () => _move(-1),
              onSkip: _finish,
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (int value) {
                  setState(() => _index = value);
                  analytics.onboardingStep(step: value + 1);
                },
                children: _pages(t),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _next,
                  child: AnimatedSwitcher(
                    duration: kMotionMedium,
                    child: Text(_label(t), key: ValueKey<String>(_label(t))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _pages(Translations t) => <Widget>[
    const WelcomeStep(),
    OnboardingStep(
      title: t.onboarding.guitarTitle,
      body: t.onboarding.guitarBody,
      child: const GuitarPicker(),
    ),
    OnboardingStep(
      title: t.onboarding.playTitle,
      body: t.onboarding.playBody,
      child: const PlayPicker(),
    ),
    OnboardingStep(
      title: t.onboarding.genresTitle,
      body: t.onboarding.genresBody,
      child: const GenrePicker(),
    ),
    OnboardingStep(
      title: t.onboarding.levelTitle,
      body: t.onboarding.levelBody,
      child: const ExperiencePicker(),
    ),
    const PlanStep(),
  ];

  String _label(Translations t) {
    if (_index == 0) {
      return t.onboarding.welcomeCta;
    }
    return _isLast ? t.onboarding.finish : t.onboarding.proceed;
  }
}

/// Barra superior: volver, progreso por segmentos y omitir.
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.index,
    required this.count,
    required this.onBack,
    required this.onSkip,
  });

  final int index;
  final int count;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 56,
      child: Row(
        children: <Widget>[
          AnimatedOpacity(
            opacity: index == 0 ? 0 : 1,
            duration: kMotionMedium,
            // Sin tooltip: el onboarding vive sobre el navegador y no tiene
            // un Overlay donde mostrarlo.
            child: IconButton(
              onPressed: index == 0 ? null : onBack,
              icon: Semantics(
                label: t.onboarding.back,
                child: const Icon(Icons.arrow_back_rounded),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                for (int i = 1; i < count; i++)
                  Expanded(
                    child: AnimatedContainer(
                      duration: kMotionSlow,
                      curve: kEmphasizedCurve,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: i <= index
                            ? scheme.primary
                            : scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AnimatedOpacity(
            opacity: index == count - 1 ? 0 : 1,
            duration: kMotionMedium,
            child: TextButton(
              onPressed: index == count - 1 ? null : onSkip,
              child: Text(t.app.skip),
            ),
          ),
        ],
      ),
    );
  }
}

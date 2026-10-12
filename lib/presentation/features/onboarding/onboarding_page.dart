import 'dart:async' show unawaited;

import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/core/analytics/settings_analytics_events.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/onboarding/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Página de introducción (onboarding) de primer uso.
class OnboardingPage extends StatefulWidget {
  /// Crea la página de onboarding.
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _index = 0;

  List<_Slide> _slides(Translations t) => <_Slide>[
    _Slide(
      title: t.onboarding.slideOneTitle,
      body: t.onboarding.slideOneBody,
      icon: Icons.library_music_rounded,
    ),
    _Slide(
      title: t.onboarding.slideTwoTitle,
      body: t.onboarding.slideTwoBody,
      icon: Icons.graphic_eq_rounded,
    ),
    _Slide(
      title: t.onboarding.slideThreeTitle,
      body: t.onboarding.slideThreeBody,
      icon: Icons.sports_esports_rounded,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next(List<_Slide> slides) {
    if (_index < slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    unawaited(context.read<OnboardingController>().complete());
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final List<_Slide> slides = _slides(t);
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton(onPressed: _finish, child: Text(t.app.skip)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: slides.length,
                onPageChanged: (int value) {
                  setState(() => _index = value);
                  analytics.onboardingStep(step: value + 1);
                },
                itemBuilder: (BuildContext context, int index) =>
                    _SlideView(slide: slides[index], theme: theme),
              ),
            ),
            _Dots(count: slides.length, index: _index, theme: theme),
            _finishButton(slides, t),
          ],
        ),
      ),
    );
  }

  Widget _finishButton(List<_Slide> slides, Translations t) => Padding(
    padding: const EdgeInsets.all(24),
    child: SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () => _next(slides),
        child: Text(_index == slides.length - 1 ? t.app.start : t.app.next),
      ),
    ),
  );
}

/// Diapositiva del onboarding.
class _Slide {
  const _Slide({required this.title, required this.body, required this.icon});

  final String title;
  final String body;
  final IconData icon;
}

/// Contenido visual de una diapositiva.
class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide, required this.theme});

  final _Slide slide;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 28),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(40),
          ),
          child: SizedBox(
            width: 108,
            height: 108,
            child: Icon(
              slide.icon,
              size: 48,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          slide.title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          slide.body,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

/// Indicadores de página del onboarding.
class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index, required this.theme});

  final int count;
  final int index;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      for (int i = 0; i < count; i++)
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: i == index ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: i == index
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
    ],
  );
}

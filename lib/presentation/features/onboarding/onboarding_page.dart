import 'dart:async' show unawaited;

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

  static const List<_Slide> _slides = <_Slide>[
    _Slide(
      title: 'Todos los acordes, todas las posiciones',
      body:
          '156 acordes y 581 posiciones verificadas, de los abiertos '
          'esenciales a los voicings de jazz.',
      icon: Icons.library_music_rounded,
    ),
    _Slide(
      title: 'Escucha cada acorde y su arpegio',
      body:
          'Sintetizamos cada cuerda para que reconozcas el sonido antes '
          'de tocar.',
      icon: Icons.graphic_eq_rounded,
    ),
    _Slide(
      title: 'Aprende por niveles y practica',
      body:
          'Itinerario paso a paso, filtro por género y modo juego para '
          'encadenar series de acordes.',
      icon: Icons.sports_esports_rounded,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < _slides.length - 1) {
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
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: _finish,
                  child: const Text('Omitir'),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (int value) {
                  setState(() => _index = value);
                },
                itemBuilder: (BuildContext context, int index) {
                  final _Slide slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 54,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          foregroundColor: theme.colorScheme.onPrimaryContainer,
                          child: Icon(slide.icon, size: 44),
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
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < _slides.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _index ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _index
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _next,
                  child: Text(
                    _index == _slides.length - 1 ? 'Empezar' : 'Siguiente',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Diapositiva del onboarding.
class _Slide {
  const _Slide({required this.title, required this.body, required this.icon});

  final String title;
  final String body;
  final IconData icon;
}

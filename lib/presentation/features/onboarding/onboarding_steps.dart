import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/usecases/recommend_chords_use_case.dart';
import 'package:chords/domain/profile/entities/guitar_type.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/features/profile/profile_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/l10n/profile_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/entrance.dart';
import 'package:chords/presentation/widgets/atoms/guitar_glyph.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Contenedor común de un paso: título, explicación y contenido desplazable.
class OnboardingStep extends StatelessWidget {
  /// Crea un paso.
  const OnboardingStep({
    required this.title,
    required this.body,
    required this.child,
    super.key,
  });

  /// Pregunta del paso.
  final String title;

  /// Explicación breve.
  final String body;

  /// Opciones del paso.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Entrance(
            child: Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Entrance(
            index: 1,
            child: Text(
              body,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

/// Bienvenida con tres guitarras que flotan suavemente.
class WelcomeStep extends StatelessWidget {
  /// Crea la bienvenida.
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ThemeData theme = Theme.of(context);
    // Centrada si cabe y desplazable si la pantalla es baja.
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) =>
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: (box.maxHeight - 24).clamp(0.0, double.infinity),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Entrance(child: _FloatingGuitars()),
                  const SizedBox(height: 32),
                  Entrance(
                    index: 2,
                    child: Text(
                      t.onboarding.welcomeTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Entrance(
                    index: 3,
                    child: Text(
                      t.onboarding.welcomeBody,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
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

/// Las tres guitarras de la bienvenida, con un vaivén finito.
class _FloatingGuitars extends StatefulWidget {
  const _FloatingGuitars();

  @override
  State<_FloatingGuitars> createState() => _FloatingGuitarsState();
}

class _FloatingGuitarsState extends State<_FloatingGuitars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Finito a propósito: la animación termina sola y no mantiene la
    // pantalla repintando para siempre.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true, count: 6);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(56),
      ),
      child: SizedBox(
        height: 240,
        width: double.infinity,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? _) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              for (int i = 0; i < GuitarType.values.length; i++)
                Transform.translate(
                  offset: Offset(0, _sway(i)),
                  child: Transform.rotate(
                    angle: (i - 1) * 0.16 + _tilt(i),
                    child: GuitarGlyph(
                      type: GuitarType.values[i],
                      size: i == 1 ? 168 : 140,
                      body: i == 1
                          ? scheme.primary
                          : scheme.onPrimaryContainer.withValues(alpha: 0.7),
                      detail: scheme.primaryContainer,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  double _sway(int i) =>
      math.sin((_controller.value * 2 - 1 + i * 0.6) * math.pi) * 7;

  double _tilt(int i) =>
      math.sin((_controller.value * 2 - 1 + i * 0.6) * math.pi) * 0.03;
}

/// Último paso: los acordes elegidos para la persona.
class PlanStep extends StatelessWidget {
  /// Crea el paso del plan.
  const PlanStep({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ProfileController profile = context.watch<ProfileController>();
    final ChordsController chords = context.watch<ChordsController>();
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController s) => s.mirrorChords,
    );
    final List<Chord> picks = const RecommendChordsUseCase()(
      chords.allChords,
      profile.profile,
      limit: 4,
    );
    return OnboardingStep(
      title: t.onboarding.planTitle,
      body: picks.isEmpty ? t.onboarding.planEmpty : t.onboarding.planBody,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Entrance(
            index: 2,
            child: Text(
              profileSummary(t, profile.profile),
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              for (int i = 0; i < picks.length; i++)
                Entrance(
                  index: i + 3,
                  child: _PlanChord(chord: picks[i], mirror: mirror),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanChord extends StatelessWidget {
  const _PlanChord({required this.chord, required this.mirror});

  final Chord chord;
  final bool mirror;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 150,
    child: AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          ChordDiagram(
            variant: chord.easiestVariant,
            mirror: mirror,
            width: 100,
            height: 124,
          ),
          const SizedBox(height: 6),
          AppText(chord.name, variant: AppTextVariant.titleLarge),
        ],
      ),
    ),
  );
}

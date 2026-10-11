import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/features/learn/learn_controller.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/progress_ring.dart';
import 'package:chords/presentation/widgets/molecules/quick_action_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Pantalla de inicio con progreso, continuación y accesos rápidos.
class HomePage extends StatelessWidget {
  /// Crea la pantalla de inicio.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ChordsController chords = context.watch<ChordsController>();
    final LearnController learn = context.watch<LearnController>();
    return Scaffold(
      appBar: AppBar(title: Text(t.app.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: <Widget>[
            _Greeting(t: t),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: _ProgressSummary(learn: learn),
            ),
            const SizedBox(height: 16),
            ..._actions(context, chords, learn.nextChordId, t),
          ],
        ),
      ),
    );
  }

  List<Widget> _actions(
    BuildContext context,
    ChordsController chords,
    String? nextId,
    Translations t,
  ) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return <Widget>[
      _padded(
        QuickActionCard(
          icon: Icons.school_rounded,
          title: t.home.continueLearning,
          subtitle: nextId == null
              ? t.home.itineraryComplete
              : t.home.nextChord(name: _nameOf(chords, nextId)),
          onTap: () => context.go(kLearnPath),
        ),
      ),
      const SizedBox(height: 12),
      _padded(
        QuickActionCard(
          icon: Icons.library_music_rounded,
          title: t.home.library,
          subtitle: t.home.librarySubtitle(count: chords.allChords.length),
          onTap: () => context.go(kChordsPath),
        ),
      ),
      const SizedBox(height: 12),
      _padded(
        QuickActionCard(
          icon: Icons.sports_esports_rounded,
          title: t.home.gameMode,
          subtitle: t.home.gameSubtitle,
          onTap: () => context.go(kGamePath),
        ),
      ),
      const SizedBox(height: 12),
      _padded(
        QuickActionCard(
          icon: Icons.graphic_eq_rounded,
          title: t.home.liveTitle,
          subtitle: t.home.liveSubtitle,
          onTap: () => context.go(kLivePath),
          color: scheme.secondaryContainer,
        ),
      ),
    ];
  }

  Widget _padded(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: child,
  );

  String _nameOf(ChordsController chords, String id) {
    for (final Chord chord in chords.allChords) {
      if (chord.id == id) {
        return chord.name;
      }
    }
    return id;
  }
}

/// Cabecera con el saludo y la pregunta inicial.
class _Greeting extends StatelessWidget {
  const _Greeting({required this.t});

  final Translations t;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppText(
          t.home.greeting,
          variant: AppTextVariant.bodyLarge,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        AppText(
          t.home.question,
          variant: AppTextVariant.displayLarge,
          maxLines: 2,
        ),
      ],
    ),
  );
}

/// Resumen de progreso del aprendizaje.
class _ProgressSummary extends StatelessWidget {
  const _ProgressSummary({required this.learn});

  final LearnController learn;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      borderRadius: 28,
      padding: const EdgeInsets.all(20),
      color: scheme.primaryContainer,
      child: Row(
        children: <Widget>[
          ProgressRing(
            progress: learn.progress,
            size: 76,
            label: '${(learn.progress * 100).round()}%',
            trackColor: scheme.onPrimaryContainer.withValues(alpha: 0.24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  t.home.progressTitle,
                  variant: AppTextVariant.titleMedium,
                  color: scheme.onPrimaryContainer,
                ),
                const SizedBox(height: 4),
                AppText(
                  t.home.masteredCount(n: learn.mastered.length),
                  color: scheme.onPrimaryContainer,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

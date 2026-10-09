import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/features/learn/learn_controller.dart';
import 'package:chords/presentation/router/route_paths.dart';
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
    final ChordsController chords = context.watch<ChordsController>();
    final LearnController learn = context.watch<LearnController>();
    final String? nextId = learn.nextChordId;
    return Scaffold(
      appBar: AppBar(title: const Text('Chords')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppText(
                    'Hola, guitararrista',
                    variant: AppTextVariant.bodyLarge,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const AppText(
                    '¿Qué tocas hoy?',
                    variant: AppTextVariant.displayLarge,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: _ProgressSummary(learn: learn),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: QuickActionCard(
                icon: Icons.school_rounded,
                title: 'Continúa aprendiendo',
                subtitle: nextId == null
                    ? '¡Itinerario completo!'
                    : 'Siguiente: ${_nameOf(chords, nextId)}',
                onTap: () => context.go(kLearnPath),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: QuickActionCard(
                icon: Icons.library_music_rounded,
                title: 'Biblioteca de acordes',
                subtitle:
                    '${chords.allChords.length} acordes por género y nivel',
                onTap: () => context.go(kChordsPath),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: QuickActionCard(
                icon: Icons.sports_esports_rounded,
                title: 'Modo juego',
                subtitle: 'Toca el acorde y encadena la serie',
                onTap: () => context.go(kGamePath),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: QuickActionCard(
                icon: Icons.graphic_eq_rounded,
                title: 'Afinación en vivo',
                subtitle: 'Detecta la nota con tu micrófono',
                onTap: () => context.go(kLivePath),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _nameOf(ChordsController chords, String id) {
    for (final Chord chord in chords.allChords) {
      if (chord.id == id) {
        return chord.name;
      }
    }
    return id;
  }
}

/// Resumen de progreso del aprendizaje.
class _ProgressSummary extends StatelessWidget {
  const _ProgressSummary({required this.learn});

  final LearnController learn;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[scheme.primaryContainer, scheme.tertiaryContainer],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: <Widget>[
          ProgressRing(
            progress: learn.progress,
            size: 76,
            label: '${(learn.progress * 100).round()}%',
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const AppText(
                  'Progreso del itinerario',
                  variant: AppTextVariant.titleMedium,
                ),
                const SizedBox(height: 4),
                AppText(
                  '${learn.mastered.length} acordes dominados',
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

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/learning_level.dart';
import 'package:chords/domain/chords/usecases/recommend_chords_use_case.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/profile/entities/player_profile.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/features/game/game_score_controller.dart';
import 'package:chords/presentation/features/home/home_hero.dart';
import 'package:chords/presentation/features/home/home_sections.dart';
import 'package:chords/presentation/features/learn/learn_controller.dart';
import 'package:chords/presentation/features/profile/profile_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/features/studio/history_page.dart';
import 'package:chords/presentation/features/studio/studio_shortcuts.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/entrance.dart';
import 'package:chords/presentation/widgets/atoms/guitar_glyph.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Dashboard de inicio: progreso, siguiente acorde, recomendaciones y accesos.
///
/// Se organiza de arriba abajo por importancia: saludo, qué estudiar ahora,
/// cifras de progreso, acordes recomendados para el perfil y herramientas.
class HomePage extends StatelessWidget {
  /// Crea la pantalla de inicio.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChordsController chords = context.watch<ChordsController>();
    final LearnController learn = context.watch<LearnController>();
    final ProfileController profileController = context
        .watch<ProfileController>();
    final GameScoreController score = context.watch<GameScoreController>();
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController s) => s.mirrorChords,
    );
    final PlayerProfile profile = profileController.profile;
    final Chord? next = _find(
      chords.allChords,
      learn.nextChordIdFrom(profile.experience.startLevel),
    );
    final List<Chord> picks = const RecommendChordsUseCase()(
      chords.allChords,
      profile,
      mastered: learn.mastered,
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: _sections(
                profile: profile,
                next: next,
                picks: picks,
                chords: chords,
                learn: learn,
                score: score,
                mirror: mirror,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _sections({
    required PlayerProfile profile,
    required Chord? next,
    required List<Chord> picks,
    required ChordsController chords,
    required LearnController learn,
    required GameScoreController score,
    required bool mirror,
  }) => <Widget>[
    Entrance(child: _Header(profile: profile)),
    const SizedBox(height: 20),
    Entrance(
      index: 1,
      child: HomeHero(
        next: next,
        progress: learn.progress,
        mastered: learn.mastered.length,
        mirror: mirror,
      ),
    ),
    const SizedBox(height: 12),
    Entrance(
      index: 2,
      child: HomeStats(
        mastered: learn.mastered.length,
        bestScore: score.bestScore,
        level: next == null ? 5 : LearningLevel.of(next).level,
      ),
    ),
    if (picks.isNotEmpty) ...<Widget>[
      const SizedBox(height: 28),
      Entrance(
        index: 3,
        child: HomeRecommendations(
          chords: picks,
          profile: profile,
          mirror: mirror,
        ),
      ),
    ],
    const SizedBox(height: 28),
    const Entrance(index: 4, child: _Studio()),
    const SizedBox(height: 28),
    Entrance(index: 5, child: _Tools(total: chords.allChords.length)),
  ];

  Chord? _find(List<Chord> chords, String? id) {
    for (final Chord chord in chords) {
      if (chord.id == id) {
        return chord;
      }
    }
    return null;
  }
}

/// Secciones para aprender la guitarra y su mundo, con los recientes.
class _Studio extends StatelessWidget {
  const _Studio();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      AppText(
        context.t.studio.sectionTitle,
        variant: AppTextVariant.titleLarge,
      ),
      const SizedBox(height: 12),
      const StudioShortcuts(),
      const SizedBox(height: 12),
      const RecentChordsRow(padding: 0),
    ],
  );
}

/// Saludo según la hora y acceso al perfil.
class _Header extends StatelessWidget {
  const _Header({required this.profile});

  final PlayerProfile profile;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final int hour = DateTime.now().hour;
    final String greeting = hour < 12
        ? t.home.greetingMorning
        : (hour < 20 ? t.home.greetingAfternoon : t.home.greetingEvening);
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppText(
                greeting,
                variant: AppTextVariant.bodyLarge,
                color: scheme.onSurfaceVariant,
              ),
              AppText(
                t.home.question,
                variant: AppTextVariant.headlineMedium,
                weight: FontWeight.w800,
                maxLines: 2,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Semantics(
          button: true,
          label: t.profile.edit,
          child: InkWell(
            onTap: () => context.push(kProfilePath),
            customBorder: const CircleBorder(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: 56,
                height: 56,
                child: Center(
                  child: GuitarGlyph(
                    type: profile.guitar,
                    size: 38,
                    body: scheme.onSecondaryContainer,
                    detail: scheme.secondaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Accesos a las demás secciones.
class _Tools extends StatelessWidget {
  const _Tools({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<HomeToolTile> tiles = <HomeToolTile>[
      HomeToolTile(
        icon: Icons.graphic_eq_rounded,
        title: t.nav.live,
        subtitle: t.home.liveSubtitle,
        background: scheme.tertiaryContainer,
        ink: scheme.onTertiaryContainer,
        onTap: () => context.go(kLivePath),
      ),
      HomeToolTile(
        icon: Icons.sports_esports_rounded,
        title: t.home.gameMode,
        subtitle: t.home.gameSubtitle(count: MiniGameKind.values.length + 1),
        background: scheme.secondaryContainer,
        ink: scheme.onSecondaryContainer,
        onTap: () => context.go(kGamePath),
      ),
      HomeToolTile(
        icon: Icons.library_music_rounded,
        title: t.home.library,
        subtitle: t.home.librarySubtitle(count: total),
        background: scheme.surfaceContainerHigh,
        ink: scheme.onSurface,
        onTap: () => context.go(kChordsPath),
      ),
      HomeToolTile(
        icon: Icons.school_rounded,
        title: t.nav.learn,
        subtitle: t.home.learnSubtitle,
        background: scheme.primaryContainer,
        ink: scheme.onPrimaryContainer,
        onTap: () => context.go(kLearnPath),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppText(t.home.toolsTitle, variant: AppTextVariant.titleLarge),
        const SizedBox(height: 12),
        for (int row = 0; row < 2; row++) ...<Widget>[
          if (row > 0) const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(child: tiles[row * 2]),
                const SizedBox(width: 12),
                Expanded(child: tiles[row * 2 + 1]),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

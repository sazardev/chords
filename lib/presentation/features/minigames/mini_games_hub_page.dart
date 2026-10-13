import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/guitar_control/guitar_action.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_bar.dart';
import 'package:chords/presentation/features/guitar_control/guitar_mic_keeper.dart';
import 'package:chords/presentation/features/minigames/hub_guitar_nav.dart';
import 'package:chords/presentation/features/minigames/mini_game_card.dart';
import 'package:chords/presentation/features/minigames/mini_game_progress_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/entrance.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Catálogo de juegos: oído, mástil y dedos, y tocar con el micrófono.
///
/// Si la persona lo activa, se recorre tocando cuerdas al aire: Re pasa al
/// juego siguiente, La al anterior, Mi abre el seleccionado y Si sale del
/// modo, de modo que puede elegir qué practicar sin soltar la guitarra. El
/// panel de abajo dice qué juego está elegido y también se puede cerrar con
/// el botón de la esquina.
class MiniGamesHubPage extends StatefulWidget {
  /// Crea el catálogo.
  const MiniGamesHubPage({super.key});

  @override
  State<MiniGamesHubPage> createState() => _MiniGamesHubPageState();
}

class _MiniGamesHubPageState extends State<MiniGamesHubPage> {
  /// Elementos navegables: la serie de acordes y después cada minijuego.
  static final int _count = 1 + MiniGameKind.values.length;

  final List<GlobalKey> _keys = List<GlobalKey>.generate(
    _count,
    (_) => GlobalKey(),
  );
  late final GuitarMicKeeper _mic;
  int _focus = 0;
  bool _wasOn = false;

  @override
  void initState() {
    super.initState();
    _mic = context.read<GuitarMicKeeper>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool on = Provider.of<SettingsController>(context).guitarBrowse;
    final bool visible =
        TickerMode.valuesOf(context).enabled &&
        (ModalRoute.isCurrentOf(context) ?? true);
    if (!on) {
      unawaited(_mic.close());
    } else if (visible) {
      unawaited(_mic.open());
    }
    if (on && !_wasOn) {
      _reveal();
    }
    _wasOn = on;
  }

  @override
  void dispose() {
    unawaited(_mic.close());
    super.dispose();
  }

  String _pathOf(int index) => index == 0
      ? kChordGamePath
      : '$kMiniGamePath?kind=${MiniGameKind.values[index - 1].id}';

  void _open() => unawaited(context.push(_pathOf(_focus)));

  void _move(int step) {
    setState(() => _focus = (_focus + step + _count) % _count);
    _reveal();
  }

  /// Sale del modo guitarra: la lista vuelve a usarse solo con el dedo.
  void _close() => unawaited(
    context.read<SettingsController>().setGuitarBrowse(value: false),
  );

  /// Lleva el elemento elegido al centro de la lista.
  void _reveal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? target = _keys[_focus].currentContext;
      if (target != null && target.mounted) {
        unawaited(
          Scrollable.ensureVisible(
            target,
            duration: const Duration(milliseconds: 300),
            alignment: 0.5,
          ),
        );
      }
    });
  }

  List<GuitarAction> _actions(Translations t) => <GuitarAction>[
    GuitarAction(
      command: GuitarCommand.next,
      label: t.guitar.open,
      icon: Icons.play_arrow_rounded,
      emphasized: true,
      onTrigger: _open,
    ),
    GuitarAction(
      command: GuitarCommand.retry,
      label: t.guitar.previousGame,
      icon: Icons.arrow_upward_rounded,
      onTrigger: () => _move(-1),
    ),
    GuitarAction(
      command: GuitarCommand.listen,
      label: t.guitar.nextGame,
      icon: Icons.arrow_downward_rounded,
      onTrigger: () => _move(1),
    ),
    GuitarAction(
      command: GuitarCommand.exit,
      label: t.guitar.leave,
      icon: Icons.close_rounded,
      onTrigger: _close,
    ),
  ];

  /// Nombre del elemento elegido con su posición en el catálogo.
  String _selected(Translations t) => t.guitar.hubSelected(
    name: _focus == 0
        ? t.minigames.chordGameTitle
        : gameTitle(t, MiniGameKind.values[_focus - 1]),
    n: _focus + 1,
    total: _count,
  );

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final MiniGameProgressController progress = context
        .watch<MiniGameProgressController>();
    final SettingsController settings = context.watch<SettingsController>();
    final bool on = settings.guitarBrowse;
    return Scaffold(
      appBar: AppBar(title: Text(t.minigames.hubTitle)),
      bottomNavigationBar: on
          ? SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: GuitarCommandBar(
                  actions: _actions(t),
                  headline: _selected(t),
                  onClose: _close,
                  compact: true,
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: <Widget>[
                Entrance(child: _ProgressCard(progress: progress)),
                const SizedBox(height: 12),
                HubGuitarSwitch(settings: settings),
                const SizedBox(height: 12),
                Entrance(
                  index: 1,
                  child: HubFocus(
                    key: _keys[0],
                    focused: on && _focus == 0,
                    child: const _ChordGameCard(),
                  ),
                ),
                for (final MiniGameCategory category
                    in MiniGameCategory.values) ...<Widget>[
                  const SizedBox(height: 24),
                  _CategorySection(
                    category: category,
                    progress: progress,
                    focused: on ? _focus : -1,
                    keys: _keys,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.progress});

  final MiniGameProgressController progress;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      color: scheme.primaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            t.minigames.hubSubtitle,
            variant: AppTextVariant.titleMedium,
            color: scheme.onPrimaryContainer,
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Icon(Icons.star_rounded, color: scheme.onPrimaryContainer),
              const SizedBox(width: 6),
              Expanded(
                child: AppText(
                  t.minigames.starsTotal(
                    earned: progress.totalStars,
                    total: progress.maxStars,
                  ),
                  color: scheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.totalStars / progress.maxStars,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChordGameCard extends StatelessWidget {
  const _ChordGameCard();

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      color: scheme.tertiaryContainer,
      onTap: () => context.push(kChordGamePath),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.sports_esports_rounded,
            size: 32,
            color: scheme.onTertiaryContainer,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  t.minigames.chordGameTitle,
                  variant: AppTextVariant.titleMedium,
                  color: scheme.onTertiaryContainer,
                ),
                AppText(
                  t.minigames.chordGameSubtitle,
                  variant: AppTextVariant.labelMedium,
                  color: scheme.onTertiaryContainer.withValues(alpha: 0.8),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: scheme.onTertiaryContainer),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.progress,
    required this.focused,
    required this.keys,
  });

  final MiniGameCategory category;
  final MiniGameProgressController progress;

  /// Posición del elemento seleccionado con la guitarra (-1 si ninguno).
  final int focused;

  /// Llaves de cada elemento para desplazar la lista hasta el seleccionado.
  final List<GlobalKey> keys;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final List<MiniGameKind> games = MiniGameKind.of(category);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppText(categoryTitle(t, category), variant: AppTextVariant.titleLarge),
        AppText(
          categorySubtitle(t, category),
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < games.length; i += 2) ...<Widget>[
          if (i > 0) const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(child: _card(context, games[i])),
                const SizedBox(width: 12),
                Expanded(
                  child: i + 1 < games.length
                      ? _card(context, games[i + 1])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _card(BuildContext context, MiniGameKind kind) {
    final int index = 1 + MiniGameKind.values.indexOf(kind);
    return HubFocus(
      key: keys[index],
      focused: focused == index,
      child: MiniGameCard(
        kind: kind,
        stars: progress.starsFor(kind),
        onTap: () => context.push('$kMiniGamePath?kind=${kind.id}'),
      ),
    );
  }
}

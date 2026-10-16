import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/guitar_control/guitar_action.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_bar.dart';
import 'package:chords/presentation/features/minigames/hub_filter.dart';
import 'package:chords/presentation/features/minigames/hub_guitar_nav.dart';
import 'package:chords/presentation/features/minigames/hub_search_bar.dart';
import 'package:chords/presentation/features/minigames/hub_sections.dart';
import 'package:chords/presentation/features/minigames/mini_game_progress_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_empty_state.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/entrance.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Catálogo de juegos por familias, con buscador y filtros.
///
/// Con el modo guitarra encendido se recorre tocando cuerdas al aire: Re pasa
/// al juego siguiente, La al anterior y Mi abre el seleccionado, de modo que
/// puede elegir qué practicar sin soltar la guitarra. Se recorren solo los
/// juegos que deja ver el filtro. El panel fijo de la app (`GuitarDock`) dice
/// qué juego está elegido; el micrófono y la salida del modo los lleva ese
/// panel, no esta pantalla.
class MiniGamesHubPage extends StatefulWidget {
  /// Crea el catálogo.
  const MiniGamesHubPage({super.key});

  @override
  State<MiniGamesHubPage> createState() => _MiniGamesHubPageState();
}

class _MiniGamesHubPageState extends State<MiniGamesHubPage> {
  /// Llave del elemento de la serie de acordes (no es un [MiniGameKind]).
  final GlobalKey _chordGameKey = GlobalKey();
  final Map<MiniGameKind, GlobalKey> _keys = <MiniGameKind, GlobalKey>{
    for (final MiniGameKind kind in MiniGameKind.values) kind: GlobalKey(),
  };

  HubFilter _filter = const HubFilter();
  int _focus = 0;
  bool _wasOn = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool on = Provider.of<SettingsController>(context).guitarBrowse;
    if (on && !_wasOn) {
      _reveal();
    }
    _wasOn = on;
  }

  /// Elementos navegables en orden: la serie de acordes (`null`) y los juegos
  /// que deja ver el filtro.
  List<MiniGameKind?> _entries(Translations t) => <MiniGameKind?>[
    if (showsChordGame(t, _filter)) null,
    ...filterGames(t, _filter),
  ];

  void _open(List<MiniGameKind?> entries) {
    if (entries.isEmpty) {
      return;
    }
    final MiniGameKind? kind = entries[_focus.clamp(0, entries.length - 1)];
    unawaited(
      context.push(
        kind == null ? kChordGamePath : '$kMiniGamePath?kind=${kind.id}',
      ),
    );
  }

  void _move(int step, int count) {
    if (count == 0) {
      return;
    }
    setState(() => _focus = (_focus + step + count) % count);
    _reveal();
  }

  /// Lleva el elemento elegido al centro de la lista.
  void _reveal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final List<MiniGameKind?> entries = _entries(context.t);
      if (entries.isEmpty) {
        return;
      }
      final MiniGameKind? kind = entries[_focus.clamp(0, entries.length - 1)];
      final BuildContext? target =
          (kind == null ? _chordGameKey : _keys[kind]!).currentContext;
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

  void _changeFilter(HubFilter filter) => setState(() {
    _filter = filter;
    _focus = 0;
  });

  List<GuitarAction> _actions(Translations t, List<MiniGameKind?> entries) =>
      <GuitarAction>[
        GuitarAction(
          command: GuitarCommand.next,
          label: t.guitar.open,
          icon: Icons.play_arrow_rounded,
          emphasized: true,
          onTrigger: () => _open(entries),
        ),
        GuitarAction(
          command: GuitarCommand.retry,
          label: t.guitar.previousGame,
          icon: Icons.arrow_upward_rounded,
          onTrigger: () => _move(-1, entries.length),
        ),
        GuitarAction(
          command: GuitarCommand.listen,
          label: t.guitar.nextGame,
          icon: Icons.arrow_downward_rounded,
          onTrigger: () => _move(1, entries.length),
        ),
      ];

  /// Nombre del elemento elegido con su posición en el catálogo.
  String _selected(Translations t, List<MiniGameKind?> entries) {
    final int at = _focus.clamp(0, entries.length - 1);
    final MiniGameKind? kind = entries[at];
    return t.guitar.hubSelected(
      name: kind == null ? t.minigames.chordGameTitle : gameTitle(t, kind),
      n: at + 1,
      total: entries.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final MiniGameProgressController progress = context
        .watch<MiniGameProgressController>();
    final SettingsController settings = context.watch<SettingsController>();
    final bool on = settings.guitarBrowse;
    final List<MiniGameKind?> entries = _entries(t);
    final MiniGameKind? focused = on && entries.isNotEmpty
        ? entries[_focus.clamp(0, entries.length - 1)]
        : null;
    final bool chordFocused = on && entries.isNotEmpty && focused == null;
    return Scaffold(
      appBar: AppBar(title: Text(t.minigames.hubTitle)),
      bottomNavigationBar: on && entries.isNotEmpty
          ? GuitarCommandBar(
              actions: _actions(t, entries),
              headline: _selected(t, entries),
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
                HubSearchBar(filter: _filter, onChanged: _changeFilter),
                const SizedBox(height: 12),
                if (entries.isEmpty)
                  AppEmptyState(
                    icon: Icons.search_off_rounded,
                    title: t.chordGames.noResultsTitle,
                    message: t.chordGames.noResultsBody,
                  ),
                if (showsChordGame(t, _filter))
                  Entrance(
                    index: 1,
                    child: HubFocus(
                      key: _chordGameKey,
                      focused: chordFocused,
                      child: const HubChordGameCard(),
                    ),
                  ),
                for (final MiniGameCategory category
                    in kHubCategoryOrder) ...<Widget>[
                  ..._section(t, category, progress, focused),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _section(
    Translations t,
    MiniGameCategory category,
    MiniGameProgressController progress,
    MiniGameKind? focused,
  ) {
    final List<MiniGameKind> games = filterGames(
      t,
      _filter,
    ).where((MiniGameKind kind) => kind.category == category).toList();
    if (games.isEmpty) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: 24),
      HubCategorySection(
        category: category,
        games: games,
        progress: progress,
        focused: focused,
        keyOf: (MiniGameKind kind) => _keys[kind]!,
      ),
    ];
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

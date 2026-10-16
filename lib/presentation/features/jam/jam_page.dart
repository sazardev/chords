import 'dart:async' show unawaited;

import 'package:chords/domain/jam/jam_track.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/band_settings_controller.dart';
import 'package:chords/presentation/features/jam/jam_controller.dart';
import 'package:chords/presentation/features/jam/jam_result_view.dart';
import 'package:chords/presentation/features/jam/jam_selection.dart';
import 'package:chords/presentation/features/jam/jam_setup_view.dart';
import 'package:chords/presentation/features/jam/jam_stage_view.dart';
import 'package:chords/presentation/features/jam/jam_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Jam guiado: elige qué tocar, toca con la app y mira el resultado.
///
/// Al entrar lee la ruta (`?prog=blues12&key=9` o `?song=bamba`) y carga
/// esa pista; al salir corta el reloj y el micrófono.
class JamPage extends StatefulWidget {
  /// Crea la pantalla.
  const JamPage({super.key});

  @override
  State<JamPage> createState() => _JamPageState();
}

class _JamPageState extends State<JamPage> {
  JamSelection _selection = const JamSelection();
  String? _appliedQuery;
  int? _loops;
  late final JamController _controller = context.read<JamController>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Uri uri = GoRouterState.of(context).uri;
    if (uri.query == _appliedQuery) {
      return;
    }
    _appliedQuery = uri.query;
    _loops = context.read<BandSettingsController>().config.loops;
    _selection = JamSelection.fromQuery(uri.queryParameters);
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  void _select(JamSelection selection) {
    setState(() => _selection = selection);
    _reload();
  }

  void _reload() {
    if (!mounted) {
      return;
    }
    final JamTrack? track = _selection.toTrack(
      context.t,
      loops: _loops ?? context.read<BandSettingsController>().config.loops,
    );
    if (track != null) {
      unawaited(_controller.load(track));
    }
  }

  @override
  void dispose() {
    _controller.leave();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final JamState state = context.watch<JamController>().state;
    final int loops = context.select<BandSettingsController, int>(
      (BandSettingsController s) => s.config.loops,
    );
    if (_loops != null && _loops != loops) {
      _loops = loops;
      WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
    }
    return PopScope(
      canPop: !state.isRunning,
      onPopInvokedWithResult: (bool didPop, Object? _) {
        if (!didPop) {
          unawaited(_controller.stop());
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(state.track?.title ?? t.jam.title)),
        body: SafeArea(
          child: switch (state.phase) {
            JamPhase.setup => JamSetupView(
              selection: _selection,
              onChanged: _select,
            ),
            JamPhase.finished => JamResultView(state: state),
            _ => JamStageView(state: state),
          },
        ),
      ),
    );
  }
}

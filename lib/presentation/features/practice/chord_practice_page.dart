import 'dart:async' show unawaited;

import 'package:chords/domain/chords/entities/chord_practice_session.dart';
import 'package:chords/domain/chords/entities/practice_string.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/practice/chord_practice_controller.dart';
import 'package:chords/presentation/features/practice/practice_guide.dart';
import 'package:chords/presentation/features/practice/practice_string_list.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/l10n/tuner_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_empty_state.dart';
import 'package:chords/presentation/widgets/atoms/app_loading.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/molecules/mic_level_bar.dart';
import 'package:chords/presentation/widgets/molecules/mic_problem_card.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Práctica de un acorde cuerda a cuerda con el micrófono.
///
/// Muestra el diagrama con cada cuerda iluminada según se reconoce, dice qué
/// tocar ahora (traste y dedo) y, si suena mal, cómo corregirlo.
class ChordPracticePage extends StatefulWidget {
  /// Crea la pantalla de práctica.
  const ChordPracticePage({super.key});

  @override
  State<ChordPracticePage> createState() => _ChordPracticePageState();
}

class _ChordPracticePageState extends State<ChordPracticePage> {
  late final ChordPracticeController _controller;
  bool _notFound = false;

  @override
  void initState() {
    super.initState();
    _controller = context.read<ChordPracticeController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_open());
      }
    });
  }

  Future<void> _open() async {
    final Map<String, String> query = GoRouterState.of(context)
        .uri
        .queryParameters;
    final bool found = await _controller.open(
      query['id'] ?? '',
      int.tryParse(query['v'] ?? '') ?? 0,
    );
    if (!mounted) {
      return;
    }
    if (found) {
      await _controller.start();
    } else {
      setState(() => _notFound = true);
    }
  }

  @override
  void dispose() {
    unawaited(_controller.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ChordPracticeController controller = context
        .watch<ChordPracticeController>();
    final ChordPracticeSession? session = controller.session;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.chord == null
              ? t.practice.title
              : '${controller.chord!.name} · ${t.practice.title}',
        ),
      ),
      body: SafeArea(
        child: _notFound
            ? AppEmptyState(
                icon: Icons.music_off_rounded,
                title: t.chordDetail.errorTitle,
                message: t.chordDetail.noChordMessage,
              )
            : session == null
            ? AppLoading(message: t.chordDetail.loading)
            : _Body(controller: controller, session: session),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.controller, required this.session});

  final ChordPracticeController controller;
  final ChordPracticeSession session;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController settings) => settings.mirrorChords,
    );
    final List<PracticeString> strings = session.strings;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: <Widget>[
        if (MicProblemCard.isProblem(controller.status)) ...<Widget>[
          MicProblemCard(
            status: controller.status,
            onRetry: () => unawaited(controller.start()),
          ),
          const SizedBox(height: 12),
        ],
        Center(
          child: ChordDiagram(
            variant: controller.variant!,
            mirror: mirror,
            width: 260,
            height: 330,
            stringStates: <PracticeStringStatus>[
              for (final PracticeString s in strings) s.status,
            ],
            focusString: controller.status.isListening
                ? session.focus?.number
                : null,
            stringNames: <String>[
              for (final PracticeString s in strings) openNoteName(t, s.string),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _Progress(session: session),
        const SizedBox(height: 12),
        PracticeGuide(controller: controller, session: session),
        if (controller.status.isListening) ...<Widget>[
          const SizedBox(height: 12),
          MicLevelBar(level: controller.level),
        ],
        const SizedBox(height: 16),
        PracticeStringList(controller: controller, session: session),
      ],
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.session});

  final ChordPracticeSession session;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: session.total == 0
                ? 0
                : session.matchedCount / session.total,
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 6),
        AppText(
          t.practice.progress(
            count: session.matchedCount,
            total: session.total,
          ),
          variant: AppTextVariant.labelMedium,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}

import 'dart:async' show unawaited;

import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/live/tuner_controller.dart';
import 'package:chords/presentation/features/live/tuner_view.dart';
import 'package:chords/presentation/features/practice/chord_practice_controller.dart';
import 'package:chords/presentation/l10n/tuner_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Abre el afinador sobre la práctica, centrado en una cuerda.
///
/// Pausa la escucha de la práctica mientras se afina (solo un micrófono a la
/// vez) y la reanuda al cerrar la hoja, sin perder las cuerdas ya
/// reconocidas.
Future<void> showRetuneSheet(BuildContext context, int stringNumber) async {
  final ChordPracticeController practice = context
      .read<ChordPracticeController>();
  final TunerController tuner = context.read<TunerController>();
  // Al parar la escucha la tarjeta del consejo desaparece: se guarda el
  // navegador antes de esperar para poder abrir la hoja igualmente.
  final NavigatorState navigator = Navigator.of(context);
  final GuitarString? string = standardStringByNumber(stringNumber);
  await practice.stop();
  if (string != null && tuner.state.target != string) {
    tuner.selectString(string);
  }
  unawaited(tuner.start());
  if (!navigator.mounted) {
    return;
  }
  await showModalBottomSheet<void>(
    context: navigator.context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (BuildContext sheet) => _RetuneSheet(string: string),
  );
  await tuner.stopIfListening();
  await practice.start(keepProgress: true);
}

class _RetuneSheet extends StatelessWidget {
  const _RetuneSheet({required this.string});

  final GuitarString? string;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          children: <Widget>[
            AppText(
              string == null
                  ? t.tuner.tabTune
                  : '${t.practice.retune} · ${stringTitle(t, string!)}',
              variant: AppTextVariant.titleLarge,
              align: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const TunerView(),
          ],
        ),
      ),
    );
  }
}

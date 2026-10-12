import 'dart:async' show unawaited;

import 'package:chords/domain/chords/entities/chord_practice_session.dart';
import 'package:chords/domain/chords/entities/practice_string.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/practice/chord_practice_controller.dart';
import 'package:chords/presentation/l10n/tuner_labels.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Lista de las seis cuerdas con su estado y lo que pide el acorde de cada una.
///
/// Pulsar una cuerda reproduce su nota para compararla de oído.
class PracticeStringList extends StatelessWidget {
  /// Crea la lista.
  const PracticeStringList({
    required this.controller,
    required this.session,
    super.key,
  });

  /// Controlador de la práctica.
  final ChordPracticeController controller;

  /// Sesión en curso.
  final ChordPracticeSession session;

  @override
  Widget build(BuildContext context) {
    final int? focus = controller.status.isListening
        ? session.focus?.number
        : null;
    return Column(
      children: <Widget>[
        for (final PracticeString string in session.strings)
          _StringRow(
            string: string,
            focused: string.number == focus,
            onTap: string.isMuted
                ? null
                : () => unawaited(controller.playString(string)),
          ),
      ],
    );
  }
}

class _StringRow extends StatelessWidget {
  const _StringRow({
    required this.string,
    required this.focused,
    required this.onTap,
  });

  final PracticeString string;
  final bool focused;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final AppChordColors colors = chordColorsOf(context);
    final (IconData icon, Color color) = switch (string.status) {
      PracticeStringStatus.matched => (
        Icons.check_circle_rounded,
        colors.inTune,
      ),
      PracticeStringStatus.muted => (Icons.block_rounded, scheme.outline),
      PracticeStringStatus.pending when focused => (
        Icons.arrow_circle_right_rounded,
        scheme.primary,
      ),
      PracticeStringStatus.pending => (
        Icons.radio_button_unchecked_rounded,
        scheme.onSurfaceVariant,
      ),
    };
    return Semantics(
      button: onTap != null,
      label:
          '${stringTitle(t, string.string)}: '
          '${practiceStringDetail(t, string)}',
      child: Material(
        color: focused ? scheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: <Widget>[
                Icon(icon, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText(
                    stringTitle(t, string.string),
                    variant: AppTextVariant.bodyLarge,
                    color: string.isMuted ? scheme.outline : null,
                  ),
                ),
                AppText(
                  practiceStringDetail(t, string),
                  color: scheme.onSurfaceVariant,
                ),
                if (onTap != null) ...<Widget>[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.volume_up_rounded,
                    size: 18,
                    color: scheme.onSurfaceVariant,
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

import 'package:chords/domain/theory/entities/scale_accents.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/l10n/theory_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Resumen de una escala en una tonalidad: nombre, carácter, fórmula de
/// grados, notas, pasos, nota característica y dónde se usa.
class ScaleSummaryCard extends StatelessWidget {
  /// Crea el resumen.
  const ScaleSummaryCard({required this.scale, required this.tonic, super.key});

  /// Escala.
  final ScaleType scale;

  /// Tónica (0 = Do).
  final int tonic;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color ink = scheme.onPrimaryContainer;
    final String notes = scale
        .pitchClasses(tonic)
        .map((int pc) => noteLabel(t, pc))
        .join(' · ');
    return AppCard(
      color: scheme.primaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            capitalized(scaleInKey(t, scale, tonic)),
            variant: AppTextVariant.titleLarge,
            color: ink,
            maxLines: 2,
          ),
          const SizedBox(height: 4),
          AppText(scaleAbout(t, scale), color: ink, maxLines: 4),
          const SizedBox(height: 10),
          _Line(
            label: t.scalesPlus.formulaTitle,
            value: scale.formula.join(' '),
            ink: ink,
          ),
          _Line(
            label: t.scalesPlus.notesCount(n: scale.length),
            value: notes,
            ink: ink,
          ),
          _Line(
            label: t.scalesPlus.intervalsLine(steps: _steps(scale)),
            ink: ink,
          ),
          if (kScaleAccents[scale] case final int interval)
            _Line(
              label: t.scalesPlus.characteristicNote(
                degree: degreeSymbol(0, interval, scale: scale),
              ),
              ink: ink,
            ),
          const SizedBox(height: 8),
          AppText(
            t.scalesPlus.stylesTitle,
            variant: AppTextVariant.labelLarge,
            color: ink,
          ),
          AppText(scaleStyles(t, scale), color: ink, maxLines: 3),
        ],
      ),
    );
  }
}

/// Pasos de la escala: `T` tono, `S` semitono, `T½` tono y medio.
String _steps(ScaleType scale) => scale.steps
    .map(
      (int step) => switch (step) {
        1 => 'S',
        2 => 'T',
        3 => 'T½',
        _ => '${step ~/ 2}T',
      },
    )
    .join(' ');

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.ink, this.value});

  final String label;
  final String? value;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    final String? text = value;
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text.rich(
        TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: text == null ? label : '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            if (text != null) TextSpan(text: text),
          ],
        ),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: ink),
      ),
    );
  }
}

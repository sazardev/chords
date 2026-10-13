import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/position_guide.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';

/// Diagrama grande de la posición con la nota de cada cuerda y la leyenda de
/// los dedos (1 índice … 4 meñique) debajo.
class ChordPositionDiagram extends StatelessWidget {
  /// Crea el diagrama de [variant]; [mirror] lo invierte para zurdos.
  const ChordPositionDiagram({
    required this.variant,
    required this.mirror,
    super.key,
  });

  /// Posición a dibujar.
  final ChordVariant variant;

  /// Si se dibuja para una persona zurda.
  final bool mirror;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Column(
      children: <Widget>[
        ChordDiagram(
          variant: variant,
          mirror: mirror,
          width: 200,
          height: 280,
          stringNames: _soundingNotes(t, variant),
        ),
        const SizedBox(height: 4),
        AppText(
          t.chordDetail.guideLegend,
          variant: AppTextVariant.labelMedium,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}

/// Nota que suena en cada cuerda (vacío si no se toca), de la 6ª a la 1ª.
List<String> _soundingNotes(Translations t, ChordVariant variant) {
  const List<int> open = <int>[40, 45, 50, 55, 59, 64];
  return <String>[
    for (int s = 0; s < variant.frets.length; s++)
      if (variant.frets[s] < 0)
        ''
      else
        noteLabel(t, open[s] + variant.frets[s]),
  ];
}

/// Tarjeta que explica cómo colocar la posición elegida.
///
/// Dice qué dedo va en cada traste y cuerda (o el cejillo), qué cuerdas se
/// tocan al aire y cuáles se silencian, para que la persona no tenga que
/// interpretar solo el diagrama.
class ChordPositionGuide extends StatelessWidget {
  /// Crea la guía de [variant].
  const ChordPositionGuide({required this.variant, super.key});

  /// Posición a explicar.
  final ChordVariant variant;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final PositionGuide guide = PositionGuide.of(variant);
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      color: scheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            t.chordDetail.guideTitle,
            variant: AppTextVariant.titleMedium,
          ),
          const SizedBox(height: 2),
          AppText(_zone(t, guide), color: scheme.onSurfaceVariant),
          const SizedBox(height: 12),
          for (final FingerStep step in guide.steps) _StepRow(step: step),
          if (guide.steps.isNotEmpty) const SizedBox(height: 4),
          _InfoRow(
            icon: Icons.play_arrow_rounded,
            text: t.chordDetail.guidePlay(strings: _range(t, guide.played)),
          ),
          if (guide.open.isNotEmpty)
            _InfoRow(
              icon: Icons.radio_button_unchecked_rounded,
              text: t.chordDetail.guideOpen(strings: _list(t, guide.open)),
            ),
          if (guide.muted.isNotEmpty)
            _InfoRow(
              icon: Icons.volume_off_rounded,
              text: t.chordDetail.guideMuted(strings: _list(t, guide.muted)),
            ),
        ],
      ),
    );
  }

  String _zone(Translations t, PositionGuide guide) {
    if (guide.isOpenPosition) {
      return t.chordDetail.guideOpenPosition;
    }
    if (guide.firstFret == guide.lastFret) {
      return t.chordDetail.guideSingleFret(fret: guide.firstFret);
    }
    return t.chordDetail.guideRange(from: guide.firstFret, to: guide.lastFret);
  }
}

/// Cuerdas separadas por comas (`5ª, 1ª`).
String _list(Translations t, List<int> strings) =>
    strings.map((int s) => guitarStringLabel(t, s)).join(', ');

/// Cuerdas como rango si son seguidas (`5ª → 1ª`), o en lista si no.
String _range(Translations t, List<int> strings) {
  final bool consecutive =
      strings.length > 2 &&
      <int>[for (int i = 0; i < strings.length; i++) strings.first - i]
              .join() ==
          strings.join();
  return consecutive
      ? '${guitarStringLabel(t, strings.first)} → '
            '${guitarStringLabel(t, strings.last)}'
      : _list(t, strings);
}

/// Un dedo: su número, su nombre y dónde va.
class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});

  final FingerStep step;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String where = step.isBarre
        ? t.chordDetail.guideBarre(
            fret: step.fret,
            from: guitarStringLabel(t, step.strings.first),
            to: guitarStringLabel(t, step.strings.last),
          )
        : t.chordDetail.guideFinger(
            fret: step.fret,
            string: guitarStringLabel(t, step.strings.first),
          );
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 14,
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            child: Text(
              '${step.finger}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  _fingerName(t, step.finger),
                  variant: AppTextVariant.labelLarge,
                ),
                AppText(
                  where,
                  color: scheme.onSurfaceVariant,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Nombre del dedo (`Índice`) a partir de su número.
String _fingerName(Translations t, int finger) =>
    t.chordDetail.fingerNames['f$finger'] ?? '$finger';

/// Línea con un icono y un texto corto.
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 18, color: scheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(child: AppText(text, overflow: TextOverflow.visible)),
        ],
      ),
    );
  }
}

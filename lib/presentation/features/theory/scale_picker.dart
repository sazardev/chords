import 'package:chords/domain/theory/catalog/scale_catalog.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/theory_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Selector de escalas por familias: primero el bloque (mayor y modos,
/// menores, pentatónicas, exóticas) y debajo sus secciones y escalas.
///
/// Con casi cuarenta escalas, una lista plana sería interminable; así solo se
/// ve a la vez el bloque que se está explorando.
class ScalePicker extends StatefulWidget {
  /// Crea el selector con la escala [selected].
  const ScalePicker({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Escala elegida.
  final ScaleType selected;

  /// Se llama al elegir otra escala.
  final ValueChanged<ScaleType> onSelected;

  @override
  State<ScalePicker> createState() => _ScalePickerState();
}

class _ScalePickerState extends State<ScalePicker> {
  late ScaleGroup _group = groupOf(widget.selected);

  @override
  void didUpdateWidget(ScalePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool shownHere = sectionsOf(_group)
        .any((ScaleSection s) => s.scales.contains(widget.selected));
    if (oldWidget.selected != widget.selected && !shownHere) {
      _group = groupOf(widget.selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (final ScaleGroup group in ScaleGroup.values) ...<Widget>[
                if (group != ScaleGroup.major) const SizedBox(width: 6),
                ChoiceChip(
                  label: Text(scaleGroupName(t, group)),
                  selected: group == _group,
                  onSelected: (_) => setState(() => _group = group),
                ),
              ],
            ],
          ),
        ),
        for (final ScaleSection section in sectionsOf(_group))
          _Section(
            section: section,
            selected: widget.selected,
            onSelected: widget.onSelected,
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.section,
    required this.selected,
    required this.onSelected,
  });

  final ScaleSection section;
  final ScaleType selected;
  final ValueChanged<ScaleType> onSelected;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            scaleSectionName(t, section.id),
            variant: AppTextVariant.labelMedium,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: <Widget>[
              for (final ScaleType scale in section.scales)
                ChoiceChip(
                  label: Text(scaleTitle(t, scale)),
                  selected: scale == selected,
                  onSelected: (_) => onSelected(scale),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

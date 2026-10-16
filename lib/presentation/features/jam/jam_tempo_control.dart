import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/jam_state.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Control de tempo preciso: ±5, ±1 y un toque en el valor para escribirlo.
class JamTempoControl extends StatelessWidget {
  /// Crea el control sobre el tempo [bpm].
  const JamTempoControl({
    required this.bpm,
    required this.onChanged,
    super.key,
  });

  /// Tempo actual.
  final int bpm;

  /// Se llama con el tempo nuevo (sin limitar: quien lo recibe lo ajusta).
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _StepButton(
          key: const ValueKey<String>('tempo-5-'),
          label: '−5',
          tooltip: t.jamBand.tempoDown5,
          onPressed: bpm > kJamMinBpm ? () => onChanged(bpm - 5) : null,
        ),
        _StepButton(
          key: const ValueKey<String>('tempo-1-'),
          label: '−1',
          tooltip: t.jamBand.tempoDown1,
          onPressed: bpm > kJamMinBpm ? () => onChanged(bpm - 1) : null,
        ),
        Flexible(
          child: Tooltip(
            message: t.jamBand.tempoEdit,
            child: TextButton(
              key: const ValueKey<String>('tempo-edit'),
              onPressed: () => _edit(context),
              child: FittedBox(
                child: AppText(
                  t.jam.bpm(n: bpm),
                  variant: AppTextVariant.titleMedium,
                ),
              ),
            ),
          ),
        ),
        _StepButton(
          key: const ValueKey<String>('tempo-1+'),
          label: '+1',
          tooltip: t.jamBand.tempoUp1,
          onPressed: bpm < kJamMaxBpm ? () => onChanged(bpm + 1) : null,
        ),
        _StepButton(
          key: const ValueKey<String>('tempo-5+'),
          label: '+5',
          tooltip: t.jamBand.tempoUp5,
          onPressed: bpm < kJamMaxBpm ? () => onChanged(bpm + 5) : null,
        ),
      ],
    );
  }

  Future<void> _edit(BuildContext context) async {
    final int? value = await showDialog<int>(
      context: context,
      builder: (BuildContext context) => _TempoDialog(bpm: bpm),
    );
    if (value != null) {
      onChanged(value);
    }
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.label,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final String label;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
    tooltip: tooltip,
    visualDensity: VisualDensity.compact,
    constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
    onPressed: onPressed,
    icon: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
  );
}

/// Diálogo para escribir el tempo.
class _TempoDialog extends StatefulWidget {
  const _TempoDialog({required this.bpm});

  final int bpm;

  @override
  State<_TempoDialog> createState() => _TempoDialogState();
}

class _TempoDialogState extends State<_TempoDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: '${widget.bpm}',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final int? value = int.tryParse(_controller.text.trim());
    Navigator.of(context).pop(value?.clamp(kJamMinBpm, kJamMaxBpm));
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return AlertDialog(
      title: Text(t.jamBand.tempoDialog),
      content: TextField(
        key: const ValueKey<String>('tempo-field'),
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          helperText: t.jamBand.tempoRange(min: kJamMinBpm, max: kJamMaxBpm),
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.jamBand.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(t.jamBand.accept)),
      ],
    );
  }
}

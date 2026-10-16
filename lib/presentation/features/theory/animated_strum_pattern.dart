import 'dart:async';

import 'package:chords/domain/theory/entities/strum_pattern.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/theory/theory_widgets.dart';
import 'package:flutter/material.dart';

/// Patrón de rasgueo con un botón que lo anima al tempo [bpm]: el hueco que
/// suena se ilumina hueco a hueco, en bucle, hasta que se detiene.
class AnimatedStrumPattern extends StatefulWidget {
  /// Crea la vista animada.
  const AnimatedStrumPattern({
    required this.pattern,
    required this.bpm,
    super.key,
  });

  /// Patrón que se anima.
  final StrumPattern pattern;

  /// Tempo en pulsos por minuto (un pulso son dos huecos).
  final int bpm;

  @override
  State<AnimatedStrumPattern> createState() => _AnimatedStrumPatternState();
}

class _AnimatedStrumPatternState extends State<AnimatedStrumPattern> {
  Timer? _timer;
  int? _slot;

  /// Duración de un hueco de corchea.
  Duration get _step =>
      Duration(milliseconds: (30000 / widget.bpm.clamp(40, 240)).round());

  void _toggle() {
    if (_timer != null) {
      _stop();
      return;
    }
    setState(() => _slot = 0);
    _timer = Timer.periodic(_step, (_) {
      setState(
        () => _slot = ((_slot ?? -1) + 1) % widget.pattern.notation.length,
      );
    });
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
    if (mounted) {
      setState(() => _slot = null);
    }
  }

  @override
  void didUpdateWidget(AnimatedStrumPattern oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pattern != widget.pattern) {
      _stop();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final bool playing = _timer != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StrumPatternView(pattern: widget.pattern, active: _slot),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            icon: Icon(
              playing ? Icons.stop_circle_rounded : Icons.play_circle_rounded,
            ),
            label: Text(playing ? t.theory.strumStop : t.theory.strumPlay),
            onPressed: _toggle,
          ),
        ),
      ],
    );
  }
}

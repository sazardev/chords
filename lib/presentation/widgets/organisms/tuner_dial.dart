import 'dart:math' as math;

import 'package:chords/domain/audio/entities/string_tuning.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/theme/app_motion.dart';
import 'package:flutter/material.dart';

/// Dial de afinación: una nota enorme dentro de un arco con aguja.
///
/// El arco va de -50 a +50 cents con marcas cada 5; las del centro son
/// verdes (afinada), las cercanas ámbar y el resto neutras. La aguja se
/// desliza suave y toma el color de su zona. Sin lectura el dial queda
/// atenuado y muestra [note] (la cuerda fijada o un guion).
class TunerDial extends StatelessWidget {
  /// Crea el dial.
  const TunerDial({
    required this.reading,
    required this.note,
    super.key,
    this.caption,
  });

  /// Lectura actual; `null` si no hay señal.
  final StringTuningReading? reading;

  /// Nota grande del centro.
  final String note;

  /// Texto pequeño bajo la nota (cuerda y frecuencia).
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final AppChordColors colors = chordColorsOf(context);
    final double cents = reading?.cents ?? 0;
    final Color tone = switch (reading?.zone) {
      TuningZone.inTune => colors.inTune,
      TuningZone.near => colors.nearTune,
      TuningZone.off || TuningZone.far => colors.outOfTune,
      null => scheme.outline,
    };
    return Semantics(
      label: t.tuner.meterLabel(cents: cents.round()),
      child: AspectRatio(
        aspectRatio: 1.45,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(end: cents),
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOutCubic,
                builder: (BuildContext context, double value, Widget? _) =>
                    CustomPaint(
                      painter: _DialPainter(
                        cents: value,
                        active: reading != null,
                        needle: tone,
                        colors: colors,
                        idle: scheme.onSurfaceVariant,
                      ),
                    ),
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.7),
              child: AnimatedScale(
                scale: reading?.isInTune ?? false ? 1.1 : 1,
                duration: kMotionSlow,
                curve: kSpringCurve,
                child: _Center(
                  note: note,
                  caption: caption,
                  tone: reading == null ? scheme.outlineVariant : tone,
                  captionColor: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Nota grande con su subtítulo.
class _Center extends StatelessWidget {
  const _Center({
    required this.note,
    required this.caption,
    required this.tone,
    required this.captionColor,
  });

  final String note;
  final String? caption;
  final Color tone;
  final Color captionColor;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 160),
          style: (text.displayLarge ?? const TextStyle()).copyWith(
            color: tone,
            fontSize: 96,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
          child: AnimatedSwitcher(
            duration: kMotionMedium,
            switchInCurve: kSpringCurve,
            transitionBuilder: (Widget child, Animation<double> animation) =>
                ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
            child: Text(note, key: ValueKey<String>(note)),
          ),
        ),
        if (caption != null)
          Text(caption!, style: text.titleSmall?.copyWith(color: captionColor)),
      ],
    );
  }
}

/// Pinta el arco de marcas y la aguja.
class _DialPainter extends CustomPainter {
  const _DialPainter({
    required this.cents,
    required this.active,
    required this.needle,
    required this.colors,
    required this.idle,
  });

  final double cents;
  final bool active;
  final Color needle;
  final AppChordColors colors;
  final Color idle;

  /// Apertura del arco a cada lado de la vertical, en grados.
  static const double _sweep = 68;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height * 0.98);
    final double radius = math.min(size.width / 2 - 10, size.height * 0.92);
    for (int c = -50; c <= 50; c += 5) {
      final bool major = c % 10 == 0;
      final double length = c == 0 ? 26 : (major ? 18 : 11);
      _tick(canvas, center, radius, length, c.toDouble(), _tickColor(c));
    }
    _needle(canvas, center, radius);
  }

  Color _tickColor(int c) {
    final double distance = c.abs().toDouble();
    if (distance <= TuningTolerance.inTune) {
      return colors.inTune;
    }
    if (distance <= TuningTolerance.near) {
      return colors.nearTune.withValues(alpha: 0.85);
    }
    return idle.withValues(alpha: 0.45);
  }

  Offset _point(Offset center, double radius, double cents) {
    final double angle = (-90 + cents / 50 * _sweep) * math.pi / 180;
    return Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
  }

  void _tick(
    Canvas canvas,
    Offset center,
    double radius,
    double length,
    double cents,
    Color color,
  ) {
    canvas.drawLine(
      _point(center, radius, cents),
      _point(center, radius - length, cents),
      Paint()
        ..color = color
        ..strokeWidth = cents == 0 ? 4 : 3
        ..strokeCap = StrokeCap.round,
    );
  }

  void _needle(Canvas canvas, Offset center, double radius) {
    final double clamped = cents.clamp(-52.0, 52.0);
    canvas.drawLine(
      _point(center, radius - 34, clamped),
      _point(center, radius + 6, clamped),
      Paint()
        ..color = needle.withValues(alpha: active ? 1 : 0.25)
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_DialPainter oldDelegate) =>
      oldDelegate.cents != cents ||
      oldDelegate.active != active ||
      oldDelegate.needle != needle ||
      oldDelegate.colors != colors ||
      oldDelegate.idle != idle;
}

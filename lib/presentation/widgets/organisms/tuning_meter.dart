import 'package:chords/domain/audio/entities/string_tuning.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Medidor horizontal de afinación: de -50 (floja) a +50 cents (alta).
///
/// La franja verde central es la zona "afinada", la ámbar el ajuste fino y
/// el resto la zona de movimiento de clavija. La aguja se desliza suave y
/// toma el color de la zona en la que está.
class TuningMeter extends StatelessWidget {
  /// Crea el medidor. Con [reading] nulo la aguja queda apagada en el centro.
  const TuningMeter({required this.reading, super.key});

  /// Lectura actual; `null` si no hay señal.
  final StringTuningReading? reading;

  static const double _range = 50;
  static const double _trackHeight = 22;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final AppChordColors colors = chordColorsOf(context);
    final double cents = reading?.cents ?? 0;
    final Color needle = switch (reading?.zone) {
      TuningZone.inTune => colors.inTune,
      TuningZone.near => colors.nearTune,
      TuningZone.off || TuningZone.far => colors.outOfTune,
      null => scheme.outline,
    };
    return Semantics(
      label: t.tuner.meterLabel(cents: cents.round()),
      child: Column(
        children: <Widget>[
          _MeterTrack(cents: cents, active: reading != null, needle: needle),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _EndLabel(
                icon: Icons.arrow_back_rounded,
                text: t.tuner.flat,
                color: scheme.onSurfaceVariant,
              ),
              AppText(
                reading == null ? '0' : t.tuner.cents(cents: _signed(cents)),
                variant: AppTextVariant.labelMedium,
                color: needle,
                weight: FontWeight.w700,
              ),
              _EndLabel(
                icon: Icons.arrow_forward_rounded,
                text: t.tuner.sharp,
                color: scheme.onSurfaceVariant,
                iconAfter: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _signed(double cents) {
    final int rounded = cents.round();
    return rounded > 0 ? '+$rounded' : '$rounded';
  }
}

/// Etiqueta de un extremo del medidor (floja / alta) con su flecha.
class _EndLabel extends StatelessWidget {
  const _EndLabel({
    required this.icon,
    required this.text,
    required this.color,
    this.iconAfter = false,
  });

  final IconData icon;
  final String text;
  final Color color;
  final bool iconAfter;

  @override
  Widget build(BuildContext context) {
    final Widget arrow = Icon(icon, size: 14, color: color);
    final Widget label = AppText(
      text,
      variant: AppTextVariant.labelMedium,
      color: color,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: iconAfter
          ? <Widget>[label, const SizedBox(width: 4), arrow]
          : <Widget>[arrow, const SizedBox(width: 4), label],
    );
  }
}

/// Pista con las franjas de zona y la aguja animada.
class _MeterTrack extends StatelessWidget {
  const _MeterTrack({
    required this.cents,
    required this.active,
    required this.needle,
  });

  final double cents;
  final bool active;
  final Color needle;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final AppChordColors colors = chordColorsOf(context);
    return SizedBox(
      height: 44,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints box) {
          final double x = (cents / TuningMeter._range).clamp(-1.0, 1.0);
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                width: box.maxWidth,
                height: TuningMeter._trackHeight,
                child: CustomPaint(
                  painter: _ZonesPainter(
                    colors: colors,
                    track: scheme.surfaceContainerHighest,
                    tick: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 140),
                curve: Curves.easeOutCubic,
                alignment: Alignment(x, 0),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 140),
                  opacity: active ? 1 : 0.25,
                  child: Container(
                    width: 10,
                    height: 44,
                    decoration: BoxDecoration(
                      color: needle,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Pinta las franjas de zona y las marcas del medidor.
class _ZonesPainter extends CustomPainter {
  const _ZonesPainter({
    required this.colors,
    required this.track,
    required this.tick,
  });

  final AppChordColors colors;
  final Color track;
  final Color tick;

  @override
  void paint(Canvas canvas, Size size) {
    final double mid = size.width / 2;
    double span(double cents) => size.width * cents / (2 * 50);
    final RRect base = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(11),
    );
    canvas
      ..drawRRect(base, Paint()..color = track)
      ..save()
      ..clipRRect(base);
    _band(canvas, size, mid, span(TuningTolerance.off), colors.outOfTune, 0.16);
    _band(canvas, size, mid, span(TuningTolerance.near), colors.nearTune, 0.3);
    _band(canvas, size, mid, span(TuningTolerance.inTune), colors.inTune, 0.45);
    canvas.restore();
    final Paint tickPaint = Paint()
      ..color = tick.withValues(alpha: 0.45)
      ..strokeWidth = 1.5;
    for (final double c in <double>[-40, -30, -20, -10, 10, 20, 30, 40]) {
      final double x = mid + span(c);
      canvas.drawLine(
        Offset(x, size.height * 0.34),
        Offset(x, size.height * 0.66),
        tickPaint,
      );
    }
  }

  void _band(
    Canvas canvas,
    Size size,
    double mid,
    double half,
    Color color,
    double alpha,
  ) {
    canvas.drawRect(
      Rect.fromLTRB(mid - half, 0, mid + half, size.height),
      Paint()..color = color.withValues(alpha: alpha),
    );
  }

  @override
  bool shouldRepaint(_ZonesPainter oldDelegate) =>
      oldDelegate.colors != colors ||
      oldDelegate.track != track ||
      oldDelegate.tick != tick;
}

import 'dart:math' as math;

import 'package:chords/domain/profile/entities/guitar_type.dart';
import 'package:flutter/material.dart';

/// Silueta dibujada de una guitarra, en vertical con el mástil hacia arriba.
///
/// Cada [GuitarType] tiene su forma: la acústica con boca y cuerpo redondo, la
/// eléctrica con cuernos y pastillas y la clásica con rosetón y cabeza
/// ranurada. Se pinta con dos colores planos (cuerpo y detalle).
class GuitarGlyph extends StatelessWidget {
  /// Crea la silueta.
  const GuitarGlyph({
    required this.type,
    required this.body,
    required this.detail,
    super.key,
    this.size = 72,
  });

  /// Tipo de guitarra a dibujar.
  final GuitarType type;

  /// Color del cuerpo y del mástil.
  final Color body;

  /// Color de los detalles (boca, pastillas, trastes).
  final Color detail;

  /// Alto de la silueta (el ancho es la mitad).
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(
      size: Size(size * 0.5, size),
      painter: _GuitarPainter(type: type, body: body, detail: detail),
    ),
  );
}

class _GuitarPainter extends CustomPainter {
  const _GuitarPainter({
    required this.type,
    required this.body,
    required this.detail,
  });

  final GuitarType type;
  final Color body;
  final Color detail;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    _neck(canvas, w, h);
    canvas.drawPath(_bodyPath(w, h), Paint()..color = body);
    switch (type) {
      case GuitarType.acoustic:
        _soundHole(canvas, w, h, 0.17, ring: false);
        _bridge(canvas, w, h * 0.84);
      case GuitarType.classical:
        _soundHole(canvas, w, h, 0.16, ring: true);
        _bridge(canvas, w, h * 0.85);
      case GuitarType.electric:
        _pickups(canvas, w, h);
    }
  }

  Path _bodyPath(double w, double h) {
    final double upper = w * (type == GuitarType.electric ? 0.30 : 0.31);
    final double lower = w * (type == GuitarType.electric ? 0.36 : 0.42);
    final Path path = Path.combine(
      PathOperation.union,
      Path()..addOval(
        Rect.fromCircle(center: Offset(w / 2, h * 0.58), radius: upper),
      ),
      Path()..addOval(
        Rect.fromCircle(center: Offset(w / 2, h * 0.78), radius: lower),
      ),
    );
    if (type != GuitarType.electric) {
      return path;
    }
    final Path withLeft = Path.combine(
      PathOperation.union,
      path,
      _horn(w, h, left: true),
    );
    return Path.combine(
      PathOperation.union,
      withLeft,
      _horn(w, h, left: false),
    );
  }

  Path _horn(double w, double h, {required bool left}) {
    final double side = left ? -1 : 1;
    return Path()
      ..moveTo(w / 2 + side * w * 0.12, h * 0.5)
      ..lineTo(w / 2 + side * w * 0.36, h * 0.44)
      ..lineTo(w / 2 + side * w * 0.3, h * 0.6)
      ..close();
  }

  void _neck(Canvas canvas, double w, double h) {
    final Paint paint = Paint()..color = body;
    canvas
      ..drawRRect(
        RRect.fromLTRBR(
          w * 0.43,
          h * 0.1,
          w * 0.57,
          h * 0.62,
          const Radius.circular(2),
        ),
        paint,
      )
      ..drawRRect(
        RRect.fromLTRBR(
          w * 0.38,
          h * 0.0,
          w * 0.62,
          h * 0.13,
          const Radius.circular(5),
        ),
        paint,
      );
    final Paint fret = Paint()
      ..color = detail.withValues(alpha: 0.55)
      ..strokeWidth = math.max(1, w * 0.018);
    for (int i = 1; i <= 5; i++) {
      final double y = h * (0.14 + i * 0.085);
      canvas.drawLine(Offset(w * 0.43, y), Offset(w * 0.57, y), fret);
    }
    if (type == GuitarType.classical) {
      final Paint slot = Paint()
        ..color = detail.withValues(alpha: 0.6)
        ..strokeWidth = w * 0.03;
      canvas
        ..drawLine(
          Offset(w * 0.42, h * 0.035),
          Offset(w * 0.58, h * 0.035),
          slot,
        )
        ..drawLine(
          Offset(w * 0.42, h * 0.08),
          Offset(w * 0.58, h * 0.08),
          slot,
        );
    }
  }

  void _soundHole(
    Canvas canvas,
    double w,
    double h,
    double radius, {
    required bool ring,
  }) {
    final Offset center = Offset(w / 2, h * 0.67);
    canvas.drawCircle(center, w * radius, Paint()..color = detail);
    if (ring) {
      canvas.drawCircle(
        center,
        w * (radius + 0.07),
        Paint()
          ..color = detail.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.03,
      );
    }
  }

  void _bridge(Canvas canvas, double w, double y) => canvas.drawRRect(
    RRect.fromLTRBR(
      w * 0.34,
      y,
      w * 0.66,
      y + w * 0.05,
      const Radius.circular(2),
    ),
    Paint()..color = detail,
  );

  void _pickups(Canvas canvas, double w, double h) {
    final Paint paint = Paint()..color = detail;
    for (final double y in <double>[0.62, 0.72]) {
      canvas.drawRRect(
        RRect.fromLTRBR(
          w * 0.3,
          h * y,
          w * 0.7,
          h * y + w * 0.07,
          const Radius.circular(2),
        ),
        paint,
      );
    }
    _bridge(canvas, w, h * 0.86);
  }

  @override
  bool shouldRepaint(_GuitarPainter oldDelegate) =>
      oldDelegate.type != type ||
      oldDelegate.body != body ||
      oldDelegate.detail != detail;
}

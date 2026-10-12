import 'package:chords/presentation/theme/app_motion.dart';
import 'package:chords/presentation/widgets/atoms/press_scale.dart';
import 'package:flutter/material.dart';

/// Tarjeta de elección con estado seleccionado expresivo.
///
/// Al elegirla cambia de color, su forma se redondea más (morfología de
/// forma) y aparece un check con efecto resorte. Sirve para opciones únicas
/// (guitarra, mano, experiencia) y múltiples (géneros).
class ChoiceCard extends StatelessWidget {
  /// Crea la tarjeta de elección.
  const ChoiceCard({
    required this.title,
    required this.selected,
    required this.onTap,
    super.key,
    this.subtitle,
    this.leading,
    this.vertical = false,
  });

  /// Título de la opción.
  final String title;

  /// Descripción opcional.
  final String? subtitle;

  /// Icono o ilustración.
  final Widget? leading;

  /// Si está elegida.
  final bool selected;

  /// Acción al pulsar.
  final VoidCallback onTap;

  /// Distribución vertical (para filas de 2-3 opciones).
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;
    final Color background = selected
        ? scheme.primaryContainer
        : scheme.surfaceContainerHigh;
    final Color ink = selected ? scheme.onPrimaryContainer : scheme.onSurface;
    final Widget label = Column(
      crossAxisAlignment: vertical
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          title,
          textAlign: vertical ? TextAlign.center : TextAlign.start,
          style: text.titleMedium?.copyWith(color: ink),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            textAlign: vertical ? TextAlign.center : TextAlign.start,
            style: text.bodyMedium?.copyWith(
              color: ink.withValues(alpha: 0.75),
            ),
          ),
      ],
    );
    final Widget content = vertical
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (leading != null) ...<Widget>[
                leading!,
                const SizedBox(height: 10),
              ],
              label,
            ],
          )
        : Row(
            children: <Widget>[
              if (leading != null) ...<Widget>[
                leading!,
                const SizedBox(width: 16),
              ],
              Expanded(child: label),
              const SizedBox(width: 28),
            ],
          );
    return Semantics(
      button: true,
      selected: selected,
      label: title,
      child: PressScale(
        child: AnimatedContainer(
          duration: kMotionMedium,
          curve: kSpringCurve,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(selected ? 32 : 22),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: <Widget>[
                    content,
                    Positioned(
                      right: 0,
                      top: 0,
                      child: AnimatedScale(
                        scale: selected ? 1 : 0,
                        duration: kMotionMedium,
                        curve: kSpringCurve,
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 22,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

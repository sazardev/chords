import 'dart:async' show unawaited;

import 'package:chords/presentation/theme/app_system_colors.dart';
import 'package:flutter/material.dart';

/// Carga una sola vez los colores del sistema y los expone a sus descendientes.
///
/// Si la plataforma no ofrece color dinámico, [systemColorsOf] devuelve `null`
/// y la aplicación usa sus propios acentos.
class SystemColorScope extends StatefulWidget {
  /// Crea el ámbito de color del sistema.
  const SystemColorScope({required this.builder, super.key});

  /// Construye la interfaz con los colores del sistema ya resueltos.
  final Widget Function(AppSystemColors? systemColors) builder;

  /// Recupera los colores del sistema más cercanos en el árbol.
  static AppSystemColors? systemColorsOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SystemColorsScope>()?.colors;

  @override
  State<SystemColorScope> createState() => _SystemColorScopeState();
}

class _SystemColorScopeState extends State<SystemColorScope> {
  AppSystemColors? _colors;
  bool _requested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_requested) {
      return;
    }
    _requested = true;
    unawaited(_load());
  }

  Future<void> _load() async {
    final AppSystemColors? colors = await loadSystemColors();
    if (!mounted || colors == null) {
      return;
    }
    setState(() => _colors = colors);
  }

  @override
  Widget build(BuildContext context) => _SystemColorsScope(
    colors: _colors,
    child: Builder(builder: (BuildContext context) => widget.builder(_colors)),
  );
}

/// Nodo de herencia que publica los colores del sistema.
class _SystemColorsScope extends InheritedWidget {
  const _SystemColorsScope({required this.colors, required super.child});

  /// Colores del sistema, o `null` si no están disponibles.
  final AppSystemColors? colors;

  @override
  bool updateShouldNotify(_SystemColorsScope oldWidget) =>
      colors != oldWidget.colors;
}

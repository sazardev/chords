import 'package:flutter/material.dart';

/// Campo de búsqueda estilizado con icono y botón de limpieza.
class SearchField extends StatelessWidget {
  /// Crea el campo de búsqueda.
  const SearchField({
    required this.onChanged,
    super.key,
    this.hintText = 'Buscar acordes',
    this.initialValue = '',
  });

  /// Se ejecuta al cambiar el texto.
  final ValueChanged<String> onChanged;

  /// Texto de ayuda.
  final String hintText;

  /// Valor inicial.
  final String initialValue;

  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onChanged,
    controller: TextEditingController(text: initialValue),
    textInputAction: TextInputAction.search,
    decoration: InputDecoration(
      hintText: hintText,
      prefixIcon: const Icon(Icons.search_rounded),
      suffixIcon: const Icon(Icons.tune_rounded),
    ),
  );
}

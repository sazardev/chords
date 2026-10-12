import 'package:flutter/material.dart';

/// Campo de búsqueda con icono y botón de limpiar cuando hay texto.
class SearchField extends StatefulWidget {
  /// Crea el campo de búsqueda.
  const SearchField({
    required this.onChanged,
    required this.hintText,
    super.key,
    this.initialValue = '',
  });

  /// Se ejecuta al cambiar el texto.
  final ValueChanged<String> onChanged;

  /// Texto de ayuda.
  final String hintText;

  /// Valor inicial.
  final String initialValue;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );

  @override
  void didUpdateWidget(SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si los filtros se limpian desde fuera, vacía también el campo.
    if (widget.initialValue != _controller.text &&
        widget.initialValue.isEmpty) {
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _controller,
    onChanged: (String value) {
      setState(() {});
      widget.onChanged(value);
    },
    textInputAction: TextInputAction.search,
    decoration: InputDecoration(
      hintText: widget.hintText,
      prefixIcon: const Icon(Icons.search_rounded),
      suffixIcon: _controller.text.isEmpty
          ? null
          : IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                _controller.clear();
                widget.onChanged('');
                setState(() {});
              },
            ),
    ),
  );
}

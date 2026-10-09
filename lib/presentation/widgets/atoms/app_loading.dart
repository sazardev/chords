import 'package:flutter/material.dart';

/// Indicador de carga centrado.
class AppLoading extends StatelessWidget {
  /// Crea el indicador.
  const AppLoading({super.key, this.message});

  /// Mensaje opcional bajo el indicador.
  final String? message;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CircularProgressIndicator(),
        if (message != null) ...<Widget>[
          const SizedBox(height: 12),
          Text(message!, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ],
    ),
  );
}

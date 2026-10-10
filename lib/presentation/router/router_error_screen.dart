import 'package:chords/config/route_paths.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pantalla mostrada cuando se navega a una ruta inexistente.
///
/// Informa al usuario de la ruta no encontrada y ofrece volver al inicio.
class RouterErrorScreen extends StatelessWidget {
  /// Crea la pantalla para la ruta no resuelta.
  const RouterErrorScreen({required this.location, super.key});

  /// Ruta que no pudo resolverse.
  final String location;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.explore_off_outlined, size: 48),
              const SizedBox(height: 16),
              Text(
                t.router.notFound,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                location,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => context.go(kHomePath),
                icon: const Icon(Icons.home_outlined),
                label: Text(t.router.goHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

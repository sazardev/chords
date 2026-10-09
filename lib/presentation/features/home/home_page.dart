import 'package:chords/presentation/router/route_paths.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pantalla de inicio con accesos a las secciones principales.
class HomePage extends StatelessWidget {
  /// Crea la pantalla de inicio.
  const HomePage({super.key});

  static const List<_Entry> _entries = <_Entry>[
    _Entry(
      icon: Icons.library_music_rounded,
      title: 'Banco de acordes',
      subtitle: '156 acordes · 581 posiciones',
      route: kChordsPath,
    ),
    _Entry(
      icon: Icons.graphic_eq_rounded,
      title: 'Afinación en vivo',
      subtitle: 'Detecta la nota con el micrófono',
      route: kLivePath,
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Chords')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const AppText(
          'Todos los acordes de guitararra',
          variant: AppTextVariant.displayLarge,
        ),
        const SizedBox(height: 8),
        AppText(
          'Todas las variantes y dificultades, con sonido y afinación en vivo.',
          variant: AppTextVariant.bodyLarge,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 20),
        for (final _Entry entry in _entries) ...<Widget>[
          AppCard(
            onTap: () => context.go(entry.route),
            child: Row(
              children: <Widget>[
                CircleAvatar(radius: 24, child: Icon(entry.icon)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppText(entry.title, variant: AppTextVariant.titleLarge),
                      AppText(
                        entry.subtitle,
                        variant: AppTextVariant.labelMedium,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    ),
  );
}

class _Entry {
  const _Entry({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
}

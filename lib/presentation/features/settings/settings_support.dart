part of 'settings_page.dart';

/// Bloque de ajustes con título y contenedor plano.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  /// Título visible del bloque.
  final String title;

  /// Contenido del bloque.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: AppText(
            title,
            variant: AppTextVariant.titleMedium,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        AppCard(
          borderRadius: 24,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ],
    ),
  );
}

/// Ajuste con título, descripción y control.
class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  /// Nombre del ajuste.
  final String title;

  /// Valor actual del ajuste.
  final String subtitle;

  /// Control interactivo del ajuste.
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppText(title, variant: AppTextVariant.titleMedium),
        AppText(
          subtitle,
          variant: AppTextVariant.labelMedium,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}

/// Separador plano entre ajustes de un mismo bloque.
class _TileSeparator extends StatelessWidget {
  const _TileSeparator();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Divider(
      height: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
    ),
  );
}

/// Opción del selector de modo de tema.
typedef _ThemeOption = ({ThemeMode mode, IconData icon, String label});

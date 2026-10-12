import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/profile/profile_pickers.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/entrance.dart';
import 'package:flutter/material.dart';

/// Perfil de la persona: edita guitarra, mano, estilo, géneros y experiencia.
///
/// Cada elección se guarda al instante y actualiza las recomendaciones.
class ProfilePage extends StatelessWidget {
  /// Crea la pantalla del perfil.
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.profile.title)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: <Widget>[
                _Section(
                  title: t.profile.guitar,
                  index: 0,
                  child: const GuitarPicker(),
                ),
                _Section(
                  title: t.profile.play,
                  index: 1,
                  child: const PlayPicker(),
                ),
                _Section(
                  title: t.profile.genres,
                  index: 2,
                  child: const GenrePicker(),
                ),
                _Section(
                  title: t.profile.experience,
                  index: 3,
                  child: const ExperiencePicker(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.index,
    required this.child,
  });

  final String title;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 28),
    child: Entrance(
      index: index,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: AppText(
              title,
              variant: AppTextVariant.titleLarge,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          child,
        ],
      ),
    ),
  );
}

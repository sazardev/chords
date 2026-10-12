import 'package:chords/domain/profile/entities/experience_level.dart';
import 'package:chords/domain/profile/entities/guitar_type.dart';
import 'package:chords/domain/profile/entities/player_profile.dart';
import 'package:chords/domain/profile/entities/playing_hand.dart';
import 'package:chords/domain/profile/entities/playing_style.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/profile/profile_controller.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
import 'package:chords/presentation/l10n/profile_labels.dart';
import 'package:chords/presentation/widgets/atoms/entrance.dart';
import 'package:chords/presentation/widgets/atoms/guitar_glyph.dart';
import 'package:chords/presentation/widgets/molecules/choice_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Elección del tipo de guitarra con una silueta de cada una.
class GuitarPicker extends StatelessWidget {
  /// Crea el selector.
  const GuitarPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final ProfileController controller = context.watch<ProfileController>();
    final PlayerProfile profile = controller.profile;
    return Column(
      children: <Widget>[
        for (final GuitarType type in GuitarType.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Entrance(
              index: type.index,
              child: ChoiceCard(
                title: guitarTypeLabel(t, type),
                subtitle: guitarTypeHint(t, type),
                selected: profile.guitar == type,
                onTap: () => controller.setGuitar(type),
                leading: SizedBox(
                  width: 52,
                  child: Center(
                    child: GuitarGlyph(
                      type: type,
                      size: 76,
                      body: profile.guitar == type
                          ? scheme.primary
                          : scheme.onSurfaceVariant,
                      detail: profile.guitar == type
                          ? scheme.primaryContainer
                          : scheme.surfaceContainerHigh,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Elección de la mano y de cómo se atacan las cuerdas.
class PlayPicker extends StatelessWidget {
  /// Crea el selector.
  const PlayPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final ProfileController controller = context.watch<ProfileController>();
    final PlayerProfile profile = controller.profile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _Label(t.onboarding.handLabel),
        Entrance(
          child: _Row(
            children: <Widget>[
              for (final PlayingHand hand in PlayingHand.values)
                ChoiceCard(
                  vertical: true,
                  title: playingHandLabel(t, hand),
                  subtitle: playingHandHint(t, hand),
                  selected: profile.hand == hand,
                  onTap: () => controller.setHand(hand),
                  leading: Transform.flip(
                    flipX: hand == PlayingHand.left,
                    child: Icon(
                      Icons.front_hand_rounded,
                      size: 34,
                      color: profile.hand == hand
                          ? scheme.primary
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _Label(t.onboarding.styleLabel),
        Entrance(
          index: 1,
          child: _Row(
            children: <Widget>[
              for (final PlayingStyle style in PlayingStyle.values)
                ChoiceCard(
                  vertical: true,
                  title: playingStyleLabel(t, style),
                  selected: profile.style == style,
                  onTap: () => controller.setStyle(style),
                  leading: Icon(
                    _styleIcon(style),
                    size: 30,
                    color: profile.style == style
                        ? scheme.primary
                        : scheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _styleIcon(PlayingStyle style) => switch (style) {
    PlayingStyle.pick => Icons.change_history_rounded,
    PlayingStyle.fingers => Icons.back_hand_rounded,
    PlayingStyle.both => Icons.all_inclusive_rounded,
  };
}

/// Elección de géneros favoritos (varios).
class GenrePicker extends StatelessWidget {
  /// Crea el selector.
  const GenrePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ProfileController controller = context.watch<ProfileController>();
    final Set<String> selected = controller.profile.genres;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: <Widget>[
        for (int i = 0; i < kProfileGenres.length; i++)
          Entrance(
            index: i,
            offset: 14,
            child: FilterChip(
              label: Text(genreLabel(t, kProfileGenres[i])),
              selected: selected.contains(kProfileGenres[i]),
              showCheckmark: false,
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              avatar: selected.contains(kProfileGenres[i])
                  ? const Icon(Icons.check_rounded, size: 18)
                  : null,
              onSelected: (_) => controller.toggleGenre(kProfileGenres[i]),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            ),
          ),
      ],
    );
  }
}

/// Elección de la experiencia con tres niveles.
class ExperiencePicker extends StatelessWidget {
  /// Crea el selector.
  const ExperiencePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final ProfileController controller = context.watch<ProfileController>();
    final ExperienceLevel current = controller.profile.experience;
    return Column(
      children: <Widget>[
        for (final ExperienceLevel level in ExperienceLevel.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Entrance(
              index: level.index,
              child: ChoiceCard(
                title: experienceLabel(t, level),
                subtitle: experienceHint(t, level),
                selected: current == level,
                onTap: () => controller.setExperience(level),
                leading: Icon(
                  _icon(level),
                  size: 32,
                  color: current == level
                      ? scheme.primary
                      : scheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
      ],
    );
  }

  IconData _icon(ExperienceLevel level) => switch (level) {
    ExperienceLevel.beginner => Icons.eco_rounded,
    ExperienceLevel.intermediate => Icons.local_fire_department_rounded,
    ExperienceLevel.advanced => Icons.bolt_rounded,
  };
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleMedium
          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
    ),
  );
}

/// Fila de tarjetas verticales con el mismo ancho.
class _Row extends StatelessWidget {
  const _Row({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int i = 0; i < children.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(width: 10),
          Expanded(child: children[i]),
        ],
      ],
    ),
  );
}

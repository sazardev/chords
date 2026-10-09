import 'dart:async' show unawaited;

import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/presentation/features/chords/chord_detail_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/widgets/atoms/app_empty_state.dart';
import 'package:chords/presentation/widgets/atoms/app_loading.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/chord_play_button.dart';
import 'package:chords/presentation/widgets/atoms/difficulty_badge.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Detalle de un acorde: todas sus posiciones y su sonido.
class ChordDetailPage extends StatefulWidget {
  /// Crea el detalle.
  const ChordDetailPage({super.key});

  @override
  State<ChordDetailPage> createState() => _ChordDetailPageState();
}

class _ChordDetailPageState extends State<ChordDetailPage> {
  bool _loadRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadRequested) {
      return;
    }
    _loadRequested = true;
    final String? id = GoRouterState.of(context).uri.queryParameters['id'];
    if (id == null || id.isEmpty) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(context.read<ChordDetailController>().load(id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ChordDetailController controller = context
        .watch<ChordDetailController>();
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController settings) => settings.mirrorChords,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.chord?.name ?? 'Acorde'),
        actions: <Widget>[
          IconButton(
            tooltip: mirror ? 'Desactivar modo zurdo' : 'Modo zurdo',
            icon: Icon(
              Icons.flip_rounded,
              color: mirror ? Theme.of(context).colorScheme.primary : null,
            ),
            onPressed: () {
              context.read<SettingsController>().mirrorChords = !mirror;
            },
          ),
        ],
      ),
      body: SafeArea(child: _resolveBody(controller, mirror)),
    );
  }

  /// Selecciona el contenido según el estado del controlador.
  Widget _resolveBody(ChordDetailController controller, bool mirror) {
    if (controller.loading) {
      return const AppLoading(message: 'Cargando acorde…');
    }
    final String? error = controller.error;
    if (error != null) {
      return AppEmptyState(
        icon: Icons.music_off_rounded,
        title: 'Acorde no disponible',
        message: error,
      );
    }
    if (controller.chord == null) {
      return const AppEmptyState(
        icon: Icons.music_off_rounded,
        title: 'Sin acorde seleccionado',
        message: 'Vuelve al listado y elige un acorde.',
      );
    }
    return _chordBody(controller, mirror);
  }

  Widget _chordBody(ChordDetailController controller, bool mirror) {
    final ThemeData theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Center(
          child: ChordDiagram(
            variant: controller.selectedVariant!,
            mirror: mirror,
            width: 200,
            height: 260,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Column(
            children: <Widget>[
              AppText(
                controller.chord!.name,
                variant: AppTextVariant.displayLarge,
              ),
              AppText(
                controller.chord!.displayName,
                variant: AppTextVariant.bodyLarge,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              DifficultyBadge(difficulty: controller.chord!.difficulty),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: controller.playSelected,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Escuchar acorde'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const AppText('Posiciones', variant: AppTextVariant.titleLarge),
        const SizedBox(height: 8),
        for (int i = 0; i < controller.chord!.variants.length; i++)
          _variantTile(controller, i, theme),
      ],
    );
  }

  Widget _variantTile(
    ChordDetailController controller,
    int index,
    ThemeData theme,
  ) {
    final ChordVariant variant = controller.chord!.variants[index];
    final bool selected = index == controller.selectedIndex;
    return ListTile(
      selected: selected,
      leading: ChordDiagram(
        variant: variant,
        showFingers: false,
        width: 44,
        height: 56,
      ),
      title: Text(variant.positionLabel),
      subtitle: Text('Notas: ${variant.notes.join(' · ')}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DifficultyBadge(difficulty: variant.difficulty, compact: true),
          const SizedBox(width: 8),
          ChordPlayButton(
            size: 36,
            tooltip: 'Escuchar ${variant.positionLabel}',
            onPressed: () {
              controller.selectVariant(index);
              unawaited(controller.playSelected());
            },
          ),
        ],
      ),
      onTap: () => controller.selectVariant(index),
      tileColor: selected ? theme.colorScheme.surfaceContainerHigh : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

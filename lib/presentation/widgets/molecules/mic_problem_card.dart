import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Aviso claro cuando el micrófono no está disponible.
///
/// Explica qué ocurre (permiso denegado o error de captura), qué hacer y
/// ofrece reintentar. Sin él, las pantallas que usan el micrófono quedarían
/// "mudas" sin dar ninguna pista.
class MicProblemCard extends StatelessWidget {
  /// Crea el aviso para el [status] indicado.
  const MicProblemCard({
    required this.status,
    required this.onRetry,
    super.key,
  });

  /// Estado del micrófono (solo se muestra si es un problema).
  final MicStatus status;

  /// Acción para reintentar.
  final VoidCallback onRetry;

  /// `true` si [status] es un problema que este aviso sabe explicar.
  static bool isProblem(MicStatus status) =>
      status == MicStatus.permissionDenied || status == MicStatus.error;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool denied = status == MicStatus.permissionDenied;
    return AppCard(
      color: scheme.errorContainer,
      child: Column(
        children: <Widget>[
          Icon(
            denied ? Icons.mic_off_rounded : Icons.error_outline_rounded,
            size: 36,
            color: scheme.onErrorContainer,
          ),
          const SizedBox(height: 8),
          AppText(
            denied ? t.mic.deniedTitle : t.mic.errorTitle,
            variant: AppTextVariant.titleMedium,
            color: scheme.onErrorContainer,
            align: TextAlign.center,
          ),
          const SizedBox(height: 4),
          AppText(
            denied ? t.mic.deniedMessage : t.mic.errorMessage,
            color: scheme.onErrorContainer,
            align: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(t.mic.retry),
          ),
        ],
      ),
    );
  }
}

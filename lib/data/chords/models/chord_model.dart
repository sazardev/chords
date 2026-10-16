import 'package:chords/data/chords/models/chord_variant_model.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';

/// Modelo de serialización de un acorde completo.
class ChordModel {
  /// Crea el modelo desde un mapa JSON.
  factory ChordModel.fromJson(Map<String, Object?> json) {
    final Object? quality = json['quality'];
    final Object? root = json['root'];
    return ChordModel._(
      id: _string(json['id']),
      variants: _variantList(json['variants']),
      rootEntity: root is String ? ChordRoot.fromName(root) : null,
      qualityEntity: quality is String ? ChordQuality.fromId(quality) : null,
    );
  }

  const ChordModel._({
    required this.id,
    required this.variants,
    required this.rootEntity,
    required this.qualityEntity,
  });

  /// Identificador del acorde.
  final String id;

  /// Posiciones del acorde.
  final List<ChordVariantModel> variants;

  /// Entidad raíz resuelta.
  final ChordRoot? rootEntity;

  /// Entidad calidad resuelta.
  final ChordQuality? qualityEntity;

  /// `true` si el modelo tiene datos suficientes para convertirse.
  bool get isComplete =>
      rootEntity != null && qualityEntity != null && variants.isNotEmpty;

  /// Convierte el modelo a entidad de dominio.
  ///
  /// [shapeLabels] son los nombres de las formas del catálogo (`e-shape` →
  /// `Forma de Mi`) que guarda el banco.
  Chord? toEntity({
    Map<String, String> shapeLabels = const <String, String>{},
  }) {
    if (!isComplete) {
      return null;
    }
    final ChordRoot root = rootEntity!;
    final ChordQuality quality = qualityEntity!;
    final List<ChordVariant> positions = <ChordVariant>[
      for (final ChordVariantModel v in variants)
        v.toEntity(
          chordId: id,
          root: root,
          quality: quality,
          shapeLabels: shapeLabels,
        ),
    ];
    return Chord(
      id: id,
      root: root,
      quality: quality,
      variants: positions,
      aliases: <String>[
        '${root.name}${quality.suffix}',
        _display(root, quality),
      ],
      tags: <String>{for (final ChordVariant v in positions) ...v.tags}
          .toList(),
    );
  }

  static String _display(ChordRoot root, ChordQuality quality) =>
      '${root.displayName} ${quality.label}';

  static String _string(Object? value) => value is String ? value : '';

  static List<ChordVariantModel> _variantList(Object? value) {
    if (value is! List<Object?>) {
      return const <ChordVariantModel>[];
    }
    return <ChordVariantModel>[
      for (final Object? item in value)
        if (item is Map<String, Object?>) ChordVariantModel.fromJson(item),
    ];
  }
}

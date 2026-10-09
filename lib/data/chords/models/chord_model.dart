import 'package:chords/data/chords/models/chord_variant_model.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';

/// Modelo de serialización de un acorde completo.
class ChordModel {
  /// Crea el modelo desde un mapa JSON.
  factory ChordModel.fromJson(Map<String, Object?> json) {
    final Object? quality = json['quality'];
    final Object? root = json['root'];
    final ChordRoot? rootEntity = root is String
        ? ChordRoot.fromName(root)
        : null;
    final ChordQuality? qualityEntity = quality is String
        ? ChordQuality.fromId(quality)
        : null;
    return ChordModel._(
      id: _string(json['id']),
      rootName: _string(json['root']),
      qualityId: _string(json['quality']),
      name: _string(json['name']),
      aliases: _stringList(json['aliases']),
      tags: _stringList(json['tags']),
      variants: _variantList(json['variants']),
      rootEntity: rootEntity,
      qualityEntity: qualityEntity,
    );
  }

  const ChordModel._({
    required this.id,
    required this.rootName,
    required this.qualityId,
    required this.name,
    required this.aliases,
    required this.tags,
    required this.variants,
    required this.rootEntity,
    required this.qualityEntity,
  });

  /// Identificador del acorde.
  final String id;

  /// Nombre de la raíz.
  final String rootName;

  /// Identificador de la calidad.
  final String qualityId;

  /// Nombre estándar del acorde.
  final String name;

  /// Alias buscables.
  final List<String> aliases;

  /// Etiquetas del acorde.
  final List<String> tags;

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
  Chord? toEntity() {
    if (!isComplete) {
      return null;
    }
    return Chord(
      id: id,
      root: rootEntity!,
      quality: qualityEntity!,
      variants: variants.map((ChordVariantModel v) => v.toEntity()).toList(),
      aliases: aliases,
      tags: tags,
    );
  }

  static String _string(Object? value) => value is String ? value : '';

  static List<String> _stringList(Object? value) => value is List<Object?>
      ? value.whereType<String>().toList()
      : const <String>[];

  static List<ChordVariantModel> _variantList(Object? value) {
    if (value is! List<Object?>) {
      return const <ChordVariantModel>[];
    }
    final List<ChordVariantModel> models = <ChordVariantModel>[];
    for (final Object? item in value) {
      if (item is Map<String, Object?>) {
        models.add(ChordVariantModel.fromJson(item));
      }
    }
    return models;
  }
}

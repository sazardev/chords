import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/drum_voice.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/domain/band/entities/sound_shapes.dart';
import 'package:meta/meta.dart';

/// Descripción de un sonido que la banda sabe tocar.
///
/// Es la "receta" que viaja de la partitura (dominio) al sintetizador (datos)
/// y su [key] identifica la muestra en la caché: dos golpes iguales comparten
/// muestra.
@immutable
class BandSound implements Comparable<BandSound> {
  const BandSound._({
    required this.family,
    required this.channel,
    required this.kind,
    required this.shape,
    this.notes = const <int>[],
    this.hard = true,
  });

  /// Golpe de batería o percusión; [hard] elige la capa fuerte.
  factory BandSound.drum(DrumVoice voice, DrumKit kit, {required bool hard}) =>
      BandSound._(
        family: SoundFamily.drum,
        channel: voice.channel,
        kind: kit,
        shape: voice,
        hard: hard,
      );

  /// Nota de bajo en la nota MIDI [midi].
  factory BandSound.bass(BassKind kind, int midi, NoteLength length) =>
      BandSound._(
        family: SoundFamily.bass,
        channel: BandChannel.bass,
        kind: kind,
        shape: length,
        notes: <int>[midi],
      );

  /// Golpe de guitarra sobre las notas MIDI [voicing] (de grave a aguda).
  factory BandSound.guitar(
    GuitarKind kind,
    GuitarStroke stroke,
    List<int> voicing,
  ) => BandSound._(
    family: SoundFamily.guitar,
    channel: BandChannel.guitar,
    kind: kind,
    shape: stroke,
    notes: List<int>.unmodifiable(voicing),
  );

  /// Acorde de teclado sobre las notas MIDI [notes].
  factory BandSound.keys(KeysKind kind, NoteLength length, List<int> notes) =>
      BandSound._(
        family: SoundFamily.keys,
        channel: BandChannel.keys,
        kind: kind,
        shape: length,
        notes: List<int>.unmodifiable(notes),
      );

  /// Acorde de vientos sobre las notas MIDI [notes].
  factory BandSound.wind(WindKind kind, NoteLength length, List<int> notes) =>
      BandSound._(
        family: SoundFamily.wind,
        channel: BandChannel.winds,
        kind: kind,
        shape: length,
        notes: List<int>.unmodifiable(notes),
      );

  /// Clic del metrónomo.
  factory BandSound.click(ClickAccent accent) => BandSound._(
    family: SoundFamily.click,
    channel: BandChannel.click,
    kind: accent,
    shape: accent,
  );

  /// Familia (sintetizador que lo genera).
  final SoundFamily family;

  /// Canal del mezclador al que pertenece.
  final BandChannel channel;

  /// Variante de timbre (kit, tipo de bajo, guitarra…).
  final Enum kind;

  /// Forma del golpe (voz de batería, rasgueo o duración).
  final Enum shape;

  /// Notas MIDI que suenan, de grave a aguda (vacío en la batería).
  final List<int> notes;

  /// Capa fuerte (`true`) o suave (`false`) de la batería.
  final bool hard;

  /// Grupo de choke: un golpe nuevo corta el anterior del mismo grupo.
  ///
  /// `null` si el sonido se deja morir (platos, tambores).
  String? get chokeGroup => switch (family) {
    SoundFamily.bass => 'bass',
    SoundFamily.guitar => 'guitar',
    SoundFamily.keys => 'keys',
    SoundFamily.wind => 'winds',
    SoundFamily.drum => _drumChoke,
    SoundFamily.click => null,
  };

  String? get _drumChoke => switch (shape) {
    DrumVoice.hatClosed || DrumVoice.hatOpen || DrumVoice.hatPedal => 'hat',
    _ => null,
  };

  /// Identificador estable para la caché de muestras.
  String get key =>
      '${family.name}:${kind.name}:${shape.name}:'
      '${hard ? 'h' : 's'}:${notes.join('.')}';

  @override
  bool operator ==(Object other) => other is BandSound && other.key == key;

  @override
  int get hashCode => key.hashCode;

  @override
  int compareTo(BandSound other) => key.compareTo(other.key);

  @override
  String toString() => key;
}

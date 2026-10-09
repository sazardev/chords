import 'dart:async';

import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/arpeggio_pattern.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';

/// Repositorio de audio en memoria para pruebas.
class FakeAudioRepository implements AudioRepository {
  final StreamController<PitchReading> _readings =
      StreamController<PitchReading>.broadcast();
  final StreamController<MicStatus> _status =
      StreamController<MicStatus>.broadcast();

  /// Identificadores de acordes reproducidos.
  final List<String> played = <String>[];

  /// Identificadores de arpegios reproducidos.
  final List<String> arpeggios = <String>[];

  @override
  Stream<PitchReading> get readings => _readings.stream;

  @override
  Stream<MicStatus> get statusStream => _status.stream;

  /// Emite una lectura de tono con nota y claridad.
  void emitReading(String note, {double clarity = 0.9, double cents = 0}) {
    _readings.add(
      PitchReading(frequency: 440, note: note, cents: cents, clarity: clarity),
    );
  }

  @override
  Future<MicStatus> requestAccess() async => MicStatus.listening;

  @override
  Future<void> startListening() async => _status.add(MicStatus.listening);

  @override
  Future<void> stopListening() async => _status.add(MicStatus.idle);

  @override
  Future<void> playChord(Chord chord, ChordVariant variant) async {
    played.add(chord.id);
  }

  @override
  Future<void> playArpeggio(
    Chord chord,
    ChordVariant variant,
    ArpeggioPattern pattern,
  ) async {
    arpeggios.add('${chord.id}:${pattern.id}');
  }

  @override
  Future<void> dispose() async {
    await _readings.close();
    await _status.close();
  }
}

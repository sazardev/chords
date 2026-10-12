import 'dart:convert';
import 'dart:io';

import 'package:chords/data/chords/models/chord_model.dart';
import 'package:chords/domain/chords/entities/chord.dart';

import 'fake_chord_repository.dart';

/// Repositorio en memoria con el banco real de acordes (el asset JSON).
FakeChordRepository loadChordBank() {
  final Map<String, Object?> json = jsonDecode(
    File('assets/chords/chords_db.json').readAsStringSync(),
  ) as Map<String, Object?>;
  final List<Chord> chords = <Chord>[
    for (final Object? item in json['chords']! as List<Object?>)
      ChordModel.fromJson(item! as Map<String, Object?>).toEntity()!,
  ];
  return FakeChordRepository(chords);
}

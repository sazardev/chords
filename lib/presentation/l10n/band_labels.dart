/// Etiquetas e iconos traducidos de la banda del jam.
///
/// Convierten canales, estilos e instrumentos del dominio en textos del
/// idioma activo.
library;

import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_mode.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:flutter/material.dart';

/// Nombre de un canal del mezclador (`Batería`).
String bandChannelName(Translations t, BandChannel channel) =>
    t.jamBand.channels[channel.name] ?? channel.name;

/// Icono de un canal del mezclador.
IconData bandChannelIcon(BandChannel channel) => switch (channel) {
  BandChannel.drums => Icons.album_rounded,
  BandChannel.percussion => Icons.vibration_rounded,
  BandChannel.bass => Icons.graphic_eq_rounded,
  BandChannel.guitar => Icons.music_note_rounded,
  BandChannel.keys => Icons.piano_rounded,
  BandChannel.winds => Icons.air_rounded,
  BandChannel.click => Icons.timer_rounded,
};

/// Nombre de un atajo de mezcla (`Solo ritmo`).
String bandModeName(Translations t, BandMode mode) =>
    t.jamBand.modes[mode.name] ?? mode.name;

/// Nombre de un estilo de banda (`Salsa`); el id si no se conoce.
String bandStyleName(Translations t, String id) => t.jamBand.styles[id] ?? id;

/// Nombre de un kit de batería.
String drumKitName(Translations t, DrumKit kit) =>
    t.jamBand.kits[kit.name] ?? kit.name;

/// Nombre de un tipo de bajo.
String bassKindName(Translations t, BassKind kind) =>
    t.jamBand.basses[kind.name] ?? kind.name;

/// Nombre de un tipo de guitarra.
String guitarKindName(Translations t, GuitarKind kind) =>
    t.jamBand.guitars[kind.name] ?? kind.name;

/// Nombre de un tipo de teclado.
String keysKindName(Translations t, KeysKind kind) =>
    t.jamBand.keysKinds[kind.name] ?? kind.name;

/// Nombre de un tipo de viento.
String windKindName(Translations t, WindKind kind) =>
    t.jamBand.winds[kind.name] ?? kind.name;

/// Nombre de una intensidad.
String bandIntensityName(Translations t, BandIntensity intensity) =>
    t.jamBand.intensities[intensity.name] ?? intensity.name;

/// Texto de los compases de cuenta atrás (0, 1 o 2).
String countInName(Translations t, int bars) =>
    t.jamBand.countInOptions[const <String>['none', 'one', 'two'][bars]] ??
    '$bars';

/// Semitonos con signo (`+2`, `-3`, `0`).
String signedSemitones(int semitones) =>
    semitones > 0 ? '+$semitones' : '$semitones';

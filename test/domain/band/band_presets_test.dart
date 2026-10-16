import 'package:chords/domain/band/entities/drum_voice.dart';
import 'package:chords/domain/band/patterns/band_preset.dart';
import 'package:chords/domain/band/patterns/bass_pattern.dart';
import 'package:chords/domain/band/patterns/chord_pattern.dart';
import 'package:chords/domain/band/patterns/drum_pattern.dart';
import 'package:chords/domain/band/presets/band_preset_catalog.dart';
import 'package:chords/domain/band/presets/drum_fills.dart';
import 'package:chords/domain/band/presets/waltz_defaults.dart';
import 'package:chords/domain/theory/catalog/genre_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

/// Los presets de banda: rejillas bien formadas y géneros distintos.
void main() {
  const List<String> expected = <String>[
    'pop', 'rock', 'blues', 'country', 'jazz', 'funk', 'ballad', 'latin', //
    'reggae', 'bossa', 'metal', 'punk', 'soul', 'gospel', 'folk', //
    'cumbia', 'salsa', 'ranchera', 'flamenco', 'disco', 'ska', 'indie',
    'grunge', 'reggaeton', 'lofi', 'tango', 'bolero',
  ];

  void expectGrid(DrumPattern pattern, int steps, String where) {
    for (final MapEntry<DrumVoice, String> lane in pattern.lanes.entries) {
      expect(lane.value.length, steps, reason: '$where ${lane.key.name}');
      for (final String char in lane.value.split('')) {
        expect(
          char == '-' || kDrumLevels.containsKey(char),
          isTrue,
          reason: '$where ${lane.key.name}: "$char"',
        );
      }
    }
  }

  void expectTokens(String notation, String alphabet, int steps, String at) {
    expect(notation.length, steps, reason: at);
    for (final String char in notation.split('')) {
      expect(alphabet.contains(char), isTrue, reason: '$at: "$char"');
    }
  }

  test('hay un preset por cada género, también los nuevos', () {
    for (final String id in expected) {
      expect(kBandPresets[id], isNotNull, reason: id);
      expect(kBandPresets[id]!.id, id);
    }
    for (final GenreGuide guide in kGenreGuides) {
      expect(kBandPresets.containsKey(guide.id), isTrue, reason: guide.id);
    }
  });

  test('un género desconocido usa el preset de respaldo; los alias valen', () {
    expect(bandPresetFor('techno'), same(kDefaultBandPreset));
    expect(bandPresetFor(null), same(kDefaultBandPreset));
    expect(bandPresetFor('balada').id, 'ballad');
    expect(bandPresetFor('latino').id, 'latin');
  });

  group('rejillas de 16 pasos en 4/4', () {
    for (final BandPreset preset in kBandPresets.values) {
      test(preset.id, () {
        final String id = preset.id;
        expectGrid(preset.drums.a, 16, '$id A');
        expectGrid(preset.drums.b, 16, '$id B');
        expectGrid(preset.drums.fill, 16, '$id fill');
        expectTokens(preset.bass.notation, kBassTokens, 16, '$id bajo');
        if (preset.bassB != null) {
          expectTokens(preset.bassB!.notation, kBassTokens, 16, '$id bajo B');
        }
        expectTokens(preset.guitar.notation, kGuitarTokens, 16, '$id guitarra');
        for (final ChordPattern? part in <ChordPattern?>[
          preset.keys,
          preset.winds,
        ]) {
          if (part != null) {
            expectTokens(part.notation, kChordTokens, 16, '$id teclas');
          }
        }
        expect(preset.fillEvery, anyOf(4, 8));
        expect(preset.swing, inInclusiveRange(0, 1));
        expect(preset.drums.a.hitsAt(0), isNotEmpty);
      });
    }
  });

  test('los patrones de 3/4 miden 12 pasos', () {
    for (final DrumPattern pattern in kWaltzGroove.all) {
      expectGrid(pattern, 12, 'vals');
    }
    expectTokens(kWaltzBass.notation, kBassTokens, 12, 'bajo de vals');
    expectTokens(kWaltzKeys.notation, kChordTokens, 12, 'teclado de vals');
    expectTokens(kWaltzWinds.notation, kChordTokens, 12, 'vientos de vals');
    for (final BandPreset preset in kBandPresets.values) {
      expect(preset.drumsFor(3).a.steps, anyOf(12, 12));
      expect(preset.bassFor(3, lift: true).steps, 12);
      expect(preset.keysFor(3)?.steps ?? 12, 12);
    }
  });

  test('los rellenos compartidos tienen 16 pasos', () {
    for (final DrumPattern fill in <DrumPattern>[
      kFillRock,
      kFillSoft,
      kFillJazz,
      kFillFunk,
      kFillLatin,
      kFillMetal,
      kFillPunk,
      kFillShuffle,
      kFillReggae,
      kFillElectronic,
      kFillFlamenco,
    ]) {
      expectGrid(fill, 16, 'relleno');
    }
  });

  test('los géneros suenan distinto: no hay dos baterías iguales', () {
    final Set<String> seen = <String>{};
    for (final BandPreset preset in kBandPresets.values) {
      final String signature = preset.drums.a.lanes.entries
          .map((MapEntry<DrumVoice, String> e) => '${e.key.name}${e.value}')
          .join('|');
      expect(seen.add(signature), isTrue, reason: preset.id);
    }
    final Set<String> voices = <String>{
      for (final BandPreset preset in kBandPresets.values)
        for (final DrumPattern pattern in preset.drums.all)
          ...pattern.voices.map((DrumVoice v) => v.name),
    };
    expect(voices.length, greaterThanOrEqualTo(20));
  });

  test('cada género define su propio carácter instrumental', () {
    expect(kBandPresets['metal']!.guitarKind.name, 'distorted');
    expect(kBandPresets['jazz']!.bass.walking, isTrue);
    expect(kBandPresets['blues']!.bassB!.walking, isTrue);
    expect(kBandPresets['salsa']!.drums.a.voices, contains(DrumVoice.claves));
    expect(
      kBandPresets['reggaeton']!.drums.a.lanes[DrumVoice.kick],
      'X---X---X---X---',
    );
    expect(kBandPresets['cumbia']!.winds, isNotNull);
    expect(kBandPresets['flamenco']!.drums.a.voices, contains(DrumVoice.palma));
    expect(
      kBandPresets['reggae']!.drums.a.lanes[DrumVoice.kick],
      hasLength(16),
    );
  });
}

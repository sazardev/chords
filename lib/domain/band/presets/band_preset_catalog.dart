import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/patterns/band_preset.dart';
import 'package:chords/domain/band/presets/presets_groove.dart';
import 'package:chords/domain/band/presets/presets_latin.dart';
import 'package:chords/domain/band/presets/presets_rock.dart';
import 'package:chords/domain/band/presets/presets_roots.dart';
import 'package:chords/domain/jam/jam_track.dart';

/// Todos los presets, por identificador de género.
///
/// Incluye los 15 géneros del catálogo actual y los que se añaden en otras
/// ramas (cumbia, salsa, ranchera, flamenco, disco, ska, indie, grunge,
/// reggaetón, lofi, tango y bolero).
const Map<String, BandPreset> kBandPresets = <String, BandPreset>{
  'pop': kPopPreset,
  'rock': kRockPreset,
  'blues': kBluesPreset,
  'country': kCountryPreset,
  'jazz': kJazzPreset,
  'funk': kFunkPreset,
  'ballad': kBalladPreset,
  'latin': kLatinPreset,
  'reggae': kReggaePreset,
  'bossa': kBossaPreset,
  'metal': kMetalPreset,
  'punk': kPunkPreset,
  'soul': kSoulPreset,
  'gospel': kGospelPreset,
  'folk': kFolkPreset,
  'cumbia': kCumbiaPreset,
  'salsa': kSalsaPreset,
  'ranchera': kRancheraPreset,
  'flamenco': kFlamencoPreset,
  'disco': kDiscoPreset,
  'ska': kSkaPreset,
  'indie': kIndiePreset,
  'grunge': kGrungePreset,
  'reggaeton': kReggaetonPreset,
  'lofi': kLofiPreset,
  'tango': kTangoPreset,
  'bolero': kBoleroPreset,
};

/// Nombres alternativos de los géneros (en español) que apuntan a su id.
const Map<String, String> kBandStyleAliases = <String, String>{
  'balada': 'ballad',
  'latino': 'latin',
  'reggaetón': 'reggaeton',
};

/// Preset de respaldo para géneros desconocidos: el de pop.
const BandPreset kDefaultBandPreset = kPopPreset;

/// Preset del género [id]; el de pop si no se conoce.
BandPreset bandPresetFor(String? id) =>
    kBandPresets[kBandStyleAliases[id] ?? id] ?? kDefaultBandPreset;

/// Género que sugiere un rasgueo cuando la pista no trae el suyo (progresión
/// propia).
const Map<String, String> kStyleByStrum = <String, String>{
  'D-DU-UDU': 'pop',
  'DUDUDUDU': 'rock',
  'D-UD-UD-': 'blues',
  'B-D-B-D-': 'country',
  '--D---D-': 'reggae',
  'B-DB-DB-': 'bossa',
  'D-------': 'ballad',
  'B-D-D-': 'folk',
  'D-D-D-D-': 'pop',
};

/// Género de la banda para [track]: el elegido en [config], el de la pista o
/// el que sugiere su rasgueo.
String bandStyleOf(JamTrack track, BandConfig config) =>
    config.style ?? track.genre ?? kStyleByStrum[track.strum.notation] ?? 'pop';

import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_quality_basic_info.dart';
import 'package:chords/domain/chords/entities/chord_quality_extended_info.dart';
import 'package:chords/domain/chords/entities/chord_quality_info.dart';

/// Metadatos de todas las calidades (básicas y extendidas) por calidad.
const Map<ChordQuality, ChordQualityInfo> kChordQualityTable =
    <ChordQuality, ChordQualityInfo>{
      ...kBasicQualityInfo,
      ...kExtendedQualityInfo,
    };

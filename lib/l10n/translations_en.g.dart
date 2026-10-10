///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';

import 'translations.g.dart';

// Path: <root>
class TranslationsEn extends Translations
    with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsEn({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(
         overrides == null,
         'Set "translation_overrides: true" in order to enable this feature.',
       ),
       _meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.en,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ),
       super(
         cardinalResolver: cardinalResolver,
         ordinalResolver: ordinalResolver,
       ) {
    _meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <en>.
  final TranslationMetadata<AppLocale, Translations> _meta;
  @override
  TranslationMetadata<AppLocale, Translations> get $meta => _meta;

  /// Access flat map
  @override
  dynamic operator [](String key) => _meta.getTranslation(key) ?? super[key];

  late final TranslationsEn _root = this; // ignore: unused_field

  @override
  TranslationsEn $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => TranslationsEn(meta: meta ?? this.$meta);

  // Translations
  @override
  late final Translations$app$en app = Translations$app$en._(_root);
  @override
  late final Translations$nav$en nav = Translations$nav$en._(_root);
  @override
  late final Translations$home$en home = Translations$home$en._(_root);
  @override
  late final Translations$chords$en chords = Translations$chords$en._(_root);
  @override
  late final Translations$chordDetail$en chordDetail =
      Translations$chordDetail$en._(_root);
  @override
  late final Translations$game$en game = Translations$game$en._(_root);
  @override
  late final Translations$chordDiagram$en chordDiagram =
      Translations$chordDiagram$en._(_root);
  @override
  late final Translations$live$en live = Translations$live$en._(_root);
  @override
  late final Translations$learn$en learn = Translations$learn$en._(_root);
  @override
  late final Translations$settings$en settings = Translations$settings$en._(
    _root,
  );
  @override
  late final Translations$onboarding$en onboarding =
      Translations$onboarding$en._(_root);
  @override
  late final Translations$data$en data = Translations$data$en._(_root);
  @override
  late final Translations$logs$en logs = Translations$logs$en._(_root);
  @override
  late final Translations$router$en router = Translations$router$en._(_root);
}

// Path: app
class Translations$app$en extends Translations$app$es {
  Translations$app$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Chords';
  @override
  String get chordFallback => 'Chord';
  @override
  String get skip => 'Skip';
  @override
  String get next => 'Next';
  @override
  String get start => 'Start';
}

// Path: nav
class Translations$nav$en extends Translations$nav$es {
  Translations$nav$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get home => 'Home';
  @override
  String get learn => 'Learn';
  @override
  String get chords => 'Chords';
  @override
  String get game => 'Play';
  @override
  String get live => 'Live';
  @override
  String get settings => 'Settings';
}

// Path: home
class Translations$home$en extends Translations$home$es {
  Translations$home$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get greeting => 'Hello, guitarist';
  @override
  String get question => 'What are you playing today?';
  @override
  String get progressTitle => 'Itinerary progress';
  @override
  String masteredCount({required num n}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
        n,
        one: '${n} chord mastered',
        other: '${n} chords mastered',
      );
  @override
  String get continueLearning => 'Keep learning';
  @override
  String get itineraryComplete => 'Itinerary complete!';
  @override
  String nextChord({required Object name}) => 'Next: ${name}';
  @override
  String get library => 'Chord library';
  @override
  String librarySubtitle({required Object count}) =>
      '${count} chords by genre and level';
  @override
  String get gameMode => 'Game mode';
  @override
  String get gameSubtitle => 'Play the chord and build a streak';
  @override
  String get liveTitle => 'Live tuning';
  @override
  String get liveSubtitle => 'Detect the note with your microphone';
}

// Path: chords
class Translations$chords$en extends Translations$chords$es {
  Translations$chords$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Chords';
  @override
  String get clearFilters => 'Clear filters';
  @override
  String get searchHint => 'Search chords';
  @override
  String get filterAll => 'All';
  @override
  String get filterAllQualities => 'All';
  @override
  String positionCount({required num n}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
        n,
        one: '${n} position',
        other: '${n} positions',
      );
  @override
  String levelShort({required Object level}) => 'Lv ${level}';
  @override
  String maxDifficulty({required Object level}) => 'Max difficulty: ${level}';
  @override
  String get loading => 'Loading chords…';
  @override
  String get loadErrorTitle => 'Could not load the chord bank';
  @override
  String get loadErrorMessage =>
      'Restart the app to try loading the bank again.';
  @override
  String get emptyTitle => 'No results';
  @override
  String get emptyMessage =>
      'Adjust the search or the filters to see more chords.';
}

// Path: chordDetail
class Translations$chordDetail$en extends Translations$chordDetail$es {
  Translations$chordDetail$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get titleFallback => 'Chord';
  @override
  String get markMastered => 'Mark as mastered';
  @override
  String get unmarkMastered => 'Remove from mastered';
  @override
  String get leftHandMode => 'Left-handed mode';
  @override
  String get leftHandModeOff => 'Disable left-handed mode';
  @override
  String get loading => 'Loading chord…';
  @override
  String get errorTitle => 'Chord unavailable';
  @override
  String notFoundMessage({required Object chordId}) =>
      'Chord ${chordId} not found';
  @override
  String get loadFailed => 'The chord bank could not be read.';
  @override
  String get noChordTitle => 'No chord selected';
  @override
  String get noChordMessage => 'Go back to the list and pick a chord.';
  @override
  String get listen => 'Listen to chord';
  @override
  String listenPosition({required Object position}) => 'Listen to ${position}';
  @override
  String get arpeggios => 'Arpeggios';
  @override
  String get positions => 'Positions';
  @override
  String notes({required Object notes}) => 'Notes: ${notes}';
  @override
  String arpeggioChip({required Object label, required Object level}) =>
      '${label} · Lv ${level}';
}

// Path: game
class Translations$game$en extends Translations$game$es {
  Translations$game$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Play';
  @override
  String get start => 'Start streak';
  @override
  String get emptyTitle => 'Play the chord';
  @override
  String emptyMessage({required Object best}) =>
      'Chain a series of chords with the microphone. Best: ${best} points.';
  @override
  String round({required Object number}) => 'Round ${number}';
  @override
  String get playThisChord => 'Play this chord';
  @override
  String get loadingChord => 'Loading chord…';
  @override
  String get listening => 'Listening to your guitar…';
  @override
  String get correctNext => 'Correct! Next';
  @override
  String get retry => 'Try again';
  @override
  String get ready => 'I\'m ready';
  @override
  String get streak => 'Streak';
  @override
  String get score => 'Score';
}

// Path: chordDiagram
class Translations$chordDiagram$en extends Translations$chordDiagram$es {
  Translations$chordDiagram$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String stringLabel({required Object number, required Object fret}) =>
      'string ${number}: ${fret}';
  @override
  String get muted => 'muted';
  @override
  String get open => 'open';
  @override
  String fret({required Object value}) => 'fret ${value}';
  @override
  String description({required Object position, required Object details}) =>
      'Diagram of ${position}, ${details}';
}

// Path: live
class Translations$live$en extends Translations$live$es {
  Translations$live$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Live';
  @override
  String get listen => 'Listen to guitar';
  @override
  String get stop => 'Stop';
  @override
  String get emptyTitle => 'No suggestions yet';
  @override
  String get emptyMessage => 'Press listen and play a chord to see matches.';
  @override
  String get suggestions => 'Suggestions';
  @override
  String get idleTitle => 'Microphone idle';
  @override
  String get idleMessage => 'Play a note on the guitar';
  @override
  String get listening => 'Listening…';
  @override
  String get deniedTitle => 'Permission denied';
  @override
  String get errorTitle => 'Capture error';
}

// Path: learn
class Translations$learn$en extends Translations$learn$es {
  Translations$learn$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Learn';
  @override
  String get loading => 'Preparing levels…';
  @override
  String get errorTitle => 'Could not load the itinerary';
  @override
  String get errorMessage => 'Restart the app to try again.';
  @override
  String get yourProgress => 'Your progress';
  @override
  String masteredCount({required num n}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
        n,
        one: '${n} chord mastered',
        other: '${n} chords mastered',
      );
  @override
  String get stepByStep => 'Step by step';
  @override
  String get stepFingers => 'Place your fingers one by one on the fretboard';
  @override
  String get stepStrum => 'Slow strum: listen to every string';
  @override
  String get stepChange => 'Move to the next chord without stopping the rhythm';
  @override
  String get guidedArpeggios => 'Guided arpeggios';
  @override
  String levelSection({
    required Object emoji,
    required Object level,
    required Object title,
  }) => '${emoji}  Level ${level}: ${title}';
  @override
  String arpeggioHint({required Object label}) =>
      'Open the chord and play its ${label} arpeggio';
}

// Path: settings
class Translations$settings$en extends Translations$settings$es {
  Translations$settings$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Settings';
  @override
  String get appearance => 'Appearance';
  @override
  late final Translations$settings$theme$en theme =
      Translations$settings$theme$en._(_root);
  @override
  late final Translations$settings$color$en color =
      Translations$settings$color$en._(_root);
  @override
  late final Translations$settings$text$en text =
      Translations$settings$text$en._(_root);
  @override
  late final Translations$settings$language$en language =
      Translations$settings$language$en._(_root);
  @override
  late final Translations$settings$accent$en accent =
      Translations$settings$accent$en._(_root);
  @override
  late final Translations$settings$fontScale$en fontScale =
      Translations$settings$fontScale$en._(_root);
  @override
  String get guitar => 'Guitar';
  @override
  String get leftHandMode => 'Left-handed mode';
  @override
  String get leftHandModeSubtitle => 'Mirrors the chord diagrams';
  @override
  String get sound => 'Sound';
  @override
  String get chordSound => 'Chord sound';
  @override
  String get chordSoundSubtitle => 'Synthesizes strums and arpeggios';
  @override
  String get learning => 'Learning';
  @override
  String get resetOnboarding => 'Reset onboarding';
  @override
  String get resetOnboardingSubtitle => 'Show the introduction again';
  @override
  String get onboardingReset => 'Onboarding reset';
  @override
  String get version => 'Version';
  @override
  String get cli => 'Development CLI';
  @override
  String get cliCommand => 'dart run bin/chords_cli.dart db generate';
}

// Path: onboarding
class Translations$onboarding$en extends Translations$onboarding$es {
  Translations$onboarding$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get slideOneTitle => 'Every chord, every position';
  @override
  String get slideOneBody =>
      '156 chords and 581 verified positions, from the essential open shapes to jazz voicings.';
  @override
  String get slideTwoTitle => 'Listen to every chord and its arpeggio';
  @override
  String get slideTwoBody =>
      'We synthesize each string so you can recognise the sound before playing.';
  @override
  String get slideThreeTitle => 'Learn by levels and practise';
  @override
  String get slideThreeBody =>
      'Step-by-step itinerary, genre filter and game mode to chain chord streaks.';
}

// Path: data
class Translations$data$en extends Translations$data$es {
  Translations$data$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  late final Translations$data$language$en language =
      Translations$data$language$en._(_root);
  @override
  late final Translations$data$genre$en genre = Translations$data$genre$en._(
    _root,
  );
  @override
  late final Translations$data$quality$en quality =
      Translations$data$quality$en._(_root);
  @override
  late final Translations$data$qualityDescription$en qualityDescription =
      Translations$data$qualityDescription$en._(_root);
  @override
  late final Translations$data$difficulty$en difficulty =
      Translations$data$difficulty$en._(_root);
  @override
  late final Translations$data$difficultyHint$en difficultyHint =
      Translations$data$difficultyHint$en._(_root);
  @override
  late final Translations$data$level$en level = Translations$data$level$en._(
    _root,
  );
  @override
  late final Translations$data$levelGoal$en levelGoal =
      Translations$data$levelGoal$en._(_root);
  @override
  late final Translations$data$arpeggio$en arpeggio =
      Translations$data$arpeggio$en._(_root);
}

// Path: logs
class Translations$logs$en extends Translations$logs$es {
  Translations$logs$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Diagnostics';
  @override
  String get clear => 'Clear log';
  @override
  String get total => 'Total';
  @override
  String get errors => 'Errors';
  @override
  String get warnings => 'Warnings';
  @override
  String get allLevels => 'All';
  @override
  String get empty => 'No events recorded';
}

// Path: router
class Translations$router$en extends Translations$router$es {
  Translations$router$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get notFound => 'Route not found';
  @override
  String get goHome => 'Go to home';
}

// Path: settings.theme
class Translations$settings$theme$en extends Translations$settings$theme$es {
  Translations$settings$theme$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Theme';
  @override
  String get system => 'System';
  @override
  String get light => 'Light';
  @override
  String get dark => 'Dark';
  @override
  String get summarySystem => 'Follows the system theme';
  @override
  String get summaryLight => 'Always light';
  @override
  String get summaryDark => 'Always dark';
  @override
  String get valueSystem => 'System theme';
  @override
  String get valueLight => 'Light theme';
  @override
  String get valueDark => 'Dark theme';
}

// Path: settings.color
class Translations$settings$color$en extends Translations$settings$color$es {
  Translations$settings$color$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'App colour';
  @override
  String get dynamicActive => 'System dynamic colour active';
  @override
  String get systemTitle => 'System colour';
  @override
  String get systemSubtitle => 'Uses your device wallpaper';
  @override
  String get systemUnavailable => 'Not available on this platform';
  @override
  String get accentDisabledNote =>
      'The manual accent is disabled while the system colour is active.';
}

// Path: settings.text
class Translations$settings$text$en extends Translations$settings$text$es {
  Translations$settings$text$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Text';
  @override
  String get fontSize => 'Font size';
  @override
  String get preview => 'Preview';
  @override
  String get previewSample => 'C major · barre at fret 3';
}

// Path: settings.language
class Translations$settings$language$en
    extends Translations$settings$language$es {
  Translations$settings$language$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Language';
}

// Path: settings.accent
class Translations$settings$accent$en extends Translations$settings$accent$es {
  Translations$settings$accent$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get violeta => 'Violet';
  @override
  String get azul => 'Blue';
  @override
  String get anil => 'Indigo';
  @override
  String get cian => 'Cyan';
  @override
  String get verde => 'Green';
  @override
  String get lima => 'Lime';
  @override
  String get ambar => 'Amber';
  @override
  String get naranja => 'Orange';
  @override
  String get rojo => 'Red';
  @override
  String get rosa => 'Pink';
}

// Path: settings.fontScale
class Translations$settings$fontScale$en
    extends Translations$settings$fontScale$es {
  Translations$settings$fontScale$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get pequena => 'Small';
  @override
  String get normal => 'Normal';
  @override
  String get grande => 'Large';
  @override
  String get extraGrande => 'Extra large';
}

// Path: data.language
class Translations$data$language$en extends Translations$data$language$es {
  Translations$data$language$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'System language';
  @override
  String get es => 'Spanish';
  @override
  String get en => 'English';
}

// Path: data.genre
class Translations$data$genre$en extends Translations$data$genre$es {
  Translations$data$genre$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get pop => 'Pop';
  @override
  String get rock => 'Rock';
  @override
  String get blues => 'Blues';
  @override
  String get jazz => 'Jazz';
  @override
  String get funk => 'Funk';
  @override
  String get ballad => 'Ballad';
  @override
  String get latin => 'Latin';
  @override
  String get metal => 'Metal';
  @override
  String get rnb => 'R&B';
  @override
  String get soul => 'Soul';
  @override
  String get bossa => 'Bossa';
  @override
  String get country => 'Country';
  @override
  String get kids => 'Kids';
  @override
  String get ambient => 'Ambient';
  @override
  String get classical => 'Classical';
  @override
  String get gospel => 'Gospel';
  @override
  String get punk => 'Punk';
}

// Path: data.quality
class Translations$data$quality$en extends Translations$data$quality$es {
  Translations$data$quality$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get major => 'Major';
  @override
  String get minor => 'Minor';
  @override
  String get seven => 'Dominant seventh';
  @override
  String get minorSeven => 'Minor seventh';
  @override
  String get majorSeven => 'Major seventh';
  @override
  String get suspendedFourth => 'Suspended 4';
  @override
  String get suspendedSecond => 'Suspended 2';
  @override
  String get power => 'Fifth';
  @override
  String get sixth => 'Sixth';
  @override
  String get minorSixth => 'Minor sixth';
  @override
  String get diminished => 'Diminished';
  @override
  String get augmented => 'Augmented';
  @override
  String get ninth => 'Ninth';
}

// Path: data.qualityDescription
class Translations$data$qualityDescription$en
    extends Translations$data$qualityDescription$es {
  Translations$data$qualityDescription$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get major => 'Major triad; the foundation of almost everything.';
  @override
  String get minor => 'Minor triad; sad or intimate colour.';
  @override
  String get seven => 'Blues and funk; tension with a strong resolution.';
  @override
  String get minorSeven => 'Soft and versatile; the backbone of ii-V-I.';
  @override
  String get majorSeven => 'Dreamy pop and jazz colour.';
  @override
  String get suspendedFourth => 'Open suspension; usually resolves to major.';
  @override
  String get suspendedSecond => 'Open and ethereal; common in pop and rock.';
  @override
  String get power => 'Two notes; rock, metal and distortion.';
  @override
  String get sixth => 'Vintage feel; frequent in funk and folk.';
  @override
  String get minorSixth => 'Latin and jazz colour; very expressive.';
  @override
  String get diminished => 'Unstable tension; passing chord.';
  @override
  String get augmented => 'Symmetric and bright; chromatic links.';
  @override
  String get ninth => 'Rich and modern; funk and r&b.';
}

// Path: data.difficulty
class Translations$data$difficulty$en extends Translations$data$difficulty$es {
  Translations$data$difficulty$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get beginner => 'Beginner';
  @override
  String get easy => 'Easy';
  @override
  String get medium => 'Intermediate';
  @override
  String get hard => 'Hard';
  @override
  String get expert => 'Expert';
}

// Path: data.difficultyHint
class Translations$data$difficultyHint$en
    extends Translations$data$difficultyHint$es {
  Translations$data$difficultyHint$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get beginner => 'Open, no barre';
  @override
  String get easy => 'Triads or short shapes';
  @override
  String get medium => 'Full barre';
  @override
  String get hard => 'Big stretch or high barre';
  @override
  String get expert => 'Advanced or jazz voicing';
}

// Path: data.level
class Translations$data$level$en extends Translations$data$level$es {
  Translations$data$level$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get first => 'First chords';
  @override
  String get second => 'Easy sevenths';
  @override
  String get third => 'Barre chords';
  @override
  String get fourth => 'Colour and suspension';
  @override
  String get fifth => 'Jazz and voicings';
}

// Path: data.levelGoal
class Translations$data$levelGoal$en extends Translations$data$levelGoal$es {
  Translations$data$levelGoal$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get first => 'Open major and minor chords';
  @override
  String get second => 'Dominant seventh without barre';
  @override
  String get third => 'Full movable shapes';
  @override
  String get fourth => 'm7, maj7, sus2, sus4, 6';
  @override
  String get fifth => '9, dim, aug and advanced voicings';
}

// Path: data.arpeggio
class Translations$data$arpeggio$en extends Translations$data$arpeggio$es {
  Translations$data$arpeggio$en._(TranslationsEn root)
    : this._root = root,
      super.internal(root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get ascending => 'Ascending';
  @override
  String get descending => 'Descending';
  @override
  String get alternating => 'Alternating';
  @override
  String get fingerstyle => 'Fingerstyle';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEn {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'app.title' => 'Chords',
      'app.chordFallback' => 'Chord',
      'app.skip' => 'Skip',
      'app.next' => 'Next',
      'app.start' => 'Start',
      'nav.home' => 'Home',
      'nav.learn' => 'Learn',
      'nav.chords' => 'Chords',
      'nav.game' => 'Play',
      'nav.live' => 'Live',
      'nav.settings' => 'Settings',
      'home.greeting' => 'Hello, guitarist',
      'home.question' => 'What are you playing today?',
      'home.progressTitle' => 'Itinerary progress',
      'home.masteredCount' =>
        ({required num n}) =>
            (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
              n,
              one: '${n} chord mastered',
              other: '${n} chords mastered',
            ),
      'home.continueLearning' => 'Keep learning',
      'home.itineraryComplete' => 'Itinerary complete!',
      'home.nextChord' => ({required Object name}) => 'Next: ${name}',
      'home.library' => 'Chord library',
      'home.librarySubtitle' => ({
        required Object count,
      }) => '${count} chords by genre and level',
      'home.gameMode' => 'Game mode',
      'home.gameSubtitle' => 'Play the chord and build a streak',
      'home.liveTitle' => 'Live tuning',
      'home.liveSubtitle' => 'Detect the note with your microphone',
      'chords.title' => 'Chords',
      'chords.clearFilters' => 'Clear filters',
      'chords.searchHint' => 'Search chords',
      'chords.filterAll' => 'All',
      'chords.filterAllQualities' => 'All',
      'chords.positionCount' =>
        ({required num n}) =>
            (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
              n,
              one: '${n} position',
              other: '${n} positions',
            ),
      'chords.levelShort' => ({required Object level}) => 'Lv ${level}',
      'chords.maxDifficulty' => ({
        required Object level,
      }) => 'Max difficulty: ${level}',
      'chords.loading' => 'Loading chords…',
      'chords.loadErrorTitle' => 'Could not load the chord bank',
      'chords.loadErrorMessage' =>
        'Restart the app to try loading the bank again.',
      'chords.emptyTitle' => 'No results',
      'chords.emptyMessage' =>
        'Adjust the search or the filters to see more chords.',
      'chordDetail.titleFallback' => 'Chord',
      'chordDetail.markMastered' => 'Mark as mastered',
      'chordDetail.unmarkMastered' => 'Remove from mastered',
      'chordDetail.leftHandMode' => 'Left-handed mode',
      'chordDetail.leftHandModeOff' => 'Disable left-handed mode',
      'chordDetail.loading' => 'Loading chord…',
      'chordDetail.errorTitle' => 'Chord unavailable',
      'chordDetail.notFoundMessage' => ({
        required Object chordId,
      }) => 'Chord ${chordId} not found',
      'chordDetail.loadFailed' => 'The chord bank could not be read.',
      'chordDetail.noChordTitle' => 'No chord selected',
      'chordDetail.noChordMessage' => 'Go back to the list and pick a chord.',
      'chordDetail.listen' => 'Listen to chord',
      'chordDetail.listenPosition' => ({
        required Object position,
      }) => 'Listen to ${position}',
      'chordDetail.arpeggios' => 'Arpeggios',
      'chordDetail.positions' => 'Positions',
      'chordDetail.notes' => ({required Object notes}) => 'Notes: ${notes}',
      'chordDetail.arpeggioChip' => ({
        required Object label,
        required Object level,
      }) => '${label} · Lv ${level}',
      'game.title' => 'Play',
      'game.start' => 'Start streak',
      'game.emptyTitle' => 'Play the chord',
      'game.emptyMessage' => ({
        required Object best,
      }) => 'Chain a series of chords with the microphone. Best: ${best} points.',
      'game.round' => ({required Object number}) => 'Round ${number}',
      'game.playThisChord' => 'Play this chord',
      'game.loadingChord' => 'Loading chord…',
      'game.listening' => 'Listening to your guitar…',
      'game.correctNext' => 'Correct! Next',
      'game.retry' => 'Try again',
      'game.ready' => 'I\'m ready',
      'game.streak' => 'Streak',
      'game.score' => 'Score',
      'chordDiagram.stringLabel' => ({
        required Object number,
        required Object fret,
      }) => 'string ${number}: ${fret}',
      'chordDiagram.muted' => 'muted',
      'chordDiagram.open' => 'open',
      'chordDiagram.fret' => ({required Object value}) => 'fret ${value}',
      'chordDiagram.description' => ({
        required Object position,
        required Object details,
      }) => 'Diagram of ${position}, ${details}',
      'live.title' => 'Live',
      'live.listen' => 'Listen to guitar',
      'live.stop' => 'Stop',
      'live.emptyTitle' => 'No suggestions yet',
      'live.emptyMessage' => 'Press listen and play a chord to see matches.',
      'live.suggestions' => 'Suggestions',
      'live.idleTitle' => 'Microphone idle',
      'live.idleMessage' => 'Play a note on the guitar',
      'live.listening' => 'Listening…',
      'live.deniedTitle' => 'Permission denied',
      'live.errorTitle' => 'Capture error',
      'learn.title' => 'Learn',
      'learn.loading' => 'Preparing levels…',
      'learn.errorTitle' => 'Could not load the itinerary',
      'learn.errorMessage' => 'Restart the app to try again.',
      'learn.yourProgress' => 'Your progress',
      'learn.masteredCount' =>
        ({required num n}) =>
            (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
              n,
              one: '${n} chord mastered',
              other: '${n} chords mastered',
            ),
      'learn.stepByStep' => 'Step by step',
      'learn.stepFingers' => 'Place your fingers one by one on the fretboard',
      'learn.stepStrum' => 'Slow strum: listen to every string',
      'learn.stepChange' =>
        'Move to the next chord without stopping the rhythm',
      'learn.guidedArpeggios' => 'Guided arpeggios',
      'learn.levelSection' => ({
        required Object emoji,
        required Object level,
        required Object title,
      }) => '${emoji}  Level ${level}: ${title}',
      'learn.arpeggioHint' => ({
        required Object label,
      }) => 'Open the chord and play its ${label} arpeggio',
      'settings.title' => 'Settings',
      'settings.appearance' => 'Appearance',
      'settings.theme.title' => 'Theme',
      'settings.theme.system' => 'System',
      'settings.theme.light' => 'Light',
      'settings.theme.dark' => 'Dark',
      'settings.theme.summarySystem' => 'Follows the system theme',
      'settings.theme.summaryLight' => 'Always light',
      'settings.theme.summaryDark' => 'Always dark',
      'settings.theme.valueSystem' => 'System theme',
      'settings.theme.valueLight' => 'Light theme',
      'settings.theme.valueDark' => 'Dark theme',
      'settings.color.title' => 'App colour',
      'settings.color.dynamicActive' => 'System dynamic colour active',
      'settings.color.systemTitle' => 'System colour',
      'settings.color.systemSubtitle' => 'Uses your device wallpaper',
      'settings.color.systemUnavailable' => 'Not available on this platform',
      'settings.color.accentDisabledNote' =>
        'The manual accent is disabled while the system colour is active.',
      'settings.text.title' => 'Text',
      'settings.text.fontSize' => 'Font size',
      'settings.text.preview' => 'Preview',
      'settings.text.previewSample' => 'C major · barre at fret 3',
      'settings.language.title' => 'Language',
      'settings.accent.violeta' => 'Violet',
      'settings.accent.azul' => 'Blue',
      'settings.accent.anil' => 'Indigo',
      'settings.accent.cian' => 'Cyan',
      'settings.accent.verde' => 'Green',
      'settings.accent.lima' => 'Lime',
      'settings.accent.ambar' => 'Amber',
      'settings.accent.naranja' => 'Orange',
      'settings.accent.rojo' => 'Red',
      'settings.accent.rosa' => 'Pink',
      'settings.fontScale.pequena' => 'Small',
      'settings.fontScale.normal' => 'Normal',
      'settings.fontScale.grande' => 'Large',
      'settings.fontScale.extraGrande' => 'Extra large',
      'settings.guitar' => 'Guitar',
      'settings.leftHandMode' => 'Left-handed mode',
      'settings.leftHandModeSubtitle' => 'Mirrors the chord diagrams',
      'settings.sound' => 'Sound',
      'settings.chordSound' => 'Chord sound',
      'settings.chordSoundSubtitle' => 'Synthesizes strums and arpeggios',
      'settings.learning' => 'Learning',
      'settings.resetOnboarding' => 'Reset onboarding',
      'settings.resetOnboardingSubtitle' => 'Show the introduction again',
      'settings.onboardingReset' => 'Onboarding reset',
      'settings.version' => 'Version',
      'settings.cli' => 'Development CLI',
      'settings.cliCommand' => 'dart run bin/chords_cli.dart db generate',
      'onboarding.slideOneTitle' => 'Every chord, every position',
      'onboarding.slideOneBody' => '156 chords and 581 verified positions, from the essential open shapes to jazz voicings.',
      'onboarding.slideTwoTitle' => 'Listen to every chord and its arpeggio',
      'onboarding.slideTwoBody' => 'We synthesize each string so you can recognise the sound before playing.',
      'onboarding.slideThreeTitle' => 'Learn by levels and practise',
      'onboarding.slideThreeBody' => 'Step-by-step itinerary, genre filter and game mode to chain chord streaks.',
      'data.language.system' => 'System language',
      'data.language.es' => 'Spanish',
      'data.language.en' => 'English',
      'data.genre.pop' => 'Pop',
      'data.genre.rock' => 'Rock',
      'data.genre.blues' => 'Blues',
      'data.genre.jazz' => 'Jazz',
      'data.genre.funk' => 'Funk',
      'data.genre.ballad' => 'Ballad',
      'data.genre.latin' => 'Latin',
      'data.genre.metal' => 'Metal',
      'data.genre.rnb' => 'R&B',
      'data.genre.soul' => 'Soul',
      'data.genre.bossa' => 'Bossa',
      'data.genre.country' => 'Country',
      'data.genre.kids' => 'Kids',
      'data.genre.ambient' => 'Ambient',
      'data.genre.classical' => 'Classical',
      'data.genre.gospel' => 'Gospel',
      'data.genre.punk' => 'Punk',
      'data.quality.major' => 'Major',
      'data.quality.minor' => 'Minor',
      'data.quality.seven' => 'Dominant seventh',
      'data.quality.minorSeven' => 'Minor seventh',
      'data.quality.majorSeven' => 'Major seventh',
      'data.quality.suspendedFourth' => 'Suspended 4',
      'data.quality.suspendedSecond' => 'Suspended 2',
      'data.quality.power' => 'Fifth',
      'data.quality.sixth' => 'Sixth',
      'data.quality.minorSixth' => 'Minor sixth',
      'data.quality.diminished' => 'Diminished',
      'data.quality.augmented' => 'Augmented',
      'data.quality.ninth' => 'Ninth',
      'data.qualityDescription.major' =>
        'Major triad; the foundation of almost everything.',
      'data.qualityDescription.minor' => 'Minor triad; sad or intimate colour.',
      'data.qualityDescription.seven' =>
        'Blues and funk; tension with a strong resolution.',
      'data.qualityDescription.minorSeven' =>
        'Soft and versatile; the backbone of ii-V-I.',
      'data.qualityDescription.majorSeven' => 'Dreamy pop and jazz colour.',
      'data.qualityDescription.suspendedFourth' =>
        'Open suspension; usually resolves to major.',
      'data.qualityDescription.suspendedSecond' =>
        'Open and ethereal; common in pop and rock.',
      'data.qualityDescription.power' =>
        'Two notes; rock, metal and distortion.',
      'data.qualityDescription.sixth' =>
        'Vintage feel; frequent in funk and folk.',
      'data.qualityDescription.minorSixth' =>
        'Latin and jazz colour; very expressive.',
      'data.qualityDescription.diminished' =>
        'Unstable tension; passing chord.',
      'data.qualityDescription.augmented' =>
        'Symmetric and bright; chromatic links.',
      'data.qualityDescription.ninth' => 'Rich and modern; funk and r&b.',
      'data.difficulty.beginner' => 'Beginner',
      'data.difficulty.easy' => 'Easy',
      'data.difficulty.medium' => 'Intermediate',
      'data.difficulty.hard' => 'Hard',
      'data.difficulty.expert' => 'Expert',
      'data.difficultyHint.beginner' => 'Open, no barre',
      'data.difficultyHint.easy' => 'Triads or short shapes',
      'data.difficultyHint.medium' => 'Full barre',
      'data.difficultyHint.hard' => 'Big stretch or high barre',
      'data.difficultyHint.expert' => 'Advanced or jazz voicing',
      'data.level.first' => 'First chords',
      'data.level.second' => 'Easy sevenths',
      'data.level.third' => 'Barre chords',
      'data.level.fourth' => 'Colour and suspension',
      'data.level.fifth' => 'Jazz and voicings',
      'data.levelGoal.first' => 'Open major and minor chords',
      'data.levelGoal.second' => 'Dominant seventh without barre',
      'data.levelGoal.third' => 'Full movable shapes',
      'data.levelGoal.fourth' => 'm7, maj7, sus2, sus4, 6',
      'data.levelGoal.fifth' => '9, dim, aug and advanced voicings',
      'data.arpeggio.ascending' => 'Ascending',
      'data.arpeggio.descending' => 'Descending',
      'data.arpeggio.alternating' => 'Alternating',
      'data.arpeggio.fingerstyle' => 'Fingerstyle',
      'logs.title' => 'Diagnostics',
      'logs.clear' => 'Clear log',
      'logs.total' => 'Total',
      'logs.errors' => 'Errors',
      'logs.warnings' => 'Warnings',
      'logs.allLevels' => 'All',
      'logs.empty' => 'No events recorded',
      'router.notFound' => 'Route not found',
      'router.goHome' => 'Go to home',
      _ => null,
    };
  }
}

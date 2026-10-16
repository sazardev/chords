import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/domain/band/presets/band_preset_catalog.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/band_settings_controller.dart';
import 'package:chords/presentation/l10n/band_labels.dart';
import 'package:flutter/material.dart';

/// Estilo de la banda y tipo de cada instrumento (con "automático").
class JamBandVoices extends StatelessWidget {
  /// Crea la sección.
  const JamBandVoices({required this.settings, super.key});

  /// Ajustes de la banda.
  final BandSettingsController settings;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final BandConfig config = settings.config;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KindDropdown<String>(
          label: t.jamBand.style,
          autoLabel: t.jamBand.styleAuto,
          values: kBandPresets.keys.toList(),
          selected: config.style,
          nameOf: (String id) => bandStyleName(t, id),
          onChanged: (String? id) =>
              settings.set(config.copyWith(style: (value: id))),
        ),
        const SizedBox(height: 12),
        ..._rhythmSection(t, config),
        const SizedBox(height: 12),
        ..._harmonySection(t, config),
      ],
    );
  }

  /// Kit de batería y tipo de bajo.
  List<Widget> _rhythmSection(Translations t, BandConfig config) => <Widget>[
    KindDropdown<DrumKit>(
      label: t.jamBand.kitLabel,
      autoLabel: t.jamBand.instrumentAuto,
      values: DrumKit.values,
      selected: config.kit,
      nameOf: (DrumKit v) => drumKitName(t, v),
      onChanged: (DrumKit? v) => settings.set(config.copyWith(kit: (value: v))),
    ),
    const SizedBox(height: 12),
    KindDropdown<BassKind>(
      label: t.jamBand.bassLabel,
      autoLabel: t.jamBand.instrumentAuto,
      values: BassKind.values,
      selected: config.bass,
      nameOf: (BassKind v) => bassKindName(t, v),
      onChanged: (BassKind? v) =>
          settings.set(config.copyWith(bass: (value: v))),
    ),
  ];

  /// Guitarra, teclado y viento.
  List<Widget> _harmonySection(Translations t, BandConfig config) => <Widget>[
    KindDropdown<GuitarKind>(
      label: t.jamBand.guitarLabel,
      autoLabel: t.jamBand.instrumentAuto,
      values: GuitarKind.values,
      selected: config.guitar,
      nameOf: (GuitarKind v) => guitarKindName(t, v),
      onChanged: (GuitarKind? v) =>
          settings.set(config.copyWith(guitar: (value: v))),
    ),
    const SizedBox(height: 12),
    KindDropdown<KeysKind>(
      label: t.jamBand.keysLabel,
      autoLabel: t.jamBand.instrumentAuto,
      values: KeysKind.values,
      selected: config.keys,
      nameOf: (KeysKind v) => keysKindName(t, v),
      onChanged: (KeysKind? v) =>
          settings.set(config.copyWith(keys: (value: v))),
    ),
    const SizedBox(height: 12),
    KindDropdown<WindKind>(
      label: t.jamBand.windLabel,
      autoLabel: t.jamBand.instrumentAuto,
      values: WindKind.values,
      selected: config.wind,
      nameOf: (WindKind v) => windKindName(t, v),
      onChanged: (WindKind? v) =>
          settings.set(config.copyWith(wind: (value: v))),
    ),
  ];
}

/// Lista desplegable con una primera opción "automático" (valor `null`).
class KindDropdown<T> extends StatelessWidget {
  /// Crea la lista.
  const KindDropdown({
    required this.label,
    required this.autoLabel,
    required this.values,
    required this.selected,
    required this.nameOf,
    required this.onChanged,
    super.key,
  });

  /// Título del campo.
  final String label;

  /// Texto de la opción automática.
  final String autoLabel;

  /// Opciones.
  final List<T> values;

  /// Opción elegida (`null` = automático).
  final T? selected;

  /// Nombre traducido de una opción.
  final String Function(T value) nameOf;

  /// Se llama al elegir (con `null` para automático).
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<T?>(
    key: ValueKey<Object?>('$label-$selected'),
    initialValue: selected,
    isExpanded: true,
    decoration: InputDecoration(labelText: label),
    items: <DropdownMenuItem<T?>>[
      DropdownMenuItem<T?>(
        child: Text(autoLabel, overflow: TextOverflow.ellipsis),
      ),
      for (final T value in values)
        DropdownMenuItem<T?>(
          value: value,
          child: Text(nameOf(value), overflow: TextOverflow.ellipsis),
        ),
    ],
    onChanged: onChanged,
  );
}

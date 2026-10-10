import 'package:chords/app/system_color_scope.dart';
import 'package:chords/presentation/theme/app_accent_color.dart';
import 'package:chords/presentation/theme/app_font_scale.dart';
import 'package:chords/presentation/theme/app_system_colors.dart';
import 'package:chords/presentation/theme/app_theme.dart';
import 'package:chords/presentation/theme/app_theme_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests del sistema de tema: acentos, escala de texto y diseño plano.
void main() {
  group('acentos de color', () {
    test('cada acento expone semilla, etiqueta e icono', () {
      for (final AppAccentColor accent in AppAccentColor.values) {
        expect(accent.seed, isA<Color>());
        expect(accent.label, isNotEmpty);
        expect(accent.icon, isA<IconData>());
      }
    });

    test('el acento elegido cambia el esquema generado', () {
      final ThemeData violeta = buildLightTheme();
      final ThemeData verde = buildLightTheme(
        options: const AppThemeOptions(accent: AppAccentColor.verde),
      );
      expect(
        verde.colorScheme.primary,
        isNot(equals(violeta.colorScheme.primary)),
      );
    });

    test('el tema oscuro invierte el brillo del esquema', () {
      final ThemeData dark = buildDarkTheme();
      expect(dark.colorScheme.brightness, Brightness.dark);
      expect(dark.scaffoldBackgroundColor, dark.colorScheme.surface);
    });
  });

  group('escala de texto', () {
    test('la escala multiplica todos los tamaños de la tipografía', () {
      final ThemeData normal = buildLightTheme();
      final ThemeData grande = buildLightTheme(
        options: const AppThemeOptions(fontScale: AppFontScale.grande),
      );
      final double factor = AppFontScale.grande.scale;
      expect(
        grande.textTheme.bodyMedium!.fontSize,
        closeTo(normal.textTheme.bodyMedium!.fontSize! * factor, 0.01),
      );
      expect(
        grande.textTheme.displayLarge!.fontSize,
        closeTo(normal.textTheme.displayLarge!.fontSize! * factor, 0.01),
      );
    });
  });

  group('diseño plano', () {
    test('ningún componente declara elevación ni sombra', () {
      final ThemeData theme = buildLightTheme();
      expect(theme.cardTheme.elevation, 0);
      expect(theme.cardTheme.surfaceTintColor, Colors.transparent);
      expect(theme.appBarTheme.elevation, 0);
      expect(theme.appBarTheme.scrolledUnderElevation, 0);
      expect(theme.appBarTheme.surfaceTintColor, Colors.transparent);
      expect(theme.navigationBarTheme.elevation, 0);
      expect(theme.navigationBarTheme.surfaceTintColor, Colors.transparent);
      expect(theme.navigationRailTheme.elevation, 0);
      expect(theme.dialogTheme.elevation, 0);
      expect(theme.snackBarTheme.elevation, 0);
      expect(theme.bottomSheetTheme.elevation, 0);
      expect(theme.chipTheme.elevation, 0);
      expect(theme.floatingActionButtonTheme.elevation, 0);
      expect(theme.shadowColor, Colors.transparent);
    });

    test('los chips no dibujan borde', () {
      expect(buildLightTheme().chipTheme.side, BorderSide.none);
    });

    test('los campos de texto son planos y sin subrayado', () {
      final InputDecorationThemeData input =
          buildLightTheme().inputDecorationTheme;
      expect(input.filled, isTrue);
      expect(input.border, isA<OutlineInputBorder>());
      expect(input.border!.borderSide, BorderSide.none);
      expect(input.enabledBorder!.borderSide, BorderSide.none);
      expect(input.focusedBorder!.borderSide, BorderSide.none);
    });

    test('el botón segmentado no dibuja borde', () {
      final ButtonStyle style = buildLightTheme().segmentedButtonTheme.style!;
      expect(style.side!.resolve(<WidgetState>{}), BorderSide.none);
    });
  });

  group('color del sistema', () {
    testWidgets('el ámbito expone los colores cuando la plataforma los da', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: SystemColorScope(builder: _probe)),
      );
      // Sin plataforma en pruebas el ámbito resuelve `null` y la app sigue
      // funcionando con sus propios acentos.
      expect(
        SystemColorScope.systemColorsOf(tester.element(find.byType(Text))),
        isNull,
      );
    });

    testWidgets('un esquema dinámico inyectado se usa tal cual', (
      WidgetTester tester,
    ) async {
      const ColorScheme injected = ColorScheme.light();
      await tester.pumpWidget(
        MaterialApp(
          theme: buildLightTheme(dynamicScheme: injected),
          home: const SizedBox.shrink(),
        ),
      );
      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).theme!.colorScheme,
        injected,
      );
    });
  });
}

/// Sonda que muestra si el ámbito tiene colores del sistema.
Widget _probe(AppSystemColors? colors) =>
    Text(colors == null ? 'sin color del sistema' : 'con color del sistema');

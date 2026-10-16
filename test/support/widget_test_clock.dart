import 'package:chords/domain/band/clock/monotonic_clock.dart';
import 'package:flutter_test/flutter_test.dart';

/// Reloj monótono que sigue el tiempo falso de `testWidgets`: avanza con
/// `tester.pump(duración)`.
class WidgetTestClock implements MonotonicClock {
  /// Crea el reloj con el origen en el instante actual del [binding].
  WidgetTestClock(this._binding) : _origin = _binding.clock.now();

  final TestWidgetsFlutterBinding _binding;
  final DateTime _origin;

  @override
  Duration get now => _binding.clock.now().difference(_origin);
}

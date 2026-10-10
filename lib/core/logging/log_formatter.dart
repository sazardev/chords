import 'package:chords/core/logging/log_entry.dart';

/// Convierte un [LogEntry] en su representación de texto.
///
/// Es una función pura e inyectable, de forma que un mismo evento pueda
/// renderizarse para consola, JSON o cualquier otro formato sin acoplar el
/// sink a un formato concreto.
typedef LogFormatter = String Function(LogEntry entry);

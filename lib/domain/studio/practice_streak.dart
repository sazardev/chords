/// Racha de práctica: días seguidos tocando.
library;

/// Clave de un día (`aaaa-mm-dd`) en hora local.
String dayKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

/// Días seguidos practicados hasta [today].
///
/// Si hoy aún no se ha practicado, la racha cuenta hasta ayer: no se pierde
/// hasta que pasa un día entero sin tocar.
int practiceStreak(Set<String> days, DateTime today) {
  DateTime cursor = DateTime(today.year, today.month, today.day);
  if (!days.contains(dayKey(cursor))) {
    cursor = cursor.subtract(const Duration(days: 1));
  }
  int streak = 0;
  while (days.contains(dayKey(cursor))) {
    streak++;
    cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
  }
  return streak;
}

/// Conserva solo los días de los últimos [keep] días (para no crecer sin fin).
Set<String> recentDays(Set<String> days, DateTime today, {int keep = 400}) {
  final String oldest = dayKey(today.subtract(Duration(days: keep)));
  return <String>{
    for (final String day in days)
      if (day.compareTo(oldest) >= 0) day,
  };
}

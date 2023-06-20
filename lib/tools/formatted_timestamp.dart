const weekdaysNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

const monthsNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

String formattedTimestamp(String? timestamp, [bool doShorten = false]) {
  if (timestamp == null) return "";

  final then = DateTime.parse(timestamp);
  final now = DateTime.now();
  final hour = then.hour == 0
      ? 12
      : then.hour > 12
          ? then.hour - 12
          : then.hour;
  final ampm = then.hour >= 12 ? "PM" : "AM";
  final minute = then.minute.toString().padLeft(2, '0');
  final timeText = "$hour:$minute $ampm";

  if (then.year != now.year) {
    final date = "${then.year}-${then.month}-${then.day}";
    if (doShorten) return date;
    return "$date, $timeText";
  }

  final daysDiffrence = now.difference(then).inDays;

  if (daysDiffrence > 7) {
    final date = "${monthsNames[then.month - 1]} ${then.day}";
    if (doShorten) return date;
    return "$date, $timeText";
  }
  if (daysDiffrence > 1) {
    final date = weekdaysNames[then.weekday - 1];
    if (doShorten) return date;
    return "$date, $timeText";
  }
  if (daysDiffrence == 1) {
    const date = "Yesterday";
    if (doShorten) return date;
    return "$date, $timeText";
  }
  return timeText;
}

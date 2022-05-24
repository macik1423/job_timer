import 'package:intl/intl.dart';

class TimeUtil {
  /// return date in format HH:mm:ss
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '__:__:__';
    }
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  /// return date in format: dd.mm.yyyy
  static String formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return '__-__-__';
    }
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }
}

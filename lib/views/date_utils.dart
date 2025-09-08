import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class IndonesianDateUtils {
  static Future<void> initialize() async {
    await initializeDateFormatting('id_ID', null);
  }

  static String formatFullDate(DateTime date) {
    final format = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    return format.format(date);
  }

  static String formatDateTime(DateTime date) {
    final format = DateFormat('EEEE, d MMMM yyyy HH:mm', 'id_ID');
    return format.format(date);
  }

  static String formatDateOnly(DateTime date) {
    final format = DateFormat('d MMMM yyyy', 'id_ID');
    return format.format(date);
  }

  static String formatTimeOnly(DateTime date) {
    final format = DateFormat('HH:mm', 'id_ID');
    return format.format(date);
  }

  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }
}

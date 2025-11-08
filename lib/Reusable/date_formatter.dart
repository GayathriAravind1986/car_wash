import 'package:intl/intl.dart';

String formatDate(String dateStr) {
  final dateTime = DateTime.parse(dateStr);
  return DateFormat('dd/MM/yyyy').format(dateTime);
}

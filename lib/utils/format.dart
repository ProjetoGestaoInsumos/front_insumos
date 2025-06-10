import 'package:intl/intl.dart';

String formatarData(String isoDate) {
  final date = DateTime.parse(isoDate);
  return DateFormat('dd/MM/yyyy').format(date);
}

String formatarDataHora(String isoDate) {
  final date = DateTime.parse(isoDate);
  return DateFormat('dd/MM/yyyy HH:mm').format(date);
}
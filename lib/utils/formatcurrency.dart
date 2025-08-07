import 'package:intl/intl.dart';

String formatCurrency(double price) {
  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  return formatCurrency.format(price);
}

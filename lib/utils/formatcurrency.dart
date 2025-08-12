import 'package:intl/intl.dart';
import 'dart:math';

String formatCurrency(int price) {
  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  return formatCurrency.format(price);
}

String generateOrderCode() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final rand = Random();
  final code = List.generate(
    6,
    (index) => chars[rand.nextInt(chars.length)],
  ).join();
  return 'ORD-$code';
}

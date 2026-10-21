/// 6325 -> "C$ 6,325.00"
String formatMoney(double value) {
  final parts = value.toStringAsFixed(2).split('.');
  final integer = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => ',',
  );
  return 'C\$ $integer.${parts[1]}';
}

/// DateTime(2026, 10, 10) -> "10/10/2026"
String formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

class AppFormat {
  AppFormat._();

  static String money(double value) => formatMoney(value);

  static String date(DateTime value) => formatDate(value);
}

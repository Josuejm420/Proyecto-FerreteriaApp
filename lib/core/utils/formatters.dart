/// Formatos de texto que usan varias pantallas (dinero y fechas).
/// Así todas muestran "C$ 1,450.00" y "14/10/2026" de la misma forma.
class AppFormat {
  AppFormat._();

  /// 1450 -> "C$ 1,450.00"
  static String money(double value) {
    final parts = value.abs().toStringAsFixed(2).split('.');
    final entero = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
    final signo = value < 0 ? '-' : '';
    return '${signo}C\$ $entero.${parts[1]}';
  }

  /// DateTime(2026, 10, 14) -> "14/10/2026"
  static String date(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

/// Bộ định dạng ngày tháng an toàn, không phụ thuộc locale ngoại vi
class DateFormatter {
  DateFormatter._();

  /// Định dạng ngày: dd/MM/yyyy (VD: 28/06/2026)
  static String formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d/$m/$y';
  }

  /// Định dạng ngày giờ: dd/MM/yyyy HH:mm (VD: 28/06/2026 16:30)
  static String formatDateTime(DateTime dateTime) {
    final d = dateTime.day.toString().padLeft(2, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final y = dateTime.year.toString();
    final h = dateTime.hour.toString().padLeft(2, '0');
    final min = dateTime.minute.toString().padLeft(2, '0');
    return '$d/$m/$y $h:$min';
  }

  /// Định dạng tháng năm: MM/yyyy (VD: 06/2026)
  static String formatMonthYear(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$m/$y';
  }

  /// Parse chuỗi ngày dd/MM/yyyy thành DateTime
  static DateTime? parseDate(String value) {
    try {
      final parts = value.trim().split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
      return DateTime.tryParse(value);
    } catch (_) {
      return null;
    }
  }

  /// Ngày hôm nay ở dạng chuỗi
  static String today() {
    return formatDate(DateTime.now());
  }

  /// Kiểm tra 2 mốc thời gian có cùng ngày
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

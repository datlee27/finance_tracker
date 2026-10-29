import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

/// Bộ định dạng tiền tệ VND an toàn
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Định dạng số thành chuỗi tiền VND, ví dụ: 18.500.000 ₫
  static String format(double amount) {
    final isNegative = amount < 0;
    final intPart = amount.abs().round();
    final str = intPart.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return '${isNegative ? '-' : ''}${buffer.toString()} ${AppConstants.currencySymbol}';
  }

  /// Định dạng số chỉ gồm phần nghìn có dấu chấm (không kèm ký hiệu ₫)
  /// Ví dụ: 1000000 -> "1.000.000", 0 -> "0"
  static String formatWithDots(double amount) {
    final isNegative = amount < 0;
    final intPart = amount.abs().round();
    final str = intPart.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return '${isNegative ? '-' : ''}${buffer.toString()}';
  }

  /// Định dạng với dấu +/- cho thu/chi
  static String formatSigned(double amount, {required bool isIncome}) {
    final prefix = isIncome ? '+' : '−';
    return '$prefix${format(amount.abs())}';
  }

  /// Parse chuỗi thành số (bỏ ký hiệu ₫, bỏ dấu chấm phần nghìn, hỗ trợ dấu phẩy thập phân)
  static double? parse(String value) {
    try {
      final cleaned = value
          .replaceAll(AppConstants.currencySymbol, '')
          .replaceAll('.', '')
          .replaceAll(',', '.')
          .trim();
      return double.tryParse(cleaned);
    } catch (_) {
      return null;
    }
  }
}

/// Formatter tự động thêm dấu chấm phân cách hàng nghìn khi người dùng nhập số tiền
/// Ví dụ: 1000000 -> 1.000.000
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final int maxDigits;

  ThousandsSeparatorInputFormatter({this.maxDigits = 12});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String newText = newValue.text;
    int selectionIndex = newValue.selection.end;

    // Khi người dùng nhấn Backspace ngay sau dấu chấm '.'
    if (oldValue.selection.isCollapsed &&
        oldValue.selection.baseOffset > 0 &&
        newValue.text.length == oldValue.text.length - 1 &&
        oldValue.selection.baseOffset - 1 < oldValue.text.length &&
        oldValue.text[oldValue.selection.baseOffset - 1] == '.') {
      final dotPos = oldValue.selection.baseOffset - 1;
      if (dotPos > 0) {
        newText = oldValue.text.substring(0, dotPos - 1) +
            oldValue.text.substring(dotPos);
        selectionIndex = dotPos - 1;
      }
    }

    // Đếm số lượng chữ số nằm trước vị trí con trỏ
    final safeSubEnd = selectionIndex.clamp(0, newText.length);
    final textBeforeCursor = newText.substring(0, safeSubEnd);
    int digitsBeforeCursor =
        textBeforeCursor.replaceAll(RegExp(r'\D'), '').length;

    // Lọc chỉ giữ lại ký tự số
    String digits = newText.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Giới hạn số chữ số tối đa
    if (digits.length > maxDigits) {
      digits = digits.substring(0, maxDigits);
      if (digitsBeforeCursor > maxDigits) {
        digitsBeforeCursor = maxDigits;
      }
    }

    // Xoá số 0 ở đầu nếu độ dài > 1 (ví dụ "05" -> "5", "00" -> "0")
    if (digits.length > 1 && digits.startsWith('0')) {
      final trimmed = digits.replaceFirst(RegExp(r'^0+'), '');
      if (trimmed.isEmpty) {
        digits = '0';
        digitsBeforeCursor = 1;
      } else {
        final removedCount = digits.length - trimmed.length;
        digits = trimmed;
        digitsBeforeCursor =
            (digitsBeforeCursor - removedCount).clamp(0, digits.length);
      }
    }

    // Định dạng chuỗi với dấu chấm ngăn cách 3 chữ số từ phải sang
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();

    // Tính toán lại vị trí con trỏ sau khi thêm dấu chấm
    int newCursorOffset = 0;
    int digitCount = 0;
    for (int i = 0; i < formatted.length; i++) {
      if (digitCount == digitsBeforeCursor) {
        break;
      }
      if (RegExp(r'\d').hasMatch(formatted[i])) {
        digitCount++;
      }
      newCursorOffset = i + 1;
    }

    if (digitsBeforeCursor >= digits.length) {
      newCursorOffset = formatted.length;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: newCursorOffset.clamp(0, formatted.length),
      ),
    );
  }
}


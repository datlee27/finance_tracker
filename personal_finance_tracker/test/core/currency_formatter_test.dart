import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_tracker/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter Tests', () {
    test('format returns VND formatted string with symbol', () {
      expect(CurrencyFormatter.format(0), '0 ₫');
      expect(CurrencyFormatter.format(1000), '1.000 ₫');
      expect(CurrencyFormatter.format(1000000), '1.000.000 ₫');
      expect(CurrencyFormatter.format(12345678), '12.345.678 ₫');
    });

    test('formatWithDots formats amount with dots without symbol', () {
      expect(CurrencyFormatter.formatWithDots(0), '0');
      expect(CurrencyFormatter.formatWithDots(500), '500');
      expect(CurrencyFormatter.formatWithDots(1000), '1.000');
      expect(CurrencyFormatter.formatWithDots(1000000), '1.000.000');
      expect(CurrencyFormatter.formatWithDots(50000000), '50.000.000');
    });

    test('parse correctly parses formatted and unformatted strings', () {
      expect(CurrencyFormatter.parse('1.000.000'), 1000000.0);
      expect(CurrencyFormatter.parse('1.000.000 ₫'), 1000000.0);
      expect(CurrencyFormatter.parse('120000'), 120000.0);
      expect(CurrencyFormatter.parse('0'), 0.0);
      expect(CurrencyFormatter.parse('abc'), isNull);
    });
  });

  group('ThousandsSeparatorInputFormatter Tests', () {
    final formatter = ThousandsSeparatorInputFormatter();

    test('formats sequential digit inputs with dot separators', () {
      // Typing '1'
      var res = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(
          text: '1',
          selection: TextSelection.collapsed(offset: 1),
        ),
      );
      expect(res.text, '1');
      expect(res.selection.baseOffset, 1);

      // Typing '1000'
      res = formatter.formatEditUpdate(
        const TextEditingValue(
          text: '100',
          selection: TextSelection.collapsed(offset: 3),
        ),
        const TextEditingValue(
          text: '1000',
          selection: TextSelection.collapsed(offset: 4),
        ),
      );
      expect(res.text, '1.000');
      expect(res.selection.baseOffset, 5);

      // Typing '1000000'
      res = formatter.formatEditUpdate(
        const TextEditingValue(
          text: '100.000',
          selection: TextSelection.collapsed(offset: 7),
        ),
        const TextEditingValue(
          text: '1000000',
          selection: TextSelection.collapsed(offset: 7),
        ),
      );
      expect(res.text, '1.000.000');
      expect(res.selection.baseOffset, 9);
    });

    test('handles backspace on last digit', () {
      final res = formatter.formatEditUpdate(
        const TextEditingValue(
          text: '1.000.000',
          selection: TextSelection.collapsed(offset: 9),
        ),
        const TextEditingValue(
          text: '1.000.00',
          selection: TextSelection.collapsed(offset: 8),
        ),
      );
      expect(res.text, '100.000');
      expect(res.selection.baseOffset, 7);
    });

    test('handles backspace right after dot separator', () {
      // Cursor is at "1.|000" (offset 2). User presses backspace on '.'
      final res = formatter.formatEditUpdate(
        const TextEditingValue(
          text: '1.000',
          selection: TextSelection.collapsed(offset: 2),
        ),
        const TextEditingValue(
          text: '1000',
          selection: TextSelection.collapsed(offset: 1),
        ),
      );
      // Deleting the digit before the dot ('1') leaves '000' -> '0'
      expect(res.text, '0');
    });

    test('handles leading zeros', () {
      final res = formatter.formatEditUpdate(
        const TextEditingValue(
          text: '0',
          selection: TextSelection.collapsed(offset: 1),
        ),
        const TextEditingValue(
          text: '05',
          selection: TextSelection.collapsed(offset: 2),
        ),
      );
      expect(res.text, '5');
      expect(res.selection.baseOffset, 1);
    });

    test('handles clearing all text', () {
      final res = formatter.formatEditUpdate(
        const TextEditingValue(
          text: '1.000',
          selection: TextSelection.collapsed(offset: 5),
        ),
        const TextEditingValue(
          text: '',
          selection: TextSelection.collapsed(offset: 0),
        ),
      );
      expect(res.text, '');
      expect(res.selection.baseOffset, 0);
    });
  });
}

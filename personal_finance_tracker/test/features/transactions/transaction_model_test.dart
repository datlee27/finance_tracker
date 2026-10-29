import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_tracker/core/constants/firestore_constants.dart';
import 'package:personal_finance_tracker/features/transactions/models/transaction_model.dart';

void main() {
  group('TransactionModel Unit Tests', () {
    test('Khởi tạo đúng các trường và thuộc tính isIncome / isExpense', () {
      final now = DateTime(2026, 6, 28);
      final item = TransactionModel(
        id: 'GD-001',
        userId: 'user_123',
        type: FirestoreConstants.typeIncome,
        amount: 15000000,
        category: 'Lương',
        date: now,
        note: 'Lương cứng',
      );

      expect(item.id, 'GD-001');
      expect(item.userId, 'user_123');
      expect(item.isIncome, isTrue);
      expect(item.isExpense, isFalse);
      expect(item.kind, 'Thu nhập');
      expect(item.amount, 15000000);
      expect(item.category, 'Lương');
      expect(item.noteDisplay, 'Lương cứng');
    });

    test('Chuyển đổi toFirestore và fromMap chính xác', () {
      final date = DateTime(2026, 6, 25);
      final item = TransactionModel(
        id: 'GD-002',
        userId: 'user_123',
        type: FirestoreConstants.typeExpense,
        amount: 350000,
        category: 'Ăn uống',
        date: date,
        note: 'Tiệc liên hoan',
      );

      final map = item.toFirestore();
      expect(map['userId'], 'user_123');
      expect(map[FirestoreConstants.fieldType], FirestoreConstants.typeExpense);
      expect(map[FirestoreConstants.fieldAmount], 350000);
      expect(map[FirestoreConstants.fieldCategory], 'Ăn uống');
      expect(map[FirestoreConstants.fieldNote], 'Tiệc liên hoan');

      final reconstructed = TransactionModel.fromMap({
        'userId': 'user_123',
        FirestoreConstants.fieldType: 'expense',
        FirestoreConstants.fieldAmount: 350000,
        FirestoreConstants.fieldCategory: 'Ăn uống',
        FirestoreConstants.fieldDate: '2026-06-25T12:00:00.000Z',
        FirestoreConstants.fieldNote: 'Tiệc liên hoan',
      }, 'GD-002');

      expect(reconstructed.id, 'GD-002');
      expect(reconstructed.amount, 350000);
      expect(reconstructed.isExpense, isTrue);
      expect(reconstructed.category, 'Ăn uống');
    });

    test('copyWith hoạt động đúng không làm thay đổi trường không truyền', () {
      final original = TransactionModel(
        id: 'GD-003',
        userId: 'user_123',
        type: FirestoreConstants.typeExpense,
        amount: 200000,
        category: 'Di chuyển',
        date: DateTime.now(),
      );

      final updated = original.copyWith(amount: 250000, note: 'Xe bus');
      expect(updated.id, original.id);
      expect(updated.amount, 250000);
      expect(updated.note, 'Xe bus');
      expect(updated.category, original.category);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_tracker/core/constants/firestore_constants.dart';
import 'package:personal_finance_tracker/features/dashboard/providers/dashboard_provider.dart';
import 'package:personal_finance_tracker/features/transactions/models/transaction_model.dart';

void main() {
  group('DashboardProvider Unit Tests', () {
    late DashboardProvider provider;

    setUp(() {
      provider = DashboardProvider();
    });

    test('Trạng thái khởi tạo: số dư = 0, ẩn/hiện mặc định là true', () {
      expect(provider.balance, 0.0);
      expect(provider.totalIncome, 0.0);
      expect(provider.totalExpense, 0.0);
      expect(provider.isBalanceVisible, isTrue);
    });

    test('toggleBalanceVisibility đổi trạng thái ẩn/hiện', () {
      provider.toggleBalanceVisibility();
      expect(provider.isBalanceVisible, isFalse);
      provider.toggleBalanceVisibility();
      expect(provider.isBalanceVisible, isTrue);
    });

    test('updateFromTransactions tính đúng Tổng thu, Tổng chi và Số dư', () {
      final now = DateTime.now();
      final items = [
        TransactionModel(
          id: '1',
          userId: 'u1',
          type: FirestoreConstants.typeIncome,
          amount: 20000000,
          category: 'Lương',
          date: now,
        ),
        TransactionModel(
          id: '2',
          userId: 'u1',
          type: FirestoreConstants.typeExpense,
          amount: 5000000,
          category: 'Nhà ở',
          date: now,
        ),
        TransactionModel(
          id: '3',
          userId: 'u1',
          type: FirestoreConstants.typeExpense,
          amount: 2000000,
          category: 'Ăn uống',
          date: now,
        ),
      ];

      provider.updateFromTransactions(items);

      expect(provider.totalIncome, 20000000);
      expect(provider.totalExpense, 7000000);
      expect(provider.balance, 13000000);
      expect(provider.chartData.months.length, 6);
    });
  });
}

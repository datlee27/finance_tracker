import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_finance_tracker/core/constants/firestore_constants.dart';
import 'package:personal_finance_tracker/features/transactions/providers/transaction_provider.dart';

void main() {
  group('TransactionProvider Unit Tests', () {
    late TransactionProvider provider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      provider = TransactionProvider();
    });

    test('Trạng thái khởi tạo danh sách trống', () {
      expect(provider.transactions, isEmpty);
      expect(provider.filteredTransactions, isEmpty);
      expect(provider.totalIncome, 0.0);
      expect(provider.totalExpense, 0.0);
      expect(provider.balance, 0.0);
    });

    test('Thêm giao dịch cục bộ và tính toán số dư', () async {
      await provider.addTransaction(
        type: FirestoreConstants.typeIncome,
        amount: 10000000,
        category: 'Lương',
        date: DateTime.now(),
        note: 'Lương chính thức',
      );

      await provider.addTransaction(
        type: FirestoreConstants.typeExpense,
        amount: 3000000,
        category: 'Ăn uống',
        date: DateTime.now(),
        note: 'Tiền chợ',
      );

      expect(provider.transactions.length, 2);
      expect(provider.totalIncome, 10000000);
      expect(provider.totalExpense, 3000000);
      expect(provider.balance, 7000000);
    });

    test('Lọc theo loại (Thu nhập / Chi tiêu)', () async {
      await provider.addTransaction(
        type: FirestoreConstants.typeIncome,
        amount: 5000000,
        category: 'Làm thêm',
        date: DateTime.now(),
      );
      await provider.addTransaction(
        type: FirestoreConstants.typeExpense,
        amount: 1000000,
        category: 'Di chuyển',
        date: DateTime.now(),
      );

      provider.setFilterType(FirestoreConstants.typeIncome);
      expect(provider.filteredTransactions.length, 1);
      expect(provider.filteredTransactions.first.category, 'Làm thêm');

      provider.setFilterType(FirestoreConstants.typeExpense);
      expect(provider.filteredTransactions.length, 1);
      expect(provider.filteredTransactions.first.category, 'Di chuyển');

      provider.setFilterType('all');
      expect(provider.filteredTransactions.length, 2);
    });

    test('Tìm kiếm theo ghi chú hoặc danh mục', () async {
      await provider.addTransaction(
        type: FirestoreConstants.typeExpense,
        amount: 500000,
        category: 'Ăn uống',
        date: DateTime.now(),
        note: 'Cà phê Highland',
      );
      await provider.addTransaction(
        type: FirestoreConstants.typeExpense,
        amount: 200000,
        category: 'Hóa đơn',
        date: DateTime.now(),
        note: 'Tiền nước',
      );

      provider.setSearchQuery('Highland');
      expect(provider.filteredTransactions.length, 1);
      expect(provider.filteredTransactions.first.note, 'Cà phê Highland');

      provider.setSearchQuery('Hóa đơn');
      expect(provider.filteredTransactions.length, 1);
      expect(provider.filteredTransactions.first.category, 'Hóa đơn');

      provider.resetFilters();
      expect(provider.filteredTransactions.length, 2);
    });

    test('recentTransactions ưu tiên hoạt động mới thêm lên đầu dù ngày phát sinh ở quá khứ', () async {
      // Giả lập 5 giao dịch cũ có ngày hôm nay hoặc tương lai
      final baseDate = DateTime(2026, 10, 28);
      for (int i = 0; i < 5; i++) {
        await provider.addTransaction(
          type: FirestoreConstants.typeExpense,
          amount: 100000.0 * (i + 1),
          category: 'Ăn uống',
          date: baseDate.subtract(Duration(days: i)), // 28/10, 27/10, 26/10, 25/10, 24/10
          note: 'Giao dịch cũ $i',
        );
      }

      // Người dùng thêm giao dịch mới "abc 120000" với ngày 22/10 (cũ hơn top 5)
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await provider.addTransaction(
        type: FirestoreConstants.typeExpense,
        amount: 120000,
        category: 'Ăn uống',
        date: DateTime(2026, 10, 22),
        note: 'abc',
      );

      // Ở danh sách Giao dịch gần đây (Dashboard), 'abc' phải đứng đầu vì vừa được thêm mới nhất
      expect(provider.recentTransactions.first.note, 'abc');
      expect(provider.recentTransactions.first.amount, 120000);

      // Trong khi đó ở danh sách đầy đủ (filteredTransactions), 'abc' xếp thứ 6 theo đúng ngày 22/10
      expect(provider.filteredTransactions[5].note, 'abc');
    });

    test('Khi có dữ liệu mẫu Lương tháng 6 và user thêm giao dịch 123123, 123123 luôn lên đầu và Lương tháng 6 bị đẩy xuống', () async {
      // Giả lập dữ liệu mẫu ban đầu có Lương tháng 6 (ngày 28/10)
      await provider.addTransaction(
        type: FirestoreConstants.typeIncome,
        amount: 18500000,
        category: 'Lương',
        date: DateTime(2026, 10, 28),
        note: 'Lương tháng 6',
      );

      // Người dùng thêm giao dịch mới 123123 cũng vào ngày 28/10
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await provider.addTransaction(
        type: FirestoreConstants.typeExpense,
        amount: 123000,
        category: 'Đi chợ',
        date: DateTime(2026, 10, 28),
        note: '123123',
      );

      // 123123 vừa thêm phải chiếm vị trí số 1 trên Dashboard
      expect(provider.recentTransactions.first.note, '123123');
      expect(provider.recentTransactions.first.amount, 123000);

      // Lương tháng 6 phải bị đẩy xuống vị trí số 2
      expect(provider.recentTransactions[1].note, 'Lương tháng 6');
    });

    test('Chế độ khách: updateUser nạp danh sách từ máy và thêm giao dịch lưu vào SharedPreferences', () async {
      provider.updateUser('guest_user_preview', isGuest: true);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Ban đầu danh sách trống sạch sẽ cho môi trường production
      expect(provider.transactions.length, 0);
      expect(provider.isGuest, isTrue);

      // Thêm giao dịch khách
      await provider.addTransaction(
        type: FirestoreConstants.typeExpense,
        amount: 88000,
        category: 'Ăn uống',
        date: DateTime.now(),
        note: 'Trà sữa trân châu',
      );

      expect(provider.transactions.length, 1);
      expect(provider.recentTransactions.first.note, 'Trà sữa trân châu');

      // Giả lập mở lại ứng dụng trên cùng thiết bị
      final newSessionProvider = TransactionProvider();
      newSessionProvider.updateUser('guest_user_preview', isGuest: true);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Dữ liệu trên máy vẫn còn 1 giao dịch
      expect(newSessionProvider.transactions.length, 1);
      expect(newSessionProvider.transactions.first.note, 'Trà sữa trân châu');
    });
  });
}

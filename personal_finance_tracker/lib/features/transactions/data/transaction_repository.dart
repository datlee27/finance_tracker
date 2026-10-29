import '../models/transaction_model.dart';
import 'firestore_transaction_data_source.dart';
import 'local_guest_transaction_data_source.dart';

/// Repository trung gian cung cấp dữ liệu giao dịch cho Provider
/// Phân tách rõ ràng:
/// - Người dùng đăng nhập: Đồng bộ lưu trữ đám mây Cloud Firestore
/// - Chế độ khách: Lưu trữ cục bộ theo máy qua SharedPreferences
class TransactionRepository {
  final FirestoreTransactionDataSource? _customFirestoreDataSource;
  final LocalGuestTransactionDataSource? _customGuestDataSource;

  TransactionRepository({
    FirestoreTransactionDataSource? firestoreDataSource,
    LocalGuestTransactionDataSource? guestDataSource,
  })  : _customFirestoreDataSource = firestoreDataSource,
        _customGuestDataSource = guestDataSource;

  FirestoreTransactionDataSource get _firestoreDataSource =>
      _customFirestoreDataSource ?? FirestoreTransactionDataSource();

  LocalGuestTransactionDataSource get _guestDataSource =>
      _customGuestDataSource ?? LocalGuestTransactionDataSource();

  // --- Chế độ Khách (Lưu theo máy) ---

  /// Lấy danh sách giao dịch khách lưu trên máy
  Future<List<TransactionModel>> getGuestTransactions() {
    return _guestDataSource.getGuestTransactions();
  }

  /// Thêm giao dịch khách và lưu vào máy
  Future<TransactionModel> addGuestTransaction(TransactionModel transaction) {
    return _guestDataSource.addGuestTransaction(transaction);
  }

  /// Cập nhật giao dịch khách và lưu vào máy
  Future<void> updateGuestTransaction(TransactionModel transaction) {
    return _guestDataSource.updateGuestTransaction(transaction);
  }

  /// Xóa giao dịch khách và cập nhật máy
  Future<void> deleteGuestTransaction(String transactionId) {
    return _guestDataSource.deleteGuestTransaction(transactionId);
  }

  /// Xoá toàn bộ giao dịch khách trên máy
  Future<void> clearAllGuestTransactions() {
    return _guestDataSource.clearAllGuestTransactions();
  }

  // --- Chế độ Đăng nhập (Cloud Firestore) ---

  /// Stream lắng nghe giao dịch realtime của user đăng nhập
  Stream<List<TransactionModel>> getTransactionsStream(String uid) {
    return _firestoreDataSource.getTransactionsStream(uid);
  }

  /// Thêm giao dịch mới vào Firestore
  Future<TransactionModel> addTransaction(
    String uid,
    TransactionModel transaction,
  ) {
    return _firestoreDataSource.addTransaction(uid, transaction);
  }

  /// Cập nhật giao dịch trên Firestore
  Future<void> updateTransaction(
    String uid,
    TransactionModel transaction,
  ) {
    return _firestoreDataSource.updateTransaction(uid, transaction);
  }

  /// Xóa giao dịch khỏi Firestore
  Future<void> deleteTransaction(String uid, String transactionId) {
    return _firestoreDataSource.deleteTransaction(uid, transactionId);
  }

  /// Nạp dữ liệu mẫu ban đầu nếu user mới tinh chưa có giao dịch nào
  Future<void> seedInitialDataIfEmpty(String uid) {
    return _firestoreDataSource.seedInitialDataIfEmpty(uid);
  }
}

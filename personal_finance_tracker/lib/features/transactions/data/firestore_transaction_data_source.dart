import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../models/transaction_model.dart';

/// Data Source giao tiếp với Cloud Firestore cho subcollection: users/{uid}/transactions
class FirestoreTransactionDataSource {
  final FirebaseFirestore? _customFirestore;

  FirestoreTransactionDataSource({FirebaseFirestore? firestore})
      : _customFirestore = firestore;

  FirebaseFirestore get _firestore =>
      _customFirestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userTransactionsRef(String uid) {
    return _firestore
        .collection(FirestoreConstants.usersCollection)
        .doc(uid)
        .collection(FirestoreConstants.transactionsCollection);
  }

  /// Stream lắng nghe toàn bộ giao dịch theo thời gian thực của user
  Stream<List<TransactionModel>> getTransactionsStream(String uid) {
    try {
      return _userTransactionsRef(uid)
          .orderBy(FirestoreConstants.fieldDate, descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return TransactionModel.fromFirestore(doc);
        }).toList();
      });
    } catch (e) {
      throw AppException('Lỗi khi tải danh sách giao dịch: $e');
    }
  }

  /// Thêm giao dịch mới vào Firestore
  Future<TransactionModel> addTransaction(
    String uid,
    TransactionModel transaction,
  ) async {
    try {
      final docRef = _userTransactionsRef(uid).doc();
      final modelToSave = transaction.copyWith(
        id: docRef.id,
        userId: uid,
        createdAt: DateTime.now(),
      );

      await docRef.set(modelToSave.toFirestore());
      return modelToSave;
    } catch (e) {
      throw AppException('Lỗi khi thêm giao dịch: $e');
    }
  }

  /// Cập nhật giao dịch đã có
  Future<void> updateTransaction(
    String uid,
    TransactionModel transaction,
  ) async {
    try {
      await _userTransactionsRef(uid)
          .doc(transaction.id)
          .update(transaction.toFirestore());
    } catch (e) {
      throw AppException('Lỗi khi cập nhật giao dịch: $e');
    }
  }

  /// Xóa giao dịch khỏi Firestore
  Future<void> deleteTransaction(String uid, String transactionId) async {
    try {
      await _userTransactionsRef(uid).doc(transactionId).delete();
    } catch (e) {
      throw AppException('Lỗi khi xóa giao dịch: $e');
    }
  }

  /// Trong môi trường Production, không tự động sinh dữ liệu mock/seed vào Firestore.
  /// Tài khoản người dùng bắt đầu sạch sẽ với dữ liệu thực tế do chính họ tạo.
  Future<void> seedInitialDataIfEmpty(String uid) async {}
}
